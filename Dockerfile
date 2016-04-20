FROM debian:jessie

ENV CORE_PACKAGES curl libpq5 locales python python-pip libpython2.7
ENV CORE_PIP_PACKAGES pip nose setuptools
ENV BUILD_PACKAGES build-essential libpq-dev python-dev libffi-dev libssl-dev
ENV PIP_BUILD_PACKAGES psycopg2 uwsgi flask alembic requests[security] SQLAlchemy SQLAlchemy-Utils

RUN apt-get update && \
    apt-get install -y --no-install-recommends ${CORE_PACKAGES} && \
    pip install --upgrade ${CORE_PIP_PACKAGES} && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/*

RUN echo "en_US.UTF-8 UTF-8" > /etc/locale.gen && \
    locale-gen "en_US.UTF-8" && \
    /usr/sbin/update-locale LANG=en_US.UTF-8

ENV LC_ALL en_US.UTF-8

RUN apt-get update && \
    apt-get install -y --no-install-recommends ${BUILD_PACKAGES} && \
    pip install --upgrade ${PIP_BUILD_PACKAGES} && \
    apt-get remove --purge -y ${BUILD_PACKAGES} && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/*

# Work in /src
WORKDIR src

# Expose on the standard HTTP port
EXPOSE 80

# Label the image
LABEL microcosm=python-service

# Copy entrypoint
COPY entrypoint.sh /src/
ENTRYPOINT ["./entrypoint.sh"]
CMD ["uwsgi"]
