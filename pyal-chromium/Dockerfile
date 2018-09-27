FROM python:3.7-alpine3.8

RUN echo "http://dl-4.alpinelinux.org/alpine/v3.7/main" >> /etc/apk/repositories && \
echo "http://dl-4.alpinelinux.org/alpine/v3.7/community" >> /etc/apk/repositories

RUN \
    # Create /app directory
    mkdir -p /app && \
    # Add base dependencies
    apk upgrade --update-cache --available && \
    apk add libc-dev=0.7.1-r0 gcc=6.4.0-r8 libxml2-dev=2.9.8-r0 libxslt-dev=1.1.32-r0 \
    xvfb=1.19.6-r2 chromium=68.0.3440.75-r0 chromium-chromedriver=68.0.3440.75-r0 \
    dbus=1.10.24-r1 ttf-dejavu=2.37-r0 && \
    # Install Gunicorn
    pip3 install --disable-pip-version-check --no-cache-dir gunicorn==19.9.0

CMD sh