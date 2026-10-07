import SwiftUI
import CoreLocation

struct DebugView: View {
    @EnvironmentObject private var appModel: AppModel

    var body: some View {
        NavigationStack {
            List {
                Section("Vehicle") {
                    let sample = appModel.locationService.latestSample
                    LabeledContent("Latitude", value: format(sample?.coordinate.latitude))
                    LabeledContent("Longitude", value: format(sample?.coordinate.longitude))
                    LabeledContent("Course°", value: format(sample?.courseDegrees))
                    LabeledContent("Speed m/s", value: format(sample?.speedMetersPerSecond))
                    LabeledContent("Course valid", value: sample.map { String($0.courseValid) } ?? "—")
                    LabeledContent(
                        "Auth",
                        value: authString(appModel.locationService.authorizationStatus)
                    )
                    if let err = appModel.locationService.lastError {
                        Text(err).foregroundStyle(.red)
                    }
                }

                Section("Session") {
                    LabeledContent("Active", value: String(appModel.session.isActive))
                    LabeledContent("Status", value: appModel.session.statusText)
                    LabeledContent("Last narrated", value: appModel.session.lastNarratedTitle ?? "—")
                    LabeledContent("Suppression", value: appModel.session.lastSuppressionSummary ?? "—")
                }

                Section("Candidates (nearest)") {
                    if appModel.session.evaluations.isEmpty {
                        Text("No evaluations yet. Start Just Drive.")
                            .foregroundStyle(.secondary)
                    }
                    ForEach(appModel.session.evaluations) { evaluation in
                        VStack(alignment: .leading, spacing: 4) {
                            Text(evaluation.marker.title).font(.headline)
                            Text(String(
                                format: "dist %.0fm · bearing %.0f° · Δcourse %.0f° · %@",
                                evaluation.distanceMeters,
                                evaluation.bearingDegrees,
                                evaluation.angularDifferenceDegrees,
                                evaluation.relation.rawValue
                            ))
                            .font(.caption)
                            .foregroundStyle(.secondary)
                            Text(
                                evaluation.eligibleToTrigger
                                    ? "ELIGIBLE"
                                    : (evaluation.suppressionReason ?? "suppressed")
                            )
                            .font(.caption2.weight(.semibold))
                            Text(evaluation.heard ? "heard" : "unheard")
                                .font(.caption2)
                        }
                        .padding(.vertical, 2)
                    }
                }
            }
            .navigationTitle("Debug")
        }
    }

    private func format(_ value: Double?) -> String {
        guard let value else { return "—" }
        return String(format: "%.5f", value)
    }

    private func authString(_ status: CLAuthorizationStatus) -> String {
        switch status {
        case .notDetermined: return "notDetermined"
        case .restricted: return "restricted"
        case .denied: return "denied"
        case .authorizedAlways: return "always"
        case .authorizedWhenInUse: return "whenInUse"
        @unknown default: return "unknown"
        }
    }
}
