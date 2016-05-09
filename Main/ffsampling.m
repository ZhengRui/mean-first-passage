function edgsSub = ffsampling(edgs, NSub, p)

  %% implementation of forestfire graph sampling method
  %% edgs: edges list (|E| x 2) of huge graph
  %% NSub: # of subgraph nodes
  %% p: probability of smearing, the higher the more difficult to spread fire, mean (1-p)/p neighbors will be affected

    N = max(max(edgs));

    s = 1;
    while s
        nBurnt = zeros(1, N);
        n0 = randi(N);
        queue = [n0];
        nBurnt(n0) = 1;
        n = 1;
        while n < NSub
            nxt = queue(1);

            lidx = find(edgs(:, 2) == nxt); %% lidx --> nxt
            ridx = find(edgs(:, 1) == nxt); %% nxt --> ridx
            nbrs = unique([edgs(lidx, 1)' edgs(ridx, 2)']); %% neighbors of nxt, unique() is for bidirectional edges
            nbrs = nbrs(nBurnt(nbrs) == 0); %% already burnt neighbors are discarded
            nnbrs = length(nbrs);
            ridx = randperm(nnbrs);
            x = geornd(p);
            nbrsWillBurn = nbrs(ridx(1:min(x, nnbrs)));
            nBurnt(nbrsWillBurn) = 1;
            n = n + length(nbrsWillBurn);
            queue = [queue(2:end) nbrsWillBurn];
            if isempty(queue)
                break; 
            end
        end
        disp(['subgraph size: ' num2str(sum(nBurnt))]);
        if n >= NSub
            s = 0;
        end
    end

    % extract subgraph using edglist (edgs) and burnt nodes (nBurnt)
    nChoosen = find(nBurnt == 1);
    lidx = ismember(edgs(:,1), nChoosen);
    ridx = ismember(edgs(:,2), nChoosen);
    edgsSub = edgs(find(lidx .* ridx), :);

end
