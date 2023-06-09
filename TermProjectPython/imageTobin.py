import os
import cv2 as cv

with open("tiles.txt", "r") as f:
    files = f.readlines()

filenames = []
for file in files:
    filenames.append(''.join(c for c in file if c not in " \t\n") + ".png")
with open("single_port_rom_init.mem", "w") as f:
    for file in filenames:
        x = cv.imread("pngs\\" + file)/255
        x = x.astype(int)
        f.write("// " + file[:-4] + "\n")
        for i in range(32):
            for j in range(32):
                f.write("".join(list(map(str, [x[i,j,2],x[i,j,1],x[i,j,0]])))) # RED-GREEN-BLUE
            f.write("\n")