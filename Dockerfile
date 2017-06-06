FROM ubuntu:16.04

ADD sources.list /etc/apt/
ADD php-5.5.9.tar.gz  /usr/local/src/

RUN apt-get update \
    && apt-get -y install --no-install-recommends libxml2* libssl-dev libsslcommon2-dev libxpm-dev libtidy-dev pkg-config curl libcurl4-gnutls-dev build-essential gcc make wget \
    && rm -rf /var/lib/apt/lists/*

RUN wget -c http://download.savannah.gnu.org/releases/freetype/freetype-2.4.0.tar.gz && \
    tar xf freetype-2.4.0.tar.gz && \
    cd freetype-2.4.0 && \
    ./configure --prefix=/usr/local/freetype-2.4.0 \
    && make && make install && \
    mkdir -p /usr/local/jpeg-9a/{bin,lib,include,man/man1} && \
    cd /usr/local/src && \
    wget http://www.ijg.org/files/jpegsrc.v9a.tar.gz && \
    tar xf jpegsrc.v9a.tar.gz && \
    cd jpeg-9a && \
    ./configure --prefix=/usr/local/jpeg-9a --enable-shared --enable-static && make && make install && \
    cd /usr/local/src && wget http://ftp.gnu.org/pub/gnu/libiconv/libiconv-1.14.tar.gz && \
    tar -zxvf libiconv-1.14.tar.gz 

COPY ./stdio.in.h /usr/local/src/libiconv-1.14/srclib/   
RUN cd /usr/local/src/libiconv-1.14 && ./configure --prefix=/usr/local/libiconv-1.14 && make && make install && \ 
    cd /usr/local/src && wget -c  http://zlib.net/fossils/zlib-1.2.8.tar.gz && \    
    tar xf zlib-1.2.8.tar.gz && \
    cd zlib-1.2.8 && ./configure && make && make install && \
    chmod 644 /usr/local/include/zlib.h /usr/local/include/zconf.h && \
    cd /usr/local/src && wget -c https://sourceforge.net/projects/libpng/files/libpng16/older-releases/1.6.9/libpng-1.6.9.tar.gz --no-check-certificate && \
    tar xf libpng-1.6.9.tar.gz && \
    cd libpng-1.6.9 && ./configure --prefix=/usr/local/libpng-1.6.9 && make && make install && \
    cd /usr/local/src && wget http://sourceforge.net/projects/mcrypt/files/Libmcrypt/2.5.8/libmcrypt-2.5.8.tar.gz --no-check-certificate && \
    tar xf libmcrypt-2.5.8.tar.gz && \
    cd libmcrypt-2.5.8 && \
    ./configure --prefix=/usr/local/libmcrypt-2.5.8 && make && make install && \
    cd /usr/local/src && wget -c ftp://ftp.csx.cam.ac.uk/pub/software/programming/pcre/pcre-8.39.tar.gz  && \
    tar xf pcre-8.39.tar.gz && \
    cd pcre-8.39 && \
    ./configure --prefix=/usr/local/pcre-8.39/ && make && make install && \
    cd /usr/local/src && wget https://bitbucket.org/libgd/gd-libgd/downloads/libgd-2.1.0.tar.gz --no-check-certificate && \
    tar -zxvf libgd-2.1.0.tar.gz && \
    cd libgd-2.1.0 && \
    ./configure --prefix=/usr/local/libgd-2.1.0 --with-png=/usr/local/libpng-1.6.9  --with-jpeg=/usr/local/jpeg-9a --with-freetype=/usr/local/freetype-2.4.0  && \
    make && make install && \
    cd /usr/local/src/php-5.5.9 && \
    ./configure  --prefix=/usr/local/php/ --with-config-file-path=/usr/local/php/etc --with-mysql=mysqlnd --with-mysqli=mysqlnd --with-iconv=/usr/local/libiconv-1.14/ --with-freetype-dir=/usr/local/freetype-2.4.0/ --with-jpeg-dir=/usr/local/jpeg-9a/ --with-png-dir=/usr/local/libpng-1.6.9/ --with-zlib --enable-xml --enable-bcmath --enable-shmop --enable-sysvsem --enable-inline-optimization --with-curl --enable-mbregex --enable-fpm --enable-mbstring --with-mcrypt=/usr/local/libmcrypt-2.5.8/ --with-gd=/usr/local/libgd-2.1.0/ --enable-gd-native-ttf --with-openssl --enable-soap --enable-ftp --enable-sockets --with-pdo-mysql=mysqlnd --with-pcre-dir=/usr/local/pcre-8.39/ --with-xmlrpc --enable-zip --enable-calendar --enable-maintainer-zts --enable-wddx --enable-opcache --with-tidy --with-xpm-dir=/usr/lib/    && \
    make && make install && \
    mkdir /usr/local/php/log/ && useradd  -s /sbin/nologin www && \
    rm -rf /usr/local/src/*  && apt-get -y remove wget

ADD php-fpm.conf /usr/local/php/etc/
#ADD php-fpm.sh /usr/local/php/sbin/ 

EXPOSE 9000
#ENTRYPOINT ["/usr/local/php/sbin/php-fpm.sh","start"]
CMD "/usr/local/php/sbin/php-fpm"
