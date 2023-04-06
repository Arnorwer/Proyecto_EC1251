function lines = z_line(lines)

  warn = {};
  for i = 1:(length(lines(:,1)) - 1)
    for j = (i + 1):length(lines(:, 1))
      if lines(2, i) == lines(2, j) && lines(3, i) == lines(3, j)
        printf("There is a WARNING\n");
        lines(4, j) = 0;
      endif
    endfor
  endfor

  line_impedances = [];
  for i = 1:length(lines(:,1))
    if !strcmp(lines(4, i), 0)
      
      line_impedances(i) = complex(lines(i, 5) * lines(i, 6),lines(i, 5) * lines(i, 7));
    else
      line_impedances(i) = 0;
    endif
  endfor

  lines(:, 9) = line_impedances;
  
endfunction
