## Copyright (C) 2023 Lartrax
##
## This program is free software: you can redistribute it and/or modify
## it under the terms of the GNU General Public License as published by
## the Free Software Foundation, either version 3 of the License, or
## (at your option) any later version.
##
## This program is distributed in the hope that it will be useful,
## but WITHOUT ANY WARRANTY; without even the implied warranty of
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
## GNU General Public License for more details.
##
## You should have received a copy of the GNU General Public License
## along with this program.  If not, see <https://www.gnu.org/licenses/>.

## -*- texinfo -*-
## @deftypefn {} {@var{retval} =} prueba (@var{input1}, @var{input2})
##
## @seealso{}
## @end deftypefn

## Author: Lartrax <lartrax@Arx-UnixWorkspace>
## Created: 2023-03-26

pkg load io
pkg load dataframe

[v_nom, txt1] = xlsread("data_io.xlsx", 1)
[generation, txt2] = xlsread("data_io.xlsx", 2)
[z_load, txt3] = xlsread("data_io.xlsx", 3)
[lines, txt4] = xlsread("data_io.xlsx", 4)

df1 = dataframe(lines);
df1.colnames = txt4
disp(df.colnames)

%{function lines = z_line(lines)

  warn = {};
  for i = 1:(length(lines(:,1)) - 1)
    for j = (i + 1):length(lines(:, 1))
      if lines(2, i) == lines(2, j) && lines(3, i) == lines(3, j)
        printf("There is a WARNING\n");
        lines(4, j) = 0;
      endif
    endfor
  endfor

  line_impedances = [];
  for i = 1:length(lines(:,1))
    if !strcmp(lines(4, i), 0)
      
      line_impedances(i) = complex(lines(i, 5) * lines(i, 6),lines(i, 5) * lines(i, 7));
    else
      line_impedances(i) = 0;
    endif
  endfor

  lines(:, 9) = line_impedances;
  
#endfunction 

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
  
#endfunction%}
