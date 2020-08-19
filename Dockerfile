# Install the base requirements for the app.
# This stage is to support development.
FROM openjdk:8-jdk-buster AS base
WORKDIR /root

RUN apt-get update && \
    apt-get -y install make file && \
    rm -rf /var/lib/apt/lists/*

ARG ANDROID_SDK_VERSION=6514223
ENV ANDROID_HOME /opt/android-sdk
RUN mkdir -p ${ANDROID_HOME}/cmdline-tools && \
    wget -q https://dl.google.com/android/repository/commandlinetools-linux-${ANDROID_SDK_VERSION}_latest.zip && \
    unzip *tools*linux*.zip -d ${ANDROID_HOME}/cmdline-tools && \
    rm *tools*linux*.zip
# Accept sdk licenses
ENV PATH "$PATH:${ANDROID_HOME}/cmdline-tools/tools/bin"
RUN yes | sdkmanager --licenses
# RUN sdkmanager --install "emulator" && rm -rf /tmp/*
RUN yes | sdkmanager --install "platform-tools"
RUN yes | sdkmanager --install "tools"
# RUN yes | sdkmanager --install "ndk-bundle"

# Specific libraries for the current build
RUN sdkmanager --install "platforms;android-28"
RUN sdkmanager --install "build-tools;29.0.2"
# This is massive (3.8G) so only install one ndk
RUN sdkmanager --install "ndk;21.0.6113669"
# Use a volume to cache the .gradle build
VOLUME ["/root/.gradle/caches"]
VOLUME ["/root/.gradle/wrapper"]
