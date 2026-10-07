#!/usr/bin/env python3
"""Normalize NM HPD Official Scenic Historic Markers spreadsheet → JSON catalogs."""

from __future__ import annotations

import argparse
import hashlib
import json
import re
from datetime import datetime, timezone
from pathlib import Path

try:
    import openpyxl
except ImportError as exc:  # pragma: no cover
    raise SystemExit("Install openpyxl: pip install openpyxl") from exc

ROOT = Path(__file__).resolve().parents[1]


def slugify(value: str) -> str:
    slug = re.sub(r"[^a-zA-Z0-9]+", "-", (value or "").strip().lower()).strip("-")
    return slug[:80] or "untitled"


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "xlsx",
        nargs="?",
        default=str(ROOT / "data/sources/OSHM-spreadsheet-for-website.xlsx"),
    )
    args = parser.parse_args()
    src = Path(args.xlsx)
    wb = openpyxl.load_workbook(src, read_only=True, data_only=True)
    rows = list(wb["Sheet1"].iter_rows(values_only=True))
    header = rows[0]
    if header[0] != "IDNUMBER":
        raise SystemExit(f"Unexpected header: {header[:5]}")

    records = []
    for row in rows[1:]:
        if not row or row[1] is None:
            continue
        idnumber, title, text, lon, lat = row[0], str(row[1]).strip(), row[2], row[3], row[4]
        county, city, highway, mile = row[5], row[6], row[7], row[8]
        women, revised, notes = row[9], row[10], row[11]
        has_coords = lat is not None and lon is not None
        latitude = float(lat) if has_coords else None
        longitude = float(lon) if has_coords else None
        if has_coords and not (31 <= latitude <= 38 and -110 <= longitude <= -102):
            has_coords = False
            latitude = longitude = None
        source_id = str(idnumber) if idnumber is not None else slugify(title)
        content = f"{title}\n{text or ''}".encode("utf-8")
        revised_s = None
        if revised is not None:
            revised_s = revised.isoformat() if hasattr(revised, "isoformat") else str(revised)
        records.append(
            {
                "id": f"nm-oshm-{source_id}",
                "sourceId": source_id,
                "title": title,
                "latitude": latitude,
                "longitude": longitude,
                "inscription": (str(text).strip() if text else None),
                "summary": None,
                "county": str(county).strip() if county else None,
                "cityOrVicinity": str(city).strip() if city else None,
                "highway": str(highway).strip() if highway else None,
                "mileMarker": str(mile).strip() if mile else None,
                "historicWomensMarker": bool(women)
                if women not in (None, "", 0, "No", "no")
                else False,
                "dateApprovedOrRevised": revised_s,
                "additionalLocationNotes": str(notes).strip() if notes else None,
                "categories": ["official-scenic-historic-marker", "new-mexico"],
                "sourceName": (
                    "New Mexico Historic Preservation Division — "
                    "Official Scenic Historic Markers spreadsheet"
                ),
                "sourceUrl": (
                    "https://www.nmhistoricpreservation.org/programs/"
                    "official-scenic-historic-markers.html"
                ),
                "sourceFile": "data/sources/OSHM-spreadsheet-for-website.xlsx",
                "attribution": (
                    "Marker text and program data © State of New Mexico / "
                    "Historic Preservation Division. Used for a personal "
                    "noncommercial prototype from the publicly posted OSHM spreadsheet."
                ),
                "contentSha256Prefix": hashlib.sha256(content).hexdigest()[:16],
                "hasCoordinates": has_coords,
                "isOfficialScenicHistoricMarker": True,
            }
        )

    geo = [r for r in records if r["hasCoordinates"]]
    bundle = {
        "schemaVersion": 1,
        "generatedAt": datetime.now(timezone.utc).isoformat(),
        "source": {
            "name": "NM HPD Official Scenic Historic Markers spreadsheet",
            "url": (
                "https://www.nmhistoricpreservation.org/assets/files/markers/"
                "OSHM%20spreadsheet%20for%20website.xlsx"
            ),
            "programPage": (
                "https://www.nmhistoricpreservation.org/programs/"
                "official-scenic-historic-markers.html"
            ),
            "coordinateCoverage": {
                "totalMarkers": len(records),
                "withCoordinates": len(geo),
                "withoutCoordinates": len(records) - len(geo),
            },
        },
        "markers": records,
    }

    out_full = ROOT / "data/processed/nm-official-scenic-markers.json"
    out_geo = ROOT / "data/processed/nm-official-scenic-markers-geocoded.json"
    app_geo = ROOT / "Apps/HistoricMarkerAhead/Resources/nm-official-scenic-markers-geocoded.json"
    out_full.parent.mkdir(parents=True, exist_ok=True)
    app_geo.parent.mkdir(parents=True, exist_ok=True)
    out_full.write_text(json.dumps(bundle, ensure_ascii=False, indent=2), encoding="utf-8")
    runtime = {**bundle, "markers": geo, "subset": "geocoded-only"}
    out_geo.write_text(json.dumps(runtime, ensure_ascii=False, indent=2), encoding="utf-8")
    app_geo.write_text(json.dumps(runtime, ensure_ascii=False), encoding="utf-8")
    print(f"Wrote {len(records)} markers ({len(geo)} geocoded) → {out_full}")


if __name__ == "__main__":
    main()
