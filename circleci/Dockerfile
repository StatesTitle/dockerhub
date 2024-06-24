FROM cimg/python:3.11.4

### 1. Underwriter binaries

# this image comes with:
#    build-essential 12.8ubuntu1.1
#    curl 7.68.0
#    docker 20.10.12
#    docker-compose v2.2.3
#    dockerize v0.6.1
#    git 2.34.1
#    jq 1.6
#    ubuntu 20.04.3 LTS (Focal Fossa)
#    wget 1.20.3
RUN sudo apt-get update -y
RUN sudo apt-get -y install software-properties-common libffi-dev libssl-dev

### 2. Node + Yarn
# Copied (and tweaked) from https://github.com/CircleCI-Public/cimg-python/blob/main/3.7/node/Dockerfile

# In the public image build, this pulls the latest LTS release from cimg-node
# but we've pinned the version here to keep this to a known good version and not update to a new major version when LTS changes
ENV NODE_VERSION 20.8.0
RUN curl -L -o node.tar.xz "https://nodejs.org/dist/v${NODE_VERSION}/node-v${NODE_VERSION}-linux-x64.tar.xz" && \
	sudo tar -xJf node.tar.xz -C /usr/local --strip-components=1 && \
	rm node.tar.xz && \
	sudo ln -s /usr/local/bin/node /usr/local/bin/nodejs

ENV YARN_VERSION 1.22.19
RUN curl -L -o yarn.tar.gz "https://yarnpkg.com/downloads/${YARN_VERSION}/yarn-v${YARN_VERSION}.tar.gz" && \
	sudo tar -xzf yarn.tar.gz -C /opt/ && \
	rm yarn.tar.gz && \
	sudo ln -s /opt/yarn-v${YARN_VERSION}/bin/yarn /usr/local/bin/yarn && \
	sudo ln -s /opt/yarn-v${YARN_VERSION}/bin/yarnpkg /usr/local/bin/yarnpkg

### 3. Thrift
# This is the 0.13.x compiler
RUN sudo apt-get install -y thrift-compiler

# unixodbc-dev is needed for pyodbc
RUN sudo apt-get update \
    && sudo apt-get install -y unixodbc-dev unixodbc tdsodbc freetds-dev freetds-bin g++
RUN echo "[FreeTDS]" | sudo tee -a /etc/odbcinst.ini
RUN echo "Description=FreeTDS Driver" | sudo tee -a /etc/odbcinst.ini
RUN echo "Driver=/usr/lib/x86_64-linux-gnu/odbc/libtdsodbc.so" | sudo tee -a /etc/odbcinst.ini
RUN echo "Setup=/usr/lib/x86_64-linux-gnu/odbc/libtdsS.so" | sudo tee -a /etc/odbcinst.ini
ENV ODBCSYSINI /etc/

# 4. Install the Azure CLI
# https://docs.microsoft.com/en-us/cli/azure/install-azure-cli-linux?pivots=apt
# https://aka.ms/InstallAzureCLIDeb redirects to this url, aka.ms has a certificate change this older version of curl doesn't like
RUN curl -sL https://azurecliprod.blob.core.windows.net/\$root/deb_install.sh | sudo bash

# 5. Install Bazel Pre-requisites
RUN sudo apt-get install --no-install-recommends -y \
  gettext-base clang

# 6. Install the Github CLI
# https://github.com/cli/cli/blob/trunk/docs/install_linux.md
RUN curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
RUN sudo chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg
RUN echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
RUN sudo apt update
RUN sudo apt install gh

# 7. Modern libmagic-dev is needed to correctly identify Word docs in Public API
ENV LIBMAGIC_VERSION 5.45
RUN curl -L -O "https://astron.com/pub/file/file-${LIBMAGIC_VERSION}.tar.gz" && \
	sudo mkdir -p /build/libmagic-dev && \
	sudo tar -xzf "file-${LIBMAGIC_VERSION}.tar.gz" -C /build/libmagic-dev && \
	rm "file-${LIBMAGIC_VERSION}.tar.gz" && \
	cd "/build/libmagic-dev/file-${LIBMAGIC_VERSION}" && \
	sudo ./configure \
		--disable-dependency-tracking \
		--prefix=/usr/local \
		--enable-fsect-man5 \
		--enable-static && \
	sudo make && \
	sudo make install
ENV LD_LIBRARY_PATH /usr/local/lib
