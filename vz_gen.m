function [generation] = vz_gen(generation)
  
  for i = 1:(length(generation.("List Gen")) - 1)
    % Comprobación de que no hay dos fuentes en paralelo
    for k = (i + 1):length(generation.("List Gen"))
      if generation.("Bus i")(i) == generation.("Bus i")(k)
        v_comp_a = complex((generation.("E ind(kV)")(i) * (10^3)) * cosd(generation.("Angle (degrees)")(i)) + generation.("E ind(kV)")(i) * sind(generation.("Angle (degrees)")(i)) * 1j);
        v_comp_b = complex((generation.("E ind(kV)")(k) * (10^3)) * cosd(generation.("Angle (degrees)")(k)) + generation.("E ind(kV)")(k) * sind(generation.("Angle (degrees)")(k)) * 1j);
        x_comp_a = complex(generation.("R gen (ohms)")(i) + generation.("X gen (ohms)")(i) * 1j);
        x_comp_b = complex(generation.("R gen (ohms)")(k) + generation.("X gen (ohms)")(k) * 1j);
        if v_comp_a / x_comp_a ~= v_comp_b / x_comp_b
          fprintf("Hay una inconsistencia entre dos fuentes en paralelo\n");
          generation.("Warning")(k) = "WARNING!";
        else
          generation.("Warning")(k) = "OK";
        endif
      endif
    endfor
    
    % Cálculo de la corriente
    corrientes = [];
    for i = 1:length(generation.("List Gen"))
      if strcmp(generation.("Warning"){i}, "WARNING!") ~= 1
        v_comp = complex(generation.("E ind(kV)")(i) * cosd(generation.("Angle (degrees)")(i)) + generation.("E ind(kV)")(i) * sind(generation.("Angle (degrees)")(i)) * 1j);
        x_comp = complex(generation.("R gen (ohms)")(i) + generation.("X gen (ohms)")(i) * 1j);
        corrientes(i) = v_comp / x_comp;
      else
        corrientes(i) = 0;
      endif
    endfor
    generation.("I (A)") = corrientes;
    
  endfor
  
endfunction
