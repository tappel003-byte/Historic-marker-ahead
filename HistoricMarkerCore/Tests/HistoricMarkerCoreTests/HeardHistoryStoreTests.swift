import XCTest
@testable import HistoricMarkerCore

final class HeardHistoryStoreTests: XCTestCase {
    func testMarkHeardAndPersist() throws {
        let dir = FileManager.default.temporaryDirectory
            .appendingPathComponent(UUID().uuidString, isDirectory: true)
        try FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
        let store = HeardHistoryStore(directory: dir)
        store.markHeard(itemId: "nm-oshm-10")
        store.setRating(itemId: "nm-oshm-10", rating: .up)

        let reloaded = HeardHistoryStore(directory: dir)
        XCTAssertTrue(reloaded.heardItemIDs().contains("nm-oshm-10"))
        XCTAssertEqual(reloaded.record(for: "nm-oshm-10")?.rating, .up)
    }

    func testResetClears() throws {
        let dir = FileManager.default.temporaryDirectory
            .appendingPathComponent(UUID().uuidString, isDirectory: true)
        try FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
        let store = HeardHistoryStore(directory: dir)
        store.markHeard(itemId: "a")
        store.resetAll()
        XCTAssertTrue(store.heardItemIDs().isEmpty)
    }

    func testHeardSuppressesInDetectorIntegration() {
        let store = HeardHistoryStore(
            directory: FileManager.default.temporaryDirectory
                .appendingPathComponent(UUID().uuidString, isDirectory: true)
        )
        store.markHeard(itemId: "m1")
        let detector = AheadDetector()
        let vehicle = VehicleSample(
            coordinate: Coordinate(latitude: 35.0844, longitude: -106.6504),
            courseDegrees: 90,
            speedMetersPerSecond: 15,
            courseValid: true
        )
        let marker = HistoricMarker(
            id: "m1",
            sourceId: "m1",
            title: "T",
            latitude: 35.0844,
            longitude: -106.6484,
            inscription: "text",
            sourceName: "t",
            sourceUrl: "https://example.com",
            attribution: "t",
            hasCoordinates: true
        )
        let evaluations = detector.evaluate(
            vehicle: vehicle,
            markers: [marker],
            heardItemIDs: store.heardItemIDs()
        )
        XCTAssertEqual(detector.selectTrigger(from: evaluations), nil)
    }
}
