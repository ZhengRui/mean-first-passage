clear all;
clc;

%%% edgs = dlmread('../crawlernet/stanford/web/web-Stanford-clean.txt');
%%% [~, ~, edgsU] = unique(edgs);
%%% edgs = reshape(edgsU, size(edgs));
%%% 
%%% edgsSub = ffsampling(edgs, 2000, 0.1);
%%% edgs = edgsSub;

%% load('../crawlernet/stanford/web/minD2004-1.mat');
%% load('../crawlernet/stanford/web/webEdgs2004-1.mat');
%% 
%% [~, ~, edgsU] = unique(edgs);
%% edgs = reshape(edgsU, size(edgs));
%% 
%% A = zeros(max(max(edgs)));
%% edgidx = sub2ind(size(A), [edgs(:,1); edgs(:,2)], [edgs(:,2); edgs(:,1)]);
%% A(edgidx) = 1;

% load Dolphin.mat;
% load Dolphindistance.mat;
% A = net;

% minD=graphallshortestpaths(sparse(A));

load('../crawlernet/stanford/fbego/fbegominD.mat');
load('../crawlernet/stanford/fbego/fbegoEdgs.mat');

n = size(minD, 1);

if n > 10000
    minD = single(minD);
end

mu = [0:0.05:1];
beta = [0, 0.85, 1];
nbeta = length(beta); 
nmu = length(mu);
T = zeros(nmu, nbeta);

minD(1:(n+1):end) = 1;
for i1 = 1:nmu
    disp(['------ mu = ' num2str(mu(i1)) ' ------']);
    s = sum(A);
    D1 = bsxfun(@rdivide, A, s);    % D1 is transition matrix (each row / column sum to 1, here is column)
    P = mu(i1) * D1 + (1 - mu(i1)) / n; % P is still transition matrix

    % proof of largest eigen value of transition matrix is 1: http://math.stackexchange.com/questions/40320/proof-that-the-largest-eigenvalue-of-a-stochastic-matrix-is-1
    % proof of M and M' has the same eigen values: http://math.stackexchange.com/questions/123923/a-matrix-and-its-transpose-have-the-same-set-of-eigenvalues
    % proof of M and M' doesn't form same space: http://math.stackexchange.com/questions/579826/the-eigenvectors-of-a-matrix-and-its-transpose-that-correspond-to-the-same-eigen

    [w e] = eigs(P, 1, 'lm');
    w = abs(w) / sum(abs(w));
    P1 = bsxfun(@plus, -P, w);
    P1(1:(n+1):end) = diag(P1) + 1;
    Z = inv(P1');
    zdiag = diag(Z)';
    Z = bsxfun(@plus, -Z, zdiag);
    sz = sum(Z);

    for j1 = 1:nbeta
        % disp(['beta = ' num2str(beta(j1))]);
        CST = minD .^ beta(j1);
        CST(1:(n+1):end) = 0;
        C = P .* CST;
        r = (sum(C) * w) ./ w;
        T(i1, j1) = sz * r / (n*(n-1));
    end
end

figure; hold on;
cc = hsv(nbeta);
leg = [];
for j = 1:nbeta
    plot(mu,T(:, j),'--','color', cc(j, :),'linewidth',2);
    leg = [leg {['\beta = ' num2str(beta(j))]}];
end

%load('../crawlernet/stanford/fbego/res_fbego_PgRnk_1x50.old.mat');
%for j = 1:nbeta
%    plot(mu,avgD(:, j),'o','color', cc(j, :),'linewidth',2);
%end
%disp(['simulation takes time: ' num2str(t/3600) ' h']);

load('../crawlernet/stanford/fbego/mean_std_20x50.mat');
for j = 1:nbeta
    errorbar(mu, mmean(:,j), sstd(:,j), 'o','color', cc(j, :),'linewidth',2);
end

xlabel('\it{\mu}','FontName','Times New Roman','FontSize',20);
ylabel('\it{\langle{T}\rangle}','FontName','Times New Roman','FontSize',20); 
legend(leg);

%%% contourf(mu, beta, T', 100); shading flat; colorbar; colormap(flipud(jet));
