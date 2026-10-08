# Historic Marker Ahead — Vision

This document is the complete long-term product vision. It is not limited to the current milestone.

**Core product principle:** Quiet most of the time. Interesting when it speaks.

---

## Where the idea came from

While driving around New Mexico, Tim frequently sees roadside signs saying **HISTORIC MARKER AHEAD**. He is normally traveling somewhere and does not have time or reason to stop, get out, and read the marker.

For years, the thought was: *Why can’t my phone simply tell me what that historical marker says while I’m driving past it?*

That is the **brainchild** of Historic Marker Ahead.

The idea developed into the **brain adult**: a location-aware audio history companion that tells you the stories of the places you’re actually driving through.

The product must preserve both ideas. The larger product must never become so elaborate that it loses the simple original promise:

> When I pass a historical marker, let me finally know what the damn thing says.

---

## Hear New Mexico / AM 530 inspiration

An important inspiration is New Mexico’s old **Hear New Mexico** program. Low-power AM broadcasts, remembered on **AM 530**, provided short historical/location-based programs to travelers. Ricardo Montalbán narrated New Mexico historical material.

The experience mattered because the story was connected to the landscape the listener was physically traveling through.

Historic Marker Ahead is a modern evolution of that experience. Instead of a low-power transmitter, a fixed broadcast location, and a small number of prerecorded programs, it can eventually use GPS, direction of travel, route context, historical databases, trusted sources, AI-assisted classification and grounded storytelling, text-to-speech/audio, and personal listening history.

The result should feel somewhat like: **AM 530 follows the truck wherever it goes.**

That is not permission for the app to talk constantly. The experience must remain restrained.

---

## What Historic Marker Ahead is

Historic Marker Ahead is a **history companion for drivers**.

It is **not** intended to replace Apple Maps, Google Maps, the user’s preferred navigation app, or the user’s podcast/music/audiobook app.

Think of the driving experience as three layers:

1. **Navigation layer** — Apple Maps / Google Maps / preferred navigation app  
2. **Entertainment layer** — podcasts / audiobooks / music / other audio  
3. **History layer** — Historic Marker Ahead  

> Maps tells you where you’re going. Historic Marker Ahead tells you where you’ve been.

The application should coexist with the tools the driver already likes.

---

## Original historical markers remain special

Actual roadside historical markers have special status. The application may eventually know about many kinds of historical locations, but an actual historical marker is directly connected to the original purpose of the product.

When the driver approaches an unheard historical marker that is relevant to the road/direction being traveled, Historic Marker Ahead should be capable of announcing and narrating it.

Where source rights permit, eventually distinguish between:

- **READ THE MARKER** — a faithful reading of the marker inscription  
- **TELL ME THE STORY** — a natural, engaging explanation of the larger history based on trustworthy sources  

Do not fabricate marker text. Do not fabricate history.

---

## Just Drive

The foundational mode is **JUST DRIVE**.

The user does not need to enter a destination. They start Historic Marker Ahead and drive normally. The application uses legitimate iOS location services to understand current position, direction/course, movement, speed where useful, and historical locations around/ahead of the vehicle.

The system must distinguish **ahead** from merely **nearby**.

A marker 500 feet away but behind the truck should generally not trigger. A marker approaching along the driver’s direction/path is relevant.

If nothing worthwhile is ahead: **say nothing**. Silence is intentional behavior.

---

## Familiar roads and heard history

Tim drives some roads repeatedly. Historic Marker Ahead must not narrate the same six historical stories every morning.

The application remembers what has already been heard. At minimum, the data model should support:

- historical item/story ID  
- heard status  
- date heard  
- rating  
- source/provenance  
- optional saved status  
- future deeper-story status  
- future encounter/pass information if useful  

Normal behavior should suppress previously heard stories. Future settings might permit never repeat, repeat after a long period, or always allow repeats — do not build unnecessary settings prematurely.

**Governing principle:** Don’t annoy the driver with history they already know.

---

## Thumbs up / thumbs down

Historic Marker Ahead should learn what kinds of history the user enjoys without a complicated preference questionnaire.

The primary explicit feedback mechanism is 👍 / 👎.

- Thumbs-up ≈ more things like this  
- Thumbs-down ≈ less things like this  

A thumbs-down does **not** mean: never show me this entire category again. One boring railroad story must not eliminate all railroad history.

Eventually, implicit behavior can supplement explicit feedback (Tell me more, skipping, completion/listening behavior, repeated engagement). Do not build manipulative engagement mechanics. The purpose is relevance.

---

## History Engine

The long-term History Engine’s central question is:

> Of everything historically interesting ahead, what is worth interrupting the driver to tell them?

Historical material can eventually be categorized automatically (Native American history, Spanish colonial, Mexican-era, territorial, Old West/frontier, military/battles, historic trails, exploration, migration/settlement, Route 66, transportation, railroads, mining, ranching/agriculture, archaeology, architecture, famous people, crime/outlaws, disasters, local/community history, local oddities, natural/geological history, major national events, and more). These categories are not a closed list.

Do not require Tim to manually manage a complicated category preference screen. The system should eventually infer preferences from behavior.

---

## Story selection

Long-term story ranking can consider: actual historical marker status, distance, direction of travel, route relevance, historical significance, user interest, whether previously heard, quality of available source material, quality of the story, relationship to the visible landscape, time since the previous narration, density of other nearby stories, and current driving context.

Do not machine-gun stories at the driver. If six interesting historical sites occur within ten minutes, that does not automatically mean six interruptions. The system needs judgment.

Again: **Quiet most of the time. Interesting when it speaks.**

---

## Discovery

Personalization must not create a history filter bubble. The system should normally favor subjects the user seems to enjoy while occasionally surfacing historically important material, exceptional stories, unusual local history, or something outside established preferences that is unusually relevant.

The user should occasionally discover interests they did not know they had.

---

## Planned Drive / Destination mode (long-term)

Historic Marker Ahead should eventually support planned trips — for example, traveling from New Mexico to New Ulm, Minnesota, or driving to Lubbock, Texas via I-40 toward Santa Rosa and eastern New Mexico.

Before or during the drive, the app can identify historically interesting things along the journey (markers, NPS sites, National Register locations, Native American history, Spanish/Mexican history, historic trails, military history, settlement, Old West, railroads, Route 66, mining, ranching, archaeology, geology, famous people, local stories, major events).

A long route might produce hundreds of candidate records. The History Engine should select a much smaller number worth hearing. History-density behavior (occasional / normal / curious / road-trip) may exist later — do not implement that configuration until authorized by a milestone.

---

## Route changes

Drivers change routes. If a planned drive exists and the driver changes highways, the history experience should eventually adapt. The user should not need to babysit the application. History follows the driver.

---

## Historically interesting routes (future)

A future capability may allow: “I’m going to Lubbock, but I don’t mind adding 20 or 30 minutes if there’s a historically interesting route.” Historic Marker Ahead could eventually compare reasonable route alternatives partly by historical interest.

This is future vision. Preserve it here; do not build it during early milestones unless authorized.

---

## Relationship with Apple Maps / Google Maps

Tim prefers Apple Maps and wants to continue using it. Historic Marker Ahead must not require abandoning Apple Maps. The same principle should eventually apply to Google Maps users.

Do not rebuild a modern navigation platform. Do not recreate traffic, lane guidance, road closures, satellite imagery, full turn-by-turn navigation, full destination search, or mature navigation infrastructure.

Historic Marker Ahead is an add-on/companion application.

Do not assume iOS permits this application to inspect Apple Maps’ private active route state. Respect application boundaries. Future planned-drive functionality may calculate its own lightweight route/history corridor while Apple Maps remains responsible for navigation.

---

## Podcast / audio experience

Central real-world state:

1. Tim is driving.  
2. Apple Maps may be navigating.  
3. A podcast is playing.  
4. Historic Marker Ahead is running appropriately in the background.  
5. An unheard and worthwhile historical location is approaching.  
6. Historic Marker Ahead delivers a short narration.  
7. The podcast/music experience resumes appropriately.  
8. Historic Marker Ahead stays quiet until something else genuinely deserves attention.  

The desired experience resembles a useful navigation prompt temporarily taking appropriate audio priority over entertainment.

Investigate what current public iOS APIs actually allow. Do not assume a third-party app receives Apple’s private/system privileges. Implement the most natural supported behavior. Test it. Document limitations honestly. Never fake unsupported platform behavior.

---

## Voice interaction (future)

Long term, minimize touch interaction while driving. Potential commands: “Tell me more,” “Skip,” “Read the marker,” “Save that.”

Voice interaction should support driving safety rather than encourage screen interaction. Do not build a huge conversational assistant during early milestones.

---

## Historical data

Initial geographic focus: **New Mexico**, with future nationwide potential.

Legitimate sources include (among others): New Mexico Historic Preservation Division official historical/scenic marker information; Historical Marker Database (HMdb) where terms permit; National Park Service; National Register datasets; OpenStreetMap; other authoritative government/local historical sources.

This is initially a personal, noncommercial application. Do not build commercial licensing machinery. Every historical record should preserve provenance.

Do not recklessly scrape websites. Respect source terms. Do not fabricate history.

---

## AI’s role

AI is storyteller, classifier, summarizer, and relevance/ranking assistant. AI is **not** historical authority.

Historical narration must be grounded in identifiable source material. AI may eventually summarize sources, produce spoken versions, classify material, rank candidates, create short and longer grounded versions, and explain historical context.

AI must **not** invent facts, invent quotations, invent historical events, or silently fill gaps with plausible-sounding history.

Source provenance should remain available even when citations are not spoken aloud. The user should eventually be able to inspect sources while parked.

---

## Privacy

Location is necessary. Unnecessary tracking is not.

Prefer on-device/local processing where practical. Do not automatically create cloud location surveillance. Do not add analytics or third-party tracking merely because most applications do. No advertising. This is currently a personal project.

---

## Technology direction

Build **native iOS first** with Swift, SwiftUI, Core Location / current supported Apple location APIs, current supported Apple audio APIs, appropriate local persistence, and appropriate native background capabilities.

Do **not** build this as a PWA. Do **not** begin Android development. Do **not** create speculative cross-platform abstraction layers.

Separate UI, location/trigger logic, historical data, persistence, and narration/audio well enough that deterministic logic can be tested. KISS.

---

## Version direction (non-authorizing)

Conversational labels **V1 / V2 / V3** mean roughly: V1 = prove Just Drive with real markers; V2 = smarter on-road judgment and quieter/better companion behavior from real use; V3 = planned-drive / richer historical context. These labels do not authorize implementation. Only `MILESTONE.md` does.

---

## Success moment

The first drive where this happens is the important moment:

Tim is driving through New Mexico. Apple Maps may be navigating. A podcast is playing. Historic Marker Ahead is quietly running. There is an unheard historical marker genuinely ahead. At an appropriate point, Historic Marker Ahead speaks: “Historic Marker Ahead…” It tells Tim something worthwhile about the place he is physically traveling through. Then it stops. His normal drive continues. The marker is remembered as heard. The next time he drives that road, the application does not mindlessly tell him the same thing again.

That is the first product experience we need to prove.
