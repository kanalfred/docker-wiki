# Refer:
# SSL generate (non expire):
#   sudo openssl req -x509 -nodes -days -1 -newkey rsa:2048 -keyout ssl/nginx.key -out ssl/nginx.crt
# Mount config;
#   site dir:           /www/site
#   site config :       /etc/nginx/conf.d/*.conf
# Permission:
#   user:  hostadmin uid 1000
#   group: hostadmin gid 1000
# Build:
#   docker build -t kanalfred/wiki .
# Note: require to mount 2 folder 
#    LocalSettings.php  (file)
#    images             (folder)
# Run:
#    docker run --name wiki -p 8004:80 -v $PWD/LocalSettings.php:/www/site/LocalSettings.php -v $PWD/images:/var/www/html/images -d kanalfred/wiki

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
# SyntaxHighlight_GeSHi
&& curl -fSL "https://extdist.wmflabs.org/dist/extensions/SyntaxHighlight_GeSHi-REL1_29-f18e070.tar.gz" -o SyntaxHighlight_GeSHi.tar.gz \
&& tar -xzf SyntaxHighlight_GeSHi.tar.gz -C /www/site/extensions \
&& rm SyntaxHighlight_GeSHi.tar.gz

