#! /bin/sh

if [ -z "${CI}" ]; then
    UNITY_PATH="/Applications/Unity/Hub/Editor/2018.2.8f1/Unity.app/Contents/MacOS/Unity"
else
    UNITY_PATH="/Applications/Unity/Unity.app/Contents/MacOS/Unity"
fi
echo "[SYNG2] Unity path: ${UNITY_PATH}"

returnLicense() {
    echo "[SYNG2] Return license"

    ${UNITY_PATH} \
        -logFile "$(pwd)/unity.returnlicense.log" \
        -returnlicense \
        -quit
    cat "$(pwd)/unity.returnlicense.log"
}

activateLicense() {
    echo "[SYNG2] Activate Unity"

    ${UNITY_PATH} \
        -logFile "$(pwd)/unity.activation.log" \
        -serial ${UNITY_SERIAL} \
        -username ${UNITY_USER} \
        -password ${UNITY_PWD} \
        -noUpm \
        -quit
    echo "[SYNG2] Unity activation log"
    cat "$(pwd)/unity.activation.log"
}

unitTests() {
    echo "[SYNG2] Running editor unit tests for ${UNITY_PROJECT_NAME}"

    ${UNITY_PATH} \
        -batchmode \
        -silent-crashes \
        -serial ${UNITY_SERIAL} \
        -username ${UNITY_USER} \
        -password ${UNITY_PWD} \
        -logFile "./unity.unittests.log" \
        -projectPath "./${UNITY_PROJECT_NAME}/" \
        -runEditorTests \
        -editorTestsResultFile "../unity.unittests.xml" \
        -quit

    rc0=$?
    echo "[SYNG2] Unit test log"
    cat "$(pwd)/unity.unittests.xml"
    echo "[SYNG2] Unity unit test run log"
    cat "$(pwd)/unity.unittests.log"

    # exit if tests failed
    if [ $rc0 -ne 0 ]; then { echo "[SYNG2] Unit tests failed"; exit $rc0; } fi
}

prepareBuilds() {
    echo "[SYNG2] Preparing building"

    BUILD_PATH=$(pwd)/Builds
    mkdir ${BUILD_PATH}
    echo "[SYNG2] Created directory: ${BUILD_PATH}"
}

buildiOS() {
    echo "[SYNG2] Building ${UNITY_PROJECT_NAME} for iOS"

    # should pass ${BUILD_PATH} to build method

    ${UNITY_PATH} \
        -batchmode \
        -silent-crashes \
        -logFile "$(pwd)/unity.build.ios.log" \
        -projectPath "$(pwd)/${UNITY_PROJECT_NAME}" \
        -executeMethod Syng.Builds.Build \
        -quit

    rc1=$?
    echo "[SYNG2] Build logs (iOS)"
    cat "$(pwd)/unity.build.ios.log"

    # exit if build failed
    if [ $rc1 -ne 0 ]; then { echo "[SYNG2] Build failed"; exit $rc1; } fi
}

fastlaneRun() {
    echo "[SYNG2] Copy fastlane setup to iOS project"
    cp -R ./fastlane ${BUILD_PATH}/iOS/
    cp Gemfile ${BUILD_PATH}/iOS/
}

# ------------------------------------------------------------------------------

returnLicense
activateLicense
unitTests
prepareBuilds
buildiOS
returnLicense
fastlaneRun

exit 0
