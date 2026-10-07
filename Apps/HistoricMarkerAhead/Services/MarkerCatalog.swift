import Foundation
import HistoricMarkerCore

@MainActor
final class MarkerCatalog: ObservableObject {
    @Published private(set) var markers: [HistoricMarker]

    init(markers: [HistoricMarker]) {
        self.markers = markers.filter(\.hasCoordinates)
    }

    static func loadBundled() -> MarkerCatalog {
        if let url = Bundle.main.url(
            forResource: "nm-official-scenic-markers-geocoded",
            withExtension: "json"
        ),
           let markers = try? MarkerCatalogLoader.load(from: url) {
            return MarkerCatalog(markers: markers)
        }
        // Fallback empty catalog — should not happen in a correct bundle.
        return MarkerCatalog(markers: [])
    }
}
