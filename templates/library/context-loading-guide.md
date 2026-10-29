# Loading SSBs into an AI-assisted workflow

This guide is tool-agnostic. It applies whether you use Kiro, Claude Code, or another agentic IDE — the questions below are the same regardless of which tool loads your SSB into context. It is written for the moment after preparation: you have a controlled, hashed, page-addressable derivative of a source set (see `MANIFEST.template.md` and `evidence-index.template.md` for that preparation pattern), and now have to decide how an agent actually sees it during an engagement.

## The transferable preparation sequence

Use the same sequence with your practice's standards and runbooks, regardless of tool:

1. authorize and acquire the bounded source set;
2. preserve originals, source identifiers, and hashes;
3. extract deterministically by source page;
4. inspect page counts, anchors, and failures;
5. compare a material derivative passage with the original page;
6. make the prepared reference materials available through the right context-loading mechanism.

Steps 1–5 are governance, not tooling — they are what let you later say *which* edition and page informed an engagement, and they hold regardless of what loads the result into an agent's context. Step 6 is what the rest of this guide is about, because it is the one most often skipped or decided by default rather than by reasoning.

## Which source set governs this engagement

Everything below assumes you already know which source set applies. That decision comes first, and it is worth making deliberately rather than by default — this guide's worked example is a workshop with exactly one SSB, chosen for the participant before the session starts, so the workshop itself never has to answer this question. Your practice will.

Start from the customer's stated technology and pattern, not from the source set you reach for most often, and match it against each candidate's own scope statement — an SSB's 1-Pager or equivalent applicability document exists to answer exactly this. A source set that talks about the right service but the wrong direction of travel, or the right pattern for a different source cloud, is not a match; it is a candidate for adaptation, and adaptation is a decision to make explicitly in the engagement, not something to back into by picking whichever set is closest to hand.

