function [ybus_array, V_vector] = ybus(lines, generation, z_load)
  
  % Cálculo de la dimensión de nuestra matriz, que será de n x n
  % donde n es el número de nodos sin contar la referencia
  dim = max(lines.Bus_j(:));
  
  % Creación de la matriz
  ybus_array = zeros(dim, dim);
  
  % Primero calculamos la impedancia equivalente en cada nodo y al invertir este resultado tendremos nuestra diagonal principal
  for k = 1:dim
    z_i = 0;
    inv_sum = 0;
    
    % Primero sumamos la impedancia de las cargas
    for l = 1:length(z_load.List_Load)
      if z_load.Bus_i(l) == k
        inv_sum += (z_load.R_load__ohms_(l)^(-1));
        if strcmp(z_load.Type(l), "IND")
          inv_sum += ((z_load.X_load__ohms_(l) * i)^(-1));
        else
          inv_sum -= ((z_load.X_load__ohms_(l) * i)^(-1));
        endif
        z_i += (inv_sum^(-1));
      endif
    endfor
    
    % Luego añadimos la impedancia de línea
    for l = 1:(length(lines.List_Line))
      if lines.Bus_i(l) == k
        if lines.Warning == 0
          if lines_l_km_(l) >= 80
            z_i += ((lines.IMPEDANCE(l))^(-1) + (lines.b_shunt__mhos_km_(l) * i)^(-1))^(-1);
          else
            z_i += lines.IMPEDANCE(l);
          endif
        endif
      endif
      
      if lines.Bus_j(l) == k
        if lines.Warning == 0
          if lines_l_km_(l) >= 80
            z_i += ((lines.IMPEDANCE(l))^(-1) + (lines.b_shunt__mhos_km_(l) * i)^(-1))^(-1);
          else
            z_i += lines.IMPEDANCE(l);
          endif
        endif
      endif
    endfor
    
    % Ahora asignamos el valor inverso de la impedancia z_i al elemento ii de nuestra matriz
    ybus_array(k, k) = (z_i^(-1));
  endfor
  
  % Luego desarrollamos los elementos fuera de la diagonal principal que representarán las impedancias de línea
  for k = 1:length(lines.List_Line)
    if lines.Warning(k) != 0
      for l = 1:dim
        ybus_array(l, lines.Bus_i(k)) = -((lines.IMPEDANCE(k))^(-1));
        ybus_array(lines.Bus_i(k), l) = -((lines.IMPEDANCE(k))^(-1));
      endfor
    endif
  endfor
  
  % Creamos el vector de las corrientes
  I_l = zeros(dim, 1);
  
  % Asignamos los valores de las corrientes en orden
  for k = 1:length(generation.List_Gen)
    I_l(generation.Bus_i(k)) = generation.I_A_(k)
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
