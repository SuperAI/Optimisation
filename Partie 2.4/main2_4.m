close all, clear all
Data=load("DonneesEnginsChantier.txt");
pinit=800;
ploc=200;
pfin=1200;

%% poids arcs
n=Lnoeuds(Data);
A=zeros(n.count);
noeuds=n.nodes;

for i=1:length(noeuds(:,1))-1
    for k=noeuds(i,1):noeuds(i,2)
        for j=noeuds(i+1,1):noeuds(i+1,2)
            di=Data(i)+k-noeuds(i,1);
            dii=Data(i+1)+j-noeuds(i+1,1);
            A(k,j)=poids(di,dii,pinit,ploc,pfin);
        end
    end
end

%% Construction graphe et calcul du cout
G=digraph(A);
l=length(noeuds);
[path,cout] = shortestpath(G,noeuds(1:1),noeuds(l,1));

temp=[];
for i=1:length(noeuds(:,1))
    r=path(i)-noeuds(i,1);
    temp=[temp,Data(i)+r];
end

g.path=temp;

g.cout=cout+Data(1)*(ploc+pinit)+Data(l)*pfin; 
disp(['cout stratégie optimale : ',num2str(g.cout)])
plot(1:(length(temp)+2),[0,temp,0],'g')
hold on
plot(1:(length(temp)+2),[0,Data,0],'r')
legend('Stratégie optimale','Besoins pour la semaine i')
