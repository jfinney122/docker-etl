FROM ruby:2.3-alpine

MAINTAINER John Allen <john.allen@technekes.com>
MAINTAINER Jack Ross <jack.ross@technekes.com>

RUN \
  cd /tmp && \

  apk --no-cache add wget ca-certificates && \

  wget "s3.amazonaws.com/aws-cli/awscli-bundle.zip" -O "awscli-bundle.zip" && \
    unzip awscli-bundle.zip && \
    apk --no-cache add groff less python && \
    ./awscli-bundle/install -i /usr/local/aws -b /usr/local/bin/aws && \

  # install build related tools
  apk --no-cache add --virtual .build_deps \
    git \
    autoconf \
    automake \
    build-base \
    glib \
    glib-dev \
    libc-dev \
    libtool \
    linux-headers \
    openssl-dev \
    ruby-dev && \

  apk --no-cache add --virtual .gem_deps \
    postgresql-dev \
    sqlite-dev \
    libxml2-dev \
    libxslt-dev && \

  # install csvquote
  wget "https://github.com/dbro/csvquote/archive/master.zip" && \
    unzip master.zip && rm master.zip && \
    cd csvquote-master && \
    make && make install && \

  # install mdb-tools
  wget "https://github.com/brianb/mdbtools/archive/0.7.1.zip" && \
    unzip 0.7.1.zip && rm 0.7.1.zip && \
    cd mdbtools-0.7.1 && \
    autoreconf -i -f && \
    ./configure --disable-man && make && make install && \

  # install apk versions of tools
  apk --no-cache add \
    bash \
    freetds \
    gawk \
    gzip \
    jq \
    postgresql-client \
    sed \
    gpgme && \

  apk --no-cache add \
    gnupg1 && \

  rm /etc/freetds.conf && \

  # symlink gsed to sed
  ln -s /bin/sed /bin/gsed && \

  #clean up
  # apk del build-base libtool autoconf automake glib-dev openssl && \
  rm -rf /tmp/*

COPY alpine/etc/freetds.conf /etc/

# override entry point from parent image
ENTRYPOINT []
