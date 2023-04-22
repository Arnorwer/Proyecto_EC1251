function [Bus_i,Qcomp]= Z_comp(v_nom, ybus_sin_comp, voltajes)
  %EN ESTA FUNCION DETERMINAREMOS LA COMPENSACION DE LOS VOLTAJES DE NODOS
      %llamado de funciones importantes

  Z_bus= voltaje;
  Rango_Nominal= v_nom;
  Vn= ybus_sin_comp;
  Voltajes_nominal= Rango_Nominal(:,1);
  Voltaje_nominal_por_arriba= Voltajes_nominal*(Rango_Nominal(:,3)/100);
  Voltaje_nominal_por_abajo= Voltajes_nominal*(Rango_Nominal(:,2)/100);


  %Recorremos todos los voltajes comprobando que est� en rango
  V_malos= find(Vn>Voltaje_nominal_por_arriba | Vn<Voltaje_nominal_por_abajo);
  V_malo_arriba = find(Vn>Voltaje_nominal_por_arriba);
  V_malo_abajo = find(Vn<Voltaje_nominal_por_abajo);
  %ajustamos las peores condiciones, Es mucho peor que el voltaje este alto
  %que el voltaje este bajo.

  if size(V_malos)==[0 0]
    disp('no hay valores a compensar')
  else

    n=0;%contador
    for k=1:length(Vn)              %variables de compensaci�n
      Ith= Z_bus(k,k);
      Rth= real(Ith);
      Xth= imag(Ith);
      [Qcomp1,Qcomp2]= formula_Comp(Voltajes_nominal,Vn(k),Xth,Rth);
      Qc= [abs(Qcomp1);abs(Qcomp2)]; %vector de potencia reactiva de compensaci�n

      %CONDICIONES PARA COMPENSAR
      if (imag(Qcomp1)~=0) || (V_malo_arriba==k && V_malo_abajo==k )
        n=n+1;
        Bus_i(n,1)=k;
        Qcomp(n,1)=0;
        Xcomp(n,1)=0;
      elseif find(V_malo_arriba==k)
        n=n+1;
        Bus_i(n,1)=k;
        Qind= max(Qc);
        Qc
        Qcomp(n,1)=Qind;
        Xind=Voltajes_nominal^(2)/Qind;
        Xcomp(n,1)=Xind;
      elseif find(V_malo_abajo==k)
        n=n+1;
        Bus_i(n,1)=k;
        Qcap= min(Qc);
        Qc
        Qcomp(n,1)=Qcap;
        Xcap=Voltajes_nominal^(2)/Qcap;
        Xcomp(n,1)=Xcap;
      else
        n=n;
        continue
      endif
    endfor
  endif


endfunction
