FROM openjdk:8-jre-slim

ENV SONAR_SCANNER_VERSION 3.1.0.1141
ENV SONAR_OPTS ''

RUN apt-get update && apt-get install -y wget
RUN wget https://sonarsource.bintray.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-${SONAR_SCANNER_VERSION}-linux.zip
RUN apt-get remove -y wget && apt-get purge

RUN unzip sonar-scanner-cli-${SONAR_SCANNER_VERSION}-linux

RUN ln -s /sonar-scanner-${SONAR_SCANNER_VERSION}-linux/bin/sonar-scanner /usr/bin/sonar-scanner
RUN chmod +x /usr/bin/sonar-scanner

VOLUME /project
WORKDIR /project

ADD run-sonar-scanner.sh /usr/bin/run-sonar-scanner
CMD run-sonar-scanner

# add sudo
# https://github.com/tianon/docker-brew-ubuntu-core/issues/48
RUN apt-get update && apt-get install -y sudo && rm -rf /var/lib/apt/lists/*

# add gnupg gnupg2 gnupg1
RUN apt-get update && apt-get install -y gnupg gnupg2 gnupg1

# Install Node.js
RUN apt-get update && apt-get install --yes curl
RUN curl --silent --location https://deb.nodesource.com/setup_8.x | sudo bash -
RUN apt-get install --yes nodejs
RUN apt-get install --yes build-essential

# Install typescript (for SonarTS) -- STILL NOT WORKING
RUN npm install -g typescript

# Install Yarn
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list

RUN apt-get update && apt-get install yarn
RUN yarn --version