import Foundation
import Combine
import HistoricMarkerCore

@MainActor
final class JustDriveSession: ObservableObject {
    @Published private(set) var isActive = false
    @Published private(set) var evaluations: [MarkerEvaluation] = []
    @Published private(set) var lastNarratedID: String?
    @Published private(set) var lastNarratedTitle: String?
    @Published private(set) var statusText: String = "Idle"
    @Published private(set) var lastSuppressionSummary: String?

    private let catalog: MarkerCatalog
    private let heardStore: HeardHistoryStore
    private let locationService: LocationService
    private let narrationService: NarrationService
    private let detector = AheadDetector()
    private var cancellables = Set<AnyCancellable>()
    private var lastNarrationAt: Date?
    private var isSpeaking = false

    init(
        catalog: MarkerCatalog,
        heardStore: HeardHistoryStore,
        locationService: LocationService,
        narrationService: NarrationService
    ) {
        self.catalog = catalog
        self.heardStore = heardStore
        self.locationService = locationService
        self.narrationService = narrationService

        locationService.$latestSample
            .compactMap { $0 }
            .sink { [weak self] sample in
                self?.handle(sample: sample)
            }
            .store(in: &cancellables)
    }

    func start() {
        isActive = true
        statusText = "Listening for history ahead"
        locationService.requestPermissionAndStart()
    }

    func stop() {
        isActive = false
        statusText = "Stopped"
        locationService.stop()
        narrationService.stop()
        isSpeaking = false
    }

    func rateLast(_ rating: Rating) {
        guard let id = lastNarratedID else { return }
        heardStore.setRating(itemId: id, rating: rating)
    }

    private func handle(sample: VehicleSample) {
        guard isActive else { return }

        let evaluated = detector.evaluate(
            vehicle: sample,
            markers: catalog.markers,
            heardItemIDs: heardStore.heardItemIDs(),
            now: Date(),
            lastNarrationAt: lastNarrationAt
        )
        // Keep a compact debug list: nearest candidates within awareness.
        evaluations = Array(evaluated.prefix(12))

        if let trigger = detector.selectTrigger(from: evaluated), !isSpeaking {
            speak(trigger)
        } else if let nearest = evaluated.first {
            lastSuppressionSummary = nearest.suppressionReason
                ?? (nearest.relation == .ahead ? "ahead but not selected" : nearest.relation.rawValue)
        }
    }

    private func speak(_ evaluation: MarkerEvaluation) {
        isSpeaking = true
        lastNarrationAt = Date()
        lastNarratedID = evaluation.marker.id
        lastNarratedTitle = evaluation.marker.title
        statusText = "Speaking: \(evaluation.marker.title)"
        let script = NarrationText.spokenScript(for: evaluation.marker)
        heardStore.markHeard(itemId: evaluation.marker.id)

        narrationService.speak(script) { [weak self] in
            Task { @MainActor in
                self?.isSpeaking = false
                self?.statusText = "Listening for history ahead"
            }
        }
    }
}
