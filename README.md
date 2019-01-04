# Roadiz documentation

[![](https://readthedocs.org/projects/roadiz/badge/?version=latest)](https://readthedocs.org/projects/roadiz/?badge=latest) 
![](https://img.shields.io/github/license/roadiz/docs.svg)

## Install locally

```bash
# Make sure python3 is setup
# On MacOS, use brew
# brew install python3

pip3 install sphinx  --user
pip3 install sphinx-intl --user
pip3 install recommonmark --user
pip3 install pygments-markdown-lexer --user
```

## Prepare translations

```bash
make gettext
sphinx-intl update -p _build/locale -l fr
```

Then translate each *.po* file with *PoEdit*.
And build your documentation with:

```bash
make -e SPHINXOPTS="-D language='fr'" html
```

## Export in PDF

```bash
make latex
cd _build/latex
pdflatex -interaction=batchmode Roadiz
```
