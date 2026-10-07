import Foundation

public enum NarrationText {
    /// Builds a short spoken script grounded in marker source fields.
    public static func spokenScript(for marker: HistoricMarker, maxCharacters: Int = 900) -> String {
        var parts: [String] = ["Historic Marker Ahead.", marker.title + "."]

        if let inscription = marker.inscription?.trimmingCharacters(in: .whitespacesAndNewlines),
           !inscription.isEmpty {
            let cleaned = inscription
                .replacingOccurrences(of: "(SIDE 1)", with: "")
                .replacingOccurrences(of: "(SIDE 2)", with: " Side two.")
                .replacingOccurrences(of: "\u{00a0}", with: " ")
            parts.append(cleaned)
        } else if let summary = marker.summary?.trimmingCharacters(in: .whitespacesAndNewlines),
                  !summary.isEmpty {
            parts.append(summary)
        } else {
            parts.append("Marker text is not available in the local catalog.")
        }

        var script = parts.joined(separator: " ")
        if script.count > maxCharacters {
            let idx = script.index(script.startIndex, offsetBy: maxCharacters)
            script = String(script[..<idx]).trimmingCharacters(in: .whitespacesAndNewlines) + "…"
        }
        return script
    }
}
