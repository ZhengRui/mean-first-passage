function A=UVnet(u,v,n)

edgs = [1 2];
lstnd = 2;

for ni = 1:n
    newedgs = zeros((u+v)^ni,2);
    for ei = 1:size(edgs, 1)
        unew = [[edgs(ei,1) [lstnd+1:lstnd+u-1]]; [[lstnd+1:lstnd+u-1] edgs(ei,2)]]';
        lstnd = lstnd + u - 1;
        vnew = [[edgs(ei,1) [lstnd+1:lstnd+v-1]]; [[lstnd+1:lstnd+v-1] edgs(ei,2)]]';
        lstnd = lstnd + v - 1;
        newedgs((ei-1)*(u+v)+1:ei*(u+v), :) = [unew;vnew];
    end
    edgs = newedgs;
end

A = zeros(max(edgs(:,1)));
edgidx = sub2ind(size(A), [edgs(:,1); edgs(:,2)], [edgs(:,2); edgs(:,1)]);

edgs
A(edgidx) = 1;

end
