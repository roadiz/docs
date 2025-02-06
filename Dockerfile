FROM python:3.7.17-slim-bullseye AS sphinx

ARG UID=1000
ARG GID=${UID}

ENV PATH="$PATH:/home/sphinx/.local/bin"

LABEL org.opencontainers.image.authors="ambroise@rezo-zero.com"

SHELL ["/bin/bash", "-e", "-o", "pipefail", "-c"]

RUN <<EOF
apt-get --quiet update
apt-get --quiet --yes --purge --autoremove upgrade
# Packages - System
apt-get --quiet --yes --no-install-recommends --verbose-versions install git make
rm -rf /var/lib/apt/lists/*

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

CMD [ "make", "livehtml" ]
