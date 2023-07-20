transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+C:/Users/abdul/Documents/Quartus/FINAL_TERM/srcs {C:/Users/abdul/Documents/Quartus/FINAL_TERM/srcs/top.v}
vlog -vlog01compat -work work +incdir+C:/Users/abdul/Documents/Quartus/FINAL_TERM/srcs {C:/Users/abdul/Documents/Quartus/FINAL_TERM/srcs/vga_sync.v}
vlog -vlog01compat -work work +incdir+C:/Users/abdul/Documents/Quartus/FINAL_TERM/srcs {C:/Users/abdul/Documents/Quartus/FINAL_TERM/srcs/vga_rgb_mux.v}
vlog -vlog01compat -work work +incdir+C:/Users/abdul/Documents/Quartus/FINAL_TERM/srcs {C:/Users/abdul/Documents/Quartus/FINAL_TERM/srcs/tile_type_to_ROM_addr.v}
vlog -vlog01compat -work work +incdir+C:/Users/abdul/Documents/Quartus/FINAL_TERM/srcs {C:/Users/abdul/Documents/Quartus/FINAL_TERM/srcs/serial_data_converter.v}
vlog -vlog01compat -work work +incdir+C:/Users/abdul/Documents/Quartus/FINAL_TERM/srcs {C:/Users/abdul/Documents/Quartus/FINAL_TERM/srcs/pixel_drawer.v}
vlog -vlog01compat -work work +incdir+C:/Users/abdul/Documents/Quartus/FINAL_TERM/srcs {C:/Users/abdul/Documents/Quartus/FINAL_TERM/srcs/game_manager.v}
vlog -vlog01compat -work work +incdir+C:/Users/abdul/Documents/Quartus/FINAL_TERM/srcs {C:/Users/abdul/Documents/Quartus/FINAL_TERM/srcs/clock_divider_negedge.v}
vlog -vlog01compat -work work +incdir+C:/Users/abdul/Documents/Quartus/FINAL_TERM/srcs {C:/Users/abdul/Documents/Quartus/FINAL_TERM/srcs/clock_divider.v}
vlog -vlog01compat -work work +incdir+C:/Users/abdul/Documents/Quartus/FINAL_TERM/srcs {C:/Users/abdul/Documents/Quartus/FINAL_TERM/srcs/single_port_rom.v}
vlog -vlog01compat -work work +incdir+C:/Users/abdul/Documents/Quartus/FINAL_TERM/srcs {C:/Users/abdul/Documents/Quartus/FINAL_TERM/srcs/simple_dual_port_ram_dual_clock.v}

