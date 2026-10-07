# Testing

## Unit tests (deterministic)

Core geometry, ahead classification, trigger selection, and heard-history suppression live in `HistoricMarkerCore` and can run without a device:

```bash
cd HistoricMarkerCore
swift test
```

On a Mac with Xcode:

```bash
xcodebuild test -scheme HistoricMarkerAhead -destination 'platform=iOS Simulator,name=iPhone 16'
```

(Exact simulator name may vary.)

## Xcode simulated locations

1. Open `HistoricMarkerAhead.xcodeproj` in Xcode.  
2. Run on a Simulator or a debuggable device.  
3. Start **Just Drive** and grant location permission.  
4. In Xcode: **Debug → Simulate Location**  
   - Use a GPX near a geocoded marker (see `data/fixtures/sample-route-abq.gpx`), or  
   - Pick a city and manually verify debug bearings, or  
   - Create a custom GPX that approaches a marker from `data/processed/nm-official-scenic-markers-geocoded.json`.  
5. Open **Debug** in the app to inspect coordinates, course, candidates, ahead/behind, heard status, and suppression reasons.

Simulator location often lacks a realistic **course**. The detector accepts either sufficient speed **or** a valid course; for course-sensitive checks, prefer a GPX with moving points or a real drive.

## Physical iPhone checklist (Milestone 1 proof)

1. Build/run from Xcode with a development team selected.  
2. Grant **While Using** / **Always** location as prompted (background updates need the appropriate authorization).  
3. Start a podcast + optionally Apple Maps.  
4. Tap **JUST DRIVE**.  
5. Drive toward an unheard geocoded Official Scenic Historic Marker.  
6. Confirm narration, thumbs, Recent History, and that a second pass does not re-narrate.  
7. Use Debug only while parked/safe.

## Reset heard history

Settings → **Reset heard history** (developer/testing aid).
