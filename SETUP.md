# SETUP: preparing the inputs for your website

Claude builds the site **only from the material you provide**. It does not look up facts about you and does not write your texts. Setup happens in two sessions with Claude Code, with your work in between.

---

## 1. Workflow

1. **Create the repository.** On GitHub, create an empty **public** repository named `<username>.github.io` (GitHub Pages on the free plan requires a public repository). In *Settings → Pages → Source*, choose **GitHub Actions** now, so that the first deployment works. Clone the repository and copy `PROMPT.md`, `SETUP.md` and `GUIDE.md` into its root.
2. **Pre-setup.** A Claude Code session following `PROMPT.md` creates the repository's base files (`README.md`, `.gitignore`, editor settings) and `setup/` with every input file ready to fill: instructions in comments, `FILL:` markers, and what you already specified pre-filled (section order, research themes, CFHT and ESO, tool names). Everything is committed, so you can work on it from any machine after pushing. Nothing is built yet.
3. **Fill in `setup/`** following §3, committing as you go if you like. Read the note on git history in §2 first.
4. **Build.** A second session following `PROMPT.md` checks the inputs, lists anything required that is missing, proposes a plan, and builds the site after approval. `setup/` then leaves the repository through dedicated commits:
   - at the start of the build, the files used as they are move into the site (the CV into `assets/`, the two `.bib` files to the root), and the photo and figures are replaced by optimised copies;
   - once you approve the site, and before it is first published, the rest of `setup/` is deleted.

After the build, `setup/` no longer exists: the content lives in the site files described in `GUIDE.md`.

### Recommended Claude Code configuration (for whoever runs the sessions)

| Session                          | Model       | Effort  | How to start                        |
| -------------------------------- | ----------- | ------- | ----------------------------------- |
| Pre-setup (step 2)               | Opus 5      | `high`  | `claude` (repository default below) |
| Build (step 4)                   | Fable 5.1   | `xhigh` | `claude --model fable --effort xhigh` |
| Later edits and small changes    | Opus 5      | `high`  | `claude`                            |

- **Fable 5.1** is Anthropic's most capable model for long, autonomous work, which is what the build session is. Depending on the plan, its usage may be billed to [extra usage credits](https://support.claude.com/en/articles/12429409-extra-usage-for-paid-claude-plans). If you prefer not to use them, run the build with `claude --model opus --effort xhigh`.
- Keep the same model for the whole build session. `max` effort is slower and applies to the current session only: worth it for a final review of the finished site, not for the build. `ultracode` orchestrates multi-agent workflows and consumes much more usage: not needed here.
- Commit a `.claude/settings.json` with the repository default (used whenever no flag is given; the command-line flags above override it):

  ```json
  {
    "model": "opus",
    "effortLevel": "high"
  }
  ```

---

## 2. What gets published, and what does not

`setup/` is **never published**. It is committed while you fill it in and removed with commits after the import; only what the site needs reaches the site files. In particular:

| In `setup/`                                        | On the site                                         |
| -------------------------------------------------- | --------------------------------------------------- |
| Values still containing `FILL:`                    | Nothing: required ones stop the build; optional ones are omitted, or become a marked placeholder you write later |
| Template entries left untouched (a proposal, a tool, a news item, a figure) | Nothing: they are dropped |
| Instructions and comments                          | Nothing                                             |
| Image files in `figures/` not listed in `credits.yml` | Nothing                                          |
| `photo.jpg`                                        | A cropped, resized copy (~600 px); the original is not published |
| `cv.pdf`                                           | Published as `<Surname>_CV.pdf`: it is the downloadable CV |
| Personal details in the CV (phone, birth date…)    | Nothing, unless you also put them in `profile.yml`  |

> **Git history.** Commits keep every version of every file, including after `setup/` is removed, and the repository is public: anything ever committed to `setup/` can be read in the history once the site is pushed. This is why `setup/` has no "private" fields. Put in it only material you would publish: leave out a confidential proposal rather than describing it, and do not add figures you may not publish. If you commit something by mistake, tell Claude **before** the first push: removing it from the history is possible only until then.

Before the site goes online, Claude runs an automated scan that checks none of the excluded material is in the published output or in the page source. Placeholders for texts still to write are listed, and Claude asks you before the first publication.

---

## 3. Filling in `setup/`

### The `FILL:` convention

Every value to provide contains `FILL:` followed by a description, for example:

```yaml
email: "FILL: public email address"
```

Replace the whole value, keeping the quotes:

```yaml
email: "name.surname@university.edu"
```

For an optional value you do not want on the site, delete the line or leave `FILL:` in it. YAML needs spaces, not tabs, and consistent indentation: edit the pre-filled blocks rather than retyping them.

### Files to add

