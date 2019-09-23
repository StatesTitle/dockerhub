# Base consists of the following images:
# https://github.com/nodejs/docker-node/blob/master/12/stretch/Dockerfile
# https://github.com/CircleCI-Public/circleci-dockerfiles/blob/master/node/images/12.10.0-stretch/Dockerfile

FROM circleci/node:12.10.0-stretch AS base
FROM circleci/python:3.7.0

RUN curl https://cli-assets.heroku.com/install.sh | sh

ENV YARN_VERSION 1.17.3

COPY --from=base /usr/local/bin/node /usr/local/bin/node
COPY --from=base /opt/yarn-v$YARN_VERSION /opt/yarn-v$YARN_VERSION

# Switch to root user to use ln cmd
USER root
# Link Binaries
RUN ln -s /usr/local/bin/node /usr/local/bin/nodejs \
    && ln -s /opt/yarn-v$YARN_VERSION/bin/yarn /usr/local/bin/yarn \
    && ln -s /opt/yarn-v$YARN_VERSION/bin/yarnpkg /usr/local/bin/yarnpkg

USER circleci