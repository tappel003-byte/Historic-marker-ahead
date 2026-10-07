# Audio coexistence (Milestone 1)

## Goal

While a podcast/music may be playing and Apple Maps may be navigating, Historic Marker Ahead should deliver a short narration, then return the audio environment to normal as far as public APIs allow.

## Public API approach (implemented)

Based on Apple’s audio session guidance for navigation-style spoken prompts:

- Category: `AVAudioSession.Category.playback`
- Options:
  - `.duckOthers`
  - `.interruptSpokenAudioAndMixWithOthers`
- Activate the session **only when a prompt is needed**
- Deactivate with `notifyOthersOnDeactivation` **after** speech finishes

Narration engine: `AVSpeechSynthesizer` (on-device TTS).

References (Apple documentation):

- Audio guidelines by app type (navigation / workout spoken prompts)
- `AVAudioSession.CategoryOptions.duckOthers`
- `interruptSpokenAudioAndMixWithOthers`

## Expected behavior

| Other audio | Expected when HMA speaks |
| --- | --- |
| Music | Volume ducks, then restores after deactivation |
| Podcast / audiobook (spoken) | Spoken content is interrupted/paused by the option above; may resume depending on the other app |
| Apple Maps prompts | OS mediates mixing/interruption; third-party apps do **not** get Maps’ private privileges |

## Observed behavior

**Not validated in this Linux/cloud environment** (no iPhone / no Xcode Simulator audio stack here).

Tim should validate on a physical device:

1. Start Apple Music or a podcast.  
2. Optionally start Apple Maps navigation with voice on.  
3. Start **Just Drive** in Historic Marker Ahead.  
4. Trigger a marker (real drive or Xcode simulated location).  
5. Confirm duck/interrupt/resume behavior and note anything surprising in a future `DECISIONS.md` entry if defaults must change.

## Limitations (honest)

- We cannot claim identical behavior to Apple Maps’ own prompt system.
- Other apps decide whether they resume after interruption.
- Background audio reliability also depends on Background Modes (`audio` + `location`) and user permission choices.
- Do not fake unsupported platform behavior in UI or docs.
