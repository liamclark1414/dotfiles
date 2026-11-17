#!/usr/bin/env python3
"""Make 'Bibata-Modern-Gold' from Bibata-Modern-Amber by shifting its orange to One Ring gold.
Output: ~/.local/share/icons/Bibata-Modern-Gold   (re-run any time; tweak TARGET_*)"""
import os, shutil, struct, colorsys
SRC = "/usr/share/icons/Bibata-Modern-Amber"
DST = os.path.expanduser("~/.local/share/icons/Bibata-Modern-Gold")
TARGET_HUE = 45/360      # gold  (Amber is ~31°)
SAT_SCALE  = 0.62        # softer, less fiery
VAL_SCALE  = 0.92

def recolor_pixel(p):
    a = p >> 24; r = (p >> 16) & 255; g = (p >> 8) & 255; b = p & 255
    if a == 0: return p
    # Xcursor pixels are premultiplied: un-premultiply, shift, re-premultiply
    rf, gf, bf = (min(1, c/a) for c in (r, g, b))
    h, s, v = colorsys.rgb_to_hsv(rf, gf, bf)
    if s > 0.25 and (h < 60/360 or h > 340/360):          # the orange parts only
        h = TARGET_HUE; s *= SAT_SCALE; v = min(1, v*VAL_SCALE)
        rf, gf, bf = colorsys.hsv_to_rgb(h, s, v)
        r, g, b = (int(round(c*a)) for c in (rf, gf, bf))
    return (a << 24) | (r << 16) | (g << 8) | b

def recolor_file(path):
    data = bytearray(open(path, "rb").read())
    magic, hsize, ver, ntoc = struct.unpack_from("<4sIII", data, 0)
    assert magic == b"Xcur"
    for i in range(ntoc):
        typ, sub, pos = struct.unpack_from("<III", data, 16 + i*12)
        if typ != 0xfffd0002: continue                      # image chunk
        chsize, ctype, csub, cver, w, h, xh, yh, delay = struct.unpack_from("<IIIIIIIII", data, pos)
        off = pos + chsize
        for k in range(w*h):
            p = struct.unpack_from("<I", data, off + 4*k)[0]
            struct.pack_into("<I", data, off + 4*k, recolor_pixel(p))
    open(path, "wb").write(data)

if os.path.exists(DST): shutil.rmtree(DST)
shutil.copytree(SRC, DST, symlinks=True)
for name in os.listdir(os.path.join(DST, "cursors")):
    p = os.path.join(DST, "cursors", name)
    if os.path.isfile(p) and not os.path.islink(p): recolor_file(p)
for f in ("index.theme", "cursor.theme"):
    p = os.path.join(DST, f)
    if os.path.exists(p):
        s = open(p).read().replace("Bibata-Modern-Amber", "Bibata-Modern-Gold")
        s = s.replace("Yellowish and rounded edge Bibata cursors.", "Bibata recoloured to One Ring gold.")
        open(p, "w").write(s)
print("made", DST)
