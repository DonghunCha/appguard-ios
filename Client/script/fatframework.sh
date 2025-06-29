# 1
# Set bash script to exit immediately if any commands fail.
set -e

echo "start fatframework build script : $1"

XCODE_MAJOR_VERSION=$(xcodebuild -version | grep -o 'Xcode [0-9\.]*' | cut -d ' ' -f 2 | cut -d '.' -f 1)
echo "xcode Major version is ${XCODE_MAJOR_VERSION}"

if [ $XCODE_MAJOR_VERSION -lt 14 ]; then
echo "Unsupport XCODE version. xcode=$XCODE_MAJOR_VERSION"
exit 1
fi


if [ -z "$1" ]; then
echo "Parameter is empty. Please input scheme name."
exit 1
fi

# 2
# Setup some constants for use later on.
FRAMEWORK_NAME=$1
BUILD_PATH="${SRCROOT}/build"
RELEASE_PATH="../Framework"

IPHONEOS_ARCH="-arch arm64"
IPHONESIMULATOR_ARCH="-arch x86_64"

# 3
# If remnants from a previous build exist, delete them.
if [ -d "${BUILD_PATH}" ]; then
rm -rf "${BUILD_PATH}"
fi

# 4
# Build the static library for device and for simulator (using all needed architectures).
xcodebuild -target "${FRAMEWORK_NAME}" \
-configuration Release ${IPHONEOS_ARCH} only_active_arch=no defines_module=yes \
OTHER_CFLAGS="-Xclang -DAPPGUARD_RELEASE=1" \
-sdk "iphoneos"

## Symbol strip
xcrun strip -x -o "${BUILD_PATH}/Release-iphoneos/${FRAMEWORK_NAME}.framework/${FRAMEWORK_NAME}" "${BUILD_PATH}/Release-iphoneos/${FRAMEWORK_NAME}.framework/${FRAMEWORK_NAME}"

xcodebuild -target "${FRAMEWORK_NAME}" \
-configuration Release ${IPHONESIMULATOR_ARCH} only_active_arch=no defines_module=yes \
OTHER_CFLAGS="-Xclang -DAPPGUARD_RELEASE=1" \
-sdk "iphonesimulator"

## Symbol strip
xcrun strip -x -o "${BUILD_PATH}/Release-iphonesimulator/${FRAMEWORK_NAME}.framework/${FRAMEWORK_NAME}" "${BUILD_PATH}/Release-iphonesimulator/${FRAMEWORK_NAME}.framework/${FRAMEWORK_NAME}"

#xcrun agvtool new-marketing-version 1.0

# 5
# Craste release directory if it does not exist.
if ! [ -d "${RELEASE_PATH}" ]; then
mkdir -p "${RELEASE_PATH}"
fi

# 6
# Remove .framework file if exists on release directory from previous built.
if [ -d "${RELEASE_PATH}/${FRAMEWORK_NAME}.framework" ]; then
rm -rf "${RELEASE_PATH}/${FRAMEWORK_NAME}.framework"
fi

# 7
# Copy the device version of framework to release folder.
cp -R "${BUILD_PATH}/Release-iphoneos/${FRAMEWORK_NAME}.framework" "${RELEASE_PATH}/${FRAMEWORK_NAME}.framework"

# 8
# Join the 2 static libs into 1 and push into the .framework.
lipo -create -output "${RELEASE_PATH}/${FRAMEWORK_NAME}.framework/${FRAMEWORK_NAME}" "${BUILD_PATH}/Release-iphoneos/${FRAMEWORK_NAME}.framework/${FRAMEWORK_NAME}" "${BUILD_PATH}/Release-iphonesimulator/${FRAMEWORK_NAME}.framework/${FRAMEWORK_NAME}"

# 9
# Remove temporary directory.
rm -rf "${BUILD_PATH}"


# SymbolObfuscate.h 에 Release Flag 주석 제거
function add_release_flag {
    SymbolObfuscate_Header="${RELEASE_PATH}/${FRAMEWORK_NAME}.framework/Headers/SymbolObfuscate.h"
    tmp_path="${RELEASE_PATH}/${FRAMEWORK_NAME}.framework/Headers/tmp.txt"
    
    sed 's/\/\/#define APPGUARD_RELEASE/#define APPGUARD_RELEASE/g' "${SymbolObfuscate_Header}" > "${tmp_path}" && \
    cat "${tmp_path}" > "${SymbolObfuscate_Header}" && \
    rm -rf "${tmp_path}"
}

add_release_flag

# 10 codesign
codesign --timestamp -v --sign "Apple Distribution: NHN Cloud Corp. (6D7P2939B7)" "${RELEASE_PATH}/${FRAMEWORK_NAME}.framework"

echo "Finish Universal Fraemwork Build"
