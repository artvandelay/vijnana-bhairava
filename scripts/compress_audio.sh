#!/usr/bin/env bash
# Convert source WAV recordings to compact, browser-friendly mono MP3 files.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
AUDIO_DIR="$ROOT/audio"

command -v ffmpeg >/dev/null || {
  echo "ffmpeg is required" >&2
  exit 1
}

for wav in "$AUDIO_DIR"/vbt_*.wav; do
  mp3="${wav%.wav}.mp3"
  [[ -s "$mp3" ]] && continue
  ffmpeg -nostdin -hide_banner -loglevel error -i "$wav" \
    -map_metadata -1 -ac 1 -ar 24000 -codec:a libmp3lame -b:a 96k \
    "$mp3"
done

wav_count=$(find "$AUDIO_DIR" -name 'vbt_*.wav' -print | wc -l | tr -d ' ')
mp3_count=$(find "$AUDIO_DIR" -name 'vbt_*.mp3' -print | wc -l | tr -d ' ')
if [[ "$wav_count" -eq 0 && "$mp3_count" -eq 164 ]]; then
  echo "audio already compressed: 164 MP3 files"
  exit 0
fi
echo "compressed $mp3_count/$wav_count recordings"
[[ "$mp3_count" -eq "$wav_count" ]]

for wav in "$AUDIO_DIR"/vbt_*.wav; do
  rm -f "$wav"
done
echo "removed source WAV copies from the static site"
