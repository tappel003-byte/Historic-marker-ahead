import Foundation

public struct AheadDetector: Sendable {
    public struct Configuration: Equatable, Sendable {
        public var maxDistanceMeters: Double
        public var nearbyAwarenessMeters: Double
        public var aheadHalfAngleDegrees: Double
        public var minSpeedMetersPerSecond: Double
        public var narrationCooldownSeconds: TimeInterval

        public static let `default` = Configuration(
            maxDistanceMeters: 450,
            nearbyAwarenessMeters: 1_200,
            aheadHalfAngleDegrees: 55,
            minSpeedMetersPerSecond: 2.5,
            narrationCooldownSeconds: 90
        )

        public init(
            maxDistanceMeters: Double,
            nearbyAwarenessMeters: Double,
            aheadHalfAngleDegrees: Double,
            minSpeedMetersPerSecond: Double,
            narrationCooldownSeconds: TimeInterval
        ) {
            self.maxDistanceMeters = maxDistanceMeters
            self.nearbyAwarenessMeters = nearbyAwarenessMeters
            self.aheadHalfAngleDegrees = aheadHalfAngleDegrees
            self.minSpeedMetersPerSecond = minSpeedMetersPerSecond
            self.narrationCooldownSeconds = narrationCooldownSeconds
        }
    }

    public var configuration: Configuration

    public init(configuration: Configuration = .default) {
        self.configuration = configuration
    }

    public func evaluate(
        vehicle: VehicleSample,
        markers: [HistoricMarker],
        heardItemIDs: Set<String>,
        now: Date = Date(),
        lastNarrationAt: Date? = nil
    ) -> [MarkerEvaluation] {
        markers.compactMap { marker in
            evaluate(
                vehicle: vehicle,
                marker: marker,
                heard: heardItemIDs.contains(marker.id),
                now: now,
                lastNarrationAt: lastNarrationAt
            )
        }
        .sorted { $0.distanceMeters < $1.distanceMeters }
    }

    public func evaluate(
        vehicle: VehicleSample,
        marker: HistoricMarker,
        heard: Bool,
        now: Date = Date(),
        lastNarrationAt: Date? = nil
    ) -> MarkerEvaluation? {
        guard let coordinate = marker.coordinate else { return nil }

        let distance = GeoMath.distanceMeters(
            fromLat: vehicle.coordinate.latitude,
            fromLon: vehicle.coordinate.longitude,
            toLat: coordinate.latitude,
            toLon: coordinate.longitude
        )

        let bearing: Double
        let angular: Double
        if let course = vehicle.courseDegrees {
            bearing = GeoMath.bearingDegrees(
                fromLat: vehicle.coordinate.latitude,
                fromLon: vehicle.coordinate.longitude,
                toLat: coordinate.latitude,
                toLon: coordinate.longitude
            )
            angular = GeoMath.angularDifferenceDegrees(course, bearing)
        } else {
            bearing = GeoMath.bearingDegrees(
                fromLat: vehicle.coordinate.latitude,
                fromLon: vehicle.coordinate.longitude,
                toLat: coordinate.latitude,
                toLon: coordinate.longitude
            )
            angular = 180
        }

        let relation: MarkerRelation
        if let _ = vehicle.courseDegrees,
           distance <= configuration.maxDistanceMeters,
           angular <= configuration.aheadHalfAngleDegrees {
            relation = .ahead
        } else if distance <= configuration.nearbyAwarenessMeters {
            // Without course, never claim "ahead" — only nearby awareness.
            if vehicle.courseDegrees == nil {
                relation = .nearby
            } else if angular <= configuration.aheadHalfAngleDegrees {
                relation = distance <= configuration.maxDistanceMeters ? .ahead : .nearby
            } else {
                relation = .behindOrIrrelevant
            }
        } else {
            relation = .behindOrIrrelevant
        }

        var suppression: String? = nil
        var eligible = false

        if heard {
            suppression = "already heard"
        } else if marker.coordinate == nil {
            suppression = "missing coordinates"
        } else if relation != .ahead {
            if vehicle.courseDegrees == nil {
                suppression = "course unavailable — cannot confirm ahead"
            } else if distance > configuration.maxDistanceMeters {
                suppression = "outside trigger distance"
            } else {
                suppression = "not ahead of course"
            }
        } else if !movementConfident(vehicle) {
            suppression = "low movement confidence"
        } else if let last = lastNarrationAt,
                  now.timeIntervalSince(last) < configuration.narrationCooldownSeconds {
            suppression = "narration cooldown"
        } else {
            eligible = true
        }

        return MarkerEvaluation(
            marker: marker,
            distanceMeters: distance,
            bearingDegrees: bearing,
            angularDifferenceDegrees: angular,
            relation: relation,
            heard: heard,
            eligibleToTrigger: eligible,
            suppressionReason: suppression
        )
    }

    public func selectTrigger(from evaluations: [MarkerEvaluation]) -> MarkerEvaluation? {
        evaluations
            .filter(\.eligibleToTrigger)
            .sorted { $0.distanceMeters < $1.distanceMeters }
            .first
    }

    private func movementConfident(_ vehicle: VehicleSample) -> Bool {
        if let speed = vehicle.speedMetersPerSecond, speed >= configuration.minSpeedMetersPerSecond {
            return true
        }
        return vehicle.courseValid && vehicle.courseDegrees != nil
    }
}
