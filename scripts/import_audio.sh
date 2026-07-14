#!/usr/bin/env bash
# Copy finished VBT WAVs into this repo once rendering is done.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
# Default: sibling TTS project render output
SRC_DEFAULT="/Users/jigar/projects/Done/vagdhenu - sloka tts/out/vbt"
SRC="${1:-$SRC_DEFAULT}"
DEST="$ROOT/audio"

if [[ ! -d "$SRC" ]]; then
  echo "Source not found: $SRC" >&2
  echo "Usage: bash scripts/import_audio.sh [/path/to/out/vbt]" >&2
  exit 1
fi

mkdir -p "$DEST"
count_before=$(find "$DEST" -name 'vbt_*.wav' | wc -l | tr -d ' ')
rsync -a --include='vbt_*.wav' --exclude='*' "$SRC"/ "$DEST"/
count_after=$(find "$DEST" -name 'vbt_*.wav' | wc -l | tr -d ' ')

echo "audio: $count_before → $count_after wavs in $DEST"
if [[ "$count_after" -lt 163 ]]; then
  echo "note: expected 163 when render finishes (currently $count_after)"
fi
