function [longitud_linea,Impedancia_linea,Yshunt,Admitancia_linea] = funcion_lineas()
  % Funcion para calcular las longitud, Impedancias, Admitancias y Yshunt de las lineas del sistema


  [LINEAS]=LINEAS()

  len=size(LINEAS);
  longitud_linea=[0];
  Yshunt=[0];
  Impedancia_linea=[0];
  Admitancia_linea=[0];
  numero_de_impedancias_L_S = LINEAS(:,1);
  LONG_de_L = LINEAS(:,5);
  R_de_Linea= LINEAS(:,6);
  X_de_Linea= LINEAS(:,7);
  B_shunt= LINEAS(:,8);

  for i=1:len(1)
     longitud_linea(i,1)= LONG_de_L (i)
     Impedancia_linea(i,1)= complex(R_de_Linea(i),X_de_Linea(i)) * LONG_de_L (i)
     Yshunt(i,1)= complex(0,  LONG_de_L (i)*B_shunt(i) )
     Admitancia_linea(i,1)= 1/Impedancia_linea(i,1)
  endfor

endfunction
