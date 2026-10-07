import SwiftUI
import Combine
import HistoricMarkerCore

@main
struct HistoricMarkerAheadApp: App {
    @StateObject private var appModel = AppModel()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(appModel)
        }
    }
}

@MainActor
final class AppModel: ObservableObject {
    let catalog: MarkerCatalog
    let heardStore: HeardHistoryStore
    let locationService: LocationService
    let narrationService: NarrationService
    let session: JustDriveSession

    /// Bumped when heard-history changes so Recent History refreshes.
    @Published private(set) var historyRevision = 0

    private var cancellables = Set<AnyCancellable>()

    init() {
        let catalog = MarkerCatalog.loadBundled()
        let support = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first
            ?? FileManager.default.temporaryDirectory
        let dir = support.appendingPathComponent("HistoricMarkerAhead", isDirectory: true)
        let heardStore = HeardHistoryStore(directory: dir)
        let locationService = LocationService()
        let narrationService = NarrationService()
        self.catalog = catalog
        self.heardStore = heardStore
        self.locationService = locationService
        self.narrationService = narrationService
        self.session = JustDriveSession(
            catalog: catalog,
            heardStore: heardStore,
            locationService: locationService,
            narrationService: narrationService
        )

        session.objectWillChange
            .sink { [weak self] _ in self?.objectWillChange.send() }
            .store(in: &cancellables)
        locationService.objectWillChange
            .sink { [weak self] _ in self?.objectWillChange.send() }
            .store(in: &cancellables)
        session.$lastNarratedID
            .sink { [weak self] _ in self?.historyRevision += 1 }
            .store(in: &cancellables)
    }

    func resetHeardHistory() {
        heardStore.resetAll()
        historyRevision += 1
    }

    func rateLast(_ rating: Rating) {
        session.rateLast(rating)
        historyRevision += 1
    }
}
