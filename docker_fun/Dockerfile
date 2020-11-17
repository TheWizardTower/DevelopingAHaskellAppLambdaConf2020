FROM docker.io/fedora:33 as build

RUN dnf install -y stack && dnf clean all
COPY tmp/stack-build/. /src/stack-build
WORKDIR /src/stack-build
RUN stack install --local-bin-path=/usr/local/bin

FROM docker.io/debian:buster
COPY --from=build /usr/local/bin/stack-build-exe /usr/local/bin
RUN /usr/local/bin/stack-build-exe