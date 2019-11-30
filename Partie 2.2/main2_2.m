Espion=load('ProbaInterception.txt');
for i=1:15
    for j=1:15
        if isnan(Espion(i,j))
            Espion(i,j) = 0;
        end
    end
end
%% question 1
G=graph(Espion);
plot(G,'EdgeLabel',G.Edges.Weight)
G.Edges.Weight = log(G.Edges.Weight);

%% question 2
G=graph(Espion);
G.Edges.Weight = log(G.Edges.Weight);
[T,pred] = minspantree(G,'Method','sparse'); %cree l'arbre recouvrant minimal en utilisant l'algo de Kruskal

plot(T)
T.Edges.Weight = exp(T.Edges.Weight)
P = transpose(T.Edges.Weight);
EG = sparse(transpose(T.Edges.EndNodes(:,1)),transpose(T.Edges.EndNodes(:,2)),P)
ProbaInterception=1-prod(ones(length (T.Edges.EndNodes(:,2)),1)-T.Edges.Weight)