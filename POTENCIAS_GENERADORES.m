function[S_Gen,Pgen,Qgen]=potencia_generadores()
  %Calculo de la potencia de los deneradores.

  [GENERATION] = load_gen();
  [~,vector_de_voltajes_generadores,Z_generadores] = VZ_gen()
  [~,~,Voltajes_Nodos,~]= YBUS_completo();
  len=size(vector_de_voltajes_generadores);
  iniciales=GENERATION(1:len(1),1:2);
  NODOS_G = GENERATION(:,2);

  %Calculo de las potencias suministrada por cada generador
  for k=1:len(1)
    %Barra en la posici�n k
    Bus_i=NODOS_G(k);
    %Potencia del generador k con respecto al voltaje de la barra bus i
    S_Gen(k,1)= Voltajes_Nodos(Bus_i,1)*conj( ( vector_de_voltajes_generadores(k,1) - Voltajes_Nodos(Bus_i,1)) / Z_generadores(k,1)  );
    Pgen(k,1)=  real(S_Gen(k,1));
    Qgen(k,1)=  imag(S_Gen(k,1));
  endfor


  xlswrite('dataIo', iniciales,'POWER_GEN','A2:B30');
  xlswrite('dataIo', Pgen,'POWER_GEN','C2');
  xlswrite('dataIo', Qgen,'POWER_GEN','D2');
endfunction
