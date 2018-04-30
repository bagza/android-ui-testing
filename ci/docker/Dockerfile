FROM openjdk:8u121-jdk

RUN apt-get update && \
    apt-get --assume-yes install git curl sudo

ENV ANDROID_SDK_URL "https://dl.google.com/android/repository/sdk-tools-linux-4333796.zip"
ENV ANDROID_SDK_FILE_NAME "android-sdk.zip"

ENV ANDROID_HOME /opt/android-sdk
ENV PATH ${PATH}:${ANDROID_HOME}/tools:${ANDROID_HOME}/tools/bin:${ANDROID_HOME}/platform-tools

RUN \
  mkdir -p $ANDROID_HOME && \
  curl $ANDROID_SDK_URL --progress-bar --location --output $ANDROID_SDK_FILE_NAME && \
  unzip $ANDROID_SDK_FILE_NAME -d $ANDROID_HOME && \
  rm $ANDROID_SDK_FILE_NAME

RUN echo "y" | $ANDROID_HOME/tools/bin/sdkmanager "build-tools;27.0.3" \
    "platforms;android-27" \
    "emulator" \
    "system-images;android-22;google_apis;x86" > /dev/null
    # TODO CREATE ISSUE FOR --silent

RUN echo "no" | avdmanager create avd --name emulator_22 \
    --package "system-images;android-22;google_apis;x86" \
    --abi google_apis/x86

COPY hardware/config_22.ini /root/.android/avd/emulator_22.avd/config.ini

ENV COMPOSER_VERSION=0.3.3
RUN curl \
    --fail \
    --location https://jcenter.bintray.com/com/gojuno/composer/composer/${COMPOSER_VERSION}/composer-${COMPOSER_VERSION}.jar \
    --output /composer.jar

COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]