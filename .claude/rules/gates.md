# Engagement gates

Order is fixed. Do not skip or merge gates; each needs the named engagement lead's explicit words in the conversation, recorded with name and UTC time.

| # | Gate | Evidence needed before it closes | Recorded in |
|---|---|---|---|
| G0 | Qualify | One sentence: pattern considered or not, with the cited guidance passage | `analysis/qualification.md` |
| G1 | Reference set prepared | Manifest with hashes; one converted page compared with its original | `analysis/reference-set.md` |
| G2 | Register approved | Every row scorable pass/fail; every unknown has owner, action, required-by, consequence | `analysis/requirements-register.md` |
| G3 | Requirements baseline approved | Side-by-side check of register vs `spec/requirements.md`; criteria copied unchanged | `spec/requirements.md` metadata |
| G4 | ADRs approved, one at a time | Requirement served, lane, alternatives, disqualifier, deciding proof, owner | `spec/design.md` increment table |
| G5 | Design frozen | All "before freeze" proofs evidenced; every requirement has a decision, plan or proof | `spec/design.md` freeze metadata |
| G6 | Tasks accepted | Bidirectional audit done; every task carries the copied criterion and unfilled proof | `spec/tasks.md` |
| G7 | Target deployed | Caller identity and account confirmed by the lead; parameters match the frozen design | `spec/tasks.md` launch evidence |
| G8 | Evidence captured | Each validation row has source, path, value, result, disposition | `signoff/validation-register.md` |
| G9 | Decision signed | GO, DEFER or NO-GO with name, reason and what it does not authorise | `signoff/go-no-go.md` |

Pre-freeze (G0 to G5): no shell commands that touch a cloud account. Read and write engagement files only.
Post-freeze (G6 onwards): `spec/requirements.md` and `spec/design.md` are read-only.
