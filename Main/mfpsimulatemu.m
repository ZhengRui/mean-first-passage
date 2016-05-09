function mfpsimulatemu(nNodes, nChain, minK)
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

load('../crawlernet/stanford/fbego/fbegoEdgs.mat');
load('../crawlernet/stanford/fbego/fbegominD.mat');

%load('../crawlernet/stanford/web/minD2004-1.mat');
%load('../crawlernet/stanford/web/webEdgs2004-1.mat'); % directed graph, may have a->b, and b->a
%[~, ~, edgsU] = unique(edgs);
%edgs = reshape(edgsU, size(edgs));
%A = zeros(max(max(edgs)));
%edgidx = sub2ind(size(A), [edgs(:,1); edgs(:,2)], [edgs(:,2); edgs(:,1)]);
%A(edgidx) = 1;


n = length(A(1,:));
mu = [0:0.05:1];
beta = [0, 0.85, 1.0];
nmu = length(mu);
nbeta = length(beta);
avgD = zeros(nmu, nbeta, nChain);
tic;
for i1 = 1:nmu
    s = sum(A);
    D1 = bsxfun(@rdivide, A, s);
    P = mu(i1) * D1 + (1 - mu(i1)) / n;
    for j1 = 1:nbeta
        for nc = 1:nChain
            avgD(i1, j1, nc) = sum(sum(meanfstpsg(P', minD .^ beta(j1), minK))) / (n * n - n);
            disp(sprintf('mu = %5.2f, beta = %5.2f, nc = %3d', mu(i1), beta(j1), nc));
        end 
    end
    t = toc;
    save(sprintf('../crawlernet/stanford/fbego/res_fbego_PgRnk_%dx%d.mat', nChain, minK), 'avgD', 'mu', 'beta', 't');
end
t = toc

save(sprintf('../crawlernet/stanford/fbego/res_fbego_PgRnk_%dx%d.mat', nChain, minK), 'avgD', 'mu', 'beta', 't');

end
