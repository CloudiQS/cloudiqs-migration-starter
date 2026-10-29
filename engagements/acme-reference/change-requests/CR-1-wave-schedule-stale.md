# CR-1 — Wave-plan schedule is stale relative to the current date

> Recorded during Module 4 delivery, not actioned. Per workshop rules, a delivery-phase finding that touches a frozen design parameter is recorded here and stopped, not silently repaired. `design.md`'s wave-plan dates remain unchanged pending a planning-phase decision.

## What was found

`design.md`'s wave plan works backwards from the fixed 15 Nov 2026 cancellation deadline: rehearsal/validation evidence by 18 Oct, DNS TTL ≤5 min by 23 Oct, cutover window 25 Oct. As of today, 2026-10-29, every one of those three intermediate dates has already passed. T15 (DNS TTL) is recorded `OVERDUE` rather than silently re-dated, per instruction.

## Why this matters

R1 itself — "cancellation notice given by 15 Nov 2026" — is not yet breached; that date is still in the future. But the cutover window that was supposed to happen *before* that notice (25 Oct) has already gone by with no recorded cutover. R1's criterion assumes a completed, validated cutover precedes the notice; a notice given without one would mean cancelling a contract Acme still depends on. The wave plan, not R1's wording, is what's stale.

## What this does not do

This does not change R1, R2, or any other frozen requirement. It does not alter `design.md`'s recorded dates — those stay as frozen, visibly wrong relative to today, rather than quietly corrected. It does not block this lab's remaining Module 4/5 mechanics (T7–T12 exercise the migration path regardless of calendar date).

## Proposed change (pending participant decision)

Re-derive the wave-plan dates from today's date (2026-10-29) using the same backward arithmetic `design.md` already uses, or confirm a new real-world exit date with the Managing Director if 15 Nov 2026 itself is no longer realistic. Either path is a **design-level change**, not a requirements change, unless the Managing Director also moves R1's own date.

## Next step if accepted

Per the baseline-change rule: copy the current design baseline to `baseline-history/`, increment to `DES-v2`, reset `design.status` and downstream approvals, and require a new freeze with the corrected wave-plan dates before resuming delivery-phase work on them. Not actioned in this session unless you direct it now.

## Disposition (Partner Workshop Participant, 2026-10-29T18:48:16Z)

Noted and accepted as a finding. **Not actioned in this lab.** Owner: Managing Director, to confirm a realistic exit date. The re-planned wave dates follow as `DES-v2` in Mobilize, once that date is confirmed. T15 stays `OVERDUE` (not re-dated). This finding carries into the Module 5 go/no-go register as an open risk against R1 — a dated requirement currently has no valid cutover window in front of it, and that has to be weighed in the sign-off decision, not just filed here.
