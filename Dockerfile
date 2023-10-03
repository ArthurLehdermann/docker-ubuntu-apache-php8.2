FROM ubuntu:22.04

ENV LC_ALL=C.UTF-8
ENV DEBIAN_FRONTEND=noninteractive
ENV ACCEPT_EULA=Y
ENV TERM=xterm

RUN apt-get update && apt-get upgrade -y

RUN apt-get install -y vim curl wget software-properties-common

RUN apt-get update && apt-get install -y curl git vim supervisor apache2 libcurl4

RUN apt-get purge -y php*

RUN add-apt-repository ppa:ondrej/php
RUN apt-get update && apt-get install -y \
        libapache2-mod-php8.2  \
        php8.2  \
        php8.2-cgi \
        php8.2-cli \
        php8.2-dev \
        php8.2-phpdbg \
        php8.2-bcmath \
        php8.2-bz2 \
        php8.2-common \
        php8.2-curl \
        php8.2-dba \
        php8.2-enchant \
        php8.2-gd \
        php8.2-gmp \
        php8.2-imap \
        php8.2-interbase \
        php8.2-intl \
        php8.2-ldap \
        php8.2-mbstring \
        php8.2-mcrypt \
        php8.2-mysql \
        php8.2-odbc \
        php8.2-pgsql \
        php8.2-pspell \
        php8.2-readline \
        php8.2-soap \
        php8.2-sqlite3 \
        php8.2-sybase \
        php8.2-tidy \
        php8.2-xml \
        php8.2-xmlrpc \
        php8.2-zip \
        php8.2-opcache \
        php-json \
        php-apcu \
        php-imagick \
        php-memcached \
        php-pear \
        php-redis \
        php-token-stream \
        phpunit \
        sendmail \
    && apt-get clean \
    && rm -fr /var/lib/apt/lists/*

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

RUN apt-get update && apt-get install -y npm nodejs

RUN curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add -
RUN curl https://packages.microsoft.com/config/ubuntu/22.04/prod.list > /etc/apt/sources.list.d/mssql-release.list
RUN apt-get update && apt-get install -y \
    unixodbc \
    unixodbc-dev \
    libreadline-dev

#RUN apt-get update && apt-get install -y \
#    mssql-tools \
#    msodbcsql

#RUN pecl install sqlsrv
#RUN echo "extension=sqlsrv.so" >> /etc/php/8.2/apache2/php.ini
#RUN pecl install pdo_sqlsrv
#RUN echo "extension=pdo_sqlsrv.so" >> /etc/php/8.2/apache2/php.ini
#RUN echo "extension=/usr/lib/php/20220829/sqlsrv.so" >> /etc/php/8.2/apache2/php.ini
#RUN echo "extension=/usr/lib/php/20220829/sqlsrv.so" >> /etc/php/8.2/cli/php.ini
#RUN echo "extension=/usr/lib/php/20220829/pdo_sqlsrv.so" >> /etc/php/8.2/apache2/php.ini
#RUN echo "extension=/usr/lib/php/20220829/pdo_sqlsrv.so" >> /etc/php/8.2/cli/php.ini
#RUN apt-get install -y msodbcsql
#RUN echo 'export PATH="$PATH:/opt/mssql-tools/bin"' >> ~/.bash_profile
#RUN echo 'export PATH="$PATH:/opt/mssql-tools/bin"' >> ~/.bashrc

RUN apt-get install -y locales && echo "en_US.UTF-8 UTF-8" > /etc/locale.gen && locale-gen

RUN apt-get clean && rm -rf /var/lib/apt/lists/*

RUN a2enmod rewrite

COPY conf/apache/000-default.conf /etc/apache2/sites-available/000-default.conf

COPY conf/apache/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

COPY conf/run.sh /run.sh

RUN chmod 755 /run.sh

COPY conf/config /config

WORKDIR /var/www/html

EXPOSE 80 80

CMD ["/run.sh"]
