import SwiftUI

struct SettingsView: View {
    @EnvironmentObject private var appModel: AppModel
    @State private var didReset = false

    var body: some View {
        NavigationStack {
            Form {
                Section("About") {
                    Text("Historic Marker Ahead")
                    Text("Milestone 1 — Just Drive proof of concept")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }

                Section("Permissions") {
                    Text("Location is used only to detect historic markers ahead while Just Drive is active. Prefer on-device processing; nothing is uploaded by this build.")
                        .font(.footnote)
                }

                Section("Developer") {
                    Button("Reset heard history", role: .destructive) {
                        appModel.resetHeardHistory()
                        didReset = true
                    }
                    if didReset {
                        Text("Heard history cleared.")
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                    }
                }

                Section("Data") {
                    Text("\(appModel.catalog.markers.count) geocoded Official Scenic Historic Markers from NM Historic Preservation Division.")
                        .font(.footnote)
                    Link(
                        "Program page",
                        destination: URL(string: "https://www.nmhistoricpreservation.org/programs/official-scenic-historic-markers.html")!
                    )
                }
            }
            .navigationTitle("Settings")
        }
    }
}
