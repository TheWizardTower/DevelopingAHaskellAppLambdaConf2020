FROM docker.io/fedora:33 as build

RUN dnf install -y \
    gmp-devel \
    make \
    perl \
    stack \
    xz \
    && dnf clean all
RUN stack setup --verbose
COPY tmp/stack-build/. /src/stack-build
WORKDIR /src/stack-build
RUN stack install --local-bin-path=/usr/local/bin --verbose

FROM docker.io/debian:buster
COPY --from=build /usr/local/bin/stack-build-exe /usr/local/bin
COPY tmp/02_stack_script.hs /usr/local/bin
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
    git \
    haskell-stack \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*
RUN /usr/local/bin/stack-build-exe
RUN /usr/local/bin/02_stack_script.hs