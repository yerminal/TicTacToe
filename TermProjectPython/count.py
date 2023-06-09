with open("count.txt", "w") as f:
    for i in range(109):
        f.write(f"addr_o <= {i}*32+v_cntr_mod32_i;"+"\n")
        
    for i in range(109):
        f.write(f"= {i},"+"\n")