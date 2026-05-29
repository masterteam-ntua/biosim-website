# Agent Guidelines for BIOSIM Website

This repository is the BIOSIM Laboratory public website, built with Jekyll/al-folio for GitHub Pages project-site deployment.

## Site Context

- Public URL: `https://masterteam-ntua.github.io/biosim-website/`.
- Production base path is `baseurl: /biosim-website` in `_config.yml`.
- Default language is English; Greek pages are generated with `jekyll-multiple-languages-plugin` under `/el/`.
- `biosim-staging` keeps the full imported BIOSIM archive for review and migration work.
- Live GitHub Pages content should be deployed from `main`/`master`, not from `biosim-staging`.
- Preserve language-aware navigation and links when editing layouts or pages.

## Local Commands

Use the Homebrew Ruby path on this machine:

```bash
PATH="/opt/homebrew/opt/ruby/bin:/opt/homebrew/lib/ruby/gems/4.0.0/bin:$PATH" bundle exec jekyll build --baseurl /biosim-website
PATH="/opt/homebrew/opt/ruby/bin:/opt/homebrew/lib/ruby/gems/4.0.0/bin:$PATH" bundle exec jekyll serve --baseurl /biosim-website
```

Other useful commands:

```bash
npm ci
npm run lint:prettier
```

Do not rely on `npm run lint:style-contract` for this customized site unless the starter contract test is updated; it still checks upstream al-folio starter ownership rules.

## Deployment

- `.github/workflows/deploy.yml` builds on pushes to `main` or `master`.
- The workflow publishes `_site` to the `gh-pages` branch.
- GitHub Pages should be configured to serve from `gh-pages` at `/`.
- If the repository name changes, update `_config.yml` `baseurl` or define `JEKYLL_BASEURL` in GitHub Actions variables.

## Content Rules

- Keep `biosim-staging` full-content unless explicitly asked to trim it.
- People live in `_data/members.yml`; do not link profile cards to the old BIOSIM website.
- Funded projects for the Projects page live in `_data/projects.yml`.
- Research-area pages live in `_projects/` and publish under `/research/:name/`.
- Research sections should stay split as Research Areas, Diploma Theses, and PhD Theses.
- Thesis data lives in `_data/diploma_theses.yml` and `_data/phd_theses.yml`.
- News posts live in `_news/`; use real source images only. If a news item has no source image, render it without an image.
- News card headings should use the long/detail `title`; preview text should use `short_title`.
- Publications are rendered from `_bibliography/papers.bib` via Jekyll Scholar.

## Design Rules

- Preserve the BIOSIM dark navy/blue/teal visual direction.
- Use the BIOSIM logo in the header/home/footer instead of visible text branding.
- Do not add random placeholder imagery or contextual stock images.
- CDN dependencies are pinned in `_includes/head.html`; keep versions explicit.

## Importer

- `scripts/import_biosim_content.rb` imports news, publications, images, and theses from the old BIOSIM site.
- Preserve corrected parsing behavior for publication authors/years, news dates, escaped image alt text, and source-only news images.
- Re-importing full content may create many files; keep staging trimmed unless full migration is requested.
