import XCTest
@testable import HistoricMarkerCore

final class GeoMathTests: XCTestCase {
    func testHaversineKnownShortDistance() {
        // ~111.2 km per degree latitude
        let meters = GeoMath.distanceMeters(
            fromLat: 35.0, fromLon: -106.0,
            toLat: 35.1, toLon: -106.0
        )
        XCTAssertEqual(meters, 11_120, accuracy: 80)
    }

    func testBearingDueEast() {
        let bearing = GeoMath.bearingDegrees(
            fromLat: 35.0, fromLon: -106.0,
            toLat: 35.0, toLon: -105.0
        )
        XCTAssertEqual(bearing, 90, accuracy: 1.0)
    }

    func testBearingDueNorth() {
        let bearing = GeoMath.bearingDegrees(
            fromLat: 35.0, fromLon: -106.0,
            toLat: 36.0, toLon: -106.0
        )
        XCTAssertEqual(bearing, 0, accuracy: 1.0)
    }

    func testAngularDifferenceWrap() {
        XCTAssertEqual(GeoMath.angularDifferenceDegrees(10, 350), 20, accuracy: 0.001)
        XCTAssertEqual(GeoMath.angularDifferenceDegrees(0, 180), 180, accuracy: 0.001)
        XCTAssertEqual(GeoMath.angularDifferenceDegrees(10, 10), 0, accuracy: 0.001)
    }
}
