
import hashlib

def get_file_hash(file_path):
    hasher = hashlib.sha256()
    with open(file_path, 'rb') as f:
        buf = f.read(4096)
        while len(buf) > 0:
            hasher.update(buf)
            buf = f.read(4096)

    file_hash = hasher.hexdigest()
    return file_hash