# Vijñāna Bhairava Tantra

An audio reading companion for the *Vijñāna Bhairava Tantra*. Move through the
text one verse at a time with Devanagari, IAST, a concise study note, and a
meter-aware Sanskrit chant.

**[Open the reader →](https://artvandelay.github.io/vijnana-bhairava/)**

This project is designed to sit beside a serious translation and commentary,
not replace one.

## What is included

- The complete numbered text: verses 1–163
- The separately transmitted breath-mantra stanza, shown as 156-A
- 164 locally hosted chant recordings
- Devanagari and IAST text layers
- Original plain-English study notes
- Keyboard, touch, deep-link, and mobile support
- A dependency-free static site suitable for GitHub Pages

## Using the reader

- `Space` toggles listening mode.
- `←` and `→` move between verses. Playback continues when listening mode is on.
- Swipe left or right on touch devices.
- Select the verse counter, enter a number such as `24` or `156A`, and press
  `Enter`.
- Each verse has a stable URL fragment, for example `#vbt_024`.

## Local preview

```bash
python3 -m http.server 8787
```

Then open <http://127.0.0.1:8787/>.

## Project structure

```text
index.html       Reader interface and application logic
verses.json      Sanskrit, IAST, study notes, and audio paths
study_notes.json Original English study notes keyed by audio ID
audio/           Generated WAV recordings
scripts/         Audio import and validation helpers
```

To refresh audio from a completed render:

```bash
bash scripts/import_audio.sh /path/to/rendered/wavs
bash scripts/compress_audio.sh
```

## Text, notes, and audio

The Sanskrit is a classical text in the public domain. The English layer
contains short, independently written orientation notes rather than a
published translation. For close study, consult a critical translation and
commentary.

The chant recordings were generated with
[Vāgdhenu](https://github.com/prathoshap/vagdhenu), the Sanskrit chant TTS
system by Prof. Prathosh A. P., IISc Bengaluru.

See [NOTICE.md](./NOTICE.md) for detailed provenance and limitations.

## License

The site code is released under the [MIT License](./LICENSE). That license does
not claim ownership of the classical Sanskrit text or third-party software and
models acknowledged in [NOTICE.md](./NOTICE.md).
