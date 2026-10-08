# MILESTONE.md — Currently authorized work

**Note:** “V1” in conversation refers to this Just Drive proof-of-concept direction. There is no “D1” milestone.

## Milestone 1 — Just Drive proof of concept

**Question this milestone must answer:**

Can Historic Marker Ahead run during a real drive, identify an appropriate unheard historical marker ahead, speak useful historical content at the appropriate time, remember that it was heard, and otherwise remain quiet?

This must be testable on Tim’s physical iPhone. It is not a mock-UI exercise.

### Authorized to build

- Native iPhone app (Swift / SwiftUI)
- Simple Home with primary action **JUST DRIVE**
- Just Drive session with clear listening/stopped states
- Legitimate Core Location usage (position, course, speed; background where supported)
- Ahead detection that is **not** merely `distance < radius`
- Real New Mexico Official Scenic Historic Marker data with provenance
- Native text-to-speech narration of marker content
- Audio coexistence spike using public AVAudioSession APIs (duck/interrupt spoken audio as appropriate)
- Local heard-history persistence (item ID, heard, date, rating)
- 👍 / 👎 on recently narrated items
- Recent History view
- Developer/debug surface for location + trigger decisions
- Simulated-location testing notes for Xcode
- Unit tests for deterministic geometry / trigger / heard suppression

### Explicitly out of scope for this milestone

- Custom turn-by-turn navigation / Maps replacement
- Nationwide ingestion
- Planned Drive (New Ulm / Lubbock preparation)
- History-optimized routes
- Sophisticated recommendation AI
- Cloud accounts, subscriptions, social, achievements, ads
- Android / web / PWA
- Giant preference questionnaire
- Full conversational voice assistant
- V2 / V3 directional ideas (richer road judgment, planned-drive storytelling, etc.) — remain vision only until a future milestone authorizes them
- Choosing or implementing a distribution path (TestFlight vs direct install), Apple Developer enrollment steps, cloud Mac CI, or install walkthroughs — process/ops, not Milestone 1 product scope, until Tim decides and explicitly asks

These ideas remain valid in `VISION.md`; they are simply not authorized now.

### Deployment target (Milestone 1)

**iOS 17.0+** — supports modern SwiftUI lifecycle, stable Core Location continuous updates, and AVSpeechSynthesizer / AVAudioSession patterns used here. Decision recorded in `DECISIONS.md`.

### Exit criteria

- App builds in Xcode and runs on a physical iPhone
- Just Drive can obtain location permission and show live debug state
- Approaching an unheard geocoded NM marker while moving can trigger narration
- Heard marker is suppressed on subsequent automatic triggers
- Unit tests cover ahead/behind geometry and heard suppression
- Limitations of audio coexistence and background location are documented honestly
