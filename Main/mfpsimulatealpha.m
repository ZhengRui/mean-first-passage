function mfpsimulatealpha(nNodes, nChain, minK)
% A = WSnet(nNodes,2,0.2);  % WSnet() is function to generate ER graph
% minD = graphallshortestpaths(sparse(A));
% save(sprintf('ER%d.mat', nNodes), 'A');
% save(sprintf('ER%ddistance.mat', nNodes), 'minD');
% return;
 
%%load(sprintf('ER%d.mat', nNodes));
%%load(sprintf('ER%ddistance.mat', nNodes));

%load Dolphin.mat;
%load Dolphindistance.mat;
%A = net;

load('../networkbase/sierpinski/net3282.mat');
load('../networkbase/sierpinski/distance3282.mat');

n = length(A(1,:));
alpha = [4:0.2:6];
beta = [0:0.5:1];
nalpha = length(alpha);
nbeta = length(beta);
avgD = zeros(nalpha, nbeta, nChain);
tic;
for i1 = 1:nalpha  
    D = minD;
    D = D+eye(n);
    D1 = D.^(-1*alpha(i1))-eye(n);
    s1 = sum(D1)';
    s = repmat(s1,1,length(s1));
    D2 = D1./s;
    for j1 = 1:nbeta
        for nc = 1:nChain
            avgD(i1, j1, nc) = sum(sum(meanfstpsg(D2, minD .^ beta(j1), minK))) / (n * n - n);
            disp(sprintf('alpha = %5.2f, beta = %5.2f, nc = %3d', alpha(i1), beta(j1), nc));
        end 
    end
    t = toc;
    save(sprintf('../networkbase/sierpinski/res_sierpinski3282_%dx%d.mat', nChain, minK), 'avgD', 'alpha', 'beta', 't');
end
t = toc;

save(sprintf('../networkbase/sierpinski/res_sierpinski3282_%dx%d.mat', nChain, minK), 'avgD', 'alpha', 'beta', 't');
end
