function lines = z_line(lines)

  warn = {};
  for i = 1:(length(lines{"List Line"}) - 1)
    for j = (i + 1):length(lines{"List Line"})
      if lines{"Bus i"}(i) == lines{"Bus i"}(j) && lines{"Bus j"}(i) == lines{"Bus j"}(j)
        printf("There's a WARNING\n");
        lines{"Warning"}{j} = "WARNING!";
      endif
    endfor
  endfor

  line_impedances = {};
  for i = 1:length(lines{"List Line"})
    if !strcmp(lines{"Warning"}{i}, "WARNING!")
      line_impedances{i} = (lines{"l(km)"}(i) * lines{"r line (ohms/km)"}(i) + lines{"l(km)"}(i) * lines{"x line (ohms/km)"}(i) * j);
    else
      line_impedances{i} = "WARNING!";
    endif
  endfor

  lines{"IMPEDANCE"} = line_impedances;
  
endfunction
