2026-05-02 librarian run

Actions:
- Created `/home/li/philosophy-city/library/.env` as a local Anna Archive CLI placeholder; kept it local-only via `.git/info/exclude`. Search now runs without the missing-.env warning. No shared catalog/config commit made because the library jj worktree already has unrelated local setup changes.
- Searched Anna Archive for the requested preferred editions and selected the best candidate hashes by requested edition plus format preference.

Candidate hits found:
- Heraclitus, Charles H. Kahn, The Art and Thought of Heraclitus, Cambridge: EPUB `927b8b33fec7f5ad2f5e6e42b6571181` selected over PDF/DJVU scans.
- Plutarch, Moralia I, Loeb 197, Babbitt: DJVU `37d5938cc80e272cee58d3f4c8d58d29` selected; no text-format Loeb hit found.
- Plutarch, Moralia VIII, Table Talk, Loeb: already present and cataloged at `en/plutarch/plutarch-moralia-viii-table-talk.pdf`, MD5 `2c1d85f40ab5548fc909b7d86042130b`.
- Cicero, De Oratore I-II, Loeb 348, Sutton/Rackham: PDF `5c369dc310e2cc6712800cadf95cf30d`.
- Cicero, De Oratore III / De Fato / Paradoxa Stoicorum / De Partitione Oratoria, Loeb 349, Rackham: PDF `7a28c7ddd13ba3b6ac115ceecc58a74c`.
- Cicero, De Natura Deorum / Academica, Loeb 268, Rackham: PDF `165ea164558f15629167162931009b2f` or alternate `6f504c11445c98a6e8f39f0fb3d0fc9c`.
- Cicero, Tusculan Disputations, Loeb 141, J. E. King: PDF `4b2fd3ca1ec73fbfc5b91f8d35145f1b`.
- Cicero, De Officiis, Loeb 30, Walter Miller: PDF `35b1ca47c1b905a897447f986e1e9dc0`.

Fetch result:
- `annas book-download` failed with `403 Forbidden` for Heraclitus Kahn, Plutarch Moralia I, Cicero De Oratore I-II, and Cicero De Oratore III. Retried Heraclitus with `ANNAS_BASE_URL=annas-archive.gl`; same 403. The wrapper does find a `gopass` secret-key entry, so this appears to be invalid/expired/non-member fast-download access rather than a missing env var name.
- After the systemic 403, remaining Cicero candidate downloads were not retried one by one; they use the same API path and would hit the same credential failure.
- No new Heraclitus, Cicero, or Plutarch Moralia I files landed. No `bibliography.md` entries were added for failed candidates to avoid creating catalog hashes without local files.

Audit summary:
- Uncataloged local files by MD5: 31. Examples: `en/aarne-ranta/grammatical-framework.djvu` `462a017c97b9cf5b34bef87fac0ee3bd`; `en/david-spivak/category-theory-for-sciences.pdf` `1528f03405b18ee75ec9729ce541e210`; `en/ptolemy/tetrabiblos.pdf` `dbcaadacc6a39c783e60fdc258c7f506`; `en/wilhelm-halbfass/halbfass-india-and-europe.pdf` `1f9818373df0fa33000018ed5f32c3a6`.
- Catalog hashes without a matching local file: 69. First samples: `0049579d212a111636b47269e4cdc5af`, `004bd25c8ef7aa2bf66c703e60a2e284`, `01c2dfacd0f4a8522bfe58012abcc7d7`, `04403e9ba8da4ce574fe18372fc53021`, `0b495318eeb9910030f1e7e245ee65c9`.
- Duplicate local file hash: Bryant Yoga Sutras EPUB `726a9ac0cfea0ad31ce03f101b93f86a` exists in both `en/edwin-bryant/` and `en/patanjali/`.
- Catalog structure drift: `bibliography.md` currently has two `Tier 7b` headings; not touched in this bead.

Status: blocked on working Anna Archive member fast-download key. Next action after credential fix: run the candidate downloads above, file Cicero Loeb PDFs under both `en/cicero/` and `la/cicero/`, then add a Classical Philosophy and Dialectic tier entry with landed hashes.