| File              | Content |
| ----------------- | ------- |
| `setup/cv.pdf`    | Your current CV. It is the source of every fact on the site (education, positions, talks, teaching, awards, skills) and becomes the downloadable CV. Check that dates, titles and affiliations are the ones you want online. |
| `setup/photo.jpg` | A professional portrait: at least 600 × 600 px, face centred (it is shown in a circle), no other people in the frame. It is also the preview image when the site is shared. Claude crops and resizes it, but does not retouch it. |

### Files to fill

| File | Required | What to do |
| ---- | -------- | ---------- |
| `profile.yml` | yes | Name, surname (for the CV file name), role, affiliations, public email, repository name. Optional: address, LinkedIn, ORCID, GitHub, ADS, Google Scholar, custom domain. |
| `site.yml` | yes | Pre-filled with the defaults matching your outline. Change only what you want different (one page or several pages, the CV button, number of publications on the home page, separate proceedings, palette, header pattern, licence of the code). |
| `proposals.yml` | for the Proposals section | One block per proposal (a CFHT and an ESO block are pre-filled): period, title, role, and optionally instrument, status, allocation, links. Only information you may make public; a block left untouched is dropped. |
| `tools.yml` | for the Tools section | Pre-filled with the tools you listed. For each: the precise name where a placeholder stands (e.g. which Milky Way models), links, and optionally a 1–2 sentence description. Say what "extrapop posynth" is. |
| `publications.bib` | yes | Refereed papers and preprints, exported from NASA ADS (see below). |
| `proceedings.bib` | may stay empty | Conference proceedings, exported from NASA ADS. |

### Exporting from NASA ADS

1. On <https://ui.adsabs.harvard.edu>, search `author:"Surname, A."`; add `orcid:0000-0000-0000-0000` to exclude namesakes.
2. **`publications.bib`:** apply the *Refereed* filter, and add the arXiv preprints that do not have a refereed version yet.
3. **`proceedings.bib`:** filter *Publication type → Proceedings* (or search with `doctype:inproceedings`). Decide whether conference abstracts belong here; if in doubt, leave them out.
4. Select the records, then *Export → BibTeX*, and paste the result below the `@comment` block of the file. Delete the `FILL:` line.

Keep the export as it is: journal abbreviations (`\apj`, `\mnras`…), `eprint` and `doi` are handled automatically and become the journal name and the arXiv and DOI links. To add a link to code or data, add to that entry:

```bibtex
note = {\href{https://github.com/…}{code}},
```

### Optional files

| File | Purpose | Length |
| ---- | ------- | ------ |
| `texts/tagline.md` | Line under your name in the header | ~15 words |
| `texts/nutshell.md` | In a nutshell | ~120–150 words |
| `texts/contact.md` | Get in touch box | ~30 words |
| `texts/research-ultra-compact-double-white-dwarfs.md` | Research theme | ~150 words |
| `texts/research-astrophysical-foregrounds.md` | Research theme | ~150 words |
| `texts/proposals-intro.md` | Introduction to Proposals | ~30 words |
| `texts/tools-intro.md` | Introduction to Tools I work with | ~40 words |
| `texts/interests.md` | Personal interests: prose or a list | ~60–100 words |
| `figures/` + `figures/credits.yml` | Figures for the research themes (your own, or with a licence that allows publication), each listed with caption, credit and alt text | — |
| `news.yml` | Recent news for the home page | 1–2 sentences each |

Texts accept Markdown and LaTeX math (`$M_\odot$`). A text left with its `FILL:` line becomes a marked placeholder on the site, which you can write later following `GUIDE.md`.

---

## 4. Accounts and access

- **GitHub:** the repository `<username>.github.io` (from `profile.yml`). Claude commits locally and asks before pushing.
- **GitHub Pages:** *Settings → Pages → Source → GitHub Actions*, set before the first push (step 1). If it is missing, the first deployment fails: set it and re-run the workflow from the *Actions* tab.
- **Custom domain** (optional): access to the domain's DNS settings.
- **Quarto** need not be installed in advance: Claude checks and installs it if needed.

---

## 5. Checklist before the build session

- [ ] `setup/cv.pdf` added
- [ ] `setup/photo.jpg` added
- [ ] `setup/profile.yml`: no `FILL:` left in name, surname, role, affiliations, email, repository
- [ ] `setup/publications.bib`: ADS export pasted
- [ ] `setup/proceedings.bib`: ADS export pasted, or left without entries
- [ ] `setup/proposals.yml`: filled (untouched template blocks are dropped)
- [ ] `setup/tools.yml`: names and links filled; "extrapop posynth" explained
- [ ] `setup/site.yml`: checked
- [ ] Optional: `setup/texts/`, `setup/figures/`, `setup/news.yml`
- [ ] GitHub: repository public, Pages source set to GitHub Actions
