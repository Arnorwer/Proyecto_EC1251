function[Slost,Plost,Qlost]=POTENCIAS_PERDIDAS()
  %Calculo de las potencias de las perdidas del sistema

  [S_ij,~,~,Sji,~,~]=LINEA_FLOW() ;
  LINES =LINEAS();

  len=size(LINEAS);
  iniciales=LINEAS(1:len(1),1:3);

  for m=1:len(1)
   Slost(m,1)=S_ij(m,1)+Sji(m,1);
   Plost(m,1)=real(Slost(m,1));
   Qlost(m,1)=imag(Slost(m,1));
  end

endfunction
