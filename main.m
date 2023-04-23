pkg load io
pkg load dataframe

[v_nom, txt1] = xlsread("caso_prueba1.xlsx", 1);
[generation, txt2] = xlsread("caso_prueba1.xlsx", 2);
[z_load, txt3] = xlsread("caso_prueba1.xlsx", 3);
[lines, txt4] = xlsread("caso_prueba1.xlsx", 4);
[~, txt5] = xlsread("caso_prueba1.xlsx", 5);
[~, txt6] = xlsread("caso_prueba1.xlsx", 6);
[~, txt7] = xlsread("caso_prueba1.xlsx", 7);
[~, txt8] = xlsread("caso_prueba1.xlsx", 8);
[~, txt9] = xlsread("caso_prueba1.xlsx", 9);
[~, txt10] = xlsread("caso_prueba1.xlsx", 10);
[~, txt11] = xlsread("caso_prueba1.xlsx", 11);

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
[ybus_sin_comp, voltajes, dim] = ybus(lines, generation, z_load);
%disp(ybus_sin_comp);

%Escribimos los datos de la hoja generation
col_names(txt1);
xlswrite("output.xlsx", {txt2{1, 1}, txt2{1, 2}, txt2{1, 3}, txt2{1, 4}, txt2{1, 5}, txt2{1, 6}, txt2{1, 7}}, "Sheet2", "A1:Z1");
xlswrite("output.xlsx", generation.data, "Sheet2", "A2:Z10");
xlswrite("output.xlsx", {"I(A)", "Angulos_I"}, "Sheet2", "H1:I1");

%Repetimos la escritura con todas la hojas
col_names(txt3);
xlswrite("output.xlsx", {txt3{1, 1}, txt3{1, 2}, txt3{1, 3}, txt3{1, 4}, txt3{1, 5}, txt3{1, 6}}, "Sheet3", "A1:Z1");
xlswrite("output.xlsx",  z_load.data, "Sheet3", "A2:Z10");

col_names(txt4);
xlswrite("output.xlsx", {txt4{1, 1}, txt4{1, 2}, txt4{1, 3}, txt4{1, 4}, txt4{1, 5}, txt4{1, 6}, txt4{1, 7}, txt4{1, 8}}, "Sheet4", "A1:Z1");
xlswrite("output.xlsx",  lines.data, "Sheet4", "A2:Z10");
xlswrite("output.xlsx",  "Impedance", "Sheet4", "I1");

col_names(txt5);
xlswrite("output.xlsx", {txt5{1, 1}, txt5{1, 2}, txt5{1, 3}, txt5{1, 4}, txt5{1, 5}, txt5{1, 6}, txt5{1, 7}}, "Sheet5", "A1:Z1");

%Acá va Thevenin
col_names(txt6);
xlswrite("output.xlsx", {txt6{1, 1}, txt6{1, 2}, txt6{1, 3}, txt6{1, 4}, txt6{1, 5}, txt6{1, 6}, txt6{1, 7}}, "Sheet6", "A1:Z1");
%Escribimos cada Vth
for k = 1:dim
    element = strcat("A", int2str(k + 1));
    xlswrite("output.xlsx",  k, "Sheet6", element);
    element = strcat("B", int2str(k + 1));
    xlswrite("output.xlsx",  sqrt(real(voltajes(k))^(2) + imag(voltajes(k))^(2)), "Sheet6", element);
    element = strcat("C", int2str(k + 1));
    xlswrite("output.xlsx",  atan(imag(voltajes(k)^(2)) / real(voltajes(k))), "Sheet6", element);
    element = strcat("D", int2str(k + 1));
    xlswrite("output.xlsx",  real(ybus_sin_comp(k, k)), "Sheet6", element);
    element = strcat("E", int2str(k + 1));
    xlswrite("output.xlsx",  imag(ybus_sin_comp(k, k)), "Sheet6", element);
endfor
%lineflow(lines, ybus_sin_comp);
%[Bus_i,Qcomp]= Z_comp(v_nom, ybus_sin_comp, voltajes);


#xlswrite("output.xlsx", reactive_comp, 5);
#xlswrite("output.xlsx", voltajes, 6);
%xlswrite("output.xlsx", generation, 8);
%xlswrite("output.xlsx", generation, 9);
%xlswrite("output.xlsx", generation, 10);
%xlswrite("output.xlsx", generation, 11);