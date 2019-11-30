function s=Lnoeuds(A)

A=[0,A];
count=0;
Lnoeuds=[];
for i=2:length(A)
        v=count+1;
        count=count+1+max(max(A(1:i-1))-A(i),0);
        Lnoeuds=[Lnoeuds;v,count];
end
s.count=count; 
s.nodes=Lnoeuds; 