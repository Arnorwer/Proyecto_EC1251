
function [S_ij,P_ij,Q_ij, line_f] = lineflow(lines, ybus_sin_comp, voltajes, dim)
  % Calculo de flujo de potencias en las lineas

  %Inicializamos listas para guardar las potencias y determinar si se debe compensar o no
  S_ij = zeros(dim, 1);
  P_ij = zeros(dim, 1);    
  Q_ij = zeros(dim, 1);    
  line_f = {};

  for m = 1: dim - 1
    ybus_sin_comp(m, m);
    %Flujo de potencia de i -> j
    for n = m + 1: dim
      S_ij(m) = voltajes(m)^(2) * conj(lines.b_shunt__mhos_km_(m)) + voltajes(m) * ((voltajes(m) - voltajes(n)) * ybus_sin_comp(m, n));
      P_ij(m) = real(S_ij(m));
      Q_ij(m) = imag(S_ij(m));
      line_f{end + 1} = [m, n];
    endfor
  endfor
endfunction
