function gamma=sfdeg(net)

%function gamma=sfdeg(net)
%
%compute the degree distribution and scale free exponent of a network
%(presumably scale free) net.
%
%MS
%25/1/07

nlinks=full(sum(net)); %compute degree distribution
mnlinks=max(nlinks);

for i=1:mnlinks,
    pk(i)=sum(nlinks==i);
end;
k=1:mnlinks;
pk=pk/sum(pk);
loglog(k,pk,'bx');
xlabel('k');ylabel('P(k)');grid;
title(['kP(k)=',num2str(mean(nlinks))]);
k=k(pk>0);
pk=pk(pk>0);
%p=polyfit(log(k),log(pk),1);
p=polyfit(log(k(k<sqrt(mnlinks))),log(pk(k<sqrt(mnlinks))),1); %don't fit the crap in the tail
hold on;
plot(k,(exp(1)^p(2))*k.^p(1),'r');

title(['P(k)=k^{-\gamma} where \gamma=',num2str(-p(1))]);
xlabel('k');
ylabel('P(k)');
grid;

gamma=p(1);

