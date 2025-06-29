# #NHN-AppGuard-iOS/352
# 1
# Set bash script to exit immediately if any commands fail.
set -e

echo "before set xcode version: $(xcodebuild -version)"

BUILD_XCODE_VERSION=$1

echo "BUILD_XCODE_VERSION: ${BUILD_XCODE_VERSION}"

if [[ ${BUILD_XCODE_VERSION} == 13 ]] ; then
  sudo xcode-select -s /Applications/Xcode.app/Contents/Developer
elif [[ ${BUILD_XCODE_VERSION} == 14 ]] ; then
  sudo xcode-select -s /Applications/Xcode*14*.app/Contents/Developer
elif [[ ${BUILD_XCODE_VERSION} == 15 ]] ; then
  sudo xcode-select -s /Applications/Xcode*15*.app/Contents/Developer
else
  echo "Unsupported xcode version"
fi

echo "after set xcode version: $(xcodebuild -version)"

## example
#sudo sh ./script/set_xcode_build_version.sh ${BUILD_XCODE_VERSION}
#sudo sh ./script/set_xcode_build_version.sh 13
