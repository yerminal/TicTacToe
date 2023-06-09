with open("tiles.txt", "r") as f:
    tiles = f.readlines()

tilenames = []
for tile in tiles:
    tilenames.append('"' + ''.join(c for c in tile if c not in " \t\n") + '"') 					

DATA_WIDTH=7
ADDR_WIDTH=9

tiles = [ 
    0, 0, 0, 0, 1, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 13, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 14, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 15, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0,
    0, 37, 38, 0, 16, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 41, 42, 0, 0,
    0, 39, 40, 0, 17, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 43, 44, 0, 0,
    0, 0, 0, 0, 18, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 19, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 20, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 21, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 22, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0,
    49, 50, 51, 51, 89, 89, 0, 57, 58, 89, 89, 0, 0, 61, 62, 63, 64, 65, 0, 0,
    53, 54, 55, 56, 89, 89, 0, 59, 60, 89, 89, 0, 0, 66, 67, 68, 69, 70, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
]

with open("simple_dual_port_ram_dual_clock_init.mem", "w") as f:
    for i in range(2**ADDR_WIDTH):
        if i < 300:
            f.write("// " + str(int(i/20)) + "," + str(i%20) + " - " + tilenames[tiles[i]] + "\n")
            f.write(bin(tiles[i])[2:].zfill(DATA_WIDTH) + "\n")
        else:
            f.write(bin(0)[2:].zfill(DATA_WIDTH) + "\n")
            

"""
import random
counter = 0
with open("simple_dual_port_ram_dual_clock_init.mem", "w") as f:
    for i in range(512):
        # if i % 32 == 0:
        #     f.write("// " + str(counter).zfill(4).upper() + "\n")
        #     counter = counter + 1
        if i >= 0 and i < 300:
            f.write(hex(random.randint(0, 87))[2:].zfill(7).upper() + "\n")
        else:
            if(i == 512-1):
                f.write(hex(0)[2:].zfill(7).upper())
            else:
                f.write(hex(0)[2:].zfill(7).upper() + "\n")

# for i in range(88):
#     print(hex(i)[2:].zfill(3).upper())
"""