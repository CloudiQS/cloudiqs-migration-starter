# T1 — dispatch-db source readiness (status record)

> Status record only. No role-play, no invented values — the Module 2 interview is closed and the real Azure database is not reachable from this lab. Confirmed items carry `[CUSTOMER]`; everything else is `[OPEN]` with an owner.

| Item | Status | Value / note | Source |
|---|---|---|---|
| Binary logging enabled | Confirmed | Yes | `[CUSTOMER]`, Module 2 interview Q2 |
| `binlog_format` | Confirmed | `ROW` | `[CUSTOMER]`, Module 2 interview Q2 |
| `binlog_row_image` | `[OPEN]` | Not checked — required `FULL` per the borrowed Google Cloud SQL for MySQL prerequisite (`implementation-guide-dms.md`, `## Source page 3`) | Owner: Applications Lead, before freeze — **D1**, not yet closed even though the design is frozen; ADR-1's disqualifier remains live until this is proved |
| Binlog retention | `[OPEN]` | "Set low — would need extending" (Module 2 interview), exact window unknown | Owner: Applications Lead |
| Retention extension to cover rehearsal + cutover window | `[OPEN]` | Not yet actioned | A3, owner Applications Lead |
| Replication grants (`REPLICATION CLIENT`, `REPLICATION SLAVE`, `SELECT`) | `[OPEN]` | Not checked | `implementation-guide-dms.md` `## Source page 3` |

**Consequence if D1 stays open through Module 5:** ADR-1's disqualifier is binlog access/ROW/retention proof failing. This lab's source is the simulation stack, not Acme's real database, so this lab cannot itself close D1 — closing it is Mobilize work the Applications Lead owns before any real cutover.
