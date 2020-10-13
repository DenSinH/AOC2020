
try:
    with open("./header.bin",  "rb") as f:
        header = bytearray(f.read())
except FileNotFoundError:
    input("File 'header.bin' was not found in working directory")
    quit(1)

chk = 0
for i in range(0xA0, 0xBC):
    chk = chk - header[i]

chk = (chk - 0x19) & 0xff

print(hex(chk))
input()
