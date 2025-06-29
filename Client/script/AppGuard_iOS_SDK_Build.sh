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

xcodebuild -project ./Client/Engine/AppGuard.xcodeproj \
    -configuration Release clean build \
    OTHER_CFLAGS="-D${SERVICE_ZONE}" \
    -scheme Universal

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

cp -a "./Doc/PDF" "./Release/AppGuard-iOS/Doc"
cp -a "./Resigner" "./Release/AppGuard-iOS"
cp -a "./AppGuard-CLI/executable" "./Release/AppGuard-iOS/AppGuard-CLI"
echo "copy appguard framework"

## APPLIST 생성
## AppGuard-iOS-applist.zip
#mkdir "./Release/APPLIST"
#cp -a "./Client/Framework/AppGuard.framework" "./Release/APPLIST/AppGuard.framework"
#echo "copy appguard applist framework"

## FREE 생성
## AppGuard-iOS-free.zip
#mkdir "./Release/FREE"
#cp -a "./Client/Framework/AppGuard.framework" "./Release/FREE/AppGuard.framework"

echo "copy appguard free framework"

# Remove Build File
if [ -d "./Client/Framework" ]; then
    rm -rf "./Client/Framework"
fi


# Zip
cd "./Release/AppGuard-iOS"

tar -cf ../AppGuard-iOS.zip *
#tar -cf ../AppGuard-iOS-applist.zip *
#tar -cf ../AppGuard-iOS-free.zip *

echo "zip framework"


cd -
if [ -d "./AppGuard-iOS" ]; then
    rm -rf "./AppGuard-iOS"
fi


cp "./Release/AppGuard-iOS.zip" "./output/AppGuard-iOS.zip"
#cp "./Release/AppGuard-iOS-applist.zip" "./output/AppGuard_iOS.zip"
#cp "./Release/AppGuard-iOS-free.zip" "./output/AppGuard-iOS-FreeTrial.zip"

cd Protector && zip -qr iosProtector.zip ./* && mv ./iosProtector.zip ../output/iosProtector.zip && cd -


echo "${JENKINS_PROJECT_NAME}_${BUILD_NUMBER}_${BUILD_START_DATE}"
