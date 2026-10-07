import XCTest
@testable import HistoricMarkerCore

final class AheadDetectorTests: XCTestCase {
    private let detector = AheadDetector()

    private func marker(
        id: String = "m1",
        lat: Double,
        lon: Double
    ) -> HistoricMarker {
        HistoricMarker(
            id: id,
            sourceId: id,
            title: "Test Marker",
            latitude: lat,
            longitude: lon,
            inscription: "A real inscription.",
            sourceName: "test",
            sourceUrl: "https://example.com",
            attribution: "test",
            hasCoordinates: true
        )
    }

    func testMarkerAheadIsEligible() {
        // Vehicle at origin-ish Albuquerque area heading east toward marker ~200m east
        let vehicle = VehicleSample(
            coordinate: Coordinate(latitude: 35.0844, longitude: -106.6504),
            courseDegrees: 90,
            speedMetersPerSecond: 15,
            courseValid: true
        )
        // ~0.002 deg lon ≈ 180m at this latitude
        let m = marker(lat: 35.0844, lon: -106.6484)
        let evaluation = detector.evaluate(vehicle: vehicle, marker: m, heard: false)
        XCTAssertEqual(evaluation?.relation, .ahead)
        XCTAssertEqual(evaluation?.eligibleToTrigger, true)
        XCTAssertNil(evaluation?.suppressionReason)
    }

    func testMarkerBehindIsNotEligible() {
        let vehicle = VehicleSample(
            coordinate: Coordinate(latitude: 35.0844, longitude: -106.6504),
            courseDegrees: 90,
            speedMetersPerSecond: 15,
            courseValid: true
        )
        // Marker west of vehicle while heading east
        let m = marker(lat: 35.0844, lon: -106.6524)
        let evaluation = detector.evaluate(vehicle: vehicle, marker: m, heard: false)
        XCTAssertEqual(evaluation?.relation, .behindOrIrrelevant)
        XCTAssertEqual(evaluation?.eligibleToTrigger, false)
        XCTAssertEqual(evaluation?.suppressionReason, "not ahead of course")
    }

    func testHeardSuppressesTrigger() {
        let vehicle = VehicleSample(
            coordinate: Coordinate(latitude: 35.0844, longitude: -106.6504),
            courseDegrees: 90,
            speedMetersPerSecond: 15,
            courseValid: true
        )
        let m = marker(lat: 35.0844, lon: -106.6484)
        let evaluation = detector.evaluate(vehicle: vehicle, marker: m, heard: true)
        XCTAssertEqual(evaluation?.eligibleToTrigger, false)
        XCTAssertEqual(evaluation?.suppressionReason, "already heard")
    }

    func testRadiusAloneIsNotEnoughWithoutAhead() {
        let vehicle = VehicleSample(
            coordinate: Coordinate(latitude: 35.0844, longitude: -106.6504),
            courseDegrees: 0, // north
            speedMetersPerSecond: 15,
            courseValid: true
        )
        // Nearby to the south — within radius but not ahead
        let m = marker(lat: 35.0825, lon: -106.6504)
        let evaluation = detector.evaluate(vehicle: vehicle, marker: m, heard: false)
        XCTAssertNotEqual(evaluation?.relation, .ahead)
        XCTAssertEqual(evaluation?.eligibleToTrigger, false)
    }

    func testSelectsClosestEligible() {
        let vehicle = VehicleSample(
            coordinate: Coordinate(latitude: 35.0844, longitude: -106.6504),
            courseDegrees: 90,
            speedMetersPerSecond: 15,
            courseValid: true
        )
        let near = marker(id: "near", lat: 35.0844, lon: -106.6488)
        let far = marker(id: "far", lat: 35.0844, lon: -106.6475)
        let evaluations = detector.evaluate(
            vehicle: vehicle,
            markers: [far, near],
            heardItemIDs: []
        )
        let selected = detector.selectTrigger(from: evaluations)
        XCTAssertEqual(selected?.marker.id, "near")
    }

    func testCooldownSuppresses() {
        let vehicle = VehicleSample(
            coordinate: Coordinate(latitude: 35.0844, longitude: -106.6504),
            courseDegrees: 90,
            speedMetersPerSecond: 15,
            courseValid: true
        )
        let m = marker(lat: 35.0844, lon: -106.6484)
        let now = Date()
        let evaluation = detector.evaluate(
            vehicle: vehicle,
            marker: m,
            heard: false,
            now: now,
            lastNarrationAt: now.addingTimeInterval(-10)
        )
        XCTAssertEqual(evaluation?.eligibleToTrigger, false)
        XCTAssertEqual(evaluation?.suppressionReason, "narration cooldown")
    }

    func testMissingCourseCannotConfirmAhead() {
        let vehicle = VehicleSample(
            coordinate: Coordinate(latitude: 35.0844, longitude: -106.6504),
            courseDegrees: nil,
            speedMetersPerSecond: 15,
            courseValid: false
        )
        let m = marker(lat: 35.0844, lon: -106.6484)
        let evaluation = detector.evaluate(vehicle: vehicle, marker: m, heard: false)
        XCTAssertEqual(evaluation?.relation, .nearby)
        XCTAssertEqual(evaluation?.eligibleToTrigger, false)
        XCTAssertEqual(evaluation?.suppressionReason, "course unavailable — cannot confirm ahead")
    }
}
