FROM mcr.microsoft.com/mssql/server:2019-CU26-ubuntu-20.04
COPY ZscalerRootCertificate.crt /usr/local/share/ca-certificates/

# Switch to root user to create the directory and set permissions
USER root
RUN mkdir -p /var/lib/apt/lists/partial && \
    chmod 755 /var/lib/apt/lists/partial

# Install curl and gnupg
RUN apt-get update && \
    apt-get install -y curl gnupg


# Update CA certificates
RUN apt-get install -y ca-certificates && \
    update-ca-certificates

# Clean up duplicate entries
RUN rm -f /etc/apt/sources.list.d/microsoft-prod.list /etc/apt/sources.list.d/mssql-release

 # Add Microsoft keys and repositories
 RUN curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add - && \
     curl https://packages.microsoft.com/config/ubuntu/20.04/prod.list -o /etc/apt/sources.list.d/microsoft-prod.list


# -y is not sufficient for upgrading SQL server
ENV ACCEPT_EULA Y


# Fix permissions for /var/lib/apt/lists
RUN chmod -R 755 /var/lib/apt/lists

RUN apt-get update -y && \
	apt-get dist-upgrade -y && \
	apt-get -y autoremove && \
	apt-get clean && \
	apt-get install -y wget && \
	apt-get install zip -y -V && \
	apt-get install build-essential -y && \
	apt-get install libssl-dev -y && \
	apt-get install libffi-dev && \
	apt-get install libbz2-dev -y && \
	apt-get install libreadline-dev -y && \
	apt-get install libsqlite3-dev -y && \
	apt-get install zlib1g-dev -y

# Install OpenSSL from source
RUN wget https://www.openssl.org/source/openssl-1.1.1k.tar.gz && \
tar -xzf openssl-1.1.1k.tar.gz && \
cd openssl-1.1.1k && \
./config --prefix=/usr/local/ssl --openssldir=/usr/local/ssl shared zlib && \
make && \
make install && \
cd .. && \
rm -rf openssl-1.1.1k.tar.gz openssl-1.1.1k

# Set environment variables for OpenSSL
ENV LD_LIBRARY_PATH /usr/local/ssl/lib
ENV CPPFLAGS -I/usr/local/ssl/include
ENV LDFLAGS -L/usr/local/ssl/lib


# Install the ODBC driver for SQL Server
RUN curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add - && \
    curl https://packages.microsoft.com/config/ubuntu/20.04/prod.list > /etc/apt/sources.list.d/mssql-release.list && \
    apt-get update && \
    ACCEPT_EULA=Y apt-get install -y msodbcsql18


### 2. Python
### The following is copied from: https://github.com/docker-library/python/blob/master/3.11/bullseye/Dockerfile

# ensure local python is preferred over distribution python
ENV PATH /usr/local/bin:$PATH

# http://bugs.python.org/issue19846
# > At the moment, setting "LANG=C" on a Linux system *fundamentally breaks Python 3*, and that's not OK.
ENV LANG C.UTF-8
ENV GPG_KEY A035C8C19219BA821ECEA86B64E628F8D684696D
ENV PYTHON_VERSION 3.11.0

# Install dependencies for Python
RUN apt-get update && \
    apt-get install -y libexpat1-dev

RUN set -ex \
	&& wget --no-check-certificate  -O python.tar.xz "https://www.python.org/ftp/python/${PYTHON_VERSION%%[a-z]*}/Python-$PYTHON_VERSION.tar.xz" \
	&& wget --no-check-certificate  -O python.tar.xz.asc "https://www.python.org/ftp/python/${PYTHON_VERSION%%[a-z]*}/Python-$PYTHON_VERSION.tar.xz.asc" \
	&& export GNUPGHOME="$(mktemp -d)" \
	&& gpg --keyserver keyserver.ubuntu.com --recv-keys "$GPG_KEY" \
	&& gpg --batch --verify python.tar.xz.asc python.tar.xz \
	&& { command -v gpgconf > /dev/null && gpgconf --kill all || :; } \
	&& rm -rf "$GNUPGHOME" python.tar.xz.asc \
	&& mkdir -p /usr/src/python \
	&& tar -xJC /usr/src/python --strip-components=1 -f python.tar.xz \
	&& rm python.tar.xz \
	\
	&& cd /usr/src/python \
	&& gnuArch="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" \
	&& ./configure \
		--build="$gnuArch" \
		--enable-loadable-sqlite-extensions \
		--enable-shared \
		--with-system-expat \
		--with-system-ffi \
		--with-openssl=/usr/local/ssl \
		--without-ensurepip; \
		nproc="$(nproc)"; \
		make -j "$nproc" && \
		make install && \
		cd / && \
		rm -rf /use/src/python && \
		find /usr/local -depth \( -type d -a \( -name test -o -name tests -o -name idle_test \) \) -exec rm -rf '{}' + && \
    	ldconfig && \
    	export PYTHONDONTWRITEBYTECODE=1 && \
    	python3 --version

# if this is called "PIP_VERSION", pip explodes with "ValueError: invalid truth value '<VERSION>'"
ENV PYTHON_PIP_VERSION 20.2.4

# Install pip
RUN wget --no-check-certificate https://bootstrap.pypa.io/get-pip.py -O get-pip.py \
&& python3 get-pip.py \
&& rm get-pip.py
RUN pip install awscli

ENV DOCKERIZE_VERSION v0.6.1

# Install Docker
RUN wget --no-check-certificate https://github.com/jwilder/dockerize/releases/download/$DOCKERIZE_VERSION/dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && tar -C /usr/local/bin -xzvf dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && rm dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz

COPY load-backup.sh /
COPY cmd.sh /

CMD [ "sh", "/cmd.sh" ]
