function [generation] = vz_gen(generation)
  
  for i = 1:(length(generation(:, 1)) - 1)
    % Comprobación de que no hay dos fuentes en paralelo
    for k = (i + 1):length(generation(:, 1))
      if generation(2, i) == generation(2, k)
        v_comp_a = complex((generation(i, 4) * (10^3)) * cosd(generation(i, 5)), generation(i, 4) * sind(generation(i, 5)));
        v_comp_b = complex((generation(4, k) * (10^3)) * cosd(generation(5, k)), generation(4, k) * sind(generation(5, k)));
        x_comp_a = complex(generation(i, 6) + generation(i, 7));
        x_comp_b = complex(generation(6, k) + generation(7,k));
        if v_comp_a / x_comp_a ~= v_comp_b / x_comp_b
          fprintf("Hay una inconsistencia entre dos fuentes en paralelo\n");
          generation(k, 3) = 0;
        else
          generation(k, 3) = 1;
        endif
      endif
    endfor
    
    % Cálculo de la corriente
    corrientes = [];
    for i = 1:length(generation(:, 1))
      if strcmp(generation(k, 3), 0) ~= 1
      #disp(complex(generation(i, 4) * cosd(generation(i, 5)), generation(i, 4) * sind(generation(i, 5))))
        v_comp = complex(generation(i, 4) * cosd(generation(i, 5)), generation(i, 4) * sind(generation(i, 5)));
        x_comp = complex(generation(i, 6), generation(i, 7));
        corrientes(i) = v_comp / x_comp;
      else
        corrientes(i) = 0;
      endif
    endfor
    generation(:, 8) = corrientes;
    
  endfor
  
endfunction
