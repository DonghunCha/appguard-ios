# appguard-cli

## Build command

```bash
xcodebuild -project ./AppGuard-CLI/AppGuard-CLI.xcodeproj -configuration Release clean build -scheme CLI-Build
```

## Build Troubleshooting
### ModuleNotFoundError: No module named 'PyInstaller'
```bash
nhn@AL01608757 AppGuard-CLI % ./pyinstaller -F IosCLI.py
Traceback (most recent call last):
  File "/Users/nhn/Documents/dev/appguard-ios/AppGuard-CLI/./pyinstaller", line 5, in <module>
    from PyInstaller.__main__ import _console_script_run
    ModuleNotFoundError: No module named 'PyInstaller'
```
* AppGuard-CLI/pyinstaller 가 바라보는 pip패키지 경로가 달라서 발생함.
* `/Applications/Xcode.app/Contents/Developer/usr/bin` 경로의 `pip3`를 이용하여 pyinstaller모듈 설치 후 빌드 재실행
    ```bash
    cd /Applications/Xcode.app/Contents/Developer/usr/bin
    ./pip3 install pyinstaller
    ```