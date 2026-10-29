# Library Source Manifest — <LIBRARY NAME>

> What was downloaded, from where, when, and what was done to it. A converted
> library without a dated manifest cannot tell a customer which edition of the
> guidance their design rests on. If you refresh a document without updating its
> row, the next engagement inherits a citation nobody can date.

## <Collection name — e.g., an SSB, or an internal runbook set>

| Document | Staged file | Acquired | Source version | Converter |
|---|---|---|---|---|
| | | YYYY-MM-DD | | |

Source: <campaign page / internal repo URL — where the canonical copies live>

## Conversion rules

- One file per document; text verbatim; headings preserved — headings are the citation addresses.
- Record the converter; different tools render headings differently.
- Leave conversion artifacts (missing figures, stray characters) unfixed so files stay diffable against originals.

## Refresh procedure

1. Download fresh from the canonical source.
2. Convert with the recorded converter; keep filenames stable so citations resolve.
3. Update this manifest: date, version, converter.
4. Re-check the evidence index: every cited heading must still exist; fix the index, never the source.
