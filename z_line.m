function [lines] = z_line(lines)
    %verificamos inconsistencias
    for i = 1:(length(lines.List_Line) - 1)
        for j = (i + 1):length(lines.List_Line)
            if lines.Bus_i(i) == lines.Bus_i(j) && lines.Bus_j(i) == lines.Bus_j(j)
                lines.Warning(j) = 0;
            else
                if lines.Warning(i) != 0
                    lines.Warning(i) = 1;
                end
            end
        end
    end

    %calculamos impedancias
    line_impedances = [];
    for i = 1:length(lines.List_Line)
        if lines.Warning(i) != 0
            line_impedances(i) = complex(lines.l_km_(i) * lines.r_line__ohms_km_(i), lines.l_km_(i) * lines.x_line__ohms_km_ (i));
        else
            line_impedances(i) = 0;
        end
    end

end

