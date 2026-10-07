# Historical data sources (Milestone 1)

## Primary source — NM Official Scenic Historic Markers

| Field | Value |
| --- | --- |
| Program | New Mexico Historic Preservation Division — Official Scenic Historic Markers |
| Program page | https://www.nmhistoricpreservation.org/programs/official-scenic-historic-markers.html |
| Machine-readable file used | `OSHM spreadsheet for website.xlsx` (publicly posted) |
| Spreadsheet URL | https://www.nmhistoricpreservation.org/assets/files/markers/OSHM%20spreadsheet%20for%20website.xlsx |
| Local copy | `data/sources/OSHM-spreadsheet-for-website.xlsx` |
| Complementary PDF guide | 2017 Historic Markers Database PDF (title/text/highway/milemarker; no reliable lat/lon) |

### Import outputs

| File | Contents |
| --- | --- |
| `data/processed/nm-official-scenic-markers.json` | Full normalized catalog (~622 markers) |
| `data/processed/nm-official-scenic-markers-geocoded.json` | Geocoded subset for runtime (~324) |
| `Apps/HistoricMarkerAhead/Resources/nm-official-scenic-markers-geocoded.json` | Bundled app catalog |

### Provenance fields preserved

`id`, `sourceId`, `title`, `latitude`, `longitude`, `inscription`, county/vicinity/highway/mile marker, women’s marker flag, revision date, notes, source name/URL/file, attribution, content hash prefix.

### Known gap

The official spreadsheet includes `LAT` / `LONG` columns, but **only a subset of rows have coordinates** (about 324 of 622 at import time). Markers without coordinates:

- remain in the full catalog with provenance
- **cannot auto-trigger** in Milestone 1
- are candidates for future legitimate geocoding (not invented coordinates)

Re-import:

```bash
python3 scripts/import_oshm.py path/to/OSHM-spreadsheet-for-website.xlsx
```

## Complementary sources (not required for Milestone 1 runtime)

- **HMdb.org** — noncommercial use with attribution is allowed per https://www.hmdb.org/copyright.asp; commercial use needs permission. Not ingested for Milestone 1.
- **OpenStreetMap** — some NM historic information boards exist with coordinates (ODbL). Useful future complement for geocoding, not used as the primary inscription authority.
- **NPS / National Register** — future broader History Engine material.

## Policy

- Do not fabricate marker text or coordinates.
- Do not scrape sites recklessly.
- Prefer official NM program text for “read the marker” style narration.
