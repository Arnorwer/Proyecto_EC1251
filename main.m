pkg load io
pkg load dataframe

[v_nom, txt1] = xlsread("data_io.xlsx", 1)
[generation, txt2] = xlsread("data_io.xlsx", 2)
[z_load, txt3] = xlsread("data_io.xlsx", 3)
[lines, txt4] = xlsread("data_io.xlsx", 4)

v_nom = dataframe(v_nom);
v_nom.colnames = txt1(1, :)
generation = dataframe(generation);
generation.colnames = txt2(1, :)
z_load = dataframe(z_load);
z_load.colnames = txt3(1, :)
lines = dataframe(lines);
lines.colnames = txt4(1, :)

#disp(lines.l_km_(1))
generation = vz_gen(generation)
lines = z_line(lines)
#run z_comp.m
#run ybus.m
#run lineflow.m