Treat a scenario that does not cleanly match any source set you carry as a real, nameable outcome — not a failure to search harder. Say so to the customer rather than forcing the nearest set to fit; the router pattern later in this guide applies the same rule to individual questions once a source set is already loaded (`ssb-router.skill.template.md`'s routing rule 4), but the choice of source set itself needs the identical honesty, made once, up front, rather than discovered claim by claim once you are already committed.

**Know what you are staging.** Some source sets need no rights check at all — AWS SSB PDFs, for example, are publicly distributed and intended for partners to consume and build on. Others do: customer architecture documents, third-party material, and anything covered by an NDA. Confirm confidentiality, storage, and redistribution terms for *this* source set before placing its text in an agent-accessible workspace, and record which revision you worked from either way, since a published document can be revised without notice and a hash is the only durable way to say which edition informed an engagement.

## Four ways to make prepared guidance available

| Mechanism | Choose when |
|---|---|
| Skill | You carry several source sets and want one summoned by topic |
| Conditional steering (or your tool's equivalent persistent context file) | Guidance should follow specific artifact types |
| Agent resource (full preload) | One engagement has one always-relevant source set, and it is small |
| Knowledge base / semantic search | The source set is too large to stage and freshness is managed elsewhere |

None of these is a default-correct answer. Each trades against the same four variables below, and the right choice depends on your practice's actual shape — not on which mechanism sounds most sophisticated.

**Check the mechanism exists before you design around it.** Mechanism names travel between tools; implementations do not. In Kiro specifically, knowledge base resources are CLI-only and experimental at the time of writing — an agent config in the IDE accepts a `knowledgeBase` entry without a validation error, but no IDE runtime tool serves it, so retrieval silently never happens and the agent answers from its own prior knowledge instead. Confirm your tool actually implements a mechanism before building a practice on it, and prefer one whose retrieval you can watch happening in the transcript.

### Real text versus generated summary

The dividing line that matters is not how precisely a mechanism can address a passage. It is whether what reaches the model — and what you can then put in front of a customer — is the source's own words or something generated from them.

A direct read returns the actual sentence, and anyone can open the same file and see the same words. A retrieval mechanism may do that too, or it may hand the model a summary of the passage before the model ever sees it. If it does, every downstream claim is a paraphrase of a paraphrase and there is nothing concrete left to check. Which of the two a given tool does is worth establishing by testing it, not by assuming, because it is rarely documented either way.

Page and heading precision sits on top of that as a convenience, not as the thing that makes a claim defensible. A page number helps you find a passage quickly; it tells you nothing about whether the words being quoted are real. Keep addresses in your index because they make navigation fast, and treat a verbatim sentence the reader can independently open as the bar a claim has to clear.

If you do route citation-bearing content through a retrieval mechanism, keep enough metadata on each indexed chunk to get back to the source file, and require the mechanism to surface the retrieved text rather than only its own answer.

### Context budget versus retrieval latency

Loading a full source document into an agent's context is not free, and the cost scales with document size, not with how often the document is actually needed. As a point of reference: a typical multi-page architecture document can run to tens of thousands of tokens — large enough that keeping it resident for an entire session, when only a few steps actually cite it, spends real budget on stretches where it earns nothing.

A single targeted read of the one page or section you actually need to cite costs an order of magnitude less — typically in the low thousands of tokens — at the price of one extra retrieval step per citation. For a source set with more than one document, that gap compounds: staging every document in a multi-document bundle wholesale can consume a meaningful fraction of a working context window before a single turn of real conversation happens.

The practical rule: keep a small, cheap address map (a page-and-heading index of the source set, per `evidence-index.template.md`) resident, and load the underlying documents on demand, page by page, rather than staging the whole bundle up front. The address map costs a small fraction of any one source document and still tells the agent exactly where to look.

### Freshness versus local control

Every one of the four mechanisms above is staging a point-in-time snapshot of whatever you fed it. None of them make a cached source current. A campaign document reflects the service facts, quotas, and support boundaries known at the time it was authored or last revised.

Where a source is published at a stable public location — as AWS SSB PDFs are — one option sits outside the four above: retrieve it at the point of use instead of staging a copy at all. That is current by construction, and it costs reproducibility, since you can no longer say which revision informed a past engagement unless you record a hash alongside it. Two limits are worth knowing before planning around it. Web fetching in most agentic tools handles text and HTML rather than PDF, so a published PDF still needs converting before an agent can read it, which puts the preparation step back. And a workflow that reaches the network mid-engagement cannot run in an isolated or offline environment.

A fact that changes over time — a service quota, a feature's support boundary, a pricing figure — should route to current documentation or a live source when the engagement permits it, regardless of which mechanism holds the rest of the architecture narrative. Treat the source's own architectural reasoning (why a pattern is shaped the way it is, what its constraints and anti-claims are) as durable enough to cache; treat anything that reads like a service fact with an expiry date as a pointer to verify live, not a value to trust from a snapshot.

### The scale of your own practice

This is the variable that actually decides the mechanism, more than any of the above:

- **One engagement, one relevant source set, short-lived.** An address map plus on-demand reads is enough. An agent resource (full preload) is a reasonable alternative only if the set is genuinely small.
- **A practice carrying a handful of source sets, used by topic.** A skill per source set, so only the relevant one loads when the conversation calls for it, is a better fit than any one mechanism trying to cover all of them at once.
- **A large, multi-source catalog across many engagements, with content that changes.** This is the case a knowledge base is designed for, where your tool implements one — accepting the retrieval trade-off above as a real cost, and mitigating it by keeping source-traceable metadata in the index and requiring retrieved text to be shown, rather than treating retrieval as good enough on its own. Where it is not available, carry the skill-per-source-set pattern further rather than falling back to preload: progressive disclosure is what keeps a large catalog affordable, since preload is the one mechanism whose cost grows with catalog size on every single request.

## Worked example: what one workshop chose, and why that is not the only answer

The "From SSB to Migrated Workload" workshop this kit ships from keeps a small address map resident and has its agent read the underlying documents directly, rather than asking it to search for a passage. With one source set and a known set of questions, that is the cheapest mechanism that clears the bar: the agent reads real text, and the participant watches it happen.

A practice carrying several source sets, or fielding unscripted customer questions, has a different shape and may reasonably choose a skill per set, a single router skill indexing all of them (see `ssb-router.skill.template.md` in this library), or a retrieval mechanism on a tool that implements one. What should not change with scale is the requirement that an attributed claim carries the source's own words and a retrieval you can see. Make that choice explicitly for your own practice, rather than defaulting to whichever mechanism is easiest to wire up first.

## A short checklist before you decide

- [ ] Established whether this source set needs a rights check at all, and cleared confidentiality, storage, and redistribution terms if it does.
- [ ] Named which claims in this engagement are material enough to need a verbatim quote and a visible read, and which are background context.
- [ ] Estimated the token cost of the candidate mechanism against your tool's actual context budget, not a guess.
- [ ] Identified which facts in the source set are architectural (durable, safe to cache) versus service facts (route to a live source instead).
- [ ] Matched the mechanism to how many source sets your practice carries and how often they're reused, not to this one engagement alone.

## The folder you are holding: loading the workshop's SSB into your own IDE

The decision above is yours to make. The mechanics for this particular ZIP are short, and the same in any agentic IDE that can read files in an open folder.

1. **Unzip and open the folder as a workspace** in your tool. Everything the agent needs is inside it; nothing has to be installed.
2. **Find the prepared set.** `ssb/workload-migration/` holds the seven derivatives (`1-pager.md`, `sdd.md`, `implementation-guide-dms.md`, `implementation-guide-mgn.md`, `implementation-guide-datasync.md`, `learning-path.md`, `getting-started.md`), each split by `## Source page N`, next to `originals/` with the seven PDFs. They are plain Markdown; any agent with a file-read tool can open them. If the folder is empty (you took the checkpoint path and it was never prepared), run `python3 ssb/preparation/prepare_ssb.py` from the folder root; it needs only Python 3 and the vendored parser.
3. **Make the address map resident, not the documents.** `ssb/evidence-index.md` is about three pages; the derivatives together are far larger. Put the index, or a pointer to it, in your tool's persistent context (in Kiro, a file under `.kiro/steering/`; in other tools, the project-level instructions file your tool reads on every turn), with one instruction: cite as `<derivative> — ## Source page N — anchor`, and open the page before quoting it. If you carry more than one source set, use `ssb-router.skill.template.md` instead and list this set in its corpus map.
4. **Watch one live read before trusting the setup.** Ask: *"Open `ssb/workload-migration/implementation-guide-dms.md` at `## Source page 2` and quote the sentence about Azure SQL Database."* You should see the file read happen and the source's own words come back with the address. If you see a paraphrase with no read, the mechanism is summarising, and step 3 needs changing before the next engagement.
5. **Record the edition.** `ssb/MANIFEST.md` carries the bundle hash and preparation date. Keep it next to any engagement artifact that cites this set, so you can later say which edition informed it. For a real customer, obtain the current SSB from Partner Ready Campaigns and repeat steps 2–5 on it.

The kit's `agents/migration-consultant.md` is a Kiro agent definition: two phases, a design freeze between them, file-write boundaries, shell asks before every command. In another tool, port the boundaries rather than the file: the list of paths it may write, the rule that it reads `requirements.md` and `design.md` as read-only after the freeze, and the ask-before-shell rule are the parts that matter.
