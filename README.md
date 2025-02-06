# Roadiz documentation

[![](https://readthedocs.org/projects/roadiz/badge/?version=latest)](https://readthedocs.org/projects/roadiz/?badge=latest)
![](https://img.shields.io/github/license/roadiz/docs.svg)

## Install and run locally

```bas
docker compose build
docker compose up
```

Go to http://locahost:8000

## Prepare translations

```bash
docker compose run --rm sphinx make gettext
docker compose run --rm sphinx /home/sphinx/.local/bin/sphinx-intl update -p _build/locale -l fr
```

Then translate each *.po* file with *PoEdit*.
And build your documentation with:

```bash
docker compose run --rm sphinx make -e SPHINXOPTS="-D language='fr'" html
```
