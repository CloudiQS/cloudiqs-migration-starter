# Transfer Window Arithmetic — Worksheet

> Run this before promising any date. The three numbers that sink cutover plans:
> the bandwidth you may actually use, the churn a final sync must move, and the
> lead time of anything in an archive tier.

## 1. Usable bandwidth

| Input | Value |
|---|---|
| Link capacity | ______ Mbps |
| Business cap (what you may sustain without hurting operations) | ______ Mbps |
| Usable hours per day (cap may vary by hour) | ______ h |
| **Effective daily transfer volume** = cap × 3600 × hours ÷ 8 ÷ 1024² | ______ GB/day |

## 2. Bulk copy

| Input | Value |
|---|---|
| Total volume | ______ TB |
| − Archive-tier volume (separate lane, below) | ______ TB |
| **Bulk days** = (volume × 1024) ÷ effective daily volume | ______ days |

## 3. Archive tier

| Input | Value |
|---|---|
| Archive volume | ______ TB |
| Rehydration lead time (per provider tier) | ______ days |
| Rehydration cost treatment (one-time, listed separately) | ______ |
| **Earliest archive completion** = rehydration + its transfer days | ______ |

## 4. The final sync — churn, not growth

| Input | Value |
|---|---|
| Net growth (what inventories show) | ______ GB/month |
| **Daily churn** (what actually changes: rewrites, replacements) | ______ GB/day |
| Final-sync volume ≈ churn × days since last incremental | ______ GB |
| **Final-sync duration** at cap — must fit the cutover window | ______ h |

## 5. Verdict

| Question | Answer |
|---|---|
| Does bulk complete before the dated dependency, with margin? | |
| Does the final sync fit the window *including validation time*? | |
| What breaks the math first (cap, churn, archive, window)? | |
| Which number is least trusted, and who validates it by when? | |
