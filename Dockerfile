FROM python:3.7.17-slim-bullseye AS sphinx

ARG UID=1000
ARG GID=${UID}

ENV BUILDDIR="_build"
# You can set these variables from the command line.
ENV SOURCEDIR=src
ENV SPHINXBUILD=sphinx-build
ENV SPHINXINTL=sphinx-intl
ENV SPHINXPROJ=RoadizDoc
ENV PAPER=a4
ENV BUILDDIR=_build
ENV I18NDIR=i18n
ENV SPHINXINTL_LANGUAGE=fr
ENV PAPEROPT_a4="-D latex_paper_size=a4"
ENV PAPEROPT_letter="-D latex_paper_size=letter"
ENV ALLSPHINXOPTS="-d ${BUILDDIR}/doctrees -D latex_paper_size=a4 ${SOURCEDIR}"
# the i18n builder cannot share the environment and doctrees with the others
ENV I18NSPHINXOPTS="-D latex_paper_size=a4 ${SOURCEDIR}"

LABEL org.opencontainers.image.authors="ambroise@rezo-zero.com"

SHELL ["/bin/bash", "-e", "-o", "pipefail", "-c"]

RUN <<EOF
# User
useradd --uid ${UID} --home /home/sphinx --create-home --shell /bin/bash sphinx
chown --verbose --recursive ${UID}:${UID} /home/sphinx

install --verbose --owner sphinx --group sphinx --mode 0755 --directory /app
EOF

USER sphinx

WORKDIR /app

RUN <<EOF
pip3 install sphinx  --user
pip3 install sphinx-intl --user
pip3 install sphinx-autobuild --user
pip3 install recommonmark --user
pip3 install pygments-markdown-lexer --user
EOF

VOLUME /app

EXPOSE 8000

CMD [ "/home/sphinx/.local/bin/sphinx-autobuild", "--host", "0.0.0.0", "--port", "8000", "--ignore", "*/_build/*", "--ignore", "*/_static/*", "--ignore", "*/Makefile", "--ignore", "*/.idea/*", "--ignore", "*/.git/*", "--ignore", "*/roadiz_rtd_theme/*", "--ignore", "*rst~", "--ignore", "*.pickle", "--ignore", "*.doctree", "--ignore", "*HEAD", "--ignore", "*FETCH_HEAD", "-b", "html", "-d", "_build/doctrees", "-D", "latex_paper_size=a4", "src", "_build/html" ]
