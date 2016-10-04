FROM debian:jessie

# We use these packages when we build a Python binary library
ENV BUILD_PACKAGES build-essential libpq-dev python-dev libffi-dev libssl-dev


# We always need these packages to do Python
ENV CORE_PACKAGES curl libpq5 locales python python-pip libpython2.7
ENV CORE_PIP_PACKAGES pip nose setuptools
RUN apt-get update && \
    apt-get install -y --no-install-recommends ${CORE_PACKAGES} && \
    pip install --upgrade ${CORE_PIP_PACKAGES} && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/*


# We need a proper locale
RUN echo "en_US.UTF-8 UTF-8" > /etc/locale.gen && \
    locale-gen "en_US.UTF-8" && \
    /usr/sbin/update-locale LANG=en_US.UTF-8
ENV LC_ALL en_US.UTF-8


# We need these libraries often enough (and they're binary), so we install them upfront
ENV PIP_COMMON_PACKAGES alembic cffi cryptography flask MarkupSafe ndg-httpsclient psycopg2 pycrypto requests[security] SQLAlchemy SQLAlchemy-Utils PyYAML uwsgi
RUN apt-get update && \
    apt-get install -y --no-install-recommends ${BUILD_PACKAGES} && \
    pip install --upgrade ${PIP_COMMON_PACKAGES} && \
    apt-get remove --purge -y ${BUILD_PACKAGES} && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/*


# Work in /src
WORKDIR src

# Expose on the standard HTTP port
EXPOSE 80

# Label the image
LABEL microcosm.type="python-service"

# Don't freeze by default
ARG FREEZE=""

# Expose as a uwsgi application
COPY entrypoint.sh /src/
COPY build.sh /src/
ENTRYPOINT ["./entrypoint.sh"]
CMD ["uwsgi"]
