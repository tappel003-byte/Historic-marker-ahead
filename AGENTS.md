# AGENTS.md — Instructions for coding agents

Authority hierarchy:

**VISION.md → AGENTS.md → MILESTONE.md → DECISIONS.md → current code**

## Rules

1. **Tim is product owner.** Ask him for product-shaping decisions; do not invent requirements.
2. **Read governing documents** (`VISION.md`, this file, `MILESTONE.md`, `DECISIONS.md`) before modifying the project.
3. **Do not invent product requirements** that are not in the governing docs or an explicit Tim instruction.
4. **Do not silently change the vision.** Propose changes; do not rewrite `VISION.md` casually.
5. **Future vision does NOT authorize immediate implementation.** Long-term ideas in `VISION.md` wait for milestone authorization.
6. **`MILESTONE.md` defines currently authorized implementation.**
7. **Prefer simple solutions.** KISS over speculative architecture.
8. **Avoid speculative architecture** and premature abstraction layers.
9. **Historical content must remain source-grounded.** Do not fabricate marker text or history.
10. **Preserve source provenance** on every historical record.
11. **Do not add analytics/tracking** without explicit approval.
12. **Do not increase driving distraction.** Audio-first; keep driving UI minimal and safe.
13. **Test actual platform behavior.** Especially location, background, and audio coexistence.
14. **Document meaningful decisions** in `DECISIONS.md` (not a general activity log).
15. **Never claim unsupported iOS behavior works.** Document limitations honestly.
16. **Preserve:** *Quiet most of the time. Interesting when it speaks.*

## Authority and external context

17. **Tim is the sole decision-maker.** Suggestions from Cursor, ChatGPT, or anyone else are not approvals.
18. **External archives are not authorization.** Project brainstorm docs, ChatGPT reconstructions, and session notes are informational only. They do not authorize code, PRs, milestones, or distribution choices unless Tim copies a decision into these governing docs or gives an explicit instruction.
19. **No repo or app changes without Tim saying so.** Do not open PRs, edit code/config, enroll services, or “just fix” distribution/signing unless Tim explicitly asks in this conversation (or an equivalent direct instruction).
20. **Version labels ≠ milestones.** Product direction may be discussed as V1 / V2 / V3. Only `MILESTONE.md` authorizes implementation. There is no separate “D1” stage (see `DECISIONS.md`).

## Repository boundaries

- Work in the existing public repo: `https://github.com/tappel003-byte/Historic-marker-ahead`
- Do not create another repository for this product.
- Do not commit secrets, API keys, credentials, provisioning profiles, certificates, generated build artifacts, or user-specific Xcode data.

## Engineering expectations

- Native iOS (Swift / SwiftUI) first.
- Keep deterministic geometry, trigger, and persistence logic testable without a drive.
- Prefer on-device processing and local persistence for V1.
- Separate UI, location/trigger logic, historical data, persistence, and narration/audio.
- Milestone 1 implements the V1 “Just Drive” proof; later V2/V3 ideas stay in `VISION.md` until a new milestone authorizes them.
