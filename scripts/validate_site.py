#!/usr/bin/env python3
"""Validate the static reader manifest and its local audio assets."""

from __future__ import annotations

import json
import shutil
import subprocess
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
MANIFEST = ROOT / "verses.json"
NOTES = ROOT / "study_notes.json"
AUDIO_DIR = ROOT / "audio"


def validate_audio(path: Path, clip_id: str) -> None:
    assert path.is_file(), f"{clip_id}: missing {path}"
    assert path.stat().st_size > 10_000, f"{clip_id}: audio file is implausibly small"

    ffprobe = shutil.which("ffprobe")
    if not ffprobe:
        return
    probe = subprocess.run(
        [
            ffprobe,
            "-v",
            "error",
            "-select_streams",
            "a:0",
            "-show_entries",
            "stream=sample_rate,channels,duration",
            "-of",
            "json",
            str(path),
        ],
        check=True,
        capture_output=True,
        text=True,
    )
    stream = json.loads(probe.stdout)["streams"][0]
    assert int(stream["channels"]) == 1, f"{clip_id}: expected mono"
    assert int(stream["sample_rate"]) == 24_000, f"{clip_id}: expected 24 kHz"
    assert float(stream.get("duration") or 0) > 0, f"{clip_id}: empty audio"


def main() -> None:
    verses = json.loads(MANIFEST.read_text(encoding="utf-8"))
    notes = json.loads(NOTES.read_text(encoding="utf-8"))

    ids = [row["id"] for row in verses]
    assert len(verses) == 164, f"expected 164 units, found {len(verses)}"
    assert len(ids) == len(set(ids)), "duplicate manifest IDs"
    assert set(notes) == set(ids), "study-note IDs do not match manifest IDs"
    assert all(notes[clip_id].strip() for clip_id in ids), "blank study note"

    addendum_index = ids.index("vbt_156a")
    assert ids[addendum_index - 1 : addendum_index + 2] == [
        "vbt_155",
        "vbt_156a",
        "vbt_156",
    ], "156-A is not ordered between verses 155 and 156"

    expected_audio: set[Path] = set()
    for row in verses:
        assert row["padas"], f"{row['id']}: no Devanagari"
        assert row["iast"], f"{row['id']}: no IAST"
        assert row["english"] == notes[row["id"]], f"{row['id']}: note mismatch"
        assert row["ready"] is True, f"{row['id']}: marked unavailable"

        audio_path = ROOT / row["audio"]
        expected_audio.add(audio_path.resolve())
        validate_audio(audio_path, row["id"])

    actual_audio = {path.resolve() for path in AUDIO_DIR.glob("vbt_*.mp3")}
    assert actual_audio == expected_audio, "orphan or missing MP3 files"
    print("validated 164 reader units and 164 mono 24 kHz MP3 files")


if __name__ == "__main__":
    main()
