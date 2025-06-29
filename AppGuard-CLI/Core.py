# -*- coding: utf-8 -*-
import sys, os
import time
import requests
import shutil
from AppGuardExit import exitWithCode

class Core:
    alphaUrl = "https://alpha-api-glock.cloud.toast.com/glock"
    betaUrl = "https://beta-api-glock.cloud.toast.com/glock"
    realUrl = "https://api-glock.cloud.toast.com/glock"

    @staticmethod
    def getAppGuardPath():
        return os.path.dirname(os.path.realpath(sys.argv[0]))

    @staticmethod
    def getCertificatePath():
        return os.path.join(Core.getAppGuardPath(), './certificate/cacert.pem')

    @staticmethod
    def isExistFile(fileName):
        if os.path.isfile(fileName) is True:
            return True
        else:
            return False

    @staticmethod
    def replaceBackSlashToSlash(string):
        if string.find('\\') != -1:
            return string.replace('\\', '/')
        else:
            return string

    @staticmethod
    def deleteFile(pathAndName):
        if os.path.exists(pathAndName):
            if os.path.isdir(pathAndName):
                # ignore_errors를 True로 변경(2018-11-06) : 삭제되지 않는 현상이 빈번하게 발생하여 에러 처리
                shutil.rmtree(pathAndName, ignore_errors=True)
            elif os.path.isfile(pathAndName):
                os.remove(pathAndName)
    @staticmethod
    def makeLocalToProtectionTime(timeValue):
        timeFormat = '%Y-%m-%dT%H:%M:%S'
        return time.strftime(timeFormat, timeValue)

    @staticmethod
    def printErrorMessage(message):
        sys.stderr.write('\033[91m' + message +'\033[0m'+'\n')
        exitWithCode(1)
        
    @staticmethod
    def printWarningMessage(message):
        print(f"\033[93m[!Warning!] {message}\033[0m")

    @staticmethod
    def makeProtectionUri(url, appKey):
        arg = [url, 'v2', 'protections', appKey]
        return '/'.join(arg)

    @staticmethod
    def makeCheckProtectionUri(url, appKey):
        arg = [url, 'v1', 'protections', appKey, 'seq']
        return '/'.join(arg)

    @staticmethod
    def makeAppDownloadUri(url, appKey):
        arg = [url, 'v1', 'protections', appKey, 'objects']
        return '/'.join(arg)

    @staticmethod
    def getVersion(url):
        arg = [url, 'v1', 'protections', 'versions']
        url = '/'.join(arg)
        versionDict = {}
        params = {"releaseTypeCodeList": "RB,HF"}
        latest = "0"
        cacert = Core.getCertificatePath()

        try:
            version = requests.get(url, params=params, stream=True, verify=cacert).json()

            for data in version['data']:
                versionDict[data["productVersion"]] = data["releaseDate"]
                if data["productVersion"] > latest:
                    latest = data["productVersion"]

        except Exception as e:
            return None, None

        return versionDict, latest
