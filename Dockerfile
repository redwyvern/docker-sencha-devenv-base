FROM docker.artifactory.weedon.org.au/redwyvern/ubuntu-base:xenial
MAINTAINER Nick Weedon <nick@weedon.org.au>

# Install Oracle Java 8
RUN \
    echo "deb http://ppa.launchpad.net/webupd8team/java/ubuntu xenial main" | tee /etc/apt/sources.list.d/webupd8team-java.list && \
    echo "deb-src http://ppa.launchpad.net/webupd8team/java/ubuntu xenial main" | tee -a /etc/apt/sources.list.d/webupd8team-java.list && \
    apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys EEA14886 && \
    echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | debconf-set-selections && \
    apt-get update && \
    apt-get install -y oracle-java8-installer --no-install-recommends && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /var/cache/oracle-jdk8-installer

# Define commonly used JAVA_HOME variable
ENV JAVA_HOME /usr/lib/jvm/java-8-oracle

RUN apt-get clean && apt-get update && apt-get install -y --no-install-recommends \
    bzip2 \
    nodejs \
    nodejs-legacy \
    npm \
    maven \
    git \
    ruby \
    libfontconfig1 \
    libfontconfig1-dev \
    libfreetype6 \
    libfreetype6-dev \
    unzip \
    xml2 && \
    apt-get -q autoremove && \
    apt-get -q clean -y && rm -rf /var/lib/apt/lists/* && rm -f /var/cache/apt/*.bin

RUN npm install -g \
    bower \
    grunt \
    less

COPY sencha/install-5.1.3.61.sh /tmp

########################## Install Sencha CMD #####################################
ENV PATH="${PATH}:/opt/Sencha/Cmd/5.1.3.61"

# Install Sencha CMD and also pull down ext then delete it, forcing it to be cached
# This means that the ext framework will still be available to us on an old image even when it 
# no longer exists on the internet.
RUN cd /tmp && \
    ./install-5.1.3.61.sh && \
    sencha package repo init -name "Nick Weedon" -email "nick@weedon.org.au" && \
    sencha package extract -todir=. ext@5.0.1.1255 && \
    chmod -R o+rw /opt/Sencha/Cmd/repo && \
    rm -r ext


