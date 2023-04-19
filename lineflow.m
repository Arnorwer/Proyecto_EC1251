function [S_ij,P_ij,Q_ij,Sji,Pji,Qji] = lineflow(Y, lines)  %,P,Q,M
  % Calculo de flujo de potencias en las lineas

  %Falta agregar la funci�n voltaje de las barras

  [~,~,Yshunt,yline] = funcion_lineas() ; #acá necesito explicación de los ~
  LINES =LINEAS(); #ok, acá defines LINES, pero luego no usas bien la variable, además, en main.m está la variable "lines", que vuelve obsoleta la función LINEAS ya que hace lo mismo y el profe había comentado que la lectura del archivo se hacía en "main.m"
  [~,~,Voltajes_Nodos,~]= YBUS_completo();

  len=size(LINEAS); #ok, esto es una lista con el número de elementos de cada dimensión de una matriz
  iniciales=LINEAS(1:len(1),1);
   % Nodos y lista

  S_ij=[0];    % Flujo de potencia en la lineas de i a j
  P_ij=[0];    % Potencia activa
  Q_ij=[0];    % Potencia reactiva
  Sji=[0];    % Flujo de potencia en la lineas de j a i
  Voltajes_Nodos;

  for m=1:len(1) 
   Bus_i=LINEAS(m,2); #me parece que la sintaxis está mal porque habías definido LINES y ahora llamas a la función LINEAS() poniéndole argumentos que no están definidos   %Barra i
   Bus_j=LINEAS(m,3);  #igual acá y para abajo hay errores parecidos, los comentamos a fondo en la reunión %Barra j
   Vi=Voltajes_Nodos(Bus_i,1);  %Voltaje en la barra i
   Vj=Voltajes_Nodos(Bus_j,1);  %Voltaje en la barra j
   yij=yline(m,1);  % Admitancia en la linea ij
   yi0=Yshunt(m,1)/2;
   %Flujo de potencia de i -> j
   S_ij(m,1)= abs(Vi)^2 * conj(yi0)+ Vi * conj((Vi-Vj)*yij);
   P_ij(m,1)= real(S_ij(m,1));
   Q_ij(m,1)= imag(S_ij(m,1));
   %Flujo de potencia de j -> 1
   Sji(m,1)=abs(Vj)^2 * conj(yi0)+ Vj * conj((Vj-Vi)*yij);
   Pji(m,1)= real(Sji(m,1));
   Qji(m,1)= imag(Sji(m,1));
  end

   %Potencias activas
   P=[P_ij;Pji];
   %Potencias reactivas
   Q=[Q_ij;Qji];
   Bus_i = LINEAS(1:len(1),2);
   Bus_j = LINEAS(1:len(1),3);
   inicialesij = [iniciales,Bus_i,Bus_j;iniciales,Bus_j,Bus_i] ;

endfunction
