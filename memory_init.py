counter = 0
with open("single_port_rom_init.mem", "w") as f:
    for i in range(4096):
        if i % 32 == 0:
            f.write("// " + str(counter).zfill(4).upper() + "\n")
            counter = counter + 1
        if i >= 0 and i < 300:
            f.write("FFFF" + hex(i)[2:].zfill(20).upper() + "\n")
        else:
            if(i == 4095):
                f.write(hex(0)[2:].zfill(24).upper())
            else:
                f.write(hex(0)[2:].zfill(24).upper() + "\n")
