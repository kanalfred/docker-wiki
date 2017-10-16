# Refer:
#   check phpmyadmin example supervisor
#   http://geekyplatypus.com/dockerise-your-php-application-with-nginx-and-php7-fpm/
#   socket fastcgi_pass config : /usr/local/etc/php-fpm.d/www.conf
#   tuning: http://www.softwareprojects.com/resources/programming/t-optimizing-nginx-and-php-fpm-for-high-traffic-sites-2081.html
# SSL generate (non expire):
#   sudo openssl req -x509 -nodes -days -1 -newkey rsa:2048 -keyout ssl/nginx.key -out ssl/nginx.crt
# Mount config;
#   site dir:           /www/site
#   site config :       /etc/nginx/conf.d/*.conf
# Permission:
#   user:  hostadmin uid 1000
#   group: hostadmin gid 1000
# Build:
#   docker build -t test/php-nginx .
# Run:
#    docker run --name web1      -p 8001:80 -p 443:443 -v $PWD/web1:/www -d kanalfred/php-nginx
#    docker run --name php-nginx -p 8080:80 -p 443:443 --tmpfs /etc/nginx/cache -v $PWD/site:/www -d kanalfred/php-nginx


FROM kanalfred/php-nginx:latest

COPY site.conf /etc/nginx/conf.d/site.conf
COPY wiki.png /www/site/images/wiki.png
# default web dir /www/site

# Version
ENV MEDIAWIKI_MAJOR_VERSION 1.29
ENV MEDIAWIKI_BRANCH REL1_29
ENV MEDIAWIKI_VERSION 1.29.1
ENV MEDIAWIKI_SHA512 c4e04c4fb665c3d8299f3e03e608904aaf0e06381240c7259813eb670c3e32cde919353dd19993250cf49be81d604ac5f6d468bc563116a4b268e5011d34119f

# MediaWiki setup
RUN curl -fSL "https://releases.wikimedia.org/mediawiki/${MEDIAWIKI_MAJOR_VERSION}/mediawiki-${MEDIAWIKI_VERSION}.tar.gz" -o mediawiki.tar.gz \
&& echo "${MEDIAWIKI_SHA512} *mediawiki.tar.gz" | sha512sum -c - \
&& tar -xz --strip-components=1 -f mediawiki.tar.gz \
&& rm mediawiki.tar.gz \
&& chown -R www-data:www-data extensions skins cache images \

# Install extensions
#SyntaxHighlight_GeSHi
&& curl -fSL "https://extdist.wmflabs.org/dist/extensions/SyntaxHighlight_GeSHi-REL1_29-f18e070.tar.gz" -o SyntaxHighlight_GeSHi.tar.gz \
&& tar -xzf SyntaxHighlight_GeSHi.tar.gz -C /www/site/extensions \
&& rm SyntaxHighlight_GeSHi.tar.gz

### Custom ###
#COPY etc /etc/
#COPY config/opcache.ini /usr/local/etc/php/conf.d/
#COPY code /www/site


## php lib & extensions
#RUN apt-get update \
# && apt-get install -y \
#        git zlib1g-dev \
#        libfreetype6-dev \
#        libjpeg62-turbo-dev \
#        libmcrypt-dev \
#        libpng12-dev \
# && docker-php-ext-install -j "$(nproc)" gd mbstring mysqli pdo pdo_mysql zip opcache
# #&& docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
#
# RUN apt-get update \
#    && apt-get install -y supervisor 

#WORKDIR /www/site
#EXPOSE 80 443 9000
#USER hostadmin

#CMD ["/usr/bin/supervisord", "-n", "-c", "/etc/supervisor/supervisord.conf"]
