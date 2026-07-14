#!/usr/bin/env bash
# Copy finished VBT WAVs into this static-site repository.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
SRC="${1:-}"
DEST="$ROOT/audio"

if [[ -z "$SRC" || ! -d "$SRC" ]]; then
  echo "Usage: bash scripts/import_audio.sh /path/to/rendered/wavs" >&2
  exit 1
fi

mkdir -p "$DEST"
count_before=$(find "$DEST" -name 'vbt_*.wav' -print | wc -l | tr -d ' ')
rsync -a --include='vbt_*.wav' --exclude='*' "$SRC"/ "$DEST"/
count_after=$(find "$DEST" -name 'vbt_*.wav' -print | wc -l | tr -d ' ')

echo "audio: $count_before → $count_after wavs in $DEST"
if [[ "$count_after" -lt 164 ]]; then
  echo "error: expected 164 audio units (currently $count_after)" >&2
  exit 1
fi
