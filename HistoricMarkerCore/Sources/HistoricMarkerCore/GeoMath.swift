import Foundation

/// Pure geometry helpers (no CoreLocation dependency) for deterministic tests.
public enum GeoMath {
    public static let earthRadiusMeters: Double = 6_371_000

    /// Great-circle distance in meters (haversine).
    public static func distanceMeters(
        fromLat: Double,
        fromLon: Double,
        toLat: Double,
        toLon: Double
    ) -> Double {
        let φ1 = fromLat * .pi / 180
        let φ2 = toLat * .pi / 180
        let Δφ = (toLat - fromLat) * .pi / 180
        let Δλ = (toLon - fromLon) * .pi / 180
        let a = sin(Δφ / 2) * sin(Δφ / 2)
            + cos(φ1) * cos(φ2) * sin(Δλ / 2) * sin(Δλ / 2)
        let c = 2 * atan2(sqrt(a), sqrt(1 - a))
        return earthRadiusMeters * c
    }

    /// Initial bearing from A → B in degrees [0, 360).
    public static func bearingDegrees(
        fromLat: Double,
        fromLon: Double,
        toLat: Double,
        toLon: Double
    ) -> Double {
        let φ1 = fromLat * .pi / 180
        let φ2 = toLat * .pi / 180
        let Δλ = (toLon - fromLon) * .pi / 180
        let y = sin(Δλ) * cos(φ2)
        let x = cos(φ1) * sin(φ2) - sin(φ1) * cos(φ2) * cos(Δλ)
        let θ = atan2(y, x) * 180 / .pi
        return normalizeDegrees(θ)
    }

    /// Smallest absolute angular difference in degrees [0, 180].
    public static func angularDifferenceDegrees(_ a: Double, _ b: Double) -> Double {
        let d = abs(normalizeDegrees(a) - normalizeDegrees(b)).truncatingRemainder(dividingBy: 360)
        return d > 180 ? 360 - d : d
    }

    public static func normalizeDegrees(_ degrees: Double) -> Double {
        var value = degrees.truncatingRemainder(dividingBy: 360)
        if value < 0 { value += 360 }
        return value
    }
}
