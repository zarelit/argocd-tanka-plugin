FROM ubuntu:22.04

ARG JB_VERSION=v0.5.1
ARG TK_VERSION=v0.22.1

RUN apt-get update && apt-get install ca-certificates curl -y --no-install-recommends && rm -rf /var/lib/apt/lists/*
RUN curl -Lo /usr/local/bin/jb https://github.com/jsonnet-bundler/jsonnet-bundler/releases/${JB_VERSION}/download/jb-linux-amd64 && \
    curl -Lo /usr/local/bin/tk https://github.com/grafana/tanka/releases/download/${TK_VERSION}/tk-linux-amd64 && \
    chmod +x /usr/local/bin/tk && \
    chmod +x /usr/local/bin/jb
COPY plugin.yaml /home/argocd/cmp-server/config/plugin.yaml
COPY scripts/* /

CMD ["/var/run/argocd/argocd-cmp-server"]
