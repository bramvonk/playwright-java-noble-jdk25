ARG PLAYWRIGHT_TAG="latest"

# use the existing docker image, because that comes with all the right packages already (we'll remove jdk 21 below)
FROM mcr.microsoft.com/playwright/java:${PLAYWRIGHT_TAG}

# remove jdk 21
RUN apt-get -y remove openjdk-21-jdk

# Add jdk 25 manually: playwright comes with Ubuntu 24.04 Noble which only has java 21:
# add adoptium repo
RUN apt-get update
RUN apt-get -y install -y wget apt-transport-https gpg
RUN wget -qO - https://packages.adoptium.net/artifactory/api/gpg/key/public | gpg --dearmor | tee /etc/apt/trusted.gpg.d/adoptium.gpg > /dev/null
RUN echo "deb https://packages.adoptium.net/artifactory/deb $(awk -F= '/^VERSION_CODENAME/{print$2}' /etc/os-release) main" | tee /etc/apt/sources.list.d/adoptium.list

# install jdk 25
RUN apt-get update
RUN apt-get -y install temurin-25-jdk

# select jdk 25
RUN update-java-alternatives --set temurin-25-jdk-amd64

# make image smaller:
# orphaned packages
RUN apt-get -y autoremove
# apt cache
RUN apt-get clean
