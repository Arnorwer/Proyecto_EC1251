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
zbus_sin_comp = inv(ybus_sin_comp);
[~, P_ij, Q_ij, line_f] = lineflow(lines, ybus_sin_comp, voltajes, dim);
[v_nuevo, Q_comp, x_comp, comp, type_c] = z_comp(v_nom, voltajes, zbus_sin_comp, dim);

%Escribimos la hoja v_nom
xlswrite("output.xlsx", {txt3{1, 1}, txt3{1, 2}, txt3{1, 3}}, "V_NOM", "A1:C1");
xlswrite("output.xlsx", v_nom.data, "V_NOM", "A2:C2");

%Escribimos los datos de la hoja generation
xlswrite("output.xlsx", {txt2{1, 1}, txt2{1, 2}, txt2{1, 3}, txt2{1, 4}, txt2{1, 5}, txt2{1, 6}, txt2{1, 7}}, "GENERATION", "A1:Z1");
xlswrite("output.xlsx", generation.data, "GENERATION", "A2:Z10");
xlswrite("output.xlsx", {"I(A)", "Angulos_I"}, "GENERATION", "H1:I1");

%Hoja load
xlswrite("output.xlsx", {txt3{1, 1}, txt3{1, 2}, txt3{1, 3}, txt3{1, 4}, txt3{1, 5}, txt3{1, 6}}, "LOAD", "A1:Z1");
xlswrite("output.xlsx",  z_load.data, "LOAD", "A2:Z10");

%hoja lines
xlswrite("output.xlsx", {txt4{1, 1}, txt4{1, 2}, txt4{1, 3}, txt4{1, 4}, txt4{1, 5}, txt4{1, 6}, txt4{1, 7}, txt4{1, 8}}, "LINES", "A1:Z1");
xlswrite("output.xlsx",  lines.data, "LINES", "A2:Z10");
xlswrite("output.xlsx",  "Impedance", "LINES", "I1");

%hoja reactive_comp
xlswrite("output.xlsx", {txt5{1, 1}, txt5{1, 2}, txt5{1, 3}, txt5{1, 4}, txt5{1, 5}, txt5{1, 6}, txt5{1, 7}}, "REACTIVE_COMP", "A1:Z1");
for k = 1:dim
    element = strcat("A", int2str(k + 1));
    xlswrite("output.xlsx",  k, "REACTIVE_COMP", element);
    element = strcat("B", int2str(k + 1));
    xlswrite("output.xlsx",  k, "REACTIVE_COMP", element);
    element = strcat("D", int2str(k + 1));
    xlswrite("output.xlsx",  type_c{k}, "REACTIVE_COMP", element);
    element = strcat("E", int2str(k + 1));
    xlswrite("output.xlsx",  v_nuevo(k), "REACTIVE_COMP", element);
    element = strcat("F", int2str(k + 1));
    xlswrite("output.xlsx",  Q_comp(k), "REACTIVE_COMP", element);
    element = strcat("G", int2str(k + 1));
    xlswrite("output.xlsx",  x_comp(k), "REACTIVE_COMP", element);
endfor

%Acá va Thevenin
xlswrite("output.xlsx", {txt6{1, 1}, txt6{1, 2}, txt6{1, 3}, txt6{1, 4}, txt6{1, 5}, txt6{1, 6}, txt6{1, 7}}, "VTH_AND_ZTH", "A1:Z1");
%Escribimos cada elemento
for k = 1:dim
    element = strcat("A", int2str(k + 1));
    xlswrite("output.xlsx",  k, "VTH_AND_ZTH", element);
    element = strcat("B", int2str(k + 1));
    xlswrite("output.xlsx",  sqrt(real(voltajes(k))^(2) + imag(voltajes(k))^(2)), "VTH_AND_ZTH", element);
    element = strcat("C", int2str(k + 1));
    xlswrite("output.xlsx",  atan(imag(voltajes(k)^(2)) / real(voltajes(k))), "VTH_AND_ZTH", element);
    element = strcat("D", int2str(k + 1));
    xlswrite("output.xlsx",  real(zbus_sin_comp(k, k)), "VTH_AND_ZTH", element);
    element = strcat("E", int2str(k + 1));
    xlswrite("output.xlsx",  imag(zbus_sin_comp(k, k)), "VTH_AND_ZTH", element);
    element = strcat("F", int2str(k + 1));
    xlswrite("output.xlsx",  comp{k}, "VTH_AND_ZTH", element);
    element = strcat("G", int2str(k + 1));
    xlswrite("output.xlsx",  type_c{k}, "VTH_AND_ZTH", element);
endfor

%Lineflow
xlswrite("output.xlsx", {txt7{1, 1}, txt7{1, 2}, txt7{1, 3}, txt7{1, 4}, txt7{1, 5}}, "LINEFLOW", "A1:Z1");
for k = 1:length(lines.List_Line)
    element = strcat("A", int2str(k + 1));
    xlswrite("output.xlsx",  k, "LINEFLOW", element);
    element = strcat("B", int2str(k + 1));
    xlswrite("output.xlsx",  line_f{k}(1), "LINEFLOW", element);
    element = strcat("C", int2str(k + 1));
    xlswrite("output.xlsx",  line_f{k}(2), "LINEFLOW", element);
    element = strcat("D", int2str(k + 1));
    xlswrite("output.xlsx",  P_ij(k), "LINEFLOW", element);
    element = strcat("E", int2str(k + 1));
    xlswrite("output.xlsx",  Q_ij(k), "LINEFLOW", element);
endfor