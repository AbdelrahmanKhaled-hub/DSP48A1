vlib work
vlog P1.v P1_tb.v
vsim -voptargs=+acc work.Project_tb
add wave *
add wave -position insertpoint  \
sim:/Project_tb/DUT/A0_reg \
sim:/Project_tb/DUT/A1_reg \
sim:/Project_tb/DUT/B0_reg \
sim:/Project_tb/DUT/B1_reg \
sim:/Project_tb/DUT/D_reg \
sim:/Project_tb/DUT/C_reg \
sim:/Project_tb/DUT/M_reg \
sim:/Project_tb/DUT/OPMODE_reg \
sim:/Project_tb/DUT/CARRYIN_reg
run -all
#quit -sim

