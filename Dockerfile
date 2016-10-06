FROM debian:jessie

# py2/py3 switch: build with --build-arg PY_VERSION=3 for python3
ARG PY_MAJOR=""
ENV PY_MINOR=${PY_MAJOR:+.4}
ENV PY_VERSION_TMP=${PY_MAJOR}${PY_MINOR}
ENV PY_VERSION=${PY_VERSION_TMP:-2.7}

# We use these packages when we build a Python binary library
ENV BUILD_PACKAGES build-essential libpq-dev python${PY_MAJOR}-dev libffi-dev libssl-dev


# We always need these packages to do Python
ENV CORE_PACKAGES curl libpq5 locales python${PY_MAJOR} python${PY_MAJOR}-pip libpython${PY_VERSION}
ENV CORE_PIP_PACKAGES pip nose setuptools
RUN apt-get update && \
    apt-get install -y --no-install-recommends ${CORE_PACKAGES} && \
    pip${PY_MAJOR} install --upgrade ${CORE_PIP_PACKAGES} && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/*

# set default python to be python${PY_MAJOR}
RUN if [ ! -z ${PY_MAJOR} ]; then \
    update-alternatives --install /usr/bin/python python /usr/bin/python${PY_MAJOR} 1; \
    update-alternatives --install /usr/bin/pip pip /usr/bin/pip${PY_MAJOR} 1; \
    fi 

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
LABEL microcosm.type="python${PY_MAJOR}-service"

# Expose as a uwsgi application
COPY entrypoint.sh /src/
COPY build.sh /src/
ENTRYPOINT ["./entrypoint.sh"]
CMD ["uwsgi"]
