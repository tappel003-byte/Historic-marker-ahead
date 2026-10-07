import XCTest
@testable import HistoricMarkerCore

final class NarrationTextTests: XCTestCase {
    func testIncludesTitleAndInscription() {
        let marker = HistoricMarker(
            id: "1",
            sourceId: "1",
            title: "Abiquiú",
            latitude: 36.2,
            longitude: -106.3,
            inscription: "Established on the site of an abandoned Indian pueblo.",
            sourceName: "NM HPD",
            sourceUrl: "https://example.com",
            attribution: "NM",
            hasCoordinates: true
        )
        let script = NarrationText.spokenScript(for: marker)
        XCTAssertTrue(script.contains("Historic Marker Ahead"))
        XCTAssertTrue(script.contains("Abiquiú"))
        XCTAssertTrue(script.contains("abandoned Indian pueblo"))
    }
}
