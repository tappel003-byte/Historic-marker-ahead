# Historic Marker Ahead

A location-aware audio history companion that tells you the stories of the places you’re actually driving through.

**Quiet most of the time. Interesting when it speaks.**

Native iOS (Swift / SwiftUI). Companion to Apple Maps — not a navigation replacement.

## Current milestone

**Milestone 1 — Just Drive proof of concept** (see `MILESTONE.md`)

Can the app run on a real drive, notice an unheard Official Scenic Historic Marker *ahead*, speak useful source-grounded content, remember it was heard, and otherwise stay quiet?

## Governing documents

| Doc | Role |
| --- | --- |
| `VISION.md` | Complete long-term product vision (not just V1) |
| `AGENTS.md` | Rules for coding agents |
| `MILESTONE.md` | Currently authorized implementation |
| `DECISIONS.md` | Durable decisions |

Authority: **VISION → AGENTS → MILESTONE → DECISIONS → code**

## Architecture

```
HistoricMarkerCore/          Pure Swift package (geometry, ahead detection, heard history, narration text)
Apps/HistoricMarkerAhead/    SwiftUI app (Just Drive, Recent, Debug, Settings)
data/sources/                Official NM OSHM spreadsheet (local copy)
data/processed/              Normalized JSON catalogs + provenance
docs/                        Data sources, ahead algorithm, audio coexistence, testing
```

Layers stay separated: UI · location/trigger · historical data · persistence · narration/audio.

## Requirements

- macOS with **Xcode 15+** (iOS 17 SDK)
- Apple ID / development team for device install
- Physical iPhone recommended for background location + audio coexistence validation

This cloud/Linux environment can run `HistoricMarkerCore` unit tests with the Swift toolchain, but **cannot** build or run the iOS app UI.

## Historical data

Primary source: New Mexico Historic Preservation Division **Official Scenic Historic Markers** spreadsheet (public).

- Full catalog: `data/processed/nm-official-scenic-markers.json` (**622** markers)
- Geocoded runtime subset: **324** markers with LAT/LONG (bundled in the app)
- Markers without coordinates are preserved but do not auto-trigger in Milestone 1

Details: `docs/data-sources.md`

Re-import:

```bash
python3 scripts/import_oshm.py
# requires: pip install openpyxl
```

## How to build & run (Mac / Tim)

1. Clone this repository.  
2. Open `HistoricMarkerAhead.xcodeproj` in Xcode.  
3. Select the **HistoricMarkerAhead** target → Signing & Capabilities → choose your **Team**.  
4. Connect an iPhone (iOS 17+) or pick a Simulator.  
5. Run (⌘R).  
6. On first **JUST DRIVE**, allow location access when prompted.

Permissions used (see `Info.plist`):

- **Location When In Use / Always** — detect markers ahead during Just Drive  
- **Background Modes:** `location`, `audio` — continue a Just Drive session and finish spoken prompts  

No analytics, ads, or cloud uploads in this build.

## How to run tests

Deterministic core tests (Linux or Mac):

```bash
cd HistoricMarkerCore
swift test
```

Xcode (Mac):

```bash
xcodebuild test -scheme HistoricMarkerAhead -destination 'platform=iOS Simulator,name=iPhone 16'
```

See `docs/testing.md` for simulated locations and the physical-drive checklist.

## Simulated locations

1. Run the app; start **JUST DRIVE**.  
2. Xcode → **Debug → Simulate Location**.  
3. Use `data/fixtures/sample-route-abq.gpx`, or build a GPX that approaches a coordinate from `data/processed/nm-official-scenic-markers-geocoded.json`.  
4. Watch the **Debug** tab for distance, bearing, Δcourse, ahead/behind, eligibility, and suppression reasons.

Note: Simulator course can be weak; a real drive or a multi-point GPX is better for ahead detection.

## Audio coexistence

Implemented with public `AVAudioSession` guidance for navigation-style prompts (`.duckOthers` + `.interruptSpokenAudioAndMixWithOthers`, activate only while speaking).  

**Device validation still required.** See `docs/audio-coexistence.md` for expected behavior and honest limitations.

## Project structure (app)

- **Home** — brand + **JUST DRIVE**  
- **Just Drive** — location session, ahead detection, TTS narration, 👍/👎  
- **Recent History** — heard items + ratings  
- **Debug** — vehicle + candidate marker diagnostics  
- **Settings** — reset heard history, data attribution  

## Known iOS limitations

- Third-party apps cannot read Apple Maps’ private active route.  
- Audio mixing/resume behavior is OS- and peer-app-mediated; not identical to Maps’ own prompts.  
- Official OSHM coordinate coverage is incomplete; ungeocoded markers won’t auto-trigger.  
- Background reliability depends on permission choices and system resource policies.

## License / use

Personal noncommercial prototype. Marker text © State of New Mexico / Historic Preservation Division (from their publicly posted OSHM materials). See provenance fields in the JSON catalog.
