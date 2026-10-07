import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var appModel: AppModel

    var body: some View {
        NavigationStack {
            VStack(spacing: 28) {
                Spacer(minLength: 24)

                Text("Historic Marker Ahead")
                    .font(.largeTitle.weight(.bold))
                    .multilineTextAlignment(.center)
                    .accessibilityAddTraits(.isHeader)

                Text("Quiet most of the time. Interesting when it speaks.")
                    .font(.body)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)

                if appModel.session.isActive {
                    JustDriveActiveCard()
                } else {
                    Button {
                        appModel.session.start()
                    } label: {
                        Text("JUST DRIVE")
                            .font(.title2.weight(.semibold))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 18)
                    }
                    .buttonStyle(.borderedProminent)
                    .padding(.horizontal, 24)
                    .accessibilityHint("Starts listening for historic markers ahead while you drive.")
                }

                Spacer()

                Text("\(appModel.catalog.markers.count) New Mexico markers loaded")
                    .font(.footnote)
                    .foregroundStyle(.tertiary)
            }
            .padding()
            .navigationTitle("Home")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

private struct JustDriveActiveCard: View {
    @EnvironmentObject private var appModel: AppModel

    var body: some View {
        VStack(spacing: 16) {
            Label("Listening for history ahead", systemImage: "ear")
                .font(.headline)

            if let title = appModel.session.lastNarratedTitle {
                Text("Last spoken: \(title)")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            } else {
                Text("Silence is intentional when nothing ahead deserves a word.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }

            HStack(spacing: 20) {
                Button {
                    appModel.rateLast(.up)
                } label: {
                    Label("Up", systemImage: "hand.thumbsup")
                }
                .disabled(appModel.session.lastNarratedID == nil)

                Button {
                    appModel.rateLast(.down)
                } label: {
                    Label("Down", systemImage: "hand.thumbsdown")
                }
                .disabled(appModel.session.lastNarratedID == nil)
            }

            Button(role: .destructive) {
                appModel.session.stop()
            } label: {
                Text("Stop Just Drive")
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
            }
            .buttonStyle(.bordered)
        }
        .padding(20)
        .frame(maxWidth: .infinity)
        .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 16))
        .padding(.horizontal, 24)
    }
}
