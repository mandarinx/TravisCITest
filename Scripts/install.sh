
#! /bin/sh

# Download Unity3D installer into the container
#  The below link will need to change depending on the version, this one is for 5.5.1
#  Refer to https://unity3d.com/get-unity/download/archive and find the link pointed to by Mac "Unity Editor"
echo 'Downloading Unity 2018.2.8f1 pkg:'
curl --retry 5 -o Unity.pkg https://netstorage.unity3d.com/unity/ae1180820377/MacEditorInstaller/Unity-2018.2.8f1.pkg
if [ $? -ne 0 ]; then { echo "Download failed"; exit $?; } fi

# Refer to http://unity.grimdork.net/ to see what form the URLs should take
# Android: http://download.unity3d.com/download_unity/ae1180820377/MacEditorTargetInstaller/UnitySetup-Android-Support-for-Editor-2018.2.8f1.pkg
echo 'Downloading Unity 2018.2.8f1 iOS module:'
curl --retry 5 -o Unity_iOS.pkg http://download.unity3d.com/download_unity/ae1180820377/MacEditorTargetInstaller/UnitySetup-iOS-Support-for-Editor-2018.2.8f1.pkg
if [ $? -ne 0 ]; then { echo "Download failed"; exit $?; } fi

# Run installer(s)
echo 'Installing Unity.pkg'
sudo installer -dumplog -package Unity.pkg -target /
echo 'Installing Unity_iOS.pkg'
sudo installer -dumplog -package Unity_iOS.pkg -target /