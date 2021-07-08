FROM golang:1.16-alpine as builder

ENV KUSTOMIZE_VER 4.1.3
ENV KUBECTL_VER 1.19.9

RUN apk --no-cache add make git curl gettext

# Download kustomize artifact https://github.com/kubernetes-sigs/kustomize/releases/download/kustomize/v4.1.3/kustomize_v4.1.3_linux_amd64.tar.gz
RUN curl -L https://github.com/kubernetes-sigs/kustomize/releases/download/kustomize/v${KUSTOMIZE_VER}/kustomize_v${KUSTOMIZE_VER}_linux_amd64.tar.gz  -o /tmp/kustomize_v${KUSTOMIZE_VER}_linux_amd64.tar.gz \
  && tar xfz /tmp/kustomize_v${KUSTOMIZE_VER}_linux_amd64.tar.gz -C /usr/bin \
  && chmod +x /usr/bin/kustomize

# Download kubectl artifact
RUN curl -L https://storage.googleapis.com/kubernetes-release/release/v${KUBECTL_VER}/bin/linux/amd64/kubectl -o /usr/bin/kubectl \
    && chmod +x /usr/bin/kubectl    

# Checkout and build kubeval
RUN git clone --depth 1 https://github.com/instrumenta/kubeval.git /kubeval
WORKDIR /kubeval
RUN make build

# Uncomment the following schema segments for offline schemas (NOTE: makes image ~10GB in size)
# FROM alpine:latest as schemas
# RUN apk --no-cache add git
# RUN git clone --depth 1 https://github.com/instrumenta/kubernetes-json-schema.git
# RUN git clone --depth 1 https://github.com/garethr/openshift-json-schema.git

# FROM schemas as standalone-schemas
# RUN cd kubernetes-json-schema/master && \
#     find -maxdepth 1 -type d -not -name "." -not -name "*-standalone*" | xargs rm -rf

# Build the container
FROM alpine:latest
RUN apk --no-cache add ca-certificates
COPY --from=builder /kubeval/bin/kubeval .
COPY --from=builder /usr/bin/kustomize .
COPY --from=builder /usr/bin/kubectl .
RUN ln -s /kubeval /usr/local/bin/kubeval
RUN ln -s /kustomize /usr/local/bin/kustomize
RUN ln -s /kubectl /usr/local/bin/kubectl

# Uncomment for offline schemas
# COPY --from=standalone-schemas /kubernetes-json-schema /schemas/kubernetes-json-schema/master
# COPY --from=standalone-schemas /openshift-json-schema /schemas/openshift-json-schema/master
# ENV KUBEVAL_SCHEMA_LOCATION=file:///schemas

ENTRYPOINT ["/bin/sh"]