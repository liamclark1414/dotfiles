#!/usr/bin/env python3
"""The White Tree of Gondor for fastfetch -> logo.txt
Colours (set in config.jsonc):  $1 tree   $2 crown + seven stars   $3 blossoms
Re-run after tweaking the numbers below."""
import math, os
HERE = os.path.dirname(os.path.abspath(__file__))
DW, DH = 32, 22                    # design size in characters
SCALE = 0.77                       # 0.77 x 0.77 ≈ 60% of the area
W, H = round(DW*SCALE), round(DH*SCALE)
PW, PH = DW*2, DH*4                # design space (braille dots)
OW, OH = W*2, H*4                  # output dots
BITS = [(0,0,0x01),(0,1,0x02),(0,2,0x04),(1,0,0x08),(1,1,0x10),(1,2,0x20),(0,3,0x40),(1,3,0x80)]
cx = PW/2 - 0.5
layer = [[0]*OW for _ in range(OH)]          # 0 empty, 1 tree, 2 crown, 3 blossom

def dot(x, y, v):
    xi, yi = int(round(x*SCALE)), int(round(y*SCALE))
    if 0 <= xi < OW and 0 <= yi < OH and v >= layer[yi][xi]: layer[yi][xi] = v

def capsule(x0, y0, x1, y1, r0, r1, v=1):
    n = int(max(abs(x1-x0), abs(y1-y0))*3) + 1
    for i in range(n+1):
        t = i/n; x = x0+(x1-x0)*t; y = y0+(y1-y0)*t; r = r0+(r1-r0)*t
        for yy in range(int(y-r)-1, int(y+r)+2):
            for xx in range(int(x-r)-1, int(x+r)+2):
                if (xx-x)**2 + (yy-y)**2 <= r*r + 0.15: dot(xx, yy, v)

def blossom(x, y):
    for dx, dy in ((0,0),(1,0),(-1,0),(0,1),(0,-1),(1,1),(-1,-1),(1,-1),(-1,1)):
        dot(x+dx, y+dy, 3)

def branch(x, y, ang, length, width, depth, side):
    segs = 3
    for s in range(segs):
        a = math.radians(ang * (1 - 0.2*s))           # curve upward
        nx = x + math.sin(a)*length/segs; ny = y - math.cos(a)*length/segs
        w2 = width*0.85
        capsule(x, y, nx, ny, width, w2); x, y, width = nx, ny, w2
    if depth == 1:
        blossom(x, y); return
    branch(x, y, ang + 30*side, length*0.66, width*0.8, depth-1, side)
    branch(x, y, ang - 22*side, length*0.70, width*0.8, depth-1, side)

# ─── the tree ───
base_y, fork_y = PH-4, PH*0.70
capsule(cx, base_y, cx, fork_y, 3.0, 2.3)                      # trunk
for s in (-1, 1):                                              # roots
    capsule(cx, base_y-2, cx + s*11, base_y+2, 2.0, 0.6)
    capsule(cx, base_y-4, cx + s*5,  base_y+2, 1.7, 0.7)
for s in (-1, 1):                                              # three great limbs a side
    branch(cx, fork_y,   12*s, 15, 2.2, 3, s)
    branch(cx, fork_y+3, 45*s, 14, 2.0, 3, s)
    branch(cx, fork_y+7, 78*s, 11, 1.8, 2, s)
capsule(cx, fork_y, cx, fork_y-20, 2.2, 0.9)                   # crown leader
blossom(cx, fork_y-21)

# ─── the winged crown of Gondor (gold) ───
by = 10                                                        # band position
capsule(cx-6, by, cx+6, by, 1.3, 1.3, 2)                       # band
for off, h in ((-6, 4), (-3, 6), (0, 9), (3, 6), (6, 4)):      # points
    capsule(cx+off, by, cx+off, by-h, 1.0, 0.5, 2)
for s in (-1, 1):                                              # sea-bird wings
    capsule(cx+s*7, by, cx+s*12, by-5, 1.1, 0.6, 2)
    capsule(cx+s*7, by+1, cx+s*14, by-2, 1.0, 0.5, 2)
    capsule(cx+s*7, by+2, cx+s*13, by+2, 0.9, 0.5, 2)

# perfect heraldic symmetry
for y in range(OH):
    for x in range(OW//2):
        v = max(layer[y][x], layer[y][OW-1-x]); layer[y][x] = layer[y][OW-1-x] = v

# ─── the seven stars, arched between crown and tree ───
STAR_TOP = 3
stars = {}
for i in range(7):
    t = (i-3)/3
    stars[(STAR_TOP + int(round(1.9*t*t)), int(round(W/2 - 0.5 + t*W*0.42)))] = "✦"
for (r, c) in stars:                       # keep tree/crown dots out of star cells
    for dy in range(4):
        for dx in range(2): layer[r*4+dy][c*2+dx] = 0

rows = []
for r in range(H):
    line, cur = "", None
    for c in range(W):
        if (r, c) in stars:
            if cur != "2": line += "$2"; cur = "2"
            line += "✦"; continue
        m = 0; votes = {1: 0, 2: 0, 3: 0}
        for dx, dy, bit in BITS:
            v = layer[r*4+dy][c*2+dx]
            if v: m |= bit; votes[v] += 1
        if m:
            col = str(2 if votes[2] else 3 if votes[3] >= votes[1] else 1)
            if col != cur: line += "$"+col; cur = col
            line += chr(0x2800+m)
        else:
            line += " "
    rows.append(line.rstrip())
strip = lambda l: "".join(ch for ch in l.replace("$1","").replace("$2","").replace("$3","")).strip()
while rows and not strip(rows[0]): rows.pop(0)
while rows and not strip(rows[-1]): rows.pop()
open(os.path.join(HERE, "logo.txt"), "w").write("\n".join(rows) + "\n")
print(f"{W}x{len(rows)}")
