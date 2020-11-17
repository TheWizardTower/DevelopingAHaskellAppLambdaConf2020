FROM docker.io/fedora:33 as build

RUN dnf install -y \
    gmp-devel \
    make \
    perl \
    stack \
    xz \
    && dnf clean all
RUN stack setup --verbose --resolver lts-16.22
COPY tmp/stack-build/. /src/stack-build
WORKDIR /src/stack-build
RUN stack install --local-bin-path=/usr/local/bin --verbose

FROM docker.io/debian:buster
COPY --from=build /usr/local/bin/stack-build-exe /usr/local/bin
COPY tmp/00_runghc.hs /usr/local/bin
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
    ca-certificates \
    curl \
    ghc \
    git \
    gnupg \
    make \
    netbase \
    xz-utils \
    zlib1g-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*
RUN curl -sSL https://get.haskellstack.org/ | sh
RUN /usr/local/bin/00_runghc.hs
COPY tmp/02_stack_script.hs /usr/local/bin/02_stack_script.hs
RUN /usr/local/bin/02_stack_script.hs
RUN /usr/local/bin/stack-build-exe