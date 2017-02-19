FROM jenkins

MAINTAINER Diego de Sousa <diegodesousas@yahoo.com.br>

# change user
USER root

# php 7 sources
RUN echo "deb http://packages.dotdeb.org jessie all" >> /etc/apt/sources.list
RUN echo "deb-src http://packages.dotdeb.org jessie all" >> /etc/apt/sources.list
RUN wget https://www.dotdeb.org/dotdeb.gpg
RUN apt-key add dotdeb.gpg

# update apt-get
RUN apt-get update

# install php
RUN apt-get install -y php7.0 php7.0-cli php7.0-json php7.0-mbstring php7.0-mysql php7.0-xml php7.0-fpm php7.0-cgi php7.0-soap git nginx zsh zip unzip

# install composer
RUN apt-get install -y curl
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# install and configure xdebug
RUN apt-get install -y php-dev wget
RUN wget -O xdebug-2.4.0.tgz http://xdebug.org/files/xdebug-2.4.0.tgz
RUN tar -xvf xdebug-2.4.0.tgz
WORKDIR /xdebug-2.4.0
RUN phpize && ./configure && make
RUN cp modules/xdebug.so /usr/lib/php/20151012
RUN echo "zend_extension = /usr/lib/php/20151012/xdebug.so" >> /etc/php/7.0/cli/php.ini
RUN echo "zend_extension = /usr/lib/php/20151012/xdebug.so" >> /etc/php/7.0/fpm/php.ini

# install node and apidoc
RUN curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.31.6/install.sh | bash
#install node 6.3.1
RUN . ~/.nvm/nvm.sh && nvm install 6.3.1 && nvm alias default 6.3.1
#set node and npm in PATH
ENV PATH /bin/versions/node/v6.3.1/bin/:/bin/versions/node/v6.3.1/lib/node_modules/npm/bin/:${PATH}
# install apidoc
RUN npm install apidoc -g

RUN echo "PATH=\"/bin/versions/node/v6.3.1/bin/:/bin/versions/node/v6.3.1/lib/node_modules/npm/bin/:${PATH}\"" >> /root/.bashrc

# external ports
EXPOSE 8080
