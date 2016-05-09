function mkcsv()
% convert graph model from mat to json

clear;
clc;

load net244.mat;

fid = fopen('graph244.csv', 'w');
N = size(A, 1);

for i = 1:N
    fstnb = 1;
    for j = i+1:N
        if A(i,j)
            if fstnb
                if i == 1
                    fprintf(fid, '%d', i);
                else
                    fprintf(fid, '\n%d', i);
                end
            end
            fstnb = 0;
            fprintf(fid, ';%d', j);
        end
    end
end

fclose(fid);

