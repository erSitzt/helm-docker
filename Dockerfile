FROM alpine:3.6 

ENV VERSION v3.2.0

WORKDIR /

# Enable SSL
RUN apk --update add ca-certificates wget curl tar jq git bash perl-utils

# Install kubectl
ENV HOME /
RUN curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl && chmod +x kubectl && mv kubectl /usr/local/bin

# Install Helm
ENV FILENAME helm-${VERSION}-linux-amd64.tar.gz
ENV HELM_URL https://get.helm.sh/${FILENAME}

RUN echo $HELM_URL

RUN curl -o /tmp/$FILENAME ${HELM_URL} \
  && tar -zxvf /tmp/${FILENAME} -C /tmp \
  && mv /tmp/linux-amd64/helm /bin/helm \
  && rm -rf /tmp

# Install envsubst [better than using 'sed' for yaml substitutions]
ENV BUILD_DEPS="gettext"  \
    RUNTIME_DEPS="libintl"

RUN set -x && \
    apk add --update $RUNTIME_DEPS && \
    apk add --virtual build_deps $BUILD_DEPS &&  \
    cp /usr/bin/envsubst /usr/local/bin/envsubst && \
    apk del build_deps

# Install Helm plugins
# workaround for an issue in updating the binary of `helm-diff`
ENV HELM_PLUGIN_DIR /.helm/plugins/helm-diff
# Plugin is downloaded to /tmp, which must exist
RUN mkdir /tmp
RUN helm plugin install https://github.com/databus23/helm-diff
RUN helm plugin install https://github.com/helm/helm-2to3


# Install kustomize
RUN curl -s "https://raw.githubusercontent.com/kubernetes-sigs/kustomize/master/hack/install_kustomize.sh"  | bash && mv kustomize /usr/local/bin

# Install kubeval
RUN wget -q https://github.com/instrumenta/kubeval/releases/latest/download/kubeval-linux-amd64.tar.gz && tar xf kubeval-linux-amd64.tar.gz && mv kubeval /usr/local/bin && rm kubeval-linux-amd64.tar.gz

# Install cattlectl
RUN wget -q https://github.com/bitgrip/cattlectl/releases/download/v1.3.0/cattlectl-v1.3.0-linux.tar.gz && tar xf cattlectl-v1.3.0-linux.tar.gz && mv build/linux/cattlectl /usr/local/bin && rm cattlectl-v1.3.0-linux.tar.gz

# Install kapp
RUN wget -nv -O- https://github.com/k14s/kapp/releases/download/v0.25.0/kapp-linux-amd64  > /usr/local/bin/kapp && chmod +x /usr/local/bin/kapp

