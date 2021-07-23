# CIRCLECI-KUBETOOLS

## Installed Tools

  - [kubeval] (https://kubeval.instrumenta.dev)
  - [kubectl] (https://kubernetes.io/docs/tasks/tools/)
  - [kustomize] (https://kustomize.io/)

## Offline Use

If necessary, the following lines can be added to pull the schemas into the image for offline use. 

__Note: Creates an image ~10GB in size__

    FROM alpine:latest as schemas
    RUN apk --no-cache add git
    RUN git clone --depth 1 https://github.com/instrumenta/kubernetes-json-schema.git
    RUN git clone --depth 1 https://github.com/garethr/openshift-json-schema.git

    FROM schemas as standalone-schemas
    RUN cd kubernetes-json-schema/master && \
      find -maxdepth 1 -type d -not -name "." -not -name "*-standalone*" | xargs rm -rf

    COPY --from=standalone-schemas /kubernetes-json-schema /schemas/kubernetes-json-schema/master
    COPY --from=standalone-schemas /openshift-json-schema /schemas/openshift-json-schema/master
    ENV KUBEVAL_SCHEMA_LOCATION=file:///schemas
