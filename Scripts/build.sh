#! /bin/sh

# NOTE the command args below make the assumption that your Unity project folder is
#  a subdirectory of the repo root directory, e.g. for this repo "unity-ci-test"
#  the project folder is "UnityProject". If this is not true then adjust the
#  -projectPath argument to point to the right location.

# SRC_FOLDER="/Users/mandarin/Clients/StormFilms/Syng 2/TravisCITest" PROJECT_NAME="TravisCITest" /Applications/Unity/Hub/Editor/2018.2.8f1/Unity.app/Contents/MacOS/Unity -batchmode -nographics -silent-crashes -logFile ~/Downloads/unity.log -projectPath /Users/mandarin/Clients/StormFilms/Syng\ 2/TravisCITest/TravisUnityProject -executeMethod Syng.Builds.Build -quit
#/Applications/Unity/Hub/Editor/2018.2.8f1/Unity.app/Contents/MacOS/Unity -batchmode -nographics -silent-crashes -logFile ~/Downloads/unity.log -projectPath /Users/mandarin/Clients/StormFilms/Syng\ 2/TravisCITest/TravisUnityProject -runEditorTests -editorTestsResultFile ~/Downloads/test.xml

## Run the editor unit tests
echo "Running editor unit tests for ${UNITY_PROJECT_NAME}"
#/Applications/Unity/Hub/Editor/2018.2.8f1/Unity.app/Contents/MacOS/Unity \
/Applications/Unity/Unity.app/Contents/MacOS/Unity \
    -batchmode \
    -nographics \
    -silent-crashes \
    -serial ${UNITY_SERIAL} \
    -logFile "$(pwd)/unity.log" \
    -projectPath "$(pwd)/${UNITY_PROJECT_NAME}" \
    -runEditorTests \
    -editorTestsResultFile "$(pwd)/log_unittests.xml"

rc0=$?
echo "Unit test logs"
cat "$(pwd)/log_unittests.xml"
# exit if tests failed
echo "Unity logs"
cat "$(pwd)/unity.log"
if [ $rc0 -ne 0 ]; then { echo "Failed unit tests"; exit $rc0; } fi

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
