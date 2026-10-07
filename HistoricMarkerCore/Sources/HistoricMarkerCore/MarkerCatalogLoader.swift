import Foundation

public enum MarkerCatalogLoader {
    public static func load(from data: Data) throws -> [HistoricMarker] {
        let decoded = try JSONDecoder().decode(MarkerCatalogFile.self, from: data)
        return decoded.markers
    }

    public static func load(from url: URL) throws -> [HistoricMarker] {
        let data = try Data(contentsOf: url)
        return try load(from: data)
    }
}
