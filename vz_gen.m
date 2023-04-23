function generation = vz_gen(generation)
    pkg load dataframe
    for i = 1:length(generation.List_Gen) - 1
        % Comprobación de que no hay dos fuentes en paralelo
        for k = i + 1:length(generation.List_Gen)
            if generation.Bus_i(i) == generation.Bus_i(k)
                v_comp_a = complex(generation.E_ind_kV_(i) * (10^3) * cosd(generation.Angle__degrees_(i)), generation.E_ind_kV_(i) * sind(generation.Angle__degrees_(i)));
                v_comp_b = complex(generation.E_ind_kV_(k) * (10^3) * cosd(generation.Angle__degrees_(k)), generation.E_ind_kV_(k) * sind(generation.Angle__degrees_(k)));
                x_comp_a = complex(generation.R_gen__ohms_(i), generation.X_gen__ohms_(i));
                x_comp_b = complex(generation.R_gen__ohms_(k), generation.X_gen__ohms_(k));
                if v_comp_a/x_comp_a ~= v_comp_b/x_comp_b
                    printf("Hay una inconsistencia entre dos fuentes en paralelo\n");
                    generation.Warning(k) = 0;
                else
                    generation.Warning(k) = 1;
                end
            end
        end
    end

    % Cálculo de la corriente
    corrientes = zeros(length(generation.List_Gen), 1);
    angulos_cor = zeros(length(generation.List_Gen), 1);
    for i = 1:length(generation.List_Gen)
        if strcmp(generation.Warning(i), 0) ~= 1
            v_comp = complex(generation.E_ind_kV_(i) * cosd(generation.Angle__degrees_(i)), generation.E_ind_kV_(i) * sind(generation.Angle__degrees_(i)));
            x_comp = complex(generation.R_gen__ohms_(i), generation.X_gen__ohms_(i));
            corrientes(i) = sqrt(real(v_comp / x_comp)^(2) + imag(v_comp / x_comp)^(2));
            angulos_cor(i) = atan(imag(v_comp / x_comp) / real(v_comp / x_comp));
        else
            corrientes(i) = 0;
            angulos_cor(i) = 0;
        end
    end
    generation.I_A_ = corrientes;
    generation.Angulo_I = angulos_cor;
endfunction



