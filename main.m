pkg load io
pkg load dataframe

[v_nom, txt1] = xlsread("caso_prueba1.xlsx", 1);
[generation, txt2] = xlsread("caso_prueba1.xlsx", 2);
[z_load, txt3] = xlsread("caso_prueba1.xlsx", 3);
[lines, txt4] = xlsread("caso_prueba1.xlsx", 4);

v_nom = dataframe(v_nom);
v_nom.colnames = txt1(1, :);
generation = dataframe(generation);
generation.colnames = txt2(1, :);
z_load = dataframe(z_load);
z_load.colnames = txt3(1, :);
lines = dataframe(lines);
lines.colnames = txt4(1, :);

generation = vz_gen(generation);
lines = z_line(lines);
[ybus_sin_comp, voltajes] = ybus(lines, generation, z_load);
disp(ybus_sin_comp);
lineflow(lines, ybus_sin_comp);
Z_comp(v_nom, ybus_sin_comp);

xlswrite("output.xlsx", generation, 2);
xlswrite("output.xlsx", z_load, 3);
xlswrite("output.xlsx", lines, 4);
#xlswrite("output.xlsx", reactive_comp, 5);
#xlswrite("output.xlsx", voltajes, 6);
%xlswrite("output.xlsx", generation, 8);
%xlswrite("output.xlsx", generation, 9);
%xlswrite("output.xlsx", generation, 10);
%xlswrite("output.xlsx", generation, 11);