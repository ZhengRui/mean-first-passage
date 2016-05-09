clear all;
clc;

n = 5;
for i = 1:1
    r = rand(n, n);
    m = (r + r') / 2 > .5;
    s = sum(m);
    m = bsxfun(@rdivide, m, s);
    mu = rand;
    m = mu * m + (1 - mu) / n;
    [V, D] = eig(m)
    [V, D] = eigs(m, 1)
end
