set -e

echo "start build script"

XCODE_MAJOR_VERSION=$(xcodebuild -version | grep -o 'Xcode [0-9\.]*' | cut -d ' ' -f 2 | cut -d '.' -f 1)
echo "xcode Major version is ${XCODE_MAJOR_VERSION}"

if [ $XCODE_MAJOR_VERSION -lt 14 ]; then
echo "Unsupport XCODE version. xcode=$XCODE_MAJOR_VERSION"
exit 1
fi

xcodebuild -project ./AppGuard-CLI/AppGuard-CLI.xcodeproj \
    -configuration Release clean build \
    -scheme CLI-Build

## 성공 빌드 검증
if [ ! -f "./AppGuard-CLI/executable/AppGuard_iOS_CLI" ]; then
    echo "Fail xcodebuild AppGuard_iOS_CLI"
    exit 1
else
    echo "Success xcodebuild AppGuard_iOS_CLI"
fi

APPGUARD_VERSION=""

NHNAppGuardVersion_Header="Client/AppGuard/AppGuard/Core/Diresu.h"
APPGUARD_VERSION=$(cat "${NHNAppGuardVersion_Header}" | grep -Eo '[0-9]+\.[0-9]+\.[0-9]+(\_[a-z]+)?')

echo "get Version: $APPGUARD_VERSION"

cd Client/AppGuard
xcrun agvtool new-marketing-version ${APPGUARD_VERSION}
cd -

xcodebuild -project ./Client/AppGuard/AppGuard.xcodeproj \
    -configuration Release clean build \
    -scheme Universal \
    -destination generic/platform=iOS

## 성공 빌드 검증
if [ ! -d "./Client/Framework/AppGuard.framework" ]; then
    echo "Fail xcodebuild AppGuard.framework"
    exit 1
else
    echo "Success xcodebuild  AppGuard.framework"
fi

if [ ! -d "./Client/Framework/AppGuard.xcframework" ]; then
    echo "Fail xcodebuild AppGuard.xcframework"
    exit 1
else
    echo "Success xcodebuild  AppGuard.xcframework"
fi


#Release 폴더 제거
if [ -d "./Release" ]; then
    rm -rf "./Release"
fi

mkdir -p "./Release"

#output 폴더 제거
if [ -d "./output" ]; then
    rm -rf "./output"
fi

mkdir -p "./output"

# AppGuard-iOS 생성
# AppGuard-iOS.zip

mkdir -p "./Release/AppGuard-iOS"
mkdir -p "./Release/AppGuard-iOS/Lib"
echo "AppGuard-iOS 생성"

if [ -d "./Client/Framework/AppGuard.framework" ]; then
cp -a "./Client/Framework/AppGuard.framework" "./Release/AppGuard-iOS/Lib/AppGuard.framework"
fi

if [ -d "./Client/Framework/AppGuard.xcframework" ]; then
cp -a "./Client/Framework/AppGuard.xcframework" "./Release/AppGuard-iOS/Lib/AppGuard.xcframework"
fi

if [ -d "./Client/Framework/AppGuard-Static-Unreal" ]; then
cp -a "./Client/Framework/AppGuard-Static-Unreal" "./Release/AppGuard-iOS/Lib/AppGuard-Static-Unreal"
fi

cp -a "./Doc/PDF" "./Release/AppGuard-iOS/Doc"
cp -a "./AppGuard-CLI/executable" "./Release/AppGuard-iOS/AppGuard-CLI"
cp -a "./AppGuard-CLI/OSS-Notice.txt" "./Release/AppGuard-iOS/AppGuard-CLI"
cp -a "./Client/OSS-Notice-SDK.txt" "./Release/AppGuard-iOS/Lib"
echo "copy appguard framework"



# Remove Build File
if [ -d "./Client/Framework" ]; then
    rm -rf "./Client/Framework"
fi


# Zip
cd "./Release/AppGuard-iOS"

tar -cf ../AppGuard-iOS.zip *


echo "zip framework"


cd -
if [ -d "./AppGuard-iOS" ]; then
    rm -rf "./AppGuard-iOS"
fi


cp "./Release/AppGuard-iOS.zip" "./output/AppGuard-iOS.zip"


cd Protector && zip -qr iosProtector.zip ./* && mv ./iosProtector.zip ../output/iosProtector.zip && cd -

