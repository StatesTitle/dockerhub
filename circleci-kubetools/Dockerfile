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

# Build the container
FROM alpine:3.14.0
RUN apk --no-cache add ca-certificates && \
  addgroup -S kubetools && adduser -S kubetools -G kubetools
COPY --from=builder /kubeval/bin/kubeval /usr/bin/kustomize /usr/bin/kubectl ./
RUN ln -s /kubeval /usr/local/bin/kubeval && \
  ln -s /kustomize /usr/local/bin/kustomize && \
  ln -s /kubectl /usr/local/bin/kubectl

USER kubetools:kubetools
ENTRYPOINT ["/bin/sh"]