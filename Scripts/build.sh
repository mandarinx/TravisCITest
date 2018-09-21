#! /bin/sh

if [ -z "${CI}" ]; then
    UNITY_PATH="/Applications/Unity/Hub/Editor/2018.2.8f1/Unity.app/Contents/MacOS/Unity"
else
    UNITY_PATH="/Applications/Unity/Unity.app/Contents/MacOS/Unity"
fi
echo "[SYNG2] Unity path: ${UNITY_PATH}"

# ------------------------------------------------------------------------------
echo "[SYNG2] Activate Unity"

${UNITY_PATH} \
    -logFile "$(pwd)/unity.activation.log" \
    -batchmode \
    -serial ${UNITY_SERIAL} \
    -username ${UNITY_USER} \
    -password ${UNITY_PWD} \
    -quit
cat "$(pwd)/unity.activation.log"

# ------------------------------------------------------------------------------
echo "[SYNG2] Running editor unit tests for ${UNITY_PROJECT_NAME}"

/Applications/Unity/Unity.app/Contents/MacOS/Unity \
    -batchmode \
    -silent-crashes \
    -logFile "$(pwd)/unity.log" \
    -projectPath "$(pwd)/${UNITY_PROJECT_NAME}" \
    -runEditorTests \
    -editorTestsResultFile "$(pwd)/unity.unittests.xml" \
    -quit

rc0=$?
echo "[SYNG2] Unit test logs"
cat "$(pwd)/unity.unittests.xml"

# exit if tests failed
if [ $rc0 -ne 0 ]; then { echo "[SYNG2] Unit tests failed"; exit $rc0; } fi


# ------------------------------------------------------------------------------
echo "[SYNG2] Preparing building"

BUILD_PATH=$(pwd)/Builds
mkdir ${BUILD_PATH}
echo "[SYNG2] Created directory: ${BUILD_PATH}"

# ------------------------------------------------------------------------------
echo "[SYNG2] Building ${UNITY_PROJECT_NAME} for iOS"

# should pass ${BUILD_PATH} to build method

/Applications/Unity/Unity.app/Contents/MacOS/Unity \
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

# ------------------------------------------------------------------------------
echo "[SYNG2] Return license"

${UNITY_PATH} \
    -logFile "$(pwd)/unity.returnlicense.log" \
    -batchmode \
    -returnlicense \
    -quit
cat "$(pwd)/unity.returnlicense.log"

# ------------------------------------------------------------------------------
echo "[SYNG2] Copy fastlane setup to iOS project"
cp -R ./fastlane ${BUILD_PATH}/iOS/
cp Gemfile ${BUILD_PATH}/iOS/

# ------------------------------------------------------------------------------

# run fastlane

exit 0
