function [v_nuevo, Q_comp, x_comp, comp, type_c] = z_comp(v_nom, voltajes, zbus_sin_comp, dim)
  %EN ESTA FUNCION DETERMINAREMOS LA COMPENSACION DE LOS VOLTAJES DE NODOS
      %llamado de funciones importantes
  comp = {};
  type_c = {};
  rang_nom = [(v_nom.Vn__kV_(1) * v_nom.min_V___Vn_(1)) / 100, (v_nom.Vn__kV_(1) * v_nom.max_V___Vn_(1)) / 100];
  v_nuevo = zeros(dim, 1);
  I_nueva = zeros(dim, 1);
  Q_comp = zeros(dim, 1);

  for m = 1:dim
    if voltajes(m) < rang_nom(1)
      comp{end + 1} = "YES";
      v_nuevo(m) = (rang_nom(2) - rang_nom(1)) * rand(1) + rang_nom(1);
      I_nueva(m) = (voltajes(m) - v_nuevo(m)) / zbus_sin_comp(m, m);
      Q_comp(m) = v_nuevo(m) * I_nueva(m);
      x_comp = v_nuevo(m)^(2) / Q_comp;
      if x_comp >= i
        type_c{end + 1} = "IND";
      else
        type_c{end + 1} = "CAP";
      endif
    else
      comp{end + 1} = "NO";
      v_nuevo(m) = voltajes(m);
      I_nueva(m) = voltajes(m) / zbus_sin_comp(m, m);
      Q_comp(m) = 0;
      x_comp = 0;
      type_c{end + 1} = "NO";
    endif
  endfor
endfunction
