# Install the base requirements for the app.
# This stage is to support development.
FROM openjdk:8-jdk-buster AS base
WORKDIR /root

RUN apt-get update && apt-get -y install make file && rm -rf /var/lib/apt/lists/*
ARG ANDROID_SDK_VERSION=6514223
ENV ANDROID_HOME /opt/android-sdk
RUN mkdir -p ${ANDROID_HOME}/cmdline-tools && \
    wget -q https://dl.google.com/android/repository/commandlinetools-linux-${ANDROID_SDK_VERSION}_latest.zip && \
    unzip *tools*linux*.zip -d ${ANDROID_HOME}/cmdline-tools && \
    rm *tools*linux*.zip
   
# Accept sdk licenses
ENV PATH "$PATH:${ANDROID_HOME}/cmdline-tools/tools/bin"
RUN yes | sdkmanager --licenses
RUN sdkmanager --install "emulator" "platform-tools" "tools" "ndk-bundle" 

# Specific libraries for the current build
RUN sdkmanager --install "platforms;android-28" "build-tools;28.0.3" "ndk;21.3.6528147" "ndk;19.2.5345600"
