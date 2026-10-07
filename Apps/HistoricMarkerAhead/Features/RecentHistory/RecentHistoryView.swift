import SwiftUI
import HistoricMarkerCore

struct RecentHistoryView: View {
    @EnvironmentObject private var appModel: AppModel

    var body: some View {
        NavigationStack {
            List {
                let _ = appModel.historyRevision
                let records = appModel.heardStore.allRecords
                if records.isEmpty {
                    Text("No heard markers yet. Start Just Drive and pass an unheard marker ahead.")
                        .foregroundStyle(.secondary)
                } else {
                    ForEach(records) { record in
                        VStack(alignment: .leading, spacing: 6) {
                            Text(title(for: record.itemId))
                                .font(.headline)
                            if let heardAt = record.heardAt {
                                Text(heardAt.formatted(date: .abbreviated, time: .shortened))
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                            HStack {
                                Text(record.heard ? "Heard" : "Not heard")
                                    .font(.caption)
                                if let rating = record.rating {
                                    Text(rating == .up ? "👍" : "👎")
                                }
                            }
                        }
                        .padding(.vertical, 4)
                    }
                }
            }
            .navigationTitle("Recent History")
        }
    }

    private func title(for id: String) -> String {
        appModel.catalog.markers.first(where: { $0.id == id })?.title ?? id
    }
}
