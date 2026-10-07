import Foundation
import CoreLocation
import Combine
import HistoricMarkerCore

@MainActor
final class LocationService: NSObject, ObservableObject {
    @Published private(set) var latestSample: VehicleSample?
    @Published private(set) var authorizationStatus: CLAuthorizationStatus
    @Published private(set) var lastError: String?

    private let manager = CLLocationManager()

    override init() {
        self.authorizationStatus = manager.authorizationStatus
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.distanceFilter = 5
        manager.activityType = .automotiveNavigation
        manager.pausesLocationUpdatesAutomatically = true
        manager.allowsBackgroundLocationUpdates = false
        manager.showsBackgroundLocationIndicator = true
    }

    func requestPermissionAndStart() {
        authorizationStatus = manager.authorizationStatus
        switch manager.authorizationStatus {
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
        case .authorizedAlways, .authorizedWhenInUse:
            beginUpdates()
        case .denied, .restricted:
            lastError = "Location permission denied. Enable Location for Historic Marker Ahead in Settings."
        @unknown default:
            lastError = "Unknown location authorization state."
        }
    }

    func stop() {
        manager.stopUpdatingLocation()
        manager.allowsBackgroundLocationUpdates = false
    }

    private func beginUpdates() {
        // Enable background updates only after authorization and Just Drive start.
        if Bundle.main.object(forInfoDictionaryKey: "UIBackgroundModes") != nil {
            manager.allowsBackgroundLocationUpdates = true
        }
        manager.startUpdatingLocation()
        // Course/heading from location updates; also request heading when available.
        if CLLocationManager.headingAvailable() {
            manager.startUpdatingHeading()
        }
    }
}

extension LocationService: CLLocationManagerDelegate {
    nonisolated func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        Task { @MainActor in
            self.authorizationStatus = manager.authorizationStatus
            if manager.authorizationStatus == .authorizedAlways
                || manager.authorizationStatus == .authorizedWhenInUse {
                self.beginUpdates()
            }
        }
    }

    nonisolated func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        Task { @MainActor in
            let course = location.course >= 0 ? location.course : nil
            let speed = location.speed >= 0 ? location.speed : nil
            self.latestSample = VehicleSample(
                coordinate: Coordinate(
                    latitude: location.coordinate.latitude,
                    longitude: location.coordinate.longitude
                ),
                courseDegrees: course,
                speedMetersPerSecond: speed,
                courseValid: course != nil,
                timestamp: location.timestamp
            )
            self.lastError = nil
        }
    }

    nonisolated func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        Task { @MainActor in
            self.lastError = error.localizedDescription
        }
    }
}
