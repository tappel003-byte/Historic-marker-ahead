import Foundation

/// Local heard-history persistence. File-backed for testability without UIKit.
public final class HeardHistoryStore: @unchecked Sendable {
    private let fileURL: URL
    private let queue = DispatchQueue(label: "HistoricMarkerAhead.HeardHistoryStore")
    private var records: [String: HeardRecord]

    public init(fileURL: URL) {
        self.fileURL = fileURL
        if let data = try? Data(contentsOf: fileURL),
           let decoded = try? JSONDecoder().decode([String: HeardRecord].self, from: data) {
            self.records = decoded
        } else {
            self.records = [:]
        }
    }

    public convenience init(directory: URL, filename: String = "heard-history.json") {
        self.init(fileURL: directory.appendingPathComponent(filename))
    }

    public var allRecords: [HeardRecord] {
        queue.sync {
            records.values.sorted { ($0.heardAt ?? .distantPast) > ($1.heardAt ?? .distantPast) }
        }
    }

    public func heardItemIDs() -> Set<String> {
        queue.sync {
            Set(records.values.filter(\.heard).map(\.itemId))
        }
    }

    public func record(for itemId: String) -> HeardRecord? {
        queue.sync { records[itemId] }
    }

    public func markHeard(itemId: String, at date: Date = Date()) {
        queue.sync {
            var existing = records[itemId] ?? HeardRecord(itemId: itemId, heard: true, heardAt: date)
            existing.heard = true
            existing.heardAt = date
            records[itemId] = existing
            persistLocked()
        }
    }

    public func setRating(itemId: String, rating: Rating?, ensureHeard: Bool = true) {
        queue.sync {
            var existing = records[itemId] ?? HeardRecord(itemId: itemId, heard: false)
            if ensureHeard {
                existing.heard = true
                if existing.heardAt == nil { existing.heardAt = Date() }
            }
            existing.rating = rating
            records[itemId] = existing
            persistLocked()
        }
    }

    public func resetAll() {
        queue.sync {
            records = [:]
            persistLocked()
        }
    }

    private func persistLocked() {
        do {
            try FileManager.default.createDirectory(
                at: fileURL.deletingLastPathComponent(),
                withIntermediateDirectories: true
            )
            let data = try JSONEncoder().encode(records)
            try data.write(to: fileURL, options: [.atomic])
        } catch {
            // Persistence failures should not crash driving UI; callers can surface via debug.
        }
    }
}
