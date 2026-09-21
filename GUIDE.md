# GUIDE: editing the website

How to change any part of the site by editing text files. No HTML, CSS or programming is needed.

> **Maintained by Claude Code.** This guide must describe the repository exactly as it is. Claude updates it in the same commit as any structural change. If you notice a mismatch, ask Claude to fix the guide.
>
> Last reviewed: 22 September 2026 (`structure: one-page`: all sections on the home page, plus the Publications and CV pages).

**In short:** personal details in `_metadata.yml`, texts in the `.qmd` pages, CV entries (and the proposals' facts) in `data/`, publications in `publications.bib` and `proceedings.bib`, colours and fonts in `custom.scss`. Never edit `_engine/`.

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

**Preview locally** (requires [Quarto](https://quarto.org/docs/get-started/), version 1.10 or later). In a terminal, from the repository root:

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
| Proposals: descriptions on the home page                | `index.qmd`                              |
| Proposals: facility, role, status (CV page)             | `data/proposals.yml`                     |
| Tools I work with                                       | `index.qmd`                              |
| Refereed papers and preprints                           | `publications.bib`                       |
| Proceedings                                             | `proceedings.bib`                        |
| Education, conferences, training, skills, languages     | `data/education.yml`, `data/talks.yml`, `data/training.yml`, `data/skills.yml`, `data/languages.yml` |
| Membership list                                         | `cv.qmd`                                 |
| Photo                                                   | `assets/photo.jpg` (replace the file)     |
| CV PDF and its "Last updated" date                      | `assets/Perego_CV.pdf`, `_metadata.yml` → `cv` |
| Colours, page width, home page background picture       | `custom.scss`                            |
| Fonts                                                   | `assets/fonts/` and the `@font-face` blocks in `custom.scss` |
| Browser tab title, search description, preview image    | `_quarto.yml` → `website`                |
| Browser tab icon                                        | `assets/favicon.svg`                     |
| Page shown for missing URLs                             | `404.qmd`                                |

Do not edit `_engine/` (layout code), `_site/` or `.quarto/` (generated).

`setup/` held the inputs for the first build and was removed from the repository after the import: its content lives in the files above. To import new material in bulk (for example a new CV with many changes), put it in a new `setup/` folder and ask Claude. It imports the material and removes the folder again with dedicated commits.

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

`_metadata.yml` holds the data used in the header, footer and CV page. Everything is written once.

```yaml
person:
  name: "Alice Perego"
  role: "PhD student in Astrophysics"
  affiliation: "[Artemis - Observatoire de la Côte d'Azur](https://www.oca.eu/fr/)"
  email: "alice.perego@oca.eu"
  address:
    - "96 Bd de l'Observatoire"
    - "06300 Nice, France"
  linkedin: "https://www.linkedin.com/in/…"
  orcid: "0009-0001-0670-2738"
  github: "username"                       # optional
  ads: "https://ui.adsabs.harvard.edu/…"   # optional
  scholar: "https://scholar.google.com/…"  # optional
```

Remove a line to hide the corresponding icon and button everywhere (header, footer and, for ORCID, ADS and Scholar, the Profiles box of the Publications page). `github`, `ads` and `scholar` are not set at the moment: add them to show them.

---

## 5. Photo, CV and other files

A file in `assets/` is published when a page links to it (the CV, the photo and the favicon are), or when it is listed under `resources` in `_quarto.yml` (the licence files of the fonts and of the Stellar design). A file that nothing links to is not published.

- **Photo:** replace `assets/photo.jpg`, keeping the name. Square, at least 600 × 600 px, face centred (it is cropped to a circle). It is also the link-preview image.
- **CV:** replace `assets/Perego_CV.pdf`, **keeping the exact name**, so existing links keep working. Then update the date in `_metadata.yml`:

  ```yaml
  cv:
    pdf: "assets/Perego_CV.pdf"
    updated: "March 2027"
  ```

- **Other files** (slides, posters, figures): put them in `assets/` and link them as `assets/file-name.pdf` from a page or a data file; the link makes them part of the site.

---

## 6. Pages and building blocks

A page is a `.qmd` file: a front matter between `---` lines, then Markdown. **Each `## Heading` creates a section card**; `###` is a sub-heading inside a card. Text before the first `##` becomes an introduction card (the CV page uses one for the download button).

```markdown
---
title: "Publications"
subtitle: "Refereed papers, preprints and proceedings"
description: "One sentence for search engines and link previews."
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
| `## Get in touch {.special}`                               | centred content                          |
| `## In a nutshell {.spotlight image="assets/photo.jpg" alt="Portrait of Alice Perego"}` | text beside a round picture; a bullet list in this section is shown as a list of facts with thin separators |

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

::: alt
- First item
- Second item
:::
```

`two-columns` is split at each `###` (one column on phones); `box` is a highlighted box; `tags` shows a list as pills; `alt` shows a list with thin separators instead of bullets.

### Buttons

```markdown
[Email](mailto:{{< meta person.email >}}){.button .primary} [CV]({{< meta cv.pdf >}}){.button} [LinkedIn]({{< meta person.linkedin >}}){.button}
```

Links on the same line form a row of buttons (stacked on phones). `.primary` is the filled button; `.small` is a smaller one. `{{< meta … >}}` inserts a value from `_metadata.yml`, so the email, the CV file and the profile links are never retyped.

### Lists from `data/` and bibliographies

| Line in a page                                   | Shows                                       |
| ------------------------------------------------ | ------------------------------------------- |
| `{{< proposals >}}`                              | `data/proposals.yml`                        |
| `{{< tools >}}`                                  | `data/tools.yml` as a grid of cards, if you create that file (see [Tools](#9-tools)) |
| `{{< list talks >}}`                             | `data/talks.yml` (any `data/NAME.yml` with dated entries) |
| `{{< news >}}`                                   | `data/news.yml`, once that file exists (see [Adding a section](#14-adding-a-section-or-a-page)) |
| `{{< bibliography publications.bib >}}`          | all entries, newest first                   |
| `{{< bibliography publications.bib limit=5 >}}`  | the 5 most recent entries                   |

---

## 7. Home page sections

File: `index.qmd`. Current order:

| Section             | Where the content is                                                  |
| ------------------- | --------------------------------------------------------------------- |
| Header              | name, role, affiliation, buttons and icons from `_metadata.yml`; tagline and the caption of the background picture in the front matter (`hero` → `tagline`, `pattern-caption`) |
| In a nutshell       | text, list of key facts and tags of scientific interests in `index.qmd` |
| Get in touch        | short text and buttons (Email, CV, LinkedIn) in `index.qmd`, section `## Get in touch {.special}`; the header's "Get in touch" button scrolls here |
| Research            | one `###` block per theme in `index.qmd`, inside `::: two-columns`     |
| Proposals           | one `###` block per proposal in `index.qmd`, with a description        |
| Tools I work with   | one `###` block per tool in `index.qmd`, inside `::: two-columns`      |
| Publications and proceedings | `{{< bibliography publications.bib limit=5 >}}` and buttons to the full lists on `publications.qmd` |
| Personal interests  | text in `index.qmd`                                                   |

**Adding a research theme:** add a `###` block inside the Research section. With two themes they sit side by side in `::: two-columns`; with three or more, remove the `::: two-columns` wrapper and stack the blocks. Figures go in `assets/figures/` and are included with `![Caption. Credit: …](assets/figures/figure.png){fig-alt="Short description"}`.

**Adding a proposal or a tool** on the home page: add a `###` block with the title and a paragraph, like the existing ones (for tools, inside the `::: two-columns` block; with three or more tools, remove that wrapper and stack the blocks). A proposal's facility, role, status and allocation belong in `data/proposals.yml`, which the CV page lists.

---

## 8. Proposals

The home page describes each proposal in prose (`index.qmd`, section `## Proposals`). The factual list is on the CV page, from `data/proposals.yml`, most recent first:

```yaml
- facility: "CFHT"
  period: "2026B"
  instrument: "MegaCam"
  title: "Proposal title"
  role: "PI"
  status: "Accepted"
  allocation: "3 nights"
  links:
    - text: "abstract"
      url: "https://…"
```

`facility`, `period`, `title` and `role` are required; `instrument`, `status`, `allocation` and `links` are optional: omit a line to hide it. Facility and period appear on the left; role, instrument, allocation and status on one line under the title.

---

## 9. Tools

The home page describes each tool in prose (`index.qmd`, section `## Tools I work with`): a `###` heading with the name, a line with the category, then the text.

A grid of cards is also available: create `data/tools.yml` and replace the blocks with the line `{{< tools >}}`.

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

`category`, `links` and `icon` are optional (`icon` defaults to `cpu`). Icon names: <https://icons.getbootstrap.com> (omit the `bi-` prefix).

---

## 10. Publications and proceedings

Files: `publications.bib` (refereed papers and preprints) and `proceedings.bib`. Entries are sorted by date automatically, newest first.

**Add an entry:**

1. On NASA ADS, open the paper, then *Export → BibTeX* (or select several records and export them together).
2. Paste the entry at the end of the right `.bib` file and save it (then save `index.qmd` or `publications.qmd` if the preview is running).

Journal macros from ADS (`\apj`, `\mnras`, `\aap`…) are expanded to full journal names automatically; an unknown macro produces a warning during the render. Each entry shows the title in bold, the authors, the venue (journal, volume and pages, or the proceedings volume) and the year, followed by link buttons generated from the entry:

| Field in the BibTeX                         | Link on the site |
| ------------------------------------------- | ---------------- |
| `eprint` with `archivePrefix = {arXiv}`, or an arxiv.org `url` | arXiv |
| `doi`                                       | DOI              |
| `note = {\href{https://github.com/…}{code}}` | code (any text and URL) |

TeX in titles (`$\sim$`, `$M_\odot$`) renders as math. **Remove an entry** by deleting it from the `.bib` file. The Profiles box at the bottom of the Publications page shows the ORCID, ADS and Google Scholar buttons for the links present in `_metadata.yml`.

---

## 11. CV page

File: `cv.qmd`. The introduction card holds the download button and the "Last updated" date (from `_metadata.yml` → `cv`); the sections follow the order of the PDF CV:

| Section                                    | Content                          |
| ------------------------------------------ | -------------------------------- |
| Education                                  | `data/education.yml`             |
| Conferences, workshops and research visits | `data/talks.yml`                 |
| Seasonal schools and specialised training  | `data/training.yml`              |
| Membership                                 | a `::: alt` list written in `cv.qmd` |
| Observational proposals                    | `data/proposals.yml` (the same file as the home page) |
| Software skills                            | `data/skills.yml`                |
| Languages                                  | `data/languages.yml`             |

All data files share one format; `skills.yml` and `languages.yml` use `label` instead of `date`:

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

`title` is shown in bold; `details` is one line or a list of lines; `links` is optional.

**New CV section** (for example Outreach): create `data/outreach.yml` in the same format, then add to `cv.qmd`:

```markdown
## Outreach

{{< list outreach >}}
```

### Updating the CV

The page is not generated from the PDF: the two are updated side by side, so that they say the same things.

1. Replace `assets/Perego_CV.pdf`, keeping the name, and set `cv → updated` in `_metadata.yml` (see [Photo, CV and other files](#5-photo-cv-and-other-files)).
2. Mirror the changes in the files of the table above (copy an existing entry, most recent first).
3. If they changed elsewhere: position or affiliation in `_metadata.yml → person`; the key facts under *In a nutshell* in `index.qmd`; new papers in the `.bib` files.
4. In the preview, save `cv.qmd` once so the data files are re-read, check the page, then commit and push.

For a CV with many changes, put the new PDF in a new `setup/` folder (`setup/cv.pdf`, ignored by git) and ask Claude to follow `PROMPT.md`: it imports the changes into the files above and removes the folder.

---

## 12. Navigation and footer

`_metadata.yml` → `site-menu`. Entries appear left to right; the footer lists Home and the entries that point to pages (without `#`).

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

The CV PDF is attached to the CV entry (icon in the navigation, "PDF" link in the footer) rather than listed as a separate entry. On phones the bar scrolls horizontally.

The footer's contact block is built from `person`. The HTML5 UP attribution line is required by the design's licence (CC BY 3.0) and is always shown.

---

## 13. Appearance

`custom.scss` contains only settings, each explained in the file:

| Variable                                  | Controls                                             |
| ----------------------------------------- | ---------------------------------------------------- |
| `$gradient-start`, `$gradient-end`        | background gradient of header and footer             |
| `$accent`, `$accent-light`                | primary buttons, icons, underline of section titles  |
| `$text`, `$text-strong`, `$text-muted`    | body text, headings, secondary text                  |
| `$line`, `$light-background`              | separators, navigation bar, highlighted boxes, tags  |
| `$font-titles`, `$font-text`              | fonts of titles and text                             |
| `$page-width`                             | maximum content width                                |
| `$hero-pattern-image`, `$hero-pattern-opacity` | picture behind the name on the home page, and its visibility (0 hides it) |

- **Colours** are hex codes. Check text contrast (≥ 4.5:1) with <https://webaim.org/resources/contrastchecker/>; the header text is white, so keep `$gradient-start` dark enough.
- **Fonts** are self-hosted (no request to Google at run time): Source Serif 4 for titles and Source Sans 3 for text, in `assets/fonts/` with their licences. To change one: download its woff2 file(s) and licence (from the font's repository, or from Google Fonts through a tool such as google-webfonts-helper), put them in `assets/fonts/`, update the corresponding `@font-face` blocks at the bottom of `custom.scss`, and set `$font-titles` or `$font-text` to the new family name.

### Home page background

The header of the home page is the gradient (`$gradient-start`, `$gradient-end`), Stellar's grainy texture (`assets/stellar/overlay.png`, also behind the footer) and a picture in the space between the affiliation and the buttons. The picture is centred on that space and sized from it (the drawn galaxy fills it minus a small margin above and below), edge to edge and softly faded at the sides, the same on phones and on wide screens; nothing in it needs adjusting per device.

- **Use your own picture:** put an SVG, PNG or JPEG in `assets/` (under ~200 KB) and point `$hero-pattern-image` to it, for example `"assets/header-background.jpg"`. It is published with the site. Then set `$hero-pattern-opacity` (currently 0.4). A picture whose subject is a horizontal band across the middle, like the default one, fits the space best. Save `custom.scss` and check in the preview that the white text stays readable.
- **Caption:** the line at the bottom right of the header (centred under it on phones) is `pattern-caption` under `hero` in the front matter of `index.qmd`; delete the line to remove it.
- **Hide it:** `$hero-pattern-opacity: 0`.
- **Regenerate the default pattern** (a scatter of points evoking the Galactic double white dwarfs): edit the parameters at the top of `_engine/hero-pattern.py` (number of points, seed) and run:

  ```bash
  python3 _engine/hero-pattern.py > assets/hero-pattern.svg
  ```

- **Change the texture:** replace `assets/stellar/overlay.png` with another small tiling PNG, keeping the name.

---

## 14. Adding a section or a page

**Section on an existing page:** write a new `## Heading` block where you want it, and add a menu entry with `link: "index.qmd#heading-id"` if it should be reachable from the navigation.

**News section:** create `data/news.yml`:

```yaml
- date: "June 2026"
  title: "A few words"
  text: "One or two sentences."
  link: "https://…"        # optional
  icon: "megaphone"        # optional
```

then add to `index.qmd`, where the section should appear:

```markdown
## News {.special}

{{< news >}}
```

**New page** (for example `outreach.qmd`):

1. Create the file:

   ```markdown
   ---
   title: "Outreach"
   subtitle: "Public talks and articles"
   description: "Outreach activities of Alice Perego."
   ---

   ## Public talks

   Text…
   ```

2. Add `- outreach.qmd` to `project → render` in `_quarto.yml`.
3. Add a menu entry in `_metadata.yml` → `site-menu`.

---

## 15. Search engines and link previews

The full status and the step-by-step list of what remains to be done are in `SEO.md`. What the site already does for search engines: every page has a unique title, a description, a canonical URL and Open Graph tags; the home page carries structured data (schema.org `Person`: name, role, affiliation, email, photo and profile links, all taken from `_metadata.yml`); `sitemap.xml` and `robots.txt` are generated; the 404 page is marked `noindex`.

**Texts you control:**

- `_quarto.yml` → `website`: `title` (name in the browser tab and after the page titles), `description` and `open-graph → description` (summary of the home page in search results and link previews), `open-graph → image` (preview image, `assets/photo.jpg`).
- Each page's front matter: `description` (its own search snippet). The browser-tab title of the home page is "Name – Role" from `_metadata.yml`; the other pages use their `title` followed by the site title.
- The texts of the pages themselves are what Google reads: the *In a nutshell* and *Research* sections should say who you are and what you work on in plain words (name, position, institute, field). Placeholder text counts against the site until it is replaced.

**Being found for your name** (things to do once, outside the repository):

1. Register the site in [Google Search Console](https://search.google.com/search-console) (URL-prefix property `https://aliperego.github.io/`). For the "HTML tag" verification method, paste the code of the tag into `_metadata.yml` → `seo → google-site-verification` (only the part inside `content="…"`), push, then click *Verify*. Then submit `https://aliperego.github.io/sitemap.xml` under *Sitemaps* and request indexing of the home page under *URL inspection*.
2. Link to the site from your profiles: ORCID (*Websites & social links*), LinkedIn (*Contact info → Website*), Google Scholar (homepage field), NASA ADS (ORCID-linked), your institute's staff or team page, GitHub. Links from these pages are the strongest signal that the site belongs to you.
3. Keep `_metadata.yml` → `person` complete (ORCID, LinkedIn, and `github`, `ads`, `scholar` when you have them): they are published as `sameAs` links in the structured data.

---

## 16. Publishing

- Every push to `main` triggers `.github/workflows/publish.yml`, which renders the site with the Quarto version pinned in the file and deploys it. Progress is in the repository's **Actions** tab; a red run contains the error message.
- One-time setting: *Settings → Pages → Source → GitHub Actions*.
- **Custom domain:** *Settings → Pages → Custom domain*, then add the DNS records GitHub indicates, and set `site-url` in `_quarto.yml` to the new address.
- **Maintenance:** Dependabot opens a pull request when one of the workflow's actions has a new version (`.github/dependabot.yml`); merging it is the only recurring task.

---

## 17. Placeholders still to write

Texts not yet written appear as italic *lorem ipsum*, marked by a comment `[[TO WRITE: … — ~N words]]` with the target length (an HTML comment in the pages, a `#` comment in YAML files). List them all with:

```bash
grep -rn "TO WRITE" --include="*.qmd" --include="*.yml" .
```

Replace the *lorem ipsum* with your text and delete the comment.

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
| A file in `assets/` is missing from the published site | Link it from a page or a data file, or list it under `resources` in `_quarto.yml` |
| A journal name is missing in a publication            | The render printed a warning with the unknown macro: ask Claude to add it to `_engine/shortcodes.lua` |
| A new top-level key in `_metadata.yml` causes a validation error | Some names are reserved by Quarto (`menu`, `navigation`); choose another name |
| The online site did not update                        | Open the failed run in the **Actions** tab; the error matches the one in `quarto render` |
| Undo a mistaken edit                                  | `git checkout -- path/to/file` restores the last committed version |
