from Crypto.Cipher import AES
from Crypto.Util.Padding import pad


def encryptAES256EBC(buf, length, key32Bytes):
    # AES ECB 모드로 암호화
    cipher = AES.new(key32Bytes, AES.MODE_ECB)
    ecryptedBuf = cipher.encrypt(pad(buf, AES.block_size))
    return ecryptedBuf