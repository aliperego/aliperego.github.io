# aliperego.github.io

Source of the personal academic website of Alice Perego, published at <https://aliperego.github.io>.
The site is built with [Quarto](https://quarto.org) and deployed by GitHub Actions on every push to `main`.

## Structure

| Path                 | Content                                                        |
| -------------------- | -------------------------------------------------------------- |
| `index.qmd`          | Home page: header, In a nutshell, Get in touch, Research, Proposals, Tools, Publications, Personal interests |
| `publications.qmd`   | Publications and proceedings, from `publications.bib` and `proceedings.bib` |
| `cv.qmd`             | CV page, from the lists in `data/`                              |
| `404.qmd`            | Page shown for missing URLs                                    |
| `_metadata.yml`      | Personal details, CV file and navigation menu                   |
| `_quarto.yml`        | Site configuration                                             |
| `custom.scss`        | Colours, fonts and sizes                                       |
| `data/`              | Proposals and CV entries (YAML)                                |
| `assets/`            | CV PDF, photo, favicon, header pattern, fonts, Stellar files   |
| `_engine/`           | Layout filter, shortcodes, bibliography style, styles and scripts |
| `.github/`           | Publishing workflow and Dependabot configuration               |
| `GUIDE.md`           | How to edit the site                                           |
| `PROMPT.md`, `SETUP.md` | Brief and setup instructions used to build the site         |

## Local preview

With Quarto installed, run from the repository root:

```bash
quarto preview
```

## Licence

The code of the site (layout, styles, scripts, configuration) is released under the
[MIT License](LICENSE). The content (texts, figures, CV, photo) is © Alice Perego, all rights reserved.
The design is adapted from [Stellar](https://html5up.net/stellar) by HTML5 UP
([CC BY 3.0](assets/stellar/LICENSE.txt)).

## Credits

- [Stellar](https://html5up.net/stellar) by HTML5 UP (CC BY 3.0): layout and overlay texture.
- [Bootstrap Icons](https://icons.getbootstrap.com) (MIT), bundled with Quarto.
- [Source Serif 4](https://github.com/adobe-fonts/source-serif) and
  [Source Sans 3](https://github.com/adobe-fonts/source-sans) by Adobe (SIL Open Font License 1.1),
  self-hosted in `assets/fonts/`.

See [GUIDE.md](GUIDE.md) to edit the site.
