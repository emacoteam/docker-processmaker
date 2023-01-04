# Refrenerces
# https://github.com/ckoliber/processmaker3
# https://github.com/jaelsonrc/docker-processmaker-3.5.4

# Base image
FROM amazonlinux:2018.03

# Declare ARGS and ENV Variables
ENV VERSION 3.5.7

# Image labels
LABEL version=$VERSION
LABEL maintainer="Majid Zandi majid.zandi1@gmail.com"
LABEL description="ProcessMaker $VERSION Docker Image."

# Install dependencies
RUN yum clean all
RUN yum install -y curl nginx mysql \
    sendmail \
    php71-fpm \
    php71-opcache \
    php71-gd \
    php71-mysqlnd \
    php71-soap \
    php71-mbstring \
    php71-ldap \
    php71-mcrypt
RUN mkdir -p /run/nginx

# Install ProcessMaker
RUN #curl -L -o /tmp/processmaker.tar.gz https://artifacts.processmaker.net/official/processmaker-$VERSION-community.tar.gz
#COPY processmaker-$VERSION-community.tar.gz /tmp

RUN tar -C /srv -xzvf /tmp/processmaker-$VERSION-community.tar.gz
RUN rm /tmp/processmaker-$VERSION-community.tar.gz
WORKDIR /srv/processmaker

# Copy configurations
RUN sed -i 's/memory_limit = .*/memory_limit = 512M/' /etc/php.ini
COPY nginx.conf /etc/nginx/nginx.conf
COPY default.conf /etc/nginx/conf.d/default.conf
COPY php-fpm.conf /etc/php-fpm.conf

# Hotfix ProcessMaker InputDocuemnt upload, download bug
RUN sed -i 's/ob_end_clean();/if (ob_get_contents()) ob_end_clean();/' /srv/processmaker/workflow/engine/src/ProcessMaker/BusinessModel/Cases/InputDocument.php
RUN sed -i 's/if ($flagps == false)/if ($flagps == false \&\& $arrayApplicationData["APP_CUR_USER"] != $userUid)/' /srv/processmaker/workflow/engine/src/ProcessMaker/BusinessModel/Cases/InputDocument.php

# Nginx Ports
EXPOSE 80

# Start crond & php-fpm & nginx
CMD php-fpm -R && nginx