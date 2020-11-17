FROM docker.io/debian:buster
COPY tmp/stack-build-exe /usr/local/bin/stack-build-exe
COPY tmp/02_stack_script.hs /usr/local/bin/02_stack_script.hs
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
    git \
    haskell-stack \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*
RUN /usr/local/bin/02_stack_script.hs
RUN /usr/local/bin/stack-build-exe 
