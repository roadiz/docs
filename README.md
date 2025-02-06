# Roadiz documentation

[![](https://readthedocs.org/projects/roadiz/badge/?version=latest)](https://readthedocs.org/projects/roadiz/?badge=latest)
![](https://img.shields.io/github/license/roadiz/docs.svg)

## Install locally

```bash
docker compose build

docker compose up
```

## Prepare translations

```bash
make gettext
docker compose run --rm sphinx /home/sphinx/.local/bin/sphinx-intl update -p _build/locale -l fr
```

Then translate each *.po* file with *PoEdit*.
And build your documentation with:

```bash
make -e SPHINXOPTS="-D language='fr'" html
```

## Live reload during writing

```
make livehtml
```

## Export in PDF

```bash
make latex
cd _build/latex
pdflatex -interaction=batchmode Roadiz
```
