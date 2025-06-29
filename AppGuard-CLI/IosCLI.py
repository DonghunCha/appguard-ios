# -*- coding: utf-8 -*-
import argparse
import sys, os
import time
import requests
import json
import base64
from Config import DEFAULT_STARTUP_MESSAGE_DURATION, DEFAULT_STARTUP_MESSAGE_DELAY
# sys.path.insert(0, "./iOSReSigner")
from AppGuardResigner import *

# os.path.dirname(os.path.abspath(os.path.dirname(__file__)))
sys.path.append("..")
from Core import Core

from requests_toolbelt import MultipartEncoder
from requests_toolbelt.adapters.socket_options import TCPKeepAliveAdapter
from AppGuardExit import exitWithCode

class IosCLI():
    def __init__(self):
        self.url = None
        self.parser = None
        self.locale = 'en_US'
        self.os = 'iOS'
        self.location = 'Console'
        self.uuid = 'CLI_USER'
        self.serverOption = ''
        self.obf = False
        self.protectionTime = time.localtime()
        self.level = "iOS"

    def main(self):
        print('[*] NHN AppGuard CLI')

        self.parseArguements()
        if self.parsedOptions.subCommand == 'codesign':
            self.doCodesign()
        else:
            self.doProtection()
       

    def parseArguements(self):
        self.parser = argparse.ArgumentParser()
        
        # Sub Command
        subCommandParser = self.parser.add_subparsers(required=False, dest="subCommand")
        codesignCommandParser = subCommandParser.add_parser("codesign")
        codesignCommandParser.add_argument('-i', help="IPA file to be re-signed", default="", required=True, type=str, dest="unsignedIPAFileName")
        
        # 필수 옵션
        
        self.parser.add_argument('-n', type=str, dest='unprotectedIPAFileName', default='',
                                 help='input \'unprotected iOS\' file path')
        self.parser.add_argument('-o', type=str, dest='protectedIPAFileName', default='',
                                 help='input \'protected iOS\' file path')
        self.parser.add_argument('-v', type=str, dest='appKey', default='', help='input NHN Cloud appkey')
        self.parser.add_argument('--latestVersion', action='store_true', dest="latestVersion", required=False ,default=True,
                                 help=argparse.SUPPRESS)
        self.parser.add_argument('--protectionVersion', dest="protectionVersion", type=str, default='',
                            help=argparse.SUPPRESS, required=False)

        protectLevelGroup = self.parser.add_mutually_exclusive_group(required=False)
        protectLevelGroup.add_argument('--business', action='store_true', dest="levelBusiness", default=False, help='Set Business plan')
        protectLevelGroup.add_argument('--enterprise', action='store_true', dest="levelEnterprise", default=False, help='Set Enterprise plan')
        protectLevelGroup.add_argument('--game', action='store_true', dest="levelGame", default=False, help='Set Game plan')
        protectLevelGroup.add_argument('--obsolete', action='store_true', dest="levelObsolete", default=False, help='Set previous user plan')
        # 서버 선택
        self.parser.add_argument('--alpha', action='store_true', dest='alphaApiHost', default=None,
                                 help=argparse.SUPPRESS)
        self.parser.add_argument('--beta', action='store_true', dest='betaApiHost', default=None,
                                 help=argparse.SUPPRESS)
        
        # React Native
        crossPlatformGroup = self.parser.add_mutually_exclusive_group(required=False)
        crossPlatformGroup.add_argument('--flutter', action='store_true', help="Protect your Flutter apps.", default=False, required=False, dest="isFlutter") 
        crossPlatformGroup.add_argument('--react-native', action='store_true', dest="isReactNative", default=False, help="Protect your React Native apps." )
        reactNativeArgsGroup = crossPlatformGroup.add_argument_group()
        reactNativeArgsGroup.add_argument('-jsbundle', default="", type=str, dest="RNjsbundlePath", help="You can enter the jsbundle file name to be protected.(default=main.jsbundle)")
        
        # StartUp Message
        self.parser.add_argument('--show-startup-message', action='store_true', default=False, dest="show_startup_message", help="Show the startup message.")
        self.parser.add_argument('--show-startup-message-duration', type=int, dest="startup_message_duration", help=argparse.SUPPRESS)
        self.parser.add_argument('--show-startup-message-delay', type=int, dest="startup_message_delay", help=argparse.SUPPRESS)

        # Detection Popup Mode
        self.parser.add_argument('--detection-popup-mode', default="detailed", dest="detection_popup_mode", help=argparse.SUPPRESS)

        self.parsedOptions, self.unparsedOptions = self.parser.parse_known_args()

    def doCodesign(self):
        print('[*] Code sign')
        unsignedIPAFileName = f"{self.parsedOptions.unsignedIPAFileName}"
        reSignedIpaPath = f"out/Signed-{os.path.basename(self.parsedOptions.unsignedIPAFileName)}"    
        self.doResign(unsignedIPAFileName, reSignedIpaPath, False)
        if os.path.exists(reSignedIpaPath) == False:
            print('[!] Error: code sign is failed.')
            exitWithCode(1)
        else:
            print('[*] Code sign is done.')
        return

    def doResign(self, ipaFile, outFile, isClear):
        print('[*] Resign')
        reSigner = AppGuardResigner(ipaFile, outFile)
        reSigner.doProcess()
        if isClear:
            clearIfFinish(outFile, ipaFile)

    def doProtection(self):
        self.checkOptions()
        self.setApiUrl()
        self.setProtectionLevel()
        self.checkFiles()

        print('[*] Protect Start, please wait a few minutes..')
        print('[*] Step 1/2')

        response = self.sendReqeuestToGas()
        if response is None:
            exitWithCode(1)

        print('[*] Step 2/2')
        self.downloadProtectedApp(response)

        print('[*] Protect Done')

        if self.parsedOptions.protectedIPAFileName == '':
            Core.printErrorMessage("Input IPA Name Error")
        else:
            # protectedIPAFile will be re-signed by AppGuardResigner
            protectedIpaName = f"{self.parsedOptions.protectedIPAFileName}"
            reSignedIpaPath = f"out/{self.parsedOptions.protectedIPAFileName}"    
            self.doResign(protectedIpaName, reSignedIpaPath, True)

    def checkOptions(self):
        if not self.parsedOptions.unprotectedIPAFileName:
            self.parser.print_help()
            Core.printErrorMessage('\n[!] Missing: -n [Unprotected IPA File Name]')

        if not self.parsedOptions.protectedIPAFileName:
            self.parser.print_help()
            Core.printErrorMessage('\n[!] Missing: -o [Protected IPA File Name]')

        if not self.parsedOptions.appKey:
            self.parser.print_help()
            Core.printErrorMessage('\n[!] Missing: -v [NHN AppGuard appkey]')
        
        if self.parsedOptions.protectionVersion:
            Core.printWarningMessage(f'--protectionVersion {self.parsedOptions.protectionVersion} argument  is not supported in iOS CLI. It will be ignored.')

        # React native argument check
        if len(self.parsedOptions.RNjsbundlePath) != 0 and self.parsedOptions.isReactNative == False:
            Core.printErrorMessage("There is a -jsbundle argument, but there is no --react-native argument.")

        if self.parsedOptions.isReactNative == True and len(self.parsedOptions.RNjsbundlePath) == 0 :
            Core.printWarningMessage("-jsbundle is not entered, but attempts to protect main.jsbundle by default.")
            self.parsedOptions.RNjsbundlePath = "main.jsbundle"
        
        if self.parsedOptions.isReactNative == True and self.parsedOptions.levelBusiness == True:
            Core.printErrorMessage("ReactNative app is available in Enterprise and Game plans.")

        if self.parsedOptions.isFlutter == True and self.parsedOptions.levelBusiness == True:
            Core.printErrorMessage("Flutter app is available in Enterprise and Game plans.")
            
        if self.parsedOptions.isFlutter == True and len(self.parsedOptions.RNjsbundlePath) != 0 :
            Core.printErrorMessage("Flutter app is unavailable jsbundle.")
        
        # Startup message argument check
        if self.parsedOptions.show_startup_message == False and self.parsedOptions.startup_message_duration is not None:
            Core.printErrorMessage("--show-startup-message-duration requires --show-startup-message to be set.")

        if self.parsedOptions.show_startup_message == False and self.parsedOptions.startup_message_delay is not None:
            Core.printErrorMessage("--show-startup-message-delay requires --show-startup-message to be set.")
        
        if self.parsedOptions.show_startup_message == True and self.parsedOptions.startup_message_duration is None:
            self.parsedOptions.startup_message_duration = DEFAULT_STARTUP_MESSAGE_DURATION
            #Core.printWarningMessage(f'--show-startup-message-duration is set {DEFAULT_STARTUP_MESSAGE_DURATION} by default.')

        if self.parsedOptions.show_startup_message == True and self.parsedOptions.startup_message_delay is None:
            self.parsedOptions.startup_message_delay = DEFAULT_STARTUP_MESSAGE_DELAY
            #Core.printWarningMessage(f'--show-startup-message-delay is set {DEFAULT_STARTUP_MESSAGE_DELAY} by default.')
        if self.parsedOptions.show_startup_message == True and self.parsedOptions.startup_message_duration < 1000:
            Core.printErrorMessage("Invalid value for --show-startup-message-duration: The duration must be at least 1000 milliseconds (1 second) when --show-startup-message is enabled.")
        if self.parsedOptions.show_startup_message == True and self.parsedOptions.startup_message_delay < 0:
            Core.printErrorMessage("Invalid value for --show-startup-message-delay: The delay must be at least 0 milliseconds (0 second) when --show-startup-message is enabled.")

        if self.parsedOptions.detection_popup_mode not in {"detailed", "simple"}:
            Core.printErrorMessage("Invalid value for --detection-popup-mode: The mode must be detailed or simple.")

    def setProtectionLevel(self):
        if self.parsedOptions.levelBusiness == True:
            self.level = "--business"
            for unparsedOption in self.unparsedOptions:
                if unparsedOption == '--class_obf':
                    Core.printErrorMessage('\n[!] You cannot use --class_obf at the Business plan.')
                    return
        elif self.parsedOptions.levelEnterprise == True:
            self.level = "--enterprise"
        elif self.parsedOptions.levelGame == True:
            self.level = "--game"
        elif self.parsedOptions.levelObsolete == True:
            self.level = "iOS"
        else:
            Core.printWarningMessage('\n[!] Plan is not set. try to task obsolete(0)')
            self.level = "iOS"
        return
    
    def setAppGuardFunction(self):
        if self.parsedOptions.allDecompilePrevention == True:
            self.function = '3'
        elif self.parsedOptions.dllDecompilePrevention == True:
            self.function = "2"
        else:
            self.function = "1"

    def setApiUrl(self):
        if self.parsedOptions.alphaApiHost != None:
            self.url = Core.alphaUrl
            self.serverOption = '-s alpha'
        elif self.parsedOptions.betaApiHost != None:
            self.url = Core.betaUrl
            self.serverOption = '-s beta'
        else:
            self.url = Core.realUrl

    def checkFiles(self):
        if self.parsedOptions.unprotectedIPAFileName != '':
            if Core.isExistFile(self.parsedOptions.unprotectedIPAFileName) is False:
                self.parser.print_help()
                Core.printErrorMessage('\n[!] Error: Not exist App File')

        if Core.isExistFile(Core.getCertificatePath()) is False:
            self.parser.print_help()
            Core.printErrorMessage('\n[!] Error: Not exist pem File')

    def sendReqeuestToGas(self):
        ipaFileName = Core.replaceBackSlashToSlash(self.parsedOptions.unprotectedIPAFileName)
        headers = {}
        response = None

        cacert = Core.getCertificatePath()
        formData = self.makeParameterToJson()

        
        if not os.path.exists(ipaFileName):
            Core.printErrorMessage("[!] Error: No such file or directory: %s" % ipaFileName)
            return
        ipaFile = open(ipaFileName, 'rb')

        # TODO: Change apk to ipa in server spec
        multipartFiles = {
            'apk': (
                base64.b64encode(os.path.basename(ipaFile.name).encode()).decode(), ipaFile,
                'application/octet-stream')
        }

        # merge formData and multipartFiles
        formData.update(multipartFiles)

        # MultipartEncodeing
        mpf = MultipartEncoder(fields=formData)
        headers['Content-Type'] = mpf.content_type
        session = requests.session()
        keep_alive = TCPKeepAliveAdapter(idle=120, count=20, interval=30)
        url = Core.makeProtectionUri(self.url, self.parsedOptions.appKey)
        session.mount(url, keep_alive)
        if self.obf:
            timeSec = 1200
        else:
            timeSec = None

        try:
            response = session.post(url, data=mpf, stream=True, verify=cacert, headers=headers, timeout=timeSec)
        except requests.exceptions.SSLError:
            Core.printErrorMessage("[!] Error: Wrong pem file")
        except requests.Timeout:
            timeoutMessage = '[!] Error: Timeout, Please check file status from Web Console'
            payload = {'protectionTime': Core.makeLocalToProtectionTime(self.protectionTime)}
            url = Core.makeCheckProtectionUri(self.url, self.parsedOptions.appKey)
            response = requests.get(url=url, params=payload, verify=cacert, stream=True)
            jsonData = json.loads(response.text)
            if jsonData['header']['resultMessage'] != 'SUCCESS':
                Core.printErrorMessage(timeoutMessage)
            else:
                seq = jsonData['data']['seq']
                if seq != -1:
                    url = Core.makeAppDownloadUri(self.parsedOptions.appKey)
                    payload = {'seq': seq}
                    with requests.Session() as r:
                        response = r.get(url=url, params=payload, verify=cacert, stream=True)
                else:
                    Core.printErrorMessage(timeoutMessage)

        try:
            if response.status_code != 200:
                raise Exception('Server response code is ' + str(response.status_code))
            jsonData = json.loads(response.text)

            if jsonData['header']['isSuccessful'] == False:
                raise Exception(f"{jsonData['header']['resultMessage']}({jsonData['header']['resultCode']})")

            seq = jsonData['data']['seq']
            if seq == -1:
                raise Exception('Sequential number error')
        except Exception as e:
            Core.printErrorMessage('[!] Error: ' + str(e))
            return

        url = Core.makeAppDownloadUri(self.url, self.parsedOptions.appKey)
        payload = {'seq': seq, 'uuid': self.uuid}

        with requests.Session() as r:
            response = r.get(url=url, params=payload, verify=cacert, stream=True)

        if self.checkProtectionResponse(response) == True:
            return response

    def makeParameterToJson(self):
        optionList = []
        
        ## Signer Option
        reSigner = AppGuardResigner(self.parsedOptions.unprotectedIPAFileName, self.parsedOptions.protectedIPAFileName)
        signer = reSigner.exportSinger()
        signerOption = f"--signer \"{signer}\""
        optionList.append(signerOption)

        ## React Native Option
        if self.parsedOptions.isReactNative:
            reactNativeOption = f"--react-native \"{self.parsedOptions.RNjsbundlePath}\""
            optionList.append(reactNativeOption)
        ## Flutter
        if self.parsedOptions.isFlutter:
            flutterOption = f"--flutter"
            optionList.append(flutterOption)
        
        ## Startup Message
        if self.parsedOptions.show_startup_message:
            startupMessageOption = f"--show-startup-message --show-startup-message-duration {self.parsedOptions.startup_message_duration} --show-startup-message-delay {self.parsedOptions.startup_message_delay}"
            optionList.append(startupMessageOption)
        
        ## Detection Popup Mode
        if self.parsedOptions.detection_popup_mode:
            optionList.append(f"--detection-popup-mode {self.parsedOptions.detection_popup_mode}")

        for unparsedOption in self.unparsedOptions:
            if unparsedOption == '--class_obf':
                self.obf = True
            optionList.append(unparsedOption)

        # change string for MultipartEncoding
        data = {
            'os': self.os, 
            'location': self.location, 'locale': self.locale, 'uuid': self.uuid,
            'level': self.level,
            'protectionVersion': '', 'options': self.serverOption
        }

        option_string = ''
        if optionList is not None:
            for option in optionList:
                option_string = option_string + option + ' '
            data['options'] = option_string

        return data

    def checkProtectionResponse(self, response):
        ret = False
        status = response.status_code
        if status != 200:
            print('[-] Return status : ' + str(status))
            Core.printErrorMessage("[!] Error: Protection Failed")

        signature = response.content[0:4]
        if self.isValidIPA(signature) == True:
            print('[-] Protection Success')
            ret = True
        else:
            try:
                jsonData = json.loads(response.text)
                resultMessage = jsonData['header']['resultMessage']
            except:
                Core.printErrorMessage("[!] Error: Response parsing fail")
                return ret

            if resultMessage == 'INVALID APPKEY':
                Core.printErrorMessage("[!] Error: Invalid AppKey")
            elif resultMessage == 'FILE NAME TOO LONG':
                Core.printErrorMessage("[!] Error: IPA name is too long")
            elif resultMessage == 'INVALID IPA':
                Core.printErrorMessage("[!] Error: Invalid IPA")
            elif resultMessage == 'INVALID PARAMETER':
                Core.printErrorMessage("[!] Error: Invalid Parameter. Please check and again")
            elif resultMessage == 'FAILED LOAD APP VERSION':
                Core.printErrorMessage("[!] Error: Failed getting app version. Check whether the IPA is packed")
            elif resultMessage == 'FAILED LOAD APP NAME':
                Core.printErrorMessage("[!] Error: Failed getting app name. Check whether the IPA is packed")
            elif resultMessage == 'NOT FOUND SOURCE IPA FILE':
                Core.printErrorMessage("[!] Error: Not found source IPA file")
            elif resultMessage == 'ALREADY PROTECTOR APPLIED':
                Core.printErrorMessage("[!] Error: Try protecting to already protected IPA")
            else:
                Core.printErrorMessage("[!] Error: Please contact customer service")

        return ret

    def isValidIPA(self, parameter):
        signature = b'\x50\x4B\x03\x04'
        if parameter.hex() == signature.hex():
            return True
        else:
            return False

    def downloadProtectedApp(self, response):
        distPath = ''

        if os.path.basename(self.parsedOptions.protectedIPAFileName).find(".ipa") < 0:
            distPath = os.path.abspath(self.parsedOptions.protectedIPAFileName)
            if not os.path.exists(distPath):
                os.makedirs(distPath)
            distName = os.path.basename(self.parsedOptions.unprotectedIPAFileName)
            distPath = os.path.join(distPath, distName)

        else:  # Output Path is IPA name
            distPath = os.path.abspath(self.parsedOptions.protectedIPAFileName)
            if not os.path.exists(os.path.dirname(distPath)):
                os.makedirs(os.path.dirname(distPath))

        Core.deleteFile(distPath)

        try:
            with open(distPath, 'wb') as f:
                for chunk in response.iter_content(chunk_size=1024):
                    if chunk:
                        f.write(chunk)
                        f.flush()
            print('[-] Download Scuccess')

        except IOError as e:
            if e.errno == 2:
                Core.printErrorMessage("[!] Error: Wrong Destination Directory")


def clearIfFinish(reSignedIpaPath, protectedIpaName):
    if Core.isExistFile(reSignedIpaPath):
        Core.deleteFile(protectedIpaName)
        Core.deleteFile( os.path.abspath("./iOSReSigner/workspace") )
    
    
if __name__ == '__main__':
    iosCli = IosCLI()
    iosCli.main()
