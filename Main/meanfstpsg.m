function mfp = meanfstpsg(Pro, minD, minK)

cumPro = cumsum(Pro, 2);
n = size(Pro, 1);   % node number
%rng('shuffle');     % randomize rand seed
s = randi([1 n]);   % start node index

nJMP = zeros(size(Pro));    % save how many jumps from i to j untill now
dJMP = zeros(size(Pro));    % save cumulative distance/cost from i to j for all the nJMP(i,j) jumps
nJMPSnap = nJMP;
dJMPSnap = dJMP;
mfpSnapOld = nJMP;

pth = [s];  % save node indices of path
cst = [0];  % save cost from previous nodes to current node along the path
lst = ones(n, 1);  % save index of last occurence for each node
lst(s) = 0;
pthL = max(lst);

cur = s;
count = 0;
[x, y] = meshgrid(1:n);
while 1
    nxt = find(cumPro(cur, :) > rand, 1);   % find next target
    if nxt == cur
        continue
    end
    pthOI = pth(end-lst(nxt)+1:end);              % path of interest
    cstOI = cst(end-lst(nxt)+1:end) + minD(cur, nxt);
    
    if isempty(pthOI)
        disp(['got you']);
    end

    [u, ui, pi] = unique(pthOI);                % u=pthOI[ui], pthOI=u[pi]
    nJMPdelta = accumarray(pi, 1);
    nJMP(u, nxt) = nJMP(u, nxt) + nJMPdelta;
    dJMPdelta = accumarray(pi, cstOI);
    dJMP(u, nxt) = dJMP(u, nxt) + dJMPdelta;

    lst = lst + 1;
    pthL = pthL + 1;
    lst(nxt) = 0;
    lmax = max(lst);
    if lmax < pthL
        pthL = lmax;
        pth = [pth(end-lmax+1:end), nxt];
        cst = [cst(end-lmax+1:end) + minD(cur, nxt), 0];
    else
        pth = [pth, nxt];
        cst = [cst + minD(cur, nxt), 0];
    end
    
    cur = nxt;

    count = count + 1;
    if ~mod(count, 100000)
        mfp = dJMP ./ (nJMP + eye(n) * 1);

        % %% visualization way 1
        % subplot(2,3,4), imshow(1 - nJMP(:,:,[1 1 1]) / max(max(nJMP)));  % the darker the more jumps
        % subplot(2,3,5), imshow(1 - dJMP(:,:,[1 1 1]) / max(max(dJMP)));  % the darker the more cumulated distance/cost
        % subplot(2,3,6), imshow(mfp(:,:,[1 1 1]) / max(max(mfp)));    % the darker the shorter mean first passage distance/cost

        % %% visualization way 2
        % subplot(2,3,1), surfc(x, y, nJMP);
        % subplot(2,3,2), surfc(x, y, dJMP);
        % subplot(2,3,3), surfc(x, y, mfp);

        % drawnow;

        count = 0;
        if nJMP + eye(n) * minK >= minK
            %close all;
            return;
        end

        %%% mfp = dJMP ./ (nJMP + eye(n) * 1);
        %%% subplot(2,2,1), plot(count/10000, min(min(nJMP + eye(n) * nJMP(1,2))), 'o', 'linewidth', 2), hold on; % plot(count/10000, minK, 'x', 'linewidth', 2, 'color', 'red');
        %%% subplot(2,2,2), plot(count/10000, sum(sum(mfp)) / (n * n - n), 'o', 'linewidth', 2), hold on; % plot(count/10000, 155.4237, 'x', 'linewidth', 2, 'color', 'red');

        %%% [mfpSorted, mfpSortedIdx] = sort(mfp(:));
        %%% subplot(2,2,3), plot([1:1:n*n-n], mfpSorted(n+1:end), 'linewidth', 2), hold on, plot([1:1:n*n-n], cumsum(mfpSorted(n+1:end)) ./ [1:1:n*n-n]', 'linewidth', 2, 'color', 'magenta'), hold off;

        %%% if ~mod(count, 100000)
        %%%     mfpSnap = (dJMP - dJMPSnap) ./ (nJMP - nJMPSnap + eye(n) * 1);
        %%%     subplot(2,2,2), plot(count/10000, sum(sum(mfpSnap)) / (n * n - n), 'o', 'linewidth', 2, 'color', 'green');

        %%%     mfpSnapDelta = mfpSnap - mfpSnapOld;
        %%%     mfpSnapDelta = mfpSnapDelta(mfpSortedIdx);
        %%%     %subplot(2,2,4), plot([1:1:n*n-n], mfpSnapDelta(n+1:end), 'linewidth', 2, 'color', 'green'), hold on, plot([1:1:n*n-n], cumsum(mfpSnapDelta(n+1:end)) ./ [1:1:n*n-n]', 'linewidth', 2, 'color', 'magenta'), hold off;
        %%%     mfpSnapSorted = mfpSnap(mfpSortedIdx);
        %%%     subplot(2,2,4), plot([1:1:n*n-n], mfpSnapSorted(n+1:end), 'linewidth', 2, 'color', 'green'), hold on, plot([1:1:n*n-n], cumsum(mfpSnapSorted(n+1:end)) ./ [1:1:n*n-n]', 'linewidth', 2, 'color', 'magenta'), hold off;
        %%%     mfpSnapOld = mfpSnap;

        %%%     nJMPSnap = nJMP;
        %%%     dJMPSnap = dJMP;
        %%% end
        %%% drawnow;
    end
end

end
