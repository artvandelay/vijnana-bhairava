# Vijñāna Bhairava Tantra — reading assistant

A small static site for studying the *Vijñāna Bhairava Tantra*: Devanagari,
IAST, meaning, and (soon) chanted audio for each verse.

**This is a companion to the book**, not a substitute. Keep Jaideva Singh’s
edition open while you listen.

Maintained by [artvandelay](https://github.com/artvandelay).

## Status

- Reader UI: ready
- Verse text (`verses.json`): ready
- Audio (`audio/*.wav`): **pending** — import when the TTS render finishes

## Local preview

```bash
cd /path/to/vijnana-bhairava
python3 -m http.server 8787
# → http://127.0.0.1:8787/
```

## Controls

| Key | Action |
|-----|--------|
| `Space` | Play / pause (owns listening mode) |
| `→` `←` | Next / previous — keeps playing if Space armed listening |
| Swipe | Same as arrows on mobile |
| Verse number | Click, type, Enter to jump |

## When audio is ready

From this repo:

```bash
bash scripts/import_audio.sh
```

That copies finished WAVs from the local render folder into `audio/` and is
safe to re-run (rsync). Then commit `audio/*.wav` for GitHub Pages.

## GitHub Pages

Settings → Pages → Deploy from branch → `/ (root)`.

## Acknowledgments

See [NOTICE.md](./NOTICE.md).

## License

Site code (HTML/CSS/JS): [MIT](./LICENSE).

Sanskrit text of the VBT is classical. Modern English wording in this reader is
provided for study alongside the book — see NOTICE for sources and limits.
