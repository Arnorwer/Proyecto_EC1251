pkg load io

v_nom = xlsread("data_io.xlsx", 1)
generation = xlsread("data_io.xlsx", 2)
z_load = xlsread("data_io.xlsx", 3)
lines = xlsread("data_io.xlsx", 4)


vz_gen(generation)
z_line(lines)
#run z_comp.m
#run ybus.m
#run lineflow.m

