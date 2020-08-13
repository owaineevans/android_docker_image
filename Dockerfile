# Install the base requirements for the app.
# This stage is to support development.
FROM openjdk:8-jdk-buster AS base
WORKDIR /root

RUN apt-get update && apt-get -y install make file

ARG ANDROID_SDK_VERSION=6514223
ENV ANDROID_HOME /opt/android-sdk
RUN mkdir -p ${ANDROID_HOME}/cmdline-tools && \
    wget -q https://dl.google.com/android/repository/commandlinetools-linux-${ANDROID_SDK_VERSION}_latest.zip && \
    unzip *tools*linux*.zip -d ${ANDROID_HOME}/cmdline-tools && \
    rm *tools*linux*.zip
# Accept sdk licenses
ENV PATH "$PATH:${ANDROID_HOME}/cmdline-tools/tools/bin"
RUN yes | sdkmanager --licenses
RUN sdkmanager --install "emulator"
RUN sdkmanager --install "platform-tools"
RUN sdkmanager --install "tools"
RUN sdkmanager --install "ndk-bundle"

# Specific libraries for the current build
RUN sdkmanager --install "platforms;android-28"
RUN sdkmanager --install "build-tools;28.0.3"
RUN sdkmanager --install "ndk;21.3.6528147"
RUN sdkmanager --install "ndk;19.2.5345600"
