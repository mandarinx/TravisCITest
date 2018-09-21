#! /bin/sh

# NOTE the command args below make the assumption that your Unity project folder is
#  a subdirectory of the repo root directory, e.g. for this repo "unity-ci-test"
#  the project folder is "UnityProject". If this is not true then adjust the
#  -projectPath argument to point to the right location.

# SRC_FOLDER="/Users/mandarin/Clients/StormFilms/Syng 2/TravisCITest" PROJECT_NAME="TravisCITest" /Applications/Unity/Hub/Editor/2018.2.8f1/Unity.app/Contents/MacOS/Unity -batchmode -nographics -silent-crashes -logFile ~/Downloads/unity.log -projectPath /Users/mandarin/Clients/StormFilms/Syng\ 2/TravisCITest/TravisUnityProject -executeMethod Syng.Builds.Build -quit
#/Applications/Unity/Hub/Editor/2018.2.8f1/Unity.app/Contents/MacOS/Unity -serial ... -batchmode -nographics -silent-crashes -logFile ../unity.log -projectPath /Users/mandarin/Clients/StormFilms/Syng\ 2/TravisCITest/TravisUnityProject -runEditorTests -editorTestsResultFile ../test.xml

if [ -z "${CI}" ]; then
    UNITY_PATH="/Applications/Unity/Hub/Editor/2018.2.8f1/Unity.app/Contents/MacOS/Unity"
else
    UNITY_PATH="/Applications/Unity/Unity.app/Contents/MacOS/Unity"
fi

echo "[SYNG2] Activate Unity"
echo ${UNITY_PATH}

${UNITY_PATH} \
    -logFile "$(pwd)/unity.activation.log" \
    -nographics \
    -batchmode \
    -serial ${UNITY_SERIAL} \
    -username ${UNITY_USER} \
    -password ${UNITY_PWD} \
    -quit
cat "$(pwd)/unity.activation.log"

echo "[SYNG2] Return license"

${UNITY_PATH} \
    -logFile "$(pwd)/unity.returnlicense.log" \
    -nographics \
    -batchmode \
    -returnlicense \
    -quit
cat "$(pwd)/unity.returnlicense.log"

exit 1

## Run the editor unit tests
echo "Running editor unit tests for ${UNITY_PROJECT_NAME}"

#cd ${UNITY_PROJECT_NAME}
#echo "Current directory: ${UNITY_PROJECT_NAME}"

mkdir $(pwd)/Builds
echo "Created directory: $(pwd)/Builds"

#/Applications/Unity/Hub/Editor/2018.2.8f1/Unity.app/Contents/MacOS/Unity \
#    -manualLicenseFile $(pwd)/Unity_v2017.x.ulf \
/Applications/Unity/Unity.app/Contents/MacOS/Unity \
    -batchmode \
    -nographics \
    -silent-crashes \
    -logFile $(pwd)/unity.log \
    -projectPath "$(pwd)/${UNITY_PROJECT_NAME}" \
    -runEditorTests \
    -editorTestsResultFile $(pwd)/log_unittests.xml \
    -quit

rc0=$?
echo "Unit test logs"
cat $(pwd)/log_unittests.xml
#echo "Unity logs"
#cat $(pwd)/unity.log

# exit if tests failed
if [ $rc0 -ne 0 ]; then { echo "Failed unit tests"; exit $rc0; } fi

exit 0

## Make the builds
#/Applications/Unity/Hub/Editor/2018.2.8f1/Unity.app/Contents/MacOS/Unity -batchmode -nographics -silent-crashes -logFile "$(pwd)/unity.log" -projectPath "$(pwd)/TravisUnityProject" -executeMethod Syng.Builds.Build -quit

echo "Attempting build of ${UNITY_PROJECT_NAME} for iOS"
#/Applications/Unity/Hub/Editor/2018.2.8f1/Unity.app/Contents/MacOS/Unity \
/Applications/Unity/Unity.app/Contents/MacOS/Unity \
    -batchmode \
    -nographics \
    -silent-crashes \
    -serial ${UNITY_SERIAL} \
    -logFile "$(pwd)/unity.log" \
    -projectPath "$(pwd)/${UNITY_PROJECT_NAME}" \
    -executeMethod Syng.Builds.Build \
    -quit

rc1=$?
echo "Build logs (iOS)"
cat "$(pwd)/unity.log"

# copy fastlane setup to unity project
cp -R ./fastlane ./Builds/iOS/
cp Gemfile ./Builds/iOS/

exit $rc1
