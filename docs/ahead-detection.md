# Ahead detection algorithm (Milestone 1)

Goal: distinguish **ahead** from merely **nearby** / **behind**.

This is intentionally simple and deterministic so it can be unit tested. It is not the long-term History Engine.

## Inputs

For a vehicle sample and a candidate marker:

- vehicle latitude / longitude  
- vehicle **course** (degrees clockwise from true north), when available  
- vehicle **speed** (m/s), when available  
- marker latitude / longitude  
- whether the marker was already heard  

## Geometry

1. **Distance** — great-circle meters via haversine.  
2. **Bearing** — initial bearing from vehicle to marker (0…360°).  
3. **Angular difference** — smallest absolute difference between course and bearing (0…180°).

## Classification

A marker is **ahead** when:

- distance ≤ `maxDistanceMeters` (default **450 m**), and  
- angular difference ≤ `aheadHalfAngleDegrees` (default **55°**)

Otherwise it is classified **nearby** (within a wider awareness radius but not ahead) or **behind/irrelevant**.

Defaults chosen for highway approaches to roadside pullouts: wide enough for imperfect course, narrow enough to suppress markers the truck has already passed.

## Trigger eligibility (automatic narration)

A marker may auto-trigger only if **all** are true:

1. It is **ahead** under the geometry rules above.  
2. It has coordinates.  
3. It is **not** already heard.  
4. Movement confidence is acceptable:
   - speed ≥ `minSpeedMetersPerSecond` (default **2.5 m/s** ≈ 5.6 mph), **or**  
   - course is present and considered usable (caller supplies `courseValid`)  
5. Global narration cooldown has elapsed (default **90 s** since last narration start).  
6. Among eligible markers, choose the **closest** ahead candidate.

## Explicit non-goals

- Not a full map-matched road network.  
- Not route-corridor planning.  
- Not “any marker within radius.” Radius alone is insufficient.

## Tunables

See `AheadDetector.Configuration` in `HistoricMarkerCore`.
