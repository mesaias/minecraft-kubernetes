FROM alpine:3.19.1

ENV TERRAFORM_VERSION=1.7.5

RUN apk update && \
    apk add curl jq python3 bash ca-certificates git openssl unzip wget && \
    cd /tmp && \
    wget https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
    unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip -d /usr/bin && \
    wget https://dl.google.com/dl/cloudsdk/channels/rapid/google-cloud-sdk.zip -O /tmp/google-cloud-sdk.zip && \
    cd /usr/local && unzip /tmp/google-cloud-sdk.zip && \
    google-cloud-sdk/install.sh --usage-reporting=false --path-update=true --bash-completion=true && \
    google-cloud-sdk/bin/gcloud config set --installation component_manager/disable_update_check true && \
    rm -rf /tmp/* && \
    rm -rf /var/cache/apk/* && \
    rm -rf /var/tmp/*

ENV PATH = $PATH:/usr/local/google-cloud-sdk/bin/

ARG VCS_REF