import Foundation

public struct Coordinate: Equatable, Sendable, Codable {
    public var latitude: Double
    public var longitude: Double

    public init(latitude: Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
    }
}

public struct VehicleSample: Equatable, Sendable {
    public var coordinate: Coordinate
    public var courseDegrees: Double?
    public var speedMetersPerSecond: Double?
    public var courseValid: Bool
    public var timestamp: Date

    public init(
        coordinate: Coordinate,
        courseDegrees: Double?,
        speedMetersPerSecond: Double?,
        courseValid: Bool,
        timestamp: Date = Date()
    ) {
        self.coordinate = coordinate
        self.courseDegrees = courseDegrees
        self.speedMetersPerSecond = speedMetersPerSecond
        self.courseValid = courseValid
        self.timestamp = timestamp
    }
}

public struct HistoricMarker: Equatable, Identifiable, Sendable, Codable {
    public var id: String
    public var sourceId: String
    public var title: String
    public var latitude: Double?
    public var longitude: Double?
    public var inscription: String?
    public var summary: String?
    public var county: String?
    public var cityOrVicinity: String?
    public var highway: String?
    public var mileMarker: String?
    public var categories: [String]
    public var sourceName: String
    public var sourceUrl: String
    public var attribution: String
    public var hasCoordinates: Bool
    public var isOfficialScenicHistoricMarker: Bool

    public var coordinate: Coordinate? {
        guard hasCoordinates, let latitude, let longitude else { return nil }
        return Coordinate(latitude: latitude, longitude: longitude)
    }

    public init(
        id: String,
        sourceId: String,
        title: String,
        latitude: Double?,
        longitude: Double?,
        inscription: String?,
        summary: String? = nil,
        county: String? = nil,
        cityOrVicinity: String? = nil,
        highway: String? = nil,
        mileMarker: String? = nil,
        categories: [String] = [],
        sourceName: String,
        sourceUrl: String,
        attribution: String,
        hasCoordinates: Bool,
        isOfficialScenicHistoricMarker: Bool = true
    ) {
        self.id = id
        self.sourceId = sourceId
        self.title = title
        self.latitude = latitude
        self.longitude = longitude
        self.inscription = inscription
        self.summary = summary
        self.county = county
        self.cityOrVicinity = cityOrVicinity
        self.highway = highway
        self.mileMarker = mileMarker
        self.categories = categories
        self.sourceName = sourceName
        self.sourceUrl = sourceUrl
        self.attribution = attribution
        self.hasCoordinates = hasCoordinates
        self.isOfficialScenicHistoricMarker = isOfficialScenicHistoricMarker
    }
}

public enum MarkerRelation: String, Equatable, Sendable {
    case ahead
    case nearby
    case behindOrIrrelevant
}

public struct MarkerEvaluation: Equatable, Identifiable, Sendable {
    public var id: String { marker.id }
    public var marker: HistoricMarker
    public var distanceMeters: Double
    public var bearingDegrees: Double
    public var angularDifferenceDegrees: Double
    public var relation: MarkerRelation
    public var heard: Bool
    public var eligibleToTrigger: Bool
    public var suppressionReason: String?

    public init(
        marker: HistoricMarker,
        distanceMeters: Double,
        bearingDegrees: Double,
        angularDifferenceDegrees: Double,
        relation: MarkerRelation,
        heard: Bool,
        eligibleToTrigger: Bool,
        suppressionReason: String?
    ) {
        self.marker = marker
        self.distanceMeters = distanceMeters
        self.bearingDegrees = bearingDegrees
        self.angularDifferenceDegrees = angularDifferenceDegrees
        self.relation = relation
        self.heard = heard
        self.eligibleToTrigger = eligibleToTrigger
        self.suppressionReason = suppressionReason
    }
}

public enum Rating: String, Codable, Equatable, Sendable {
    case up
    case down
}

public struct HeardRecord: Equatable, Identifiable, Codable, Sendable {
    public var id: String { itemId }
    public var itemId: String
    public var heard: Bool
    public var heardAt: Date?
    public var rating: Rating?

    public init(itemId: String, heard: Bool, heardAt: Date? = nil, rating: Rating? = nil) {
        self.itemId = itemId
        self.heard = heard
        self.heardAt = heardAt
        self.rating = rating
    }
}

public struct MarkerCatalogFile: Codable, Sendable {
    public var schemaVersion: Int
    public var markers: [HistoricMarker]
}
