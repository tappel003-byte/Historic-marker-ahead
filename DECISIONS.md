# DECISIONS.md — Durable decision log

Record product/architecture decisions that constrain future work. Not an activity log.

---

## D001 — Product name

**Decision:** Historic Marker Ahead  
**Date:** 2026-10-07  
**Rationale:** Matches the roadside prompt that inspired the product.

## D002 — Vision documented from the beginning

**Decision:** Complete long-term vision lives in `VISION.md` from day one; milestones authorize implementation slices.  
**Rationale:** Prevents the product from being accidentally reduced to V1.

## D003 — Milestone-driven implementation

**Decision:** Only work authorized in `MILESTONE.md` may be implemented.  
**Rationale:** Keeps agents from building future vision early.

## D004 — Native iOS first

**Decision:** Build native iPhone experience first with Swift and SwiftUI. No PWA, no Android, no speculative cross-platform layer in early milestones.  
**Date:** 2026-10-07  
**Authorized by:** Tim (native iOS Swift/SwiftUI)  
**Rationale:** Driving + background location + audio coexistence needs real platform APIs.

## D005 — New Mexico first

**Decision:** Initial geographic focus is New Mexico Official Scenic Historic Markers.  
**Rationale:** Origin of the idea; authoritative state program exists.

## D006 — Personal / noncommercial initially

**Decision:** Personal noncommercial prototype; no ads/analytics by default; no commercial licensing machinery yet.  
**Rationale:** Privacy and simplicity; licensing stays honest.

## D007 — Companion to Maps, not a navigator

**Decision:** Coexist with Apple Maps / Google Maps; do not rebuild navigation. Do not assume access to Apple Maps’ private route state.  
**Rationale:** Respect app boundaries and product focus.

## D008 — Original markers remain sacred

**Decision:** Official roadside historical markers retain special status versus broader historical POIs.  
**Rationale:** Brainchild promise.

## D009 — Source-grounded narration

**Decision:** Narration must be grounded in identifiable source material; no fabricated marker text or history. Preserve provenance on every record.  
**Rationale:** Trust and historical integrity.

## D010 — Heard history suppresses repeats

**Decision:** Previously heard items normally do not auto-trigger again.  
**Rationale:** Familiar roads must not become repetitive.

## D011 — Thumbs as primary preference signal

**Decision:** 👍 / 👎 is the primary explicit preference mechanism; no complex recommendation engine in Milestone 1.  
**Rationale:** Simple learning signal for a future History Engine.

## D012 — Silence is a feature

**Decision:** If nothing worthwhile is ahead, say nothing.  
**Rationale:** Core principle — quiet most of the time.

## D013 — Location privacy

**Decision:** Use location for the history companion purpose only; prefer on-device persistence; no cloud location surveillance or default analytics.  
**Rationale:** Location is necessary; tracking is not.

## D014 — Milestone 1 deployment target

**Decision:** iOS 17.0 minimum.  
**Date:** 2026-10-07  
**Rationale:** Modern SwiftUI + Core Location + speech APIs without chasing bleeding-edge OS exclusives.

## D015 — Milestone 1 marker data source

**Decision:** Primary data = New Mexico Historic Preservation Division Official Scenic Historic Markers publicly posted spreadsheet (`OSHM spreadsheet for website.xlsx`), normalized into JSON with provenance. Runtime auto-trigger uses the geocoded subset (LAT/LONG present). Markers lacking coordinates remain in the full catalog but do not auto-trigger until geocoded.  
**Date:** 2026-10-07  
**Rationale:** Official program source; spreadsheet is machine-readable and includes inscription text. Official PDF guide is complementary reference. Coordinate coverage is incomplete in the official sheet (~324 of ~622); that gap is documented rather than faked. HMdb is permitted for noncommercial attributed use per its copyright page, but Milestone 1 does not require HMdb ingestion.

## D016 — Milestone 1 narration = on-device TTS

**Decision:** Use `AVSpeechSynthesizer` for Milestone 1 narration. Architecture leaves room for richer grounded audio later.  
**Rationale:** Avoids cloud dependencies; sufficient to prove the drive loop.

## D017 — Audio session strategy for coexistence

**Decision:** For narration prompts, use `AVAudioSession` category `.playback` with options `.duckOthers` and `.interruptSpokenAudioAndMixWithOthers`; activate only while speaking; deactivate afterward (Apple’s public guidance for navigation-style spoken prompts).  
**Date:** 2026-10-07  
**Rationale:** Matches documented public API guidance. Exact coexistence with Apple Maps prompts is OS-mediated and must be validated on device — do not claim parity with private Maps privileges.

## D018 — Ahead detection (Milestone 1)

**Decision:** Trigger candidates using distance + bearing-vs-course angular window + movement confidence; not radius-only proximity. Defaults documented in `docs/ahead-detection.md`.  
**Rationale:** Distinguishes ahead from nearby/behind.
