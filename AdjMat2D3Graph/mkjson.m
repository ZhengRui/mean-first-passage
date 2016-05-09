function mkjson()
% convert graph model from mat to json

clear;
clc;

load net244.mat;

fid = fopen('graph244.json', 'w');
fprintf(fid, '{\n\t"nodes":[\n');

N = size(A, 1);

for i = 1:N
    if i ~= 1
       fprintf(fid, ',\n'); 
    end
    fprintf(fid, '\t\t{"name":"node%d","degree":%d}', i,sum(A(i,:))); 
end

fprintf(fid, '\n\t],\n\t"links":[\n');

fstlk = 1;
for i = 1:N  
    for j = i+1:N
        if A(i,j)
            if ~fstlk
                fprintf(fid, ',\n');
            end
            fstlk = 0;
            fprintf(fid, '\t\t{"source":%d,"target":%d,"weight":1}', i-1,j-1);
        end
    end
end

fprintf(fid, '\n\t]\n}');
fclose(fid);

