function [S_ij,P_ij,Q_ij,Sji,Pji,Qji] = lineflow(lines, ybus_sin_comp)
  % Calculo de flujo de potencias en las lineas

  LINES = lines;

  len=size(lines);
  iniciales= lines(1:len(1),1);
   % Nodos y lista

  S_ij=[0];    % Flujo de potencia en la lineas de i a j
  P_ij=[0];    % Potencia activa
  Q_ij=[0];    % Potencia reactiva
  Sji=[0];    % Flujo de potencia en la lineas de j a i


  for m=1:len(1)
   Bus_i= lines(m,2); %Barra i
   Bus_j= lines(m,3);  %Barra j
   Vi= ybus_array(Bus_i,1);  %Voltaje en la barra i
   Vj= ybus_array(Bus_j,1);  %Voltaje en la barra j
   yij= lines(m,6);  % Admitancia en la linea ij
   yi0= lines(m,8)/2; %Admitancia capacitiva de la línea
   %Flujo de potencia de i -> j
   S_ij(m,1)= abs(Vi)^2 * conj(yi0)+ Vi * conj((Vi-Vj)*yij);
   P_ij(m,1)= real(S_ij(m,1));
   Q_ij(m,1)= imag(S_ij(m,1));
   %Flujo de potencia de j -> 1
   Sji(m,1)=abs(Vj)^2 * conj(yi0)+ Vj * conj((Vj-Vi)*yij);
   Pji(m,1)= real(Sji(m,1));
   Qji(m,1)= imag(Sji(m,1));
  endfor

   %Potencias activas
   P=[P_ij;Pji];
   %Potencias reactivas
   Q=[Q_ij;Qji];
   Bus_i = lines(1:len(1),2);
   Bus_j = lines(1:len(1),3);
   inicialesij = [iniciales,Bus_i,Bus_j;iniciales,Bus_j,Bus_i] ;

endfunction


function [Slost,Plost,Qlost]=POTENCIAS_PERDIDAS()
    %Se calculan las potencias pérdidas en las líneas

  [S_ij,~,~,Sji,~,~] = lineflow(Y, lines, ybus) ;
  LINES = lines;

  len=size(lines);
  iniciales= lines(1:len(1),1:3);

  for m=1:len(1)
   Slost(m,1)=S_ij(m,1)+Sji(m,1);
   Plost(m,1)=real(Slost(m,1));
   Qlost(m,1)=imag(Slost(m,1));
  end

endfunction

