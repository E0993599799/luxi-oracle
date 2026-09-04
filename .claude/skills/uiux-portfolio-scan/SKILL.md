---
name: uiux-portfolio-scan
description: Batch UI/UX teardown of every client project shown on an agency's own portfolio/homepage — discovers project names, resolves each to its real live website (agencies rarely link out from case studies, so this must be searched, not guessed blind), fans out via parallel forks running the /uiux-teardown method, and produces one master index report cross-referenced against design-system/MASTER.md.
installer: create-shortcut
created_at: 2026-09-05T04:00:00+07:00
---

# /uiux-portfolio-scan

Given an agency site (e.g. a studio/agency homepage with a client portfolio grid), research the UI/UX of the **actual delivered client websites**, not just the agency's own case-study framing of them. This is the natural follow-up to [[uiux-teardown]] when a single-site teardown surfaces a portfolio of other real products worth studying.

**Trigger phrases**: "research related websites shown on [agency]", "teardown their whole portfolio", "look at the clients they built for", "/uiux-portfolio-scan".

Do not trigger for a single already-known target URL — use `/uiux-teardown` directly for that.

## Step 0: Init

```bash
date "+🕐 %H:%M %Z (%A %d %B %Y)"
```

## Step 1 — Discover the portfolio, bounded to what the user actually pointed at

Scope discipline matters here: an agency's full case-study archive is often 5-10x larger than what's featured on the page the user actually looked at (e.g. a homepage grid of ~14 vs. a full `/work` index of 60+). **Default to the set visible on the page(s) the user named** — don't silently expand to the full archive. If genuinely ambiguous which set is meant, ask rather than pick the larger scope.

To enumerate reliably (client-rendered grids often don't show all items in raw `curl` HTML):
```bash
curl -s -A "Mozilla/5.0 ..." "<portfolio-or-homepage-url>" -o page.html
grep -oiE '<script id="__NEXT_DATA__"[^>]*>.*?</script>' page.html   # if Next.js — parse the embedded JSON for project name/slug fields instead of relying on visible hrefs
```
For non-Next.js sites, fall back to visible `href` links to case-study pages and their linked text as project names.

## Step 2 — Resolve each project to its real live URL (never guess blind)

Check each case-study page first for an outbound "visit site" link or a `url`/`website`/`link`/`domain` field in embedded JSON — agencies sometimes include it, but often **don't** (confidentiality/scope reasons — the deliverable may be one campaign page, not the whole client domain). When absent:

- Use WebSearch for `"<brand>" official website` (add "Thailand" or the relevant market if the brand is multinational and the agency is local — e.g. a Bangkok agency's "Uniqlo" case study means Uniqlo Thailand, not the global site).
- If a brand name is ambiguous or a confident official domain can't be found, **mark it explicitly as unresolved in the report** rather than guessing a plausible-looking domain. A wrong domain silently pollutes the whole teardown with someone else's site.

## Step 3 — Fan out via parallel forks

For anything beyond 2-3 projects, spawn parallel `fork` agents (they inherit this conversation's context, so they already know the `/uiux-teardown` method — no need to re-explain it). Split the resolved project list into balanced batches (3-5 per fork). Each fork's directive:

- For each assigned brand: WebSearch to confirm the domain if not already resolved, then run a **lighter** version of the `/uiux-teardown` extraction — one WebFetch content/IA pass + curl/grep for colors, fonts, type-scale, border-radius, transitions, image formats, and framework/stack signals (skip the service-methodology pass — these are product sites, not agency sales pages).
- Write findings to a shared batch file, e.g. `ψ/writing/site-teardowns/YYYY-MM-DD_<agency-slug>-batch-<letter>.md`, one section per brand (name, resolved URL or "unresolved", key tokens found, one-paragraph IA/positioning read).
- Report back a short summary (which brands done, which unresolved/blocked) — not raw tool output.

Don't peek at fork transcripts while they run; wait for their completion notifications.

## Step 4 — Synthesize the master index

After all forks report back, read each batch file and write one master report: `ψ/writing/YYYY-MM-DD_<agency-slug>-client-portfolio-uiux-research.md` with:
- A table: brand, resolved URL (or "unresolved — flagged"), one-line positioning read, standout visual/technical token.
- A short cross-brand pattern section — what recurs across this portfolio (e.g. shared component patterns, a house style the agency imposes vs. genuine client-brand variation).
- Comparison against `design-system/MASTER.md` where a pattern is directly relevant to Captain Maid 2.0.
- Confidence & limitations: name every unresolved brand and every fetch failure plainly.

## Step 5 — Close out

Report the master file path, how many of the portfolio's projects were successfully resolved vs. unresolved, and the single most useful cross-brand pattern found. Present everything as research input for a human decision (Rule 3 — External Brain, Not Command) — never as already-implemented changes, and never with fabricated URLs, stats, or claims for a project you couldn't actually reach.
