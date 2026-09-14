# PROMPT: build an academic website from scratch

You are Claude Code. Your task is to build, verify and prepare for publication the personal academic website of **the site owner**, a PhD candidate in astrophysics. This document is your brief. It also records what was learned building a prototype of the same site, so that mistakes are not repeated.

The repository root contains three documents:

- `PROMPT.md` (this file): what to build and how.
- `SETUP.md`: the user's instructions for preparing the inputs in `setup/`.
- `GUIDE.md`: the user-facing editing guide. **You own it and must keep it in sync with the repository** (§13).

Reply to the user in the language they write in. The site, the code comments and every generated file are in English (British spelling for documentation, conventional spelling for code identifiers such as `color`).

---

## Standards of work (read first, apply at all times)

This website represents a researcher's professional reputation. Work to the standard of a senior engineer delivering a production site to a demanding client: quality over speed, and one more verification rather than one unverified assumption.

1. **Evidence before claims.** Never state that something works, passes or is done unless you verified it in this session with a command, a render or a browser check, and can show the output. "Should work" is not a result.
2. **No silent failures.** Never suppress, skip or work around an error, a warning or a failing check without reporting it. If a check cannot be run, say so and explain why.
3. **No guessing.** If a fact, a URL, a decision or the user's intent is uncertain, ask. Never fill a gap with plausible content. An unknown or unverifiable link is omitted and reported, never reconstructed.
4. **Read before writing.** Read a file before editing it. Re-read the relevant section of this document before starting each part of the work.
5. **Definition of done.** A phase is done only when every applicable check of §11 passes and the report of §12 is complete. Unfinished work is reported as unfinished, with the list of what remains.
6. **Review every commit.** Before each commit, read the full staged diff (`git diff --staged`). Check for leftovers, stray files, `FILL:` values, secrets, formatting problems, and whether the message is accurate.
7. **Keep a visible task list** for the phase (the plan items plus the checks of §11), and keep it updated.
8. **Scope discipline.** Build what this document and the user ask for. Propose improvements; do not implement features nobody requested.
9. **Safe operations only.** Never run destructive or irreversible operations without explicit approval: `git push` (any), `git push --force`, `git reset --hard`, history rewriting, deleting tracked files outside the plan of §3.4, changing repository or GitHub settings.
10. **Authoritative, not infallible.** If a tool behaves differently from what this document describes (for example after a Quarto update), stop, report the discrepancy with evidence, propose a fix, and continue only after agreement. Never deviate silently. An explicit instruction from the user overrides this document: follow it, and record the override in the report.
11. **Do not edit `PROMPT.md` or `SETUP.md`** unless the user asks. You maintain `GUIDE.md` (§13).
12. **Communicate professionally.** Give short updates at milestones and ask clear questions, each with a recommended option. No filler, and no inflated claims.

---

## 0. Phases

Each time you are asked to "follow PROMPT.md", determine the phase from the state of the repository (`git status`, `git log`, which files exist) and run only that phase. State what you found before starting.

| State of the repository                                                  | Phase |
| ------------------------------------------------------------------------ | ----- |
| No site (`_quarto.yml` absent) and no `setup/`, or an incomplete scaffold (§3.1) | **A. Pre-setup** |
| No site, scaffold present                                                | **B. Validation**, then **C. Build** |
| Site present but the build is incomplete (files of §5 missing, checks of §11 failing, no build report yet) | **C. Build**, resumed from its task list |
| Site present, `setup/` still tracked                                     | **C.4 Retire `setup/`** (after approval) |
| Site present, no `setup/`                                                | **D. Maintenance** |
| Site present, a new untracked `setup/`                                   | **D. Import** |

Any other request after the build (an edit, new content, a fix) is handled under the rules of phase D: the site files are the source of truth, `GUIDE.md` stays in sync, and the checks of §11 apply to what changed.

### A. Pre-setup

The repository contains only the three documents (possibly uncommitted) and, usually, a git remote. The goal is to leave it well-formed and to spare the user from writing the input files from scratch. Nothing is built.

1. **Check git.** Confirm it is a repository; make sure the branch is `main` (`git branch -M main` if it is `master`); read the remote with `git remote get-url origin`. Never push.
2. **Repository baseline**, one commit, `Add repository baseline`:
   - `.gitignore` (§5): it must ignore neither `setup/` nor `*.pdf`, because the scaffold is committed;
   - `.editorconfig` and `.gitattributes` (§5);
   - `README.md`, provisional: the site's purpose in one line, a status line ("in preparation: inputs are being collected in `setup/`, see `SETUP.md`") and the roles of the three documents. It is rewritten at build (§8);
   - `.claude/settings.json` with the repository default of `SETUP.md` (`opus`, `high`), unless it already exists;
   - the three documents, if they are not committed yet.

   Community files (contributing guide, code of conduct, issue templates) are not created: this is a personal site. `LICENSE`, the workflow and `dependabot.yml` are created at build, when the owner's name is known (§5, §10).
3. **Scaffold**, one commit, `Add setup scaffold for the first build`: the complete `setup/` of §3.1, exactly as specified, with its instructions and `FILL:` markers. Pre-fill only what is already known: what the owner stated (section order, research themes, facilities, tool names) and `repository` from the git remote when there is one (say so). Everything else stays `FILL:`. Do not create `cv.pdf` or `photo.jpg`.
4. Run the validation script of §3.3 once, to prove that the scaffold parses and that it reports exactly the expected `FILL:` values.
5. Stop and tell the user, concisely and grouped by effort:
   - the files to add (`cv.pdf`, `photo.jpg`);
   - the exports to do (the two `.bib` files from ADS);
   - the YAML files to fill;
   - the optional texts;
   - a reminder that everything committed to `setup/` stays in the git history, which becomes public with the site (§3.2);
   - the two GitHub settings to check (public repository; *Pages → Source → GitHub Actions*);
   - "then ask me again to follow PROMPT.md".

### B. Validation

1. Run the checks of §3.3 and show the report.
2. **Required input missing, or still containing `FILL:`:** stop, and list exactly what is missing (file, field, line).
3. **Optional input missing:** state what will happen: omitted from the site, or rendered as a `[[TO WRITE]]` placeholder (§2).
4. **CV, `.bib` and YAML disagree** (dates, titles, affiliations, names): ask before using them.
5. **Photo not suitable** for a professional academic site (sunglasses, other people in the frame, low resolution): say so and ask for another one. You may crop and resize, never retouch.
6. **A text file that contains both real text and a `FILL:` line:** ask whether the line was left by mistake; do not guess.

### C. Build

1. Present a plan in at most 10 lines and **wait for approval**.
2. Build following §4–§8, with atomic commits and the preview running.
3. Verify and review (§11).
4. **Retire `setup/`** with the commits of §3.4, once the user approves the built site and **before the first push of the site**.
5. Report (§12).

### D. Maintenance

After the build, the **site files are the only source of truth** (`_metadata.yml`, pages, `data/`, `.bib`, `assets/`), and `setup/` no longer exists. To import new material (for example a new CV), the user puts it in a new `setup/` folder and asks. Apply §3.2, retire the folder again with §3.4, and re-run the leak scan (§11.1).

---

## 1. What the owner asked for

These are the requirements. The final report must trace each of them (§12).

| #  | Requirement |
| -- | ----------- |
| R1 | **Content structure** inspired by <https://laviniapaiella.github.io>: an "In a nutshell" opening, "Tools I work with", and the usual Research, Publications and CV. More sub-sections (e.g. Proposals) may be added later, so adding sections must be trivial. |
| R2 | **Layout** of <https://criswellalexander.github.io>, which is HTML5 UP **Stellar**: a large header on the home page, then the sections one below the other, scrolling. |
| R3 | **Palette** like that site (Stellar's), but **azure**. |
| R4 | **Home page sections, in this order:** (1) In a nutshell; (2) a box with Get in touch, CV and LinkedIn; (3) Research: ultra-compact double white dwarfs, astrophysical foregrounds; (4) Proposals: CFHT, ESO; (5) Tools: COSMIC binary population synthesis, white dwarf evolution and Milky Way models, public electromagnetic catalogues, LISA analysis tools and GBGPU, the iterative procedure to estimate astrophysical foregrounds, "extrapop posynth"; (6) Publications and proceedings; (7) Personal interests. |
| R5 | **Very easy to edit by hand**, with a guide covering every aspect (`GUIDE.md`), kept up to date. |
| R6 | **Academic and professional**, and visually striking. |
| R7 | **Works well on phones.** |

Requirements that come from the prototype's owner and apply here too:

| #   | Requirement |
| --- | ----------- |
| R8  | No invented content: facts only from the inputs; prose as marked placeholders (§2). |
| R9  | The CV PDF has a stable URL and is reachable from the navigation, the home header and the CV page, **without duplicate download entries**: the PDF is attached to the CV entry (§7.4). |
| R10 | Clean, readable, consistently formatted code; atomic commits. |
| R11 | Before declaring the work done, a review pass that polishes button placement, navigation and details (§11.2). |
| R12 | **Nothing that is not meant for the site appears on it**: no setup files, instructions, `FILL:` markers, private notes, non-public entries or unused files, in the published output, in the page source, or in the repository tree once the build is done (§3.2, §3.4). |
| R13 | A **pre-setup** phase generates every input file with useful placeholders, so that the user only fills them in (§0.A, §3.1). |

---

## 2. Non-negotiable rules

1. **Facts come only from `setup/`**: CV, `.bib` files, YAML files, texts. Never write facts from memory and never rephrase titles, author lists, dates or affiliations.
2. **Do not write content prose** (research descriptions, "In a nutshell", tool descriptions, interests, tagline) unless it is provided in `setup/texts/` or in the YAML. Otherwise insert **site placeholders**:
   - in pages: `<!-- [[TO WRITE: what — ~N words]] -->` followed by an italic *lorem ipsum* paragraph of about N words;
   - in site YAML: a `# [[TO WRITE: what — ~N words]]` comment above the entry and an italic *lorem ipsum* value.

   The markers exist only in the source files: HTML comments are stripped from the rendered pages (§6.3). Interface labels (section titles, button labels such as "Get in touch", "Read more", "Download CV") are not content and may be written.
3. **Setup markers are not site placeholders.** A `FILL:` value is *absent* input. It is never copied to the site; it becomes an omission or a `[[TO WRITE]]` placeholder, per §3.2.
4. **Do not reuse wording** from the reference websites: they belong to real people and are references for structure and layout only. Section names the owner chose ("In a nutshell", "Tools I work with", "Proposals", "Publications and proceedings", "Personal interests") are fine.
5. **Keep the HTML5 UP attribution** in the footer (Stellar is released under CC BY 3.0) and ship its `LICENSE.txt` in `assets/stellar/`.
6. **Pages are plain Markdown.** No inline CSS or HTML in `.qmd` files; all layout lives in `_engine/`.
7. **Atomic, frequent commits** with clear messages, especially while iterating on CSS. Do not push, and do not change GitHub settings, without asking.
8. **When a choice has real alternatives, present them** (with a recommendation) instead of deciding silently.
9. **Scroll-triggered animations:** if they do not work cleanly within two iterations, drop them and keep the layout static. Subtle load-time transitions are allowed only under `prefers-reduced-motion: no-preference`.
10. **Keep `GUIDE.md` in sync** with every structural change, in the same commit.

---

## 3. The `setup/` directory

### 3.1 Scaffold created in the pre-setup phase

```
setup/
├── README.md                     short index of the files below and the FILL convention
├── profile.yml                   required
├── site.yml                      required, pre-filled with defaults
├── proposals.yml                 required for the Proposals section
├── tools.yml                     required for the Tools section, pre-filled with names
├── publications.bib              required: ADS export
├── proceedings.bib               required, may stay without entries
├── texts/
│   ├── tagline.md                optional
│   ├── nutshell.md               optional
│   ├── contact.md                optional
│   ├── research-ultra-compact-double-white-dwarfs.md   optional
│   ├── research-astrophysical-foregrounds.md           optional
│   ├── proposals-intro.md        optional
│   ├── tools-intro.md            optional
│   └── interests.md              optional
├── figures/
│   └── credits.yml               optional; the image files go next to it
└── news.yml                      optional
```

`cv.pdf` and `photo.jpg` are added by the user.

Everything in `setup/` is publishable by design: there are no private fields, because every committed version ends up in the (public) git history of the site (§3.2).

**The `FILL:` convention.** Every value the user must provide contains `FILL:` followed by what to write. A value still containing `FILL:` is treated as absent. Instructions are YAML comments (`#`), BibTeX `@comment{…}` blocks, or HTML comments at the top of the text files.

Generate the files with exactly this content.

`setup/README.md`:

```markdown
# setup/

Inputs for the first build of the website. It is committed while you fill it in, never published,
and removed by Claude with dedicated commits once its content has been imported.
Everything committed here stays in the git history, which is public once the site is pushed:
add only material you would publish.

Replace every `FILL:` value. Anything that still contains `FILL:` is treated as missing:
required inputs stop the build; optional ones are left out, or become a marked placeholder
you can write later. See SETUP.md at the repository root for details.

Add here: cv.pdf, photo.jpg. Then ask Claude again to follow PROMPT.md.
```

`setup/profile.yml`:

```yaml
# Identity and contacts. Replace every "FILL:" value.
# Required: name, surname, role, affiliations (at least one name), email, repository.
# Optional lines: delete them, or leave FILL, to keep them off the site.

name: "FILL: full name as it should appear"
surname: "FILL: surname, used for the CV file name (e.g. Surname → Surname_CV.pdf)"
role: "FILL: e.g. PhD Candidate in Astrophysics"
affiliations:
  - name: "FILL: Department, University"
    url: "FILL: https://… (optional)"
email: "FILL: public email address"
address:                              # optional
  - "FILL: first line, e.g. Department of Physics"
  - "FILL: second line, e.g. University, City, Country"
links:                                # optional, each line independently
  linkedin: "FILL: https://www.linkedin.com/in/…"
  orcid: "FILL: 0000-0000-0000-0000 (iD only)"
  github: "FILL: GitHub username (only if you want it shown)"
  ads: "FILL: public ADS library or author query URL"
  scholar: "FILL: Google Scholar profile URL"
repository: "FILL: username.github.io"
custom_domain: ""                     # optional, e.g. "namesurname.com"
```

`setup/site.yml`:

```yaml
# Decisions about the site. The defaults below match what you asked for;
# change a value only if you want something different.

# Home page sections, top to bottom. Allowed names: nutshell, contact, research,
# proposals, tools, publications, interests, news (news only if news.yml is filled).
home_sections:
  - nutshell            # In a nutshell (with your photo)
  - contact             # Get in touch: a box with Email, CV and LinkedIn buttons
  - research
  - proposals
  - tools               # Tools I work with
  - publications        # most recent entries, plus links to the full lists
  - interests           # Personal interests

# Research themes, in this order. Each can have a text in texts/research-<theme>.md.
research_themes:
  - "Ultra-compact double white dwarfs"
  - "Astrophysical foregrounds"

# "one-page": all sections on the home page, plus Publications and CV pages.
# "multi-page": short home page; separate Research, Proposals and Tools pages.
structure: "one-page"

# The CV button opens: "pdf", "page" (HTML CV) or "both".
cv_button: "pdf"

# Recent publications shown on the home page: a whole number, 0 = only the links to the full lists.
home_publications: 5

# Proceedings as a separate list.
separate_proceedings: true

# "light-azure", "deep-azure", or two hex colours for the gradient: ["#3fa7e0", "#2c4f9e"].
palette: "light-azure"

# Faint decorative pattern behind your name, related to your research.
hero_pattern: true

# Licence of the site's code (layout, styles, scripts), written into the LICENSE file
# with your name: "MIT" (default, the usual choice for personal academic sites) or "none"
# (no LICENSE file, all rights reserved). Your texts, figures and CV are your copyright
# in either case and are not covered by it.
code_licence: "MIT"
```

`setup/proposals.yml`:

```yaml
# Observing proposals, most recent first. One block per proposal; copy a block to add one.
# Required per proposal: facility, period, title, role. A block whose required values
# are still FILL is ignored. Optional lines: delete them, or leave FILL, to keep them off the site.
# Add only proposals you may make public: this file ends up in the site's git history.

- facility: "CFHT"
  period: "FILL: semester, e.g. 2026B"
  instrument: "FILL: optional"
  title: "FILL: title as submitted"
  role: "FILL: PI or Co-I"
  status: "FILL: optional, e.g. Accepted"
  allocation: "FILL: optional, e.g. 3 nights"
  links: []

- facility: "ESO"
  period: "FILL: period, e.g. P114"
  instrument: "FILL: optional"
  title: "FILL: title as submitted"
  role: "FILL: PI or Co-I"
  status: "FILL: optional, e.g. Accepted"
  allocation: "FILL: optional, e.g. 12 h"
  links: []
```

`setup/tools.yml`:

```yaml
# Tools I work with, in display order. Copy a block to add one; delete a block to drop a tool.
# name is required (a block whose name is still FILL is ignored). description: 1–2 sentences
# on how you use the tool; leave FILL to get a marked placeholder on the site, to write later.
# links: add as many as useful, e.g. code, documentation, paper. A link whose url
# still contains FILL is omitted.

- name: "COSMIC"
  category: "Binary population synthesis"
  description: "FILL: how you use it"
  links:
    - text: "code"
      url: "FILL: https://…"

- name: "FILL: white dwarf evolution models (name them)"
  category: "White dwarf evolution"
  description: "FILL: how you use them"
  links:
    - text: "reference"
      url: "FILL: https://…"

- name: "FILL: Milky Way models (name them)"
  category: "Galactic modelling"
  description: "FILL: how you use them"
  links:
    - text: "reference"
      url: "FILL: https://…"

- name: "FILL: public electromagnetic catalogues (name them)"
  category: "Electromagnetic catalogues"
  description: "FILL: how you use them"
  links:
    - text: "catalogue"
      url: "FILL: https://…"

- name: "FILL: LISA analysis tools (name them)"
  category: "LISA data analysis"
  description: "FILL: how you use them"
  links:
    - text: "code"
      url: "FILL: https://…"

- name: "GBGPU"
  category: "LISA data analysis"
  description: "FILL: how you use it"
  links:
    - text: "code"
      url: "FILL: https://…"

- name: "FILL: name of the iterative foreground estimation procedure"
  category: "Astrophysical foregrounds"
  description: "FILL: what it does"
  links:
    - text: "paper"
      url: "FILL: https://…"

- name: "FILL: full name of \"extrapop posynth\""
  category: "FILL: category"
  description: "FILL: what it is and how you use it"
  links:
    - text: "code"
      url: "FILL: https://…"
```

`setup/publications.bib`:

```bibtex
@comment{
  Refereed papers and preprints, exported from NASA ADS (https://ui.adsabs.harvard.edu).

  1. Search: author:"Surname, A." (add orcid:0000-0000-0000-0000 to avoid namesakes).
  2. Keep refereed papers (filter "Refereed") and arXiv preprints without a refereed version.
  3. Select all, then Export, then BibTeX, and paste the result below this block.

  Optional, per entry: a link to code or data, e.g.
    note = {\href{https://github.com/...}{code}},

  FILL: paste the export below, then delete this line.
}
```

`setup/proceedings.bib`: the same block, for conference proceedings (ADS filter *Publication type → Proceedings*, or `doctype:inproceedings`), with the line "Leave this file without entries if you have no proceedings."

Each `setup/texts/*.md` has this form, with its own purpose and length:

```markdown
<!--
In a nutshell: ~120–150 words. The opening of the home page, next to your photo.
Markdown and LaTeX math ($M_\odot$) are allowed.
Replace the FILL line with your text, or leave it: the site will show a marked placeholder.
-->

FILL: your text
```

| File | Purpose and length |
| ---- | ------------------ |
| `tagline.md` | One line under your name in the header, ~15 words |
| `nutshell.md` | In a nutshell, ~120–150 words |
| `contact.md` | Text of the Get in touch box, ~30 words |
| `research-ultra-compact-double-white-dwarfs.md` | Research theme, ~150 words |
| `research-astrophysical-foregrounds.md` | Research theme, ~150 words |
| `proposals-intro.md` | Optional introduction to Proposals, ~30 words |
| `tools-intro.md` | Optional introduction to Tools I work with, ~40 words |
| `interests.md` | Personal interests, ~60–100 words, or a Markdown list |

`setup/figures/credits.yml`:

```yaml
# Figures for the site. Put the image files in this folder and describe them here.
# Add only figures you have the right to publish (your own, or with a licence or
# permission that allows it): a figure is published only if it is listed here with
# its credit. Image files in this folder that are not listed are ignored.

- file: "FILL: file name, e.g. dwd-population.png"
  section: "FILL: research-ultra-compact-double-white-dwarfs | research-astrophysical-foregrounds"
  caption: "FILL: caption"
  credit: "FILL: source and licence, e.g. Surname et al. 2025, CC BY 4.0"
  alt: "FILL: short description for screen readers"
```

`setup/news.yml`:

```yaml
# Optional news for the home page, newest first. Leave the FILL entry to have no News section.

- date: "FILL: e.g. June 2026"
  title: "FILL: a few words"
  text: "FILL: one or two sentences"
  link: "FILL: optional URL"
  icon: "megaphone"    # name from https://icons.getbootstrap.com
```

### 3.2 Handling rules: what reaches the site

`setup/` is **input only**. It is committed while the user fills it in; you read it, transform its content into the site files, and then remove it from the repository with dedicated commits (§3.4). Nothing is published from it directly.

1. **Git:** `setup/` is tracked during setup, so the user can commit and sync it. Git keeps every committed version even after the folder is removed, and the whole history becomes public at the first push. This is why `setup/` has no private fields: by design, everything in it is publishable.
   - Remind the user of this in phase A.
   - If the user reports having committed something that must not become public, stop before the first push. Removing it needs a history rewrite (e.g. `git filter-repo --invert-paths --path <file>`): propose it, do it only with explicit approval, and only while nothing has been pushed. Never rewrite history that has been pushed.
2. **No references:** no site file (`_quarto.yml`, pages, `data/`, `.bib`, SCSS, Lua, HTML includes) mentions a path under `setup/`. Files are moved or converted into the site (never symlinked), as described in §3.4.
3. **Explicit rendering:** `project.render` lists only the site pages. Without it, Quarto renders every `.md` and `.qmd`, including `setup/texts/*.md`, `README.md` and the three documents. `resources` lists only the CV and `assets/**`.
4. **`FILL:` values** are absent:
   - a required field stops the build (§0.B);
   - an optional field, link or line is omitted;
   - optional prose becomes a `[[TO WRITE]]` placeholder in the site source;
   - a whole YAML entry whose required fields are still `FILL:` is dropped (a news item, a figure, a proposal or tool left as template);
   - a home section whose list ends up empty (no proposals, no tools, no news) is omitted from the page and from the menu, and reported.
5. **Never copy to the site:**
   - instruction comments, `@comment{…}` blocks and HTML comments from `setup/`;
   - image files in `setup/figures/` that are not listed in `credits.yml` with a credit;
   - configuration-only fields (`surname`, `repository`, `custom_domain`), which go into configuration, not into content;
   - the original, full-resolution photo.
6. **Transform, don't dump.** Site files get their own clean headers (the data schemas of §6.5) and only the fields the site uses. `setup/texts/*.md` content goes into the pages without its instruction comment; a text is "provided" only when, after removing that comment, it contains no `FILL:` line.
7. **Minimal disclosure:** an optional detail appears only when provided (address, allocations, statuses). Do not derive extra personal details from the CV, such as a phone number, date of birth or home address, even if they are in it.
8. **Rendered output keeps no hidden content:** the layout filter strips HTML comments from the pages (§6.3), so `[[TO WRITE]]` markers and author notes exist only in the source.
9. **Leak scan** before every report: §11.1.

### 3.3 Validation checks (phase B)

Write a small script in the scratchpad (not in the repository). It reports:

- presence of `cv.pdf` and `photo.jpg`, with the photo's pixel size;
- every remaining `FILL:` per file and field, marked required or optional; text files that mix real text and a `FILL:` line;
- YAML parse errors, with line numbers;
- `profile.yml` → `repository` against the git remote (`git remote get-url origin`): a mismatch would give the site a wrong `site-url`;
- the number of real BibTeX entries in each `.bib` (excluding `@comment`), with key, year and entry type;
- **publications and proceedings:** entries appearing in both files, and proceedings-like entries (`@inproceedings`, conference abstracts) in `publications.bib`;
- invalid values in `site.yml`: unknown section names in `home_sections`, or values outside the allowed options for `structure`, `cv_button`, `palette`, `home_publications`, `separate_proceedings`, `hero_pattern`, `code_licence`;
- research themes without a text, and texts without a theme. The text file of a theme is `texts/research-<slug>.md`, where the slug is the theme in lower case with hyphens (non-alphanumeric characters removed);
- reachability of every URL provided (a `HEAD` or `GET` request): unreachable links are reported, never replaced;
- `figures/credits.yml` against the folder: listed files that do not exist, files that are not listed (they will not be published), entries without a credit.

### 3.4 Moving and removing the setup files

Setup files leave the repository through commits that keep the history readable. Use `git mv` when a file is used as it is, so its history follows it. Use `git rm` when its content has been transformed into site files. If the user has not committed a file (typically `cv.pdf` or `photo.jpg`), ask whether to commit it first; `git mv` does not work on untracked files.

**At the start of the build**, as the first commits of phase C:

| Commit | Operations |
| ------ | ---------- |
| `Move CV and bibliographies from setup` | `git mv setup/cv.pdf assets/<Surname>_CV.pdf`; `git mv setup/publications.bib publications.bib` and the same for `proceedings.bib`. In the `.bib` files, replace the setup instructions with a short `@comment{…}` header (what the file is, and "see GUIDE.md to add an entry"). |
| `Import photo and figures from setup` | Add the cropped, resized `assets/photo.jpg` and `git rm setup/photo.jpg`. Add the optimised figures listed in `credits.yml` to `assets/figures/`, and `git rm` all originals, including unlisted ones. |

The remaining files (`profile.yml`, `site.yml`, `proposals.yml`, `tools.yml`, `texts/`, `figures/credits.yml`, `news.yml`, `README.md`) stay in place during the build, as the reference for the import and for re-validation.

**At the end of the build**, once the user approves the site (phase C.4) and before its first push:

| Commit | Operations |
| ------ | ---------- |
| `Remove setup files after import` | First check that every value the site uses is in `_metadata.yml`, `_quarto.yml`, `data/` or the pages. Then `git rm -r setup/`. |
| `Ignore setup/ for future imports` | Append to `.gitignore`: a comment ("local inputs for future imports; see PROMPT.md §0.D") and `setup/`. |

Then run the repository part of the leak scan (§11.1, item 4). If files remain because the user declined a removal, list them in the report.

---

## 4. Environment

- **Quarto:** check with `quarto --version`. `brew install --cask quarto` needs `sudo`, which is not available from the agent's shell. In that case install the official macOS or Linux tarball from the quarto-cli GitHub releases into `~/.local/quarto`, use `~/.local/quarto/bin/quarto`, and tell the user.
- **Stellar:** download <https://html5up.net/stellar/download> into the scratchpad and unpack it there. Do **not** commit the template. Copy only `assets/css/images/overlay.png` and `LICENSE.txt` into `assets/stellar/`, then port the needed Sass (`libs/_vars.scss`, `base/`, `layout/`, `components/`) into `_engine/stellar.scss`. jQuery, Font Awesome and Stellar's JavaScript are not used.
- **Claude Code settings:** if `.claude/settings.json` exists (model and effort chosen by the user, see `SETUP.md`), do not change it.
- **Preview:** create `.claude/launch.json` (local, ignored by git) with a configuration that runs `quarto preview --port 4321 --no-browser` (absolute path to the Quarto binary), start it in the Browser pane, and tell the user when there is something to look at. If the user stops the preview, do not restart it without a reason.
- **Images:** crop and resize with `sips` (macOS) or Pillow. Keep only the subject.
- **Fonts:** download the woff2 files of the two families (latin subset) from their official repositories or through Google Fonts' CSS endpoint, together with their licence file (both default families are under the SIL Open Font License), into `assets/fonts/` (§6.6).

---

## 5. Repository layout

```
.
├── PROMPT.md, SETUP.md, GUIDE.md, README.md
├── LICENSE                   code licence (site.yml → code_licence), created at build
├── _quarto.yml               site configuration
├── _metadata.yml             personal details, CV file, navigation menu
├── index.qmd                 home page
├── publications.qmd
├── cv.qmd
├── 404.qmd                   page for missing URLs
├── custom.scss               style settings only (colours, fonts, sizes)
├── publications.bib          refereed papers and preprints (NASA ADS BibTeX)
├── proceedings.bib           conference proceedings (NASA ADS BibTeX)
├── data/
│   ├── proposals.yml
│   ├── tools.yml
│   ├── education.yml
│   ├── positions.yml
│   ├── talks.yml
│   ├── teaching.yml          only if the CV has teaching
│   ├── awards.yml            only if the CV has awards, grants, fellowships
│   ├── skills.yml
│   └── news.yml              only if news were provided
├── assets/
│   ├── <Surname>_CV.pdf      stable name: its URL must never change
│   ├── photo.jpg             square, ~600 px
│   ├── favicon.svg
│   ├── hero-pattern.svg      optional decorative pattern
│   ├── fonts/                self-hosted woff2 files and their licence
│   ├── figures/              only figures listed with a credit
│   └── stellar/              overlay.png, LICENSE.txt
├── _engine/
│   ├── common.lua            helpers
│   ├── layout.lua            page layout filter
│   ├── shortcodes.lua        lists and bibliographies
│   ├── reverse-chronological.csl
│   ├── stellar.scss          layout rules
│   ├── stellar-nav.html      navigation script
│   └── hero-pattern.py       regenerates assets/hero-pattern.svg (standard library only)
├── .github/workflows/publish.yml
├── .github/dependabot.yml    monthly updates of the workflow's actions
├── .claude/settings.json     Claude Code defaults for the repository (SETUP.md)
├── .editorconfig
├── .gitattributes
├── .gitignore
└── setup/                    inputs, only until the build is approved (§3.4)
```

- Add a data file only when there is content for it. `assets/` contains only files the site uses.
- **Single source of truth:** each fact lives in exactly one site file. For example, talks appear on the CV page and wherever else they are needed from `data/talks.yml` alone; contacts come only from `_metadata.yml`.
- `.gitignore`:

  ```
  # Quarto
  /.quarto/
  /_site/
  **/*.quarto_ipynb

  # Local tooling (project settings in .claude/settings.json stay tracked)
  .claude/*
  !.claude/settings.json
  .DS_Store
  ```

  Make sure no rule excludes `*.pdf`, which happens when a `.gitignore` is inherited from a LaTeX project. `setup/` is added only when the folder is retired (§3.4).
- `.editorconfig`: UTF-8, LF, 2-space indentation, final newline, trailing whitespace trimmed except in `.md` and `.qmd`.
- `.gitattributes`: `* text=auto eol=lf`, and `binary` for `*.pdf`, `*.jpg`, `*.png`, `*.woff2`.
- `LICENSE` (build): the MIT text with the owner's name and the current year when `code_licence` is `MIT`; no file when `none`. `README.md` states the scope in either case: the code is under that licence, the content (texts, figures, CV, photo) is the owner's copyright, and the design is adapted from Stellar (CC BY 3.0).

---

## 6. Architecture

Everyday edits never touch layout code: personal details in `_metadata.yml`, prose in the pages, lists in `data/`, bibliographies in `.bib`, styles in `custom.scss`.

### 6.1 `_quarto.yml`

```yaml
project:
  type: website
  render:                      # explicit: nothing else is rendered (setup/, README, documents)
    - index.qmd
    - publications.qmd
    - cv.qmd
    - 404.qmd
  resources:
    - assets/<Surname>_CV.pdf  # declared explicitly
    - assets/**

website:
  title: "<Name Surname>"
  description: "<one factual sentence from profile.yml>"
  site-url: "https://<username>.github.io"   # https://<custom_domain> when profile.yml sets one
  favicon: assets/favicon.svg
  search: false
  open-graph:
    image: assets/photo.jpg
    description: "<same sentence>"   # website.description alone does not produce og:description
  twitter-card:
    card-style: summary

format:
  html:
    theme: [default, _engine/stellar.scss, custom.scss]   # this order (see pitfalls)
    page-layout: custom
    section-divs: false
    toc: false
    anchor-sections: false
    smooth-scroll: true
    include-after-body: _engine/stellar-nav.html

shortcodes:
  - _engine/shortcodes.lua

filters:
  - quarto
  - _engine/layout.lua
```

Do not use Quarto's `navbar` or `page-footer`: navigation and footer are generated by the layout filter.

### 6.2 `_metadata.yml`

Directory-level metadata, merged into every page:

- `person`: `name`, `role`, `affiliation` (a Markdown string built from `profile.yml` → `affiliations`, e.g. `"[Dept, University](https://…)"`; several affiliations are joined with " · "), `email`, `address` (list of lines), `linkedin` (full URL), `orcid` (iD only), `github` (username), `ads` (URL), `scholar` (URL). Include only provided values. An absent key hides its icon and button everywhere.
- `cv`: `pdf` (path) and `updated` ("Month Year": the date printed on the CV; if the CV has none, ask).
- `site-menu`: a list of `{text, link}`, with an optional `download: true` that attaches the CV PDF icon to that entry.

`menu` and `navigation` are **reserved** by Quarto's schema (Reveal.js). Test any new top-level key with a render.

The menu has one entry per home section except the contact box (reached from the header button) and Personal interests (a seventh entry would crowd the bar), in the order of `home_sections`, followed by the separate pages. Default menu for `structure: one-page`, written in block style in the file:

| text          | link                        |
| ------------- | --------------------------- |
| In a nutshell | `index.qmd#in-a-nutshell`   |
| Research      | `index.qmd#research`        |
| Proposals     | `index.qmd#proposals`       |
| Tools         | `index.qmd#tools-i-work-with` |
| Publications  | `publications.qmd`          |
| CV            | `cv.qmd`, with `download: true` |

### 6.3 Layout filter (`_engine/layout.lua`)

Load the helpers with `dofile(quarto.utils.resolve_path("common.lua"))`. The filter builds the page around plain Markdown:

- **Home header**, when the front matter has `hero:`: name (the only `h1`), role and affiliation, `hero.tagline`, a row of two buttons (Download CV as primary; Get in touch linking to the contact box, `#get-in-touch`), round icon links (email, LinkedIn, ORCID as an "iD" label, GitHub, ADS), and a scroll cue to `#main`.
- **Other pages** use Quarto's title block (`title`, `subtitle`), styled like the Stellar header. Do not print the title again.
- **Navigation** from `site-menu`. **Footer** (id `contact`) from `person`: a Contact column (email, address, icons), a Pages column (menu entries without `#`, with the PDF link attached to the CV entry), and the attribution line with the current year.
- **Cards:** every `## Heading` starts a `.main` card that takes the heading's id (removed from the heading). Text before the first `##` becomes an `.intro` card. Heading classes move to the card: `{.special}` centres the content; `{.spotlight image="…" alt="…"}` puts the text beside a round picture. Front matter `compact-sections: true` reduces card padding. Leading comments do not create an empty card.
- **Blocks:** `::: two-columns` is split into columns at each `###`; `::: box` is a highlighted box; `::: tags` shows a list as tags. A paragraph of `[text](link){.button}` links is a button row (CSS `p:has(> .button)`).
- **Comments removed:** delete `RawBlock` and `RawInline` elements in HTML format that are comments (`<!-- … -->`), so placeholder markers and notes never reach the published HTML.
- Links to `.qmd` files generated in Lua are resolved by Quarto like the ones written in Markdown.

### 6.4 Shortcodes (`_engine/shortcodes.lua`)

| Shortcode                                   | Output |
| ------------------------------------------- | ------ |
| `{{< list NAME >}}`                         | `data/NAME.yml` as dated entries: label on the left, bold title, detail lines, links |
| `{{< proposals >}}`                         | `data/proposals.yml` as dated entries: facility and period on the left; title; role · instrument · allocation · status; links |
| `{{< tools >}}`                             | `data/tools.yml` as a grid of cards: optional icon, name, category, description, links |
| `{{< news >}}`                              | `data/news.yml` as cards (only if news exist) |
| `{{< bibliography FILE >}}`                 | every entry of a `.bib` file, newest first |
| `{{< bibliography FILE limit=N >}}`         | the N most recent entries |
| `{{< meta person.email >}}` (Quarto built-in) | a value from `_metadata.yml`; also works inside link targets |

Implementation notes:

- **Reading YAML lists in Lua:** indent the file by two spaces, prepend `---\nitems:\n`, append `\n---\n`, then parse with `pandoc.read(…, "markdown")`. Values come back as Markdown-parsed Inlines or Blocks. Resolve paths against `quarto.project.directory`.
- **Bibliographies** (this pipeline was tested with pandoc's Lua interpreter and ADS-style entries):
  1. Read the `.bib` text and **expand the AAS journal macros** used by ADS exports (`\apj`, `\apjl`, `\apjs`, `\aj`, `\mnras`, `\aap`, `\aaps`, `\pasp`, `\prd`, `\prl`, `\physrep`, `\araa`, `\nat`, `\jcap`, `\na`, `\procspie`, `\apss`, `\pasa`, `\ssr`, …) into full journal names, with a table taken from the AASTeX macro list. Pandoc silently drops unknown macros, so the journal disappears. Verify the table against the actual files: every `\name` appearing in a `journal` field of the two `.bib` files must be in it, and the check must be part of the leak scan so that a new export cannot lose its journal silently.
  2. Parse the expanded text with `pandoc.read(text, "bibtex")`; its `meta.references` holds the entries.
  3. Read a small Markdown document with `csl` (absolute path), `nocite: "@*"` and an empty `::: {#refs}` div, set its `meta.references` to those entries, and run `pandoc.utils.citeproc` on it.
  4. Take the `#refs` div and drop its id, since several lists can share a page. Replace bare URLs with the labels `arXiv`, `DOI` or `link`.
  5. With `limit`, keep the first N `csl-entry` divs. Return nothing for a file with no entries.
- **Never set `bibliography` in a page's front matter.** `@comment{…}` blocks, including ones with nested braces, are ignored by pandoc.
- **CSL** (`_engine/reverse-chronological.csl`):
  - sort by `issued` descending, then `citation-number`, so entries with equal dates keep file order;
  - bold title with `text-case="title"`, then authors, then genre, event, container title (italic), publisher, place and year;
  - links in the order URL (arXiv), DOI, `note` (e.g. `\href` code links).
- Every site data file starts with a comment header that documents its fields with an example and says: *"After saving this file, also save the page that shows it, so the preview updates."*

### 6.5 Site data schemas

Use exactly these field names, and document them in each file header and in `GUIDE.md`. They are the setup schemas without `public`, `notes` and `FILL:` values.

```yaml
# Dated entries: education, positions, talks, teaching, awards
- date: "2023 – Present"        # skills use label: "Programming" instead
  title: "PhD in Astrophysics"
  details:                      # one string or a list of lines; Markdown allowed
    - "[University](https://…), City, Country, advisor Name Surname"
  links:                        # optional
    - text: "slides"
      url: "assets/…pdf"

# data/proposals.yml
- facility: "ESO"
  period: "P114"
  instrument: "X-shooter"       # optional
  title: "…"
  role: "PI"                    # PI | Co-I
  status: "Accepted"            # optional
  allocation: "12 h"            # optional
  links: []                     # optional

# data/tools.yml
- name: "COSMIC"
  category: "Binary population synthesis"   # optional
  description: "…"                          # placeholder unless provided
  links:                                    # optional
    - text: "code"
      url: "https://…"
  icon: "cpu"                               # Bootstrap Icons name; the import assigns one per category

# data/news.yml (only when news were provided)
- date: "June 2026"
  title: "…"
  text: "…"
  link: "https://…"             # optional
  icon: "megaphone"             # optional
```

Tool icons are design, not content: assign one per category (for example `cpu` for codes, `database` for catalogues, `journal-text` for procedures and papers, `globe` for Galactic models), list the choices in the plan, and let the user change them in `data/tools.yml`.

YAML values that start with `[`, `*` or `{`, or that contain `: `, must be quoted. Quote every string in the generated files, so the user copies a safe pattern.

### 6.6 Styles

- **Fonts are self-hosted**: the woff2 files live in `assets/fonts/` with their licence, and `custom.scss` declares them with `@font-face` (`font-display: swap`). No request goes to Google's servers: the site then has no third-party dependency at run time, loads faster, and avoids the privacy problem that loading Google Fonts raises in the EU.
- `custom.scss` contains **only** commented settings:
  - the `@font-face` declarations, one block per file;
  - `$font-titles`, `$font-text`;
  - `$gradient-start`, `$gradient-end`;
  - `$accent`, `$accent-light`;
  - `$text`, `$text-strong`, `$text-muted`;
  - `$line`, `$light-background`;
  - `$page-width`;
  - `$hero-pattern-opacity`.

  Each group has a one-line explanation, written for a non-developer.
- `_engine/stellar.scss` has the Bootstrap mapping (`$body-bg`, `$body-color`, `$link-color`, headings, font families and weights) in `scss:defaults`, and every rule in `scss:rules`, organised by section (Page, Buttons, Header, Navigation, Cards, Card content, Lists, Footer, Motion, Touch).
- Icons come from Bootstrap Icons, bundled with Quarto (`bi bi-…`). ORCID has no glyph: use a small "iD" label. LinkedIn is `bi-linkedin`.

### 6.7 Navigation script (`_engine/stellar-nav.html`)

Vanilla JavaScript, included with `include-after-body`. It:

- marks the current page as active (`aria-current="page"`);
- on the home page, rewrites `index.html#id` links to `#id` (so they don't reload) and highlights the section in view, using an IntersectionObserver on `#main > .main` with a root margin around the middle of the viewport;
- toggles `.alt` (compact style) while the nav is stuck, via a 1px sentinel element inserted before it;
- on narrow screens, scrolls the horizontal nav so the active entry is visible.

### 6.8 Pages

- **`index.qmd`**: `hero:` in the front matter (tagline from `texts/tagline.md`, or a placeholder); sections in the order of `site.yml` → `home_sections`:
  - `## In a nutshell {.spotlight image="assets/photo.jpg" alt="Portrait of <Name>"}`: text from `nutshell.md`, or a placeholder, followed by a short list of key facts stated in the CV (position, group or department, advisor).
  - `## Get in touch {.special}` (the contact box, id `get-in-touch`): text from `contact.md`, or a placeholder; buttons **Email** (primary, `mailto:` from `person.email`), **CV** (per `cv_button`: the PDF, `cv.qmd`, or both) and **LinkedIn** (when provided). In the plan, offer the alternative of a compact `::: box` at the end of In a nutshell instead of a separate card, with a recommendation.
  - `## Research`: one block per theme in `research_themes`, each with its text or a placeholder and its figures when provided. Two themes go in `::: two-columns`; three or more are stacked `###` blocks.
  - `## Proposals`: the intro when provided, then `{{< proposals >}}`.
  - `## Tools I work with`: the intro when provided, then `{{< tools >}}`.
  - `## Publications and proceedings`: `{{< bibliography publications.bib limit=N >}}` with N = `home_publications` (with 0, show only the buttons), then buttons All publications and Proceedings, pointing to `publications.qmd` and its anchors. With no proceedings, the section is titled `## Publications` and has one button.
  - `## Personal interests`: text from `interests.md`, `::: tags` if it is a list, or a placeholder.
  - `## News {.special}` with `{{< news >}}`, only if news were provided: where `home_sections` lists `news`, otherwise after the contact box (say so in the plan).
- **`publications.qmd`**: `## Refereed publications and preprints` with `{{< bibliography publications.bib >}}`; `## Proceedings` with `{{< bibliography proceedings.bib >}}` (merge the two if `separate_proceedings: false`; omit the section if there are no proceedings); `## Profiles {.special}` with ADS, ORCID and Scholar buttons when those links are present.
- **`cv.qmd`**: `compact-sections: true`; an intro card with the Download CV (PDF) button and "Last updated: {{< meta cv.updated >}}"; then Education, Positions, Talks, Teaching, Awards, Skills via `{{< list … >}}`, in the order of the PDF CV.
- **`404.qmd`**: `title: "Page not found"`; one intro card with a single sentence and a button back to the home page. GitHub Pages serves it for missing URLs. Check that its links and assets use absolute paths (Quarto does this for `404.qmd` when `site-url` is set) by opening a non-existent nested URL in the preview.
- **`structure: multi-page`**: the home page keeps In a nutshell, the contact box and short teasers (a placeholder sentence plus a button) for Research, Proposals and Tools, which move to `research.qmd`, `proposals.qmd` and `tools.qmd` with the same content blocks. Add them to `render` and to `site-menu`.

---

## 7. Design

### 7.1 Principles

These are the evaluation criteria used to judge the prototype's design, and they apply here too:

- **Awwwards scoring weights:** design 40%, usability 30%, creativity 20%, content 10%. A strong first impression, obvious navigation, one distinctive element.
- **Best Personal Academic Websites contest (The Academic Designer, 2025 winners):** a clear statement of *what* and *why* in the first screen; a navigation bar that stays legible while scrolling; one coordinated palette; research presented with context, not only citations; consistent behaviour on desktop, tablet and phone.
- **Portfolio typography guidance:** at most two type families, generous whitespace, a grid-based layout, visible keyboard focus, reduced-motion support.
- **NN/g touch targets:** at least 1 cm × 1 cm, about 44 × 44 CSS px; do not hide the navigation behind a hamburger menu.

The tone is academic and professional. Stellar's playful pastel palette must be toned down: text with good contrast, a single accent colour for icons, **no multicoloured icons**.

### 7.2 Stellar, faithfully

- The body has a diagonal gradient with `overlay.png` on top. Stellar uses `background-attachment: fixed`, which iOS ignores (the background scrolls with the page): the design must look right either way, so check the phone view with the gradient spanning the whole document. Content is centred at `$page-width` (64em).
- **Home header:** near full screen (`min-height: 92vh` and `92svh`, 88 on phones), centred. Large serif name, role, tagline, button row, icons, and a scroll cue with a gentle bounce.
- **Navigation:** a pill-shaped bar with a light background and rounded top corners, sticky, with the active entry on white. It becomes compact, with a subtle shadow, while stuck.
- **Cards:** white, separated by a 1px line, `h2` with a short gradient underline. Override Quarto's default `h2` bottom border and padding.
- **Spotlight:** a round picture with a 1px ring. The facts list next to it uses thin separators (Stellar's `ul.alt`).
- **Feature and tool cards:** large round outlined icons in the accent colour, and **buttons aligned on the same baseline** (`> p:last-child { margin-top: auto }` in a flex column).
- **Footer:** two columns on the gradient (Contact; Pages), with the copyright and attribution below.

### 7.3 Palette and typography

Starting values, chosen so that white text passes WCAG AA (4.5:1) even on the lighter end of the gradient. Show them to the user as screenshots, together with one variant, and confirm before moving on.

| `palette`      | `$gradient-start` | `$gradient-end` | `$accent` | `$accent-light` | White text on the lighter stop |
| -------------- | ----------------- | --------------- | --------- | --------------- | ------------------------------ |
| `light-azure`  | `#2777bb`         | `#1f3f7f`       | `#1f6fb2` | `#8cc9f0`       | 4.7:1                          |
| `deep-azure`   | `#1c6fb0`         | `#132b57`       | `#1a64a3` | `#7fbfe8`       | 5.3:1                          |

- A paler azure such as `#3fa7e0` gives 2.7:1 with white text: it fails even for large text. If the user wants it, say so, and either darken the area behind the header text (a translucent band) or record the accepted deviation in the report.
- Header text: the name in white; role, affiliation and tagline in white at opacity ≥ 0.9 (Stellar's 0.65–0.78 fails on the lighter half of the gradient). Verify with a script that interpolates the gradient stops at the position of each text block: ≥ 4.5:1 for role, affiliation and tagline, ≥ 3:1 for the name. Report the numbers.
- Text on the cards: `$text: #4b5563` (7.6:1 on white), `$text-strong: #1f2937`, `$text-muted: #6b7280` (4.8:1), `$line: #e2e6eb`, `$light-background: #f5f7fa`.
- Primary buttons: white on `$accent` (5.3:1 and 6.2:1 for the two palettes). Stellar's original body text (#a2a2a2 on white) and pastel accents do not pass: do not reuse them.
- Titles in a serif (default Source Serif 4), text in a sans serif (default Source Sans 3), body weight 400. Stellar's weight 300 is too light.

### 7.4 CV download (R9)

- The CV PDF appears **once per context**:
  - in the home header, as the primary button;
  - in the navigation, as a PDF icon attached to the CV entry (one outlined pill split by a thin line, with `aria-label` "Download CV (PDF)");
  - in the footer Pages list, as a small "PDF" link on the same line as the CV entry;
  - on the CV page, as the intro button.
- **No separate "Download CV" entries** in the navigation or in the footer list.

### 7.5 Header pattern (`hero_pattern`; confirm the design with the user)

A faint decorative SVG tied to the research, generated by `_engine/hero-pattern.py` (Python standard library only, fixed seed, documented at the top, run as `python3 _engine/hero-pattern.py > assets/hero-pattern.svg`), so that it can be regenerated. For example: a scatter evoking the Galactic double white dwarf confusion foreground in the LISA band.

- Draw it with no frame.
- Fade it with `mask-image: radial-gradient(closest-side, #000 55%, transparent)`.
- Default opacity `$hero-pattern-opacity: 0.12`, placed behind the header content.
- It is decoration: no axes, no caption, never presented as data.

### 7.6 Phones (R7)

- The navigation stays visible and scrolls horizontally, with a fade mask at the edges. No hamburger menu.
- Tap targets are at least 44px: nav links, icon links, small buttons (full size on phones), footer links.
- Nothing overflows horizontally at 360px.
- Button rows stack as full-width buttons below 480px.
- The spotlight stacks with the picture on top. **Long paragraphs are left-aligned**, never centred.
- Grids go from 3 to 2 to 1 columns; the entry grid (label | body) collapses to one column below about 576px.

### 7.7 Accessibility

- One `h1` per page; alt text on images; visually hidden labels on icon-only links.
- `:focus-visible` outline in the accent colour.
- `html { scroll-padding-top: 4.5em }`, so anchors are not hidden under the sticky navigation.
- Load-time header transitions and the scroll-cue bounce only under `prefers-reduced-motion: no-preference`.

---

## 8. Code quality (R10)

- Code comments are short, in English, and explain intent. Comment density is consistent across files.
- Lua: small local functions, no globals except the filter entry points (`Div`, `Pandoc`, `RawBlock`, `RawInline`), no dead code.
- SCSS: properties in alphabetical order within a rule, nesting at most three levels, no `!important` except to beat Bootstrap on `.button` colours and borders.
- Every file ends with a newline, with no trailing whitespace and no tabs. Check with a script before the final commit (third-party licence text excepted).
- `README.md` (English, rewritten at build): what the site is, a structure table, local preview, a "Licence" section (scope as in §5), credits (Stellar, Bootstrap Icons, the fonts), and a link to `GUIDE.md`. No personal details beyond name and the public site address.

---

## 9. Known pitfalls (found while building the prototype)

| Symptom | Cause and fix |
| ------- | ------------- |
| `Directory metadata validation failed … menu` / `navigation` | Reserved Quarto keys. Use `site-menu`. |
| `Undefined variable` when the theme compiles | Quarto places the defaults of later theme files first. List `_engine/stellar.scss` **before** `custom.scss`. |
| `NotFound … lstat` for an SCSS `url()` | SCSS URLs resolve against the project root, not the SCSS file. Write `url("assets/…")`. |
| Markdown files (documents, `setup/texts/*.md`) rendered as pages | Without `project.render`, every `.md` is rendered. Keep the explicit list. |
| Journal missing from ADS citations | ADS uses AAS macros (`\apj`, `\mnras`, `\aap`…), which pandoc drops. Expand them before parsing (§6.4). |
| Duplicate ids (e.g. two `contact`) | Quarto turns a div whose first child is a heading into a `<section>` with the heading's id. Give generated headings explicit ids (`contact-title`), and move card ids from the heading to the card. |
| Page title shown twice | `title-block-style: none` is ignored here. Style `#title-block-header` (`h1.title`, `p.subtitle`) as the header instead of printing a title. |
| Header buttons enlarged by the subtitle rule | Target the role line with `#header > h1 + p`, not `#header p`. |
| `{.class}` printed as text after a list | Pandoc has no attributes on lists. Wrap the list in `::: class`. |
| Pasted BibTeX titles in sentence case | Pandoc lowercases English titles. Use `text-case="title"` on the title in the CSL. |
| Lists overwritten or duplicated by citeproc | Do not set `bibliography` in page front matter; run citeproc inside the shortcode. |
| Edits to `data/*.yml` or `.bib` not shown in the preview | These files are not tracked dependencies. Saving the page that uses them triggers a re-render. Document this in `GUIDE.md` and in every data file header. |
| `[[TO WRITE]]` markers visible in the page source | HTML comments pass through pandoc. Strip them in the layout filter (§6.3). |
| An existing `_site/` appears inside a verification build | Rendering with `--output-dir <scratch>` copies the project's `_site/`. Ignore it, or delete it from the scratch output before the leak scan. |
| No `og:description` | Set `website.open-graph.description` explicitly. |
| `CNAME` copied into `_site` | Quarto copies it. With GitHub Actions deployment it is ignored; configure the domain in *Settings → Pages*. |
| Anchors hidden under the sticky navigation | `html { scroll-padding-top: 4.5em; }`. |
| Blank or failed screenshots in the Browser pane | Capture artefact with `background-attachment: fixed`, or batches of screenshots. Take single screenshots, and verify with DOM checks (computed styles, `elementFromPoint`) or a real scroll before assuming a bug. |
| `brew install --cask quarto` fails | Needs `sudo`. Use the tarball (§4). |
| Header text unreadable on the light end of the gradient | Stellar's pastel palette and 0.65 text opacity fail WCAG. Use the stops of §7.3 and opacity ≥ 0.9; verify by interpolation. |
| Gradient background scrolls on iPhone | iOS ignores `background-attachment: fixed`. Design for both behaviours (§7.2). |
| The first deployment fails with a Pages error | *Settings → Pages → Source* was not set to **GitHub Actions** before the push. Set it, then re-run the workflow from the Actions tab. |
| The preview shows "Quarto Render Error" after many file changes | Stop and restart the preview. Check with a standalone `quarto render --output-dir <scratch>`. |

---

## 10. Deployment

`.github/workflows/publish.yml`, on every push to `main` and on manual dispatch:

```yaml
name: Publish site

on:
  push:
    branches: [main]
  workflow_dispatch:

permissions:
  contents: read
  pages: write
  id-token: write

concurrency:
  group: pages
  cancel-in-progress: false

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: quarto-dev/quarto-actions/setup@v2
        with:
          version: <the local Quarto version>
      - name: Render
        run: quarto render
      - name: Check that the CV PDF is in the build
        run: test -f _site/assets/<Surname>_CV.pdf
      - uses: actions/upload-pages-artifact@v3
        with:
          path: _site

  deploy:
    needs: build
    runs-on: ubuntu-latest
    environment:
      name: github-pages
      url: ${{ steps.deployment.outputs.page_url }}
    steps:
      - id: deployment
        uses: actions/deploy-pages@v4
```

- The action versions above were current when this document was written. Check the actions' release pages for newer major versions and use them. Validate the workflow file before the push (YAML syntax, step names, paths); after the push, follow the run in the Actions tab and fix a failure immediately.
- Add `.github/dependabot.yml` with `package-ecosystem: github-actions`, `directory: /`, `schedule: interval: monthly`, so that the actions receive update pull requests. Tell the user that merging them is the only recurring maintenance.
- `setup/` is retired before the first push of the site, so CI never sees it. The build must therefore not depend on it: a successful CI run proves it.
- *Settings → Pages → Source → GitHub Actions* must be set **before** the first push (`SETUP.md` tells the user; confirm it with them), otherwise the deploy job fails. A custom domain goes in *Settings → Pages → Custom domain*; no `CNAME` file is needed with Actions deployment.
- **Before the first push**, list the remaining `[[TO WRITE]]` placeholders and ask whether the site may go online with them. The push itself is done by the user, or by you once they have agreed.

---

## 11. Verification and review before declaring anything done

### 11.1 Automated checks, including the leak scan

Report the results faithfully; if something fails, say so.

1. `quarto render` completes with no errors or warnings. Also run it with `--output-dir` in the scratchpad, to exclude interference from the preview; delete any copied `_site/` from that output before scanning.
2. `_site/assets/<Surname>_CV.pdf` exists and is byte-identical to `assets/`.
3. A script parses every `_site/*.html` and reports:
   - broken internal links and anchors;
   - duplicate ids;
   - leftovers such as `{.class}`, `?meta` or `{{<`;
   - the number of links to the CV PDF on each page.
4. **Leak scan** (R12), on the output directory:
   - **file inventory:** only the rendered pages, `site_libs/`, the `assets/` files that are actually referenced (plus the licence files in `assets/stellar/` and `assets/fonts/`), `robots.txt` and `sitemap.xml`. No `setup/`, no `.md`, `.bib`, `.yml`, `.lua` or `.py` files, no unreferenced images, no original photo;
   - **no forbidden strings** anywhere in the output: `FILL`, `TO WRITE`, `setup/`, `@comment`; no HTML comment between the start of `#header` (or `#title-block-header`) and the end of the footer (Quarto's own template comments such as `<!-- sidebar -->` sit outside and are acceptable);
   - **no excluded content:** the names of unlisted figure files, and the titles of setup entries that were dropped, are absent;
   - **journals:** every entry of both `.bib` files renders with its journal or venue (no macro left unexpanded, no entry without a container title unless the entry has none);
   - `sitemap.xml` lists the site pages and nothing else;
   - **after retirement:** `git ls-files setup` is empty; `git grep -n "FILL:"` finds nothing outside the three documents; no tracked file mentions `setup/` except `.gitignore` and the three documents;
   - **history:** `git log --stat --all -- setup/` shows only the scaffold, the user's own fillings and the retirement commits; ask the user to confirm that nothing in them must stay private before the first push (§3.2, rule 1).
5. `og:title`, `og:description`, `og:image` and the Twitter card tags are present on the home page; every page has a unique `<title>` and a meta description.
6. **Browser health:** on every page, the console shows no errors and no network request fails (Browser pane console and network tools).
7. **Weight:** images are under ~200 KB each (the photo well below); only the font files actually used are shipped; no unused scripts or stylesheets; the home page transfers under ~1.5 MB in total (preview network log).
8. **External links:** every external URL on the site answers without an error (a `HEAD` or `GET` request); report the ones that fail, with their status.
9. **404 page:** a missing nested URL shows the 404 page with working styles, navigation and links.
10. MathJax is loaded wherever a page or bibliography contains TeX.
11. The site placeholder list is complete: `grep -rn "TO WRITE" --include="*.qmd" --include="*.yml" .`, excluding `setup/`.
12. Every example in `GUIDE.md` works when copied into the repository: test the new ones with a render.

### 11.2 Visual and UX review (R6, R7, R11)

At 1440×900 and 375×812, check with screenshots and DOM queries:

- **Header:** the first screen says who, what and why; buttons are centred and on one row on desktop, stacked on phones.
- **Navigation:** sticky; compact while stuck; the active entry follows the page or section; anchors land below the bar; the CV and PDF pill works; horizontal scroll and fade on phones.
- **Cards:**
  - no double lines under the `h2`;
  - card buttons aligned on one baseline;
  - grids wrap gracefully for the actual number of items (tool cards, news): the last row is centred or the grid uses auto-fit columns, with no single item stranded at the left;
  - long text left-aligned on phones.
- **Lists:** proposals, tools, publications (with the journal name, and the arXiv, DOI and code labels), CV entries.
- **Footer:** columns on desktop, stacked on phones, with the PDF link on the CV line.
- **Overflow:** no horizontal overflow; the smallest tap target is at least 44px; keyboard focus is visible.
- **Consistency:** the palette is coherent, with no stray pastel or multicoloured elements, and contrast passes.

Fix what you find, commit, and re-check.

---

## 12. Final report

End each phase with a report. After the build (phase C) it contains:

1. What was built, and the list of commits.
2. The verification results (§11), including the leak scan.
3. **Requirements traceability:** a table with R1–R13, how each is met, and where in the repository.
4. What was **not** published, and why: `FILL:` values left, dropped template entries, unlisted figures, CV details deliberately left out. Also the `setup/` retirement commits, and the note on what remains in the git history.
5. Actions for the user:
   - GitHub Pages source and custom domain;
   - confirmation of photo, palette and header pattern;
   - the missing information.
6. The complete list of `[[TO WRITE]]` placeholders, grouped by file, with target lengths.

---

## 13. Keeping `GUIDE.md` current

`GUIDE.md` is the user's only reference for editing the site. It must always describe the repository **as it is**.

- Update it **in the same commit** whenever you add, rename or remove any of the following, or change how it works:
  - a page, a section or a menu mechanism;
  - a data file, a field or a shortcode;
  - a block type or a setting in `custom.scss`;
  - how publications, the CV or deployment work.
- Replace the planned-configuration notice at the top with the actual configuration, and set the "Last reviewed" date.
- Keep its tone: concise, direct, professional. The reader is an astrophysicist, not a web developer.
- At the end of each working session, re-read it against the repository and fix any drift.
