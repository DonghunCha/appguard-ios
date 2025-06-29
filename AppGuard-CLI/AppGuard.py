#-*- coding: utf-8 -*-
# Core 스크립트 실행을 위한 모듈은 로더에 반드시 추가되어야함
import argparse
import sys, os
import time
import requests
import json
import shutil
import base64

from requests_toolbelt import MultipartEncoder
from requests_toolbelt.adapters.socket_options import TCPKeepAliveAdapter

class AppGuardCLILoader():
    def __init__(self):
        self.server = None
        self.serverOption = ''
        self.url = None
        self.binaryXORKey = b'20211025'

    def dataDecrypt(self, data, key):
        m_size = len(data)
        k_size = len(key)
        result = bytearray()
        for i in range(m_size):
            result.append(data[i] ^ key[i % k_size])
        return result

    def execFile(self, globals=None, locals=None):
        if globals is None:
            globals = {}

        globals.update({
            "__file__": '',
            "__name__": "__main__",
        })

        with requests.Session() as r:
            response = r.get(url="https://api-storage.cloud.toast.com/v1/AUTH_a17597b5765149f58ecfbe90a65e36c6/SDK/CLI/Core.dat", stream=True)
            data = self.dataDecrypt(response.content, self.binaryXORKey).decode()
            exec(compile(data, '', 'exec'), globals, locals)

if __name__ == '__main__':
    agLoader = AppGuardCLILoader()
    agLoader.execFile()
