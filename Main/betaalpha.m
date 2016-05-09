clear all;
clc;

tobeload = {'../networkbase/Dolphin/Dolphindistance.mat', '../networkbase/12/distance3282.mat', '../networkbase/BA/distance2000.mat', '../networkbase/sierpinski/distance3282.mat', '../networkbase/Tgraph/distance2188.mat', '../networkbase/12/distance366.mat', '../networkbase/sierpinski/distance366.mat'};

idx = 6;
load(tobeload{idx});

n = size(minD,1);

if n > 10000
    minD = single(minD);
end

alpha = [0:0.2:10];
beta = [0:0.5:1];
nalpha = length(alpha);
nbeta = length(beta); 
T = zeros(nalpha, nbeta);

minD(1:(n+1):end) = 1;
for i1 = 1:nalpha
    disp(['------ alpha = ' num2str(alpha(i1)) ' ------']);
    D1 = minD .^ (-1 * alpha(i1));
    D1(1:(n+1):end) = 0;
    s1 = sum(D1)';
    w1 = s1' ./ sum(s1);
    D1 = bsxfun(@rdivide, D1, s1);
    D1 = bsxfun(@plus, -D1, w1);
    D1(1:(n+1):end) = diag(D1) + 1;
    %tic;
    Z = inv(D1);
    %toc;
    zdiag = diag(Z)';
    Z = bsxfun(@plus, -Z, zdiag);
    sz = sum(Z);
    for j1 = 1:nbeta
        disp(['beta = ' num2str(beta(j1))]);
        %tic;
        D2 = minD .^ (-1 * alpha(i1) + beta(j1));
        D2(1:(n+1):end) = 0;
        s2 = sum(D2)';
        r = sum(s2) ./ s1;
        T(i1, j1) = sz * r / (n*(n-1));
        %toc;
    end
end

figure; hold on;

cc = hsv(nbeta);
leg = [];
for j = 1:nbeta
    plot(alpha,T(:, j),'--','color', cc(j, :),'linewidth',2);
    leg = [leg {['\beta = ' num2str(beta(j))]}];
end


tobeload = {'../networkbase/Dolphin/res_Dolphin_1x2000.mat', '../networkbase/12/res_onetwo3282_1x500.mat', '../networkbase/BA/res_BA2000_1x800.mat', '../networkbase/sierpinski/res_sierpinski3282_1x500.mat', '../networkbase/Tgraph/res_*.mat', '../networkbase/12/res_onetwo366_20x100.mat', '../networkbase/sierpinski/res_sierpinski366_20x200.mat'};

load(tobeload{idx});
for j = 1:nbeta
    %plot(alpha,avgD(:, j),'o','color', cc(j, :),'linewidth',2);
    errorbar(alpha, mean(avgD(:,j,:), 3), std(avgD(:,j,:), 0, 3), 'o','color', cc(j, :),'linewidth',2);
end
disp(['simulation takes time: ' num2str(t/3600) ' h']);

%%% res = cellstr(['1x8000'; '10x800']);
%%% cc = hsv(length(res));
%%% for r = 1:length(res)
%%%     clear avgD alpha t;
%%%     load(['res_Dolphin_' res{r} '.mat']);
%%%     if exist('t')
%%%         disp([res{r} ' spent time: ' num2str(t/3600) ' h']);
%%%     end
%%%     %plot(alpha, mean(avgD, 1), 'o', 'color', cc(r,:), 'linewidth', 2);
%%%     errorbar(alpha, mean(avgD, 1), std(avgD, 0, 1), 'o', 'color', cc(r,:), 'linewidth', 2);
%%%     leg = [leg res{r}];
%%% end

xlabel('\it{\alpha}','FontName','Times New Roman','FontSize',16);
ylabel('\it{\langleT\rangle}','FontName','Times New Roman','FontSize',16); 
legend(leg);
