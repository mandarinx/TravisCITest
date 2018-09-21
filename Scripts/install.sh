#! /bin/sh

# Refer to http://unity.grimdork.net/ to see what form the URLs should take

BASE_URL=https://netstorage.unity3d.com/unity
HASH=ae1180820377
VERSION=2018.2.8f1

download() {
    file=$1
    url="$BASE_URL/$HASH/$file"

    if [ ! -e ${UNITY_DOWNLOAD_CACHE}/`basename "$file"` ] ; then
        echo "Downloading `basename "$file"` from $url: "
        curl --retry 5 -o ${UNITY_DOWNLOAD_CACHE}/`basename "$file"` "$url"
    else
        echo "$file exists in cache. Skipping download."
    fi

#    echo "Downloading $url to `basename "$file"`"
#    curl --retry 5 -o `basename "$file"` "$url"
#    if [ $? -ne 0 ]; then { echo "Download failed"; exit $?; } fi
}

install() {
    package=$1
    download "$package"

    echo "Installing ${UNITY_DOWNLOAD_CACHE}/`basename "$package"`"
    sudo installer -dumplog -package ${UNITY_DOWNLOAD_CACHE}/`basename "$package"` -target /

}

install "MacEditorInstaller/Unity-$VERSION.pkg"
#install "MacEditorTargetInstaller/UnitySetup-iOS-Support-for-Editor-$VERSION.pkg"
#install "MacEditorTargetInstaller/UnitySetup-Android-Support-for-Editor-$VERSION.pkg"
