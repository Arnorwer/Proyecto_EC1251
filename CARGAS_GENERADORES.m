function [GENERATION,LOAD,text1]= CARGAS_GENERADORES()
  %matrices correspondientes a la hoja GENERATION y LOAD
  GENERATION= xlsread('data_io.xlsx','GENERATION');
  [LOAD,text1] = xlsread('data_io.xlsx','LOAD');
endfunction
