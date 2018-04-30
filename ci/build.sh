#!/bin/bash
set -e

# You can run it from any directory.
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PROJECT_DIR="$DIR/.."

pushd "$PROJECT_DIR"

# Files created in mounted volume by container should have same owner as host machine user to prevent chmod problems.
USER_ID=`id -u $USER`

if [ "$USER_ID" == "0" ]; then
    echo "Warning: running as r00t."
fi

docker build -t android-ui-testing:latest ci/docker

BUILD_COMMAND="set -e && "
BUILD_COMMAND+="echo 'Java version:' && java -version && "
BUILD_COMMAND+="/opt/project/gradlew "
BUILD_COMMAND+="--no-daemon --info --stacktrace "
BUILD_COMMAND+="clean build "

if [ "$PUBLISH" == "true" ]; then
    BUILD_COMMAND+="bintrayUpload "
fi

BUILD_COMMAND+="--project-dir /opt/project; "

BUILD_COMMAND+="java -jar composer-latest-version.jar "
BUILD_COMMAND+="--apk test-app/build/outputs/apk/debug/test-app-debug.apk "
BUILD_COMMAND+="--test-apk test-app/build/outputs/apk/android-test\test-app-debug-androidTest.apk "
BUILD_COMMAND+="--test-runner com.avito.android.ui "
BUILD_COMMAND+="--output-directory artifacts/composer-output "
BUILD_COMMAND+="--verbose-output false "
BUILD_COMMAND+="--keep-output-on-exit false"

docker run \
--env LOCAL_USER_ID="$USER_ID" \
--env BINTRAY_USER="$BINTRAY_USER" \
--env BINTRAY_API_KEY="$BINTRAY_API_KEY" \
--env BINTRAY_GPG_PASSPHRASE="$BINTRAY_GPG_PASSPHRASE" \
--volume `"pwd"`:/opt/project \
--rm \
android-ui-testing:latest \
bash -c "$BUILD_COMMAND"

popd