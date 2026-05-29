# BioSim Lab NTUA Website

Modern academic lab website built with Jekyll and the al-folio theme stack for GitHub Pages project-site deployment.

## Local Development

```bash
bundle install
bundle exec jekyll serve --baseurl /biosim-website
```

The production project-site base path is configured in `_config.yml` as `baseurl: /biosim-website`. If the GitHub repository uses a different name, update `baseurl` or define the GitHub Actions variable `JEKYLL_BASEURL`.

## Deployment

The workflow in `.github/workflows/deploy.yml` builds the site on pushes to `main`, `master`, or `biosim-staging` and publishes `_site` to the `gh-pages` branch using `JamesIves/github-pages-deploy-action@v4`.

For a custom domain, add a `CNAME` file and configure DNS in GitHub Pages settings.

## Add A Publication

Edit `_bibliography/papers.bib` and add a BibTeX entry:

```bibtex
@article{key2026paper,
  title = {Your paper title},
  author = {Surname, Name and Collaborator, Name},
  journal = {Journal Name},
  year = {2026}
}
```

The Publications page is rendered by Jekyll Scholar from this file.

## Add A Team Member

Edit `_data/members.yml` and add a new entry with English and Greek fields:

```yaml
- name_en: New Member
  name_el: Νέο Μέλος
  role_en: PhD Candidate
  role_el: Υποψήφιος Διδάκτορας
  image: /assets/img/profile.jpg
  email: member@biosim.ntua.gr
  scholar: https://scholar.google.com
```

Images should be placed under `assets/img/`.

## Add A News Post

Create a Markdown file in `_news/`:

```markdown
---
layout: post
title: News title
date: 2026-05-28
---

Short announcement text for the lab news page and home carousel.
```

## Change Language Strings

Edit `_i18n/en.yml` for English or `_i18n/el.yml` for Greek. The `_i18n/en/` and `_i18n/el/` folders are available for additional language assets. The navigation, home-page labels, and section descriptions use these translation files through `jekyll-multiple-languages-plugin`.

## Interactive Libraries

All CDN dependencies are pinned in `_includes/head.html`:

- `tsparticles@3.8.1`
- `aos@2.3.4`
- `swiper@11.1.15`
- `countup.js@2.8.0`
- `glightbox@3.3.0`
- `typed.js@2.1.0`
