#!/bin/bash

apt-get install --yes curl zip unzip libnss3

####
# Chromium Latest Binary URLs
# Courtsey : https://github.com/scheib/chromium-latest-linux/
####
LASTCHANGE_URL="https://www.googleapis.com/download/storage/v1/b/chromium-browser-snapshots/o/Linux_x64%2FLAST_CHANGE?alt=media"
REVISION=$(curl -s -S $LASTCHANGE_URL)
ZIP_URL="https://www.googleapis.com/download/storage/v1/b/chromium-browser-snapshots/o/Linux_x64%2F$REVISION%2Fchrome-linux.zip?alt=media"
ZIP_FILE="${REVISION}-chrome-linux.zip"

echo "Fetching $ZIP_URL"
curl -# $ZIP_URL > $ZIP_FILE
echo "Extracting..."
unzip $ZIP_FILE

cp chromium-browser.desktop ./chrome-linux/
patchelf --set-rpath '$ORIGIN' ./chrome-linux/libEGL.so

wget "https://github.com/azubieta/linuxdeployqt/releases/download/continuous/linuxdeployqt-continuous-x86_64.AppImage"
chmod a+x linuxdeployqt-continuous-x86_64.AppImage

LINUX_DEPLOY_QT_EXCLUDE_COPYRIGHTS=true ARCH=x86_64 appimage-wrapper linuxdeployqt-continuous-x86_64.AppImage ./chrome-linux/chromium-browser.desktop -appimage

ls

echo "################################################"
echo "Uploading to transfer.sh"

mkdir -p release
cp Chromium_Web_Browser-x86_64.AppImage release/
md5sum Chromium_Web_Browser-x86_64.AppImage > release/MD5.txt
curl --upload-file ./Chromium_Web_Browser-x86_64.AppImage https://transfer.sh/Chromium_Web_Browser-x86_64.AppImage > release/URL
