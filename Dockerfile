# syntax=docker/dockerfile:1
FROM ubuntu:22.04

ARG JB_VERSION=v0.5.1
ARG TK_VERSION=v0.22.1

RUN apt-get update && apt-get install ca-certificates -y --no-install-recommends && rm -rf /var/lib/apt/lists/*
ADD --chmod=755 https://github.com/jsonnet-bundler/jsonnet-bundler/releases/download/${JB_VERSION}/jb-linux-amd64 /usr/local/bin/jb
ADD --chmod=755 https://github.com/grafana/tanka/releases/download/${TK_VERSION}/tk-linux-amd64 /usr/local/bin/tk
COPY plugin.yaml /home/argocd/cmp-server/config/plugin.yaml
COPY scripts/* /

CMD ["/var/run/argocd/argocd-cmp-server"]
