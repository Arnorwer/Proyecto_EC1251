function [col_list] = col_names(txt)
    for k = 1:length(txt)
        colname = txt{1, k};
        if k == 1
            col_list = [colname];
        else
            col_list = [col_list; colname];
        endif
    endfor