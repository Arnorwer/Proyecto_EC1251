function [ybus_array, V_vector] = ybus(lines, generation, z_load)
  
  % Cálculo de la dimensión de nuestra matriz, que será de n x n
  % donde n es el número de nodos sin contar la referencia
  dim = max(lines.Bus_j(:));
  
  % Creación de la matriz
  ybus_array = zeros(dim, dim);
  
  % Primero calculamos la impedancia equivalente en cada nodo y al invertir este resultado tendremos nuestra diagonal principal
  for k = 1:dim
    inv_sum = 0;
    
    % Primero sumamos la impedancia de las cargas
    for l = 1:length(z_load.List_Load)
      if z_load.Bus_i(l) == k
        if strcmp(z_load.Type(l), "IND")
          inv_sum += ((z_load.R_load__ohms_(l) + z_load.X_load__ohms_(l) * i)^(-1));
        else
          inv_sum += ((z_load.R_load__ohms_(l) - z_load.X_load__ohms_(l) * i)^(-1));
        endif
      endif
    endfor

    % Luego añadimos la impedancia de línea
    for l = 1:(length(lines.List_Line))
      if lines.Bus_i(l) == k
        if lines.Warning == 0
          if lines.l_km_(l) >= 80
            inv_sum += ((lines.impedance(l))^(-1) + (lines.b_shunt__mhos_km_(l) * i) / 2);
          else
            inv_sum += lines.impedance(l)^(-1);
          endif
        endif
      endif

      if lines.Bus_j(l) == k
        if lines.Warning(l) == 0
          if lines.l_km_(l) >= 80
            inv_sum += ((lines.impedance(l))^(-1) + (lines.b_shunt__mhos_km_(l) * i) / 2);
          else
            inv_sum += lines.impedance(l)^(-1);
          endif
        endif
      endif
    endfor

    %Por último agregamos las impedancias de generadores
    for l = 1:length(generation.List_Gen)
      if l == k
        inv_sum += (generation.R_gen__ohms_(l) + generation.X_gen__ohms_(l) * i)^(-1);
      endif
    endfor

    % Ahora asignamos inv_sum al elemento kk de nuestra matriz
    ybus_array(k, k) = inv_sum;
  endfor
  
  % Luego desarrollamos los elementos fuera de la diagonal principal que representarán las impedancias de línea
  for k = 1:length(lines.List_Line)
    if lines.Warning(k) != 1
      for l = 1:dim
        if l != lines.Bus_i(k)
          ybus_array(l, lines.Bus_i(k)) = -((lines.impedance(k))^(-1));
          ybus_array(lines.Bus_i(k), l) = -((lines.impedance(k))^(-1));
        endif
      endfor
    endif
  endfor
  
  % Creamos el vector de las corrientes
  I_l = zeros(dim, 1);
  
  % Asignamos los valores de las corrientes en orden
  for k = 1:length(generation.List_Gen)
    I_l(generation.Bus_i(k)) = generation.I_A_(k);
  endfor

  % Verificamos que todas las corrientes estén en el vector
  for k = 1:length(I_l)
    if I_l(k) == 0
      if k > 1 && k < length(I_l)
        I_l(k) = I_l(k - 1) + I_l(k + 1);
      endif
    endif
  endfor
  V_vector = inv(ybus_array) * I_l;
