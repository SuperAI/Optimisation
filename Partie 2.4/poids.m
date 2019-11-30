function p=poids(dj,di,pinit,ploc,pfin)
poids=max(di-dj,0)*pinit+max(dj-di,0)*pfin+di*ploc;
p=poids;