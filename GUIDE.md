# GUIDE: editing the website

How to change any part of the site by editing text files. No HTML, CSS or programming is needed.

> **Maintained by Claude Code.** This guide must describe the repository exactly as it is. Claude updates it in the same commit as any structural change. If you notice a mismatch, ask Claude to fix the guide.
>
> Last reviewed: *not yet built*. The guide describes the planned default configuration (`structure: one-page`) and will be revised during the build.

**In short:** personal details in `_metadata.yml`, texts in the `.qmd` pages, lists (proposals, tools, CV entries) in `data/`, publications in `publications.bib` and `proceedings.bib`, colours and fonts in `custom.scss`. Never edit `_engine/`.

## Contents

1. [Workflow](#1-workflow)
2. [File map](#2-file-map)
3. [Syntax essentials](#3-syntax-essentials)
4. [Personal details and links](#4-personal-details-and-links)
5. [Photo, CV and other files](#5-photo-cv-and-other-files)
6. [Pages and building blocks](#6-pages-and-building-blocks)
7. [Home page sections](#7-home-page-sections)
8. [Proposals](#8-proposals)
9. [Tools](#9-tools)
10. [Publications and proceedings](#10-publications-and-proceedings)
11. [CV page](#11-cv-page)
12. [Navigation and footer](#12-navigation-and-footer)
13. [Appearance](#13-appearance)
14. [Adding a section or a page](#14-adding-a-section-or-a-page)
15. [Search engines and link previews](#15-search-engines-and-link-previews)
16. [Publishing](#16-publishing)
17. [Placeholders still to write](#17-placeholders-still-to-write)
18. [Troubleshooting](#18-troubleshooting)

---

## 1. Workflow

**Preview locally** (requires [Quarto](https://quarto.org/docs/get-started/)). In a terminal, from the repository root:

```bash
quarto preview
```

The site opens in the browser and reloads when you save a `.qmd` page, `_metadata.yml` or `custom.scss`.

> **Note:** changes to `data/*.yml` or to the `.bib` files are not detected by themselves. After saving one of them, also save the page that displays it (for example `index.qmd`), or restart `quarto preview`.

**Publish.** Commit and push to `main` (`git add -A && git commit -m "Describe the change" && git push`): GitHub Actions rebuilds and deploys the site in about two minutes (see [Publishing](#16-publishing)).

---

## 2. File map

| To change…                                              | Edit                                     |
| ------------------------------------------------------- | ---------------------------------------- |
| Name, role, affiliation, email, address                 | `_metadata.yml` → `person`               |
| LinkedIn, ORCID, GitHub, ADS, Google Scholar links      | `_metadata.yml` → `person`               |
| Navigation entries (and footer page list)               | `_metadata.yml` → `site-menu`            |
| Tagline under the name                                  | `index.qmd`, front matter → `hero.tagline` |
| In a nutshell, Get in touch box, Research, Personal interests | `index.qmd`                        |
| Proposals                                               | `data/proposals.yml`                     |
| Tools                                                   | `data/tools.yml`                         |
| Refereed papers and preprints                           | `publications.bib`                       |
| Proceedings                                             | `proceedings.bib`                        |
| Education, positions, talks, teaching, awards, skills   | `data/education.yml`, `data/positions.yml`, `data/talks.yml`, `data/teaching.yml`, `data/awards.yml`, `data/skills.yml` |
| Photo                                                   | `assets/photo.jpg` (replace the file)     |
| CV PDF and its "Last updated" date                      | `assets/<Surname>_CV.pdf`, `_metadata.yml` → `cv` |
| Colours, page width, header pattern                     | `custom.scss`                            |
| Fonts                                                   | `assets/fonts/` and the `@font-face` blocks in `custom.scss` |
| Browser tab title, search description, preview image    | `_quarto.yml` → `website`                |
| Browser tab icon                                        | `assets/favicon.svg`                     |
| Page shown for missing URLs                             | `404.qmd`                                |

Do not edit `_engine/` (layout code), `_site/` or `.quarto/` (generated).

`setup/` held the inputs for the first build and was removed from the repository after the import: its content now lives in the files above. To import new material in bulk (for example a new CV with many changes), put it in a new `setup/` folder and ask Claude. It imports the material and removes the folder again with dedicated commits.

---

## 3. Syntax essentials

### YAML (`.yml` files and page front matter)

- **Quote text values:** `title: "Ultra-compact binaries in the LISA band"`. Quoting is mandatory when a value starts with `[`, `*` or `{`, or contains `: `. Use single quotes outside if the text contains double quotes.
- **Indent with spaces, never tabs.** Items of the same entry share the same indentation. The safest way to add an entry is to copy an existing one.
- `#` starts a comment. `- ` starts a list item.

```yaml
- date: "2024"
  title: "Talk title"
  details:
    - "First line"
    - "Second line"
```

### Markdown (pages and most YAML values)

| Syntax                         | Result                            |
| ------------------------------ | --------------------------------- |
| `*italic*`, `**bold**`         | *italic*, **bold**                |
| `[text](https://…)`            | link                              |
| `- item`                       | bullet list                       |
| `\` at line end                | line break                        |
| `$M_\odot$`, `$$f_\mathrm{GW} = 2/P$$` | inline and display math (MathJax) |
| `<!-- note -->`                | comment: not shown, and removed from the published page source |

---

## 4. Personal details and links

`_metadata.yml` holds the data used in the header, contact box, footer and CV page. Everything is written once.

```yaml
person:
  name: "Name Surname"
  role: "PhD Candidate in Astrophysics"
  affiliation: "[Department, University](https://…)"
  email: "name.surname@…"
  address:
    - "Department of Physics"
    - "University, City, Country"
  linkedin: "https://www.linkedin.com/in/…"
  orcid: "0000-0000-0000-0000"
  github: "username"
  ads: "https://ui.adsabs.harvard.edu/…"
  scholar: "https://scholar.google.com/…"
```

Remove a line to hide the corresponding icon and button everywhere.

---

## 5. Photo, CV and other files

Everything in `assets/` is published as is.

- **Photo:** replace `assets/photo.jpg`, keeping the name. Square, at least 600 × 600 px, face centred (it is cropped to a circle). It is also the link-preview image.
- **CV:** replace `assets/<Surname>_CV.pdf`, **keeping the exact name**, so existing links keep working. Then update the date in `_metadata.yml`:

  ```yaml
  cv:
    pdf: "assets/<Surname>_CV.pdf"
    updated: "March 2027"
  ```

- **Other files** (slides, posters, figures): put them in `assets/` and link them as `assets/file-name.pdf`.

---

## 6. Pages and building blocks

A page is a `.qmd` file: a front matter between `---` lines, then Markdown. **Each `## Heading` creates a section card**; `###` is a sub-heading inside a card.

```markdown
---
title: "Publications"
subtitle: "Refereed papers, preprints and proceedings"
---

## Refereed papers and preprints

Text…
```

- **Reorder** sections by moving everything from a `##` to the next one.
- **Remove** a section by deleting that block.
- **Link to a section** with `page.qmd#id`, where the id is the heading in lower case with hyphens (`## Personal interests` → `#personal-interests`), or the id set explicitly: `## Research {#research}`.

### Section options

| Heading                                                    | Effect                                   |
| ---------------------------------------------------------- | ---------------------------------------- |
| `## News {.special}`                                       | centred content                          |
| `## In a nutshell {.spotlight image="assets/photo.jpg" alt="Portrait of Name Surname"}` | text beside a round picture |

### Blocks inside a section

```markdown
::: two-columns
### Ultra-compact double white dwarfs
Text of the left column.

### Astrophysical foregrounds
Text of the right column.
:::

::: box
### Key result
Highlighted text.
:::

::: tags
- LISA
- Double white dwarfs
:::
```

### Buttons

```markdown
[Email](mailto:{{< meta person.email >}}){.button .primary} [CV]({{< meta cv.pdf >}}){.button} [LinkedIn]({{< meta person.linkedin >}}){.button}
```

Links on the same line form a row of buttons. `.primary` is the filled button; `.small` is a smaller one. `{{< meta … >}}` inserts a value from `_metadata.yml`, so the email, the CV file and the profile links are never retyped.

### Lists from `data/` and bibliographies

| Line in a page                                   | Shows                                       |
| ------------------------------------------------ | ------------------------------------------- |
| `{{< proposals >}}`                              | `data/proposals.yml`                        |
| `{{< tools >}}`                                  | `data/tools.yml`                            |
| `{{< list talks >}}`                             | `data/talks.yml` (any `data/NAME.yml` with dated entries) |
| `{{< news >}}`                                   | `data/news.yml`, if the site has a News section |
| `{{< bibliography publications.bib >}}`          | all entries, newest first                   |
| `{{< bibliography publications.bib limit=5 >}}`  | the 5 most recent entries                   |

---

## 7. Home page sections

File: `index.qmd`. Default order:

| Section             | Where the content is                                                  |
| ------------------- | --------------------------------------------------------------------- |
| Header              | name, role, buttons, icons from `_metadata.yml`; tagline in the front matter (`hero.tagline`) |
| In a nutshell       | text in `index.qmd`                                                   |
| Get in touch        | contact box: short text and buttons (Email, CV, LinkedIn) in `index.qmd`, section `## Get in touch {.special}` |
| Research            | one sub-section per theme in `index.qmd`                              |
| Proposals           | `{{< proposals >}}` → `data/proposals.yml`                            |
| Tools I work with   | optional intro in `index.qmd`, then `{{< tools >}}` → `data/tools.yml` |
| Publications and proceedings | `{{< bibliography publications.bib limit=5 >}}` and buttons to the full lists on `publications.qmd` |
| Personal interests  | text in `index.qmd`                                                   |

**Adding a research theme:** add a `###` block inside the Research section. With two themes they sit side by side in `::: two-columns`; with three or more, remove the `::: two-columns` wrapper and stack the blocks. Figures go in `assets/figures/` and are included with `![Caption. Credit: …](assets/figures/figure.png){fig-alt="Short description"}`.

---

## 8. Proposals

File: `data/proposals.yml`, most recent first.

```yaml
- facility: "CFHT"
  period: "2026B"
  instrument: "SPIRou"
  title: "Proposal title"
  role: "PI"
  status: "Accepted"
  allocation: "3 nights"
  links:
    - text: "abstract"
      url: "https://…"
```

`instrument`, `status`, `allocation` and `links` are optional; omit a line to hide it.

---

## 9. Tools

File: `data/tools.yml`. Shown as cards in file order.

```yaml
- name: "GBGPU"
  category: "LISA data analysis"
  description: "GPU-accelerated waveforms for Galactic binaries, used to …"
  links:
    - text: "code"
      url: "https://…"
    - text: "paper"
      url: "https://arxiv.org/abs/…"
  icon: "cpu"
```

`category`, `links` and `icon` are optional. Icon names: <https://icons.getbootstrap.com> (omit the `bi-` prefix).

---

## 10. Publications and proceedings

Files: `publications.bib` (refereed papers and preprints) and `proceedings.bib`. Entries are sorted by date automatically.

**Add an entry:**

1. On NASA ADS, open the paper, then *Export → BibTeX* (or select several records and export them together).
2. Paste the entry at the end of the right `.bib` file and save it (then save `index.qmd` or `publications.qmd` if the preview is running).

Journal macros from ADS (`\apj`, `\mnras`, `\aap`…) are expanded to full journal names automatically. Links are generated from the entry:

| Field in the BibTeX                         | Link on the site |
| ------------------------------------------- | ---------------- |
| `eprint` with `archivePrefix = {arXiv}`, or an arxiv.org `url` | arXiv |
| `doi`                                       | DOI              |
| `note = {\href{https://github.com/…}{code}}` | code (any text and URL) |

Titles are shown in title case, and TeX in titles (`$\sim$`, `$M_\odot$`) renders as math. **Remove an entry** by deleting it from the `.bib` file.

---

## 11. CV page

File: `cv.qmd` defines the order of the sections; the content is in `data/`:

| Section       | File                 |
| ------------- | -------------------- |
| Education     | `data/education.yml` |
| Positions     | `data/positions.yml` |
| Talks         | `data/talks.yml`     |
| Teaching      | `data/teaching.yml`  |
| Awards        | `data/awards.yml`    |
| Skills        | `data/skills.yml`    |

All entries share one format; `skills.yml` uses `label` instead of `date`:

```yaml
- date: "2023 – Present"
  title: "PhD in Astrophysics"
  details:
    - "[University](https://…), City, Country"
    - "Advisor: Name Surname"
  links:
    - text: "thesis"
      url: "assets/thesis.pdf"
```

**New CV section** (for example Outreach): create `data/outreach.yml` in the same format, then add to `cv.qmd`:

```markdown
## Outreach

{{< list outreach >}}
```

The download button and "Last updated" come from `_metadata.yml` → `cv`.

---

## 12. Navigation and footer

`_metadata.yml` → `site-menu`. Entries appear left to right; the footer lists the entries that point to pages (without `#`).

```yaml
site-menu:
  - text: "In a nutshell"
    link: "index.qmd#in-a-nutshell"
  - text: "Research"
    link: "index.qmd#research"
  - text: "Proposals"
    link: "index.qmd#proposals"
  - text: "Tools"
    link: "index.qmd#tools-i-work-with"
  - text: "Publications"
    link: "publications.qmd"
  - text: "CV"
    link: "cv.qmd"
    download: true            # attaches the CV PDF icon to this entry
```

The CV PDF is attached to the CV entry (icon in the navigation, "PDF" link in the footer) rather than listed as a separate entry.

The footer's contact block is built from `person`. The HTML5 UP attribution line is required by the design's licence (CC BY 3.0) and is always shown.

---

## 13. Appearance

`custom.scss` contains only settings:

| Variable                                  | Controls                                             |
| ----------------------------------------- | ---------------------------------------------------- |
| `$gradient-start`, `$gradient-end`        | background gradient of header and footer             |
| `$accent`, `$accent-light`                | primary buttons, icons, underline of section titles  |
| `$text`, `$text-strong`, `$text-muted`    | body text, headings, secondary text                  |
| `$line`, `$light-background`              | separators, navigation bar, highlighted boxes        |
| `$font-titles`, `$font-text` + `@import`  | fonts (Google Fonts)                                 |
| `$page-width`                             | maximum content width                                |
| `$hero-pattern-opacity`                   | visibility of the header pattern (0 hides it)        |

- **Colours** are hex codes. Check text contrast (≥ 4.5:1) with <https://webaim.org/resources/contrastchecker/>.
- **Fonts** are self-hosted (no request to Google at run time). To change one: download its woff2 files and licence (from the font's repository, or Google Fonts through a tool such as google-webfonts-helper), put them in `assets/fonts/`, update the corresponding `@font-face` blocks at the top of `custom.scss`, and set `$font-titles` or `$font-text` to the new family name.
- **Header pattern:** replace `assets/hero-pattern.svg`, or set `$hero-pattern-opacity: 0`.

---

## 14. Adding a section or a page

**Section on an existing page:** write a new `## Heading` block where you want it, and add a menu entry with `link: "index.qmd#heading-id"` if it should be reachable from the navigation.

**New page** (for example `outreach.qmd`):

1. Create the file:

   ```markdown
   ---
   title: "Outreach"
   subtitle: "Public talks and articles"
   ---

   ## Public talks

   Text…
   ```

2. Add `- outreach.qmd` to `project → render` in `_quarto.yml`.
3. Add a menu entry in `_metadata.yml` → `site-menu`.

---

## 15. Search engines and link previews

`_quarto.yml` → `website`:

- `title`: name in the browser tab;
- `description`: summary used by search engines and link previews;
- `open-graph → image`: preview image (default: `assets/photo.jpg`).

---

## 16. Publishing

- Every push to `main` triggers `.github/workflows/publish.yml`, which renders the site and deploys it. Progress is in the repository's **Actions** tab; a red run contains the error message.
- One-time setting: *Settings → Pages → Source → GitHub Actions*.
- **Custom domain:** *Settings → Pages → Custom domain*, then add the DNS records GitHub indicates.

---

## 17. Placeholders still to write

Texts not yet written appear as italic *lorem ipsum*, marked by a comment `[[TO WRITE: … — ~N words]]` with the target length. List them all with:

```bash
grep -rn "TO WRITE" --include="*.qmd" --include="*.yml" .
```

Delete the comment once the text is written.

---

## 18. Troubleshooting

| Symptom                                               | Fix                                                    |
| ----------------------------------------------------- | ------------------------------------------------------ |
| Preview shows an error with a file and line           | Usually YAML: add quotes, fix indentation, replace tabs with spaces |
| A change in `data/` or a `.bib` file is not visible   | Save the page that shows it, or restart `quarto preview` |
| Text after a list shows `{.something}`                | Wrap the list in a `::: something` block instead       |
| A `:::` block swallows the rest of the page           | Close the block with a `:::` line                      |
| A page link is broken                                 | Check the file exists and is listed in `_quarto.yml` → `render` |
| A section link does not scroll                        | Check the id: `## Title {#id}` or the automatic lower-case-hyphen form |
| A new top-level key in `_metadata.yml` causes a validation error | Some names are reserved by Quarto (`menu`, `navigation`); choose another name |
| The online site did not update                        | Open the failed run in the **Actions** tab; the error matches the one in `quarto render` |
| Undo a mistaken edit                                  | `git checkout -- path/to/file` restores the last committed version |
