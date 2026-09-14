# setup/

Inputs for the first build of the website. It is committed while you fill it in, never published,
and removed by Claude with dedicated commits once its content has been imported.
Everything committed here stays in the git history, which is public once the site is pushed:
add only material you would publish.

Replace every `FILL:` value. Anything that still contains `FILL:` is treated as missing:
required inputs stop the build; optional ones are left out, or become a marked placeholder
you can write later. See SETUP.md at the repository root for details.

Add here: cv.pdf, photo.jpg. Then ask Claude again to follow PROMPT.md.
