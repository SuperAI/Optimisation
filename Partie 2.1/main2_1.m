%% Paramètres
clear all close all
obj = readtable("PositionObjets.txt");
obj = obj.Variables;
box = readtable("PositionCasiers.txt");
box = box.Variables;
n = size(box,1);

%Calcul de la matrice de distance
dist = zeros(size(obj,1),size(obj,1));

for i = 1:n
    tempBox = box(i,:);
    for j = 1:n
        tempObj = obj(j,:);
        dist(i,j)=sqrt((tempObj(1)-tempBox(1))^2+...
            (tempObj(2)-tempBox(2))^2);
    end
end

%% Question 2

%Calcul de Aeq, on code chaque contrainte dans une matrice puis on
%rassemble

constraint1 = zeros(n,n^2);
count = 0;
oneTemp = ones(1,n);
for i = 1:n
    constraint1(i,count*n+1:count*n+n) = oneTemp;
    count = count + 1;
end

constraint2 = eye(n);
for i = 1:n-1
    constraint2 = [constraint2 eye(n)];
end

Aeq = [constraint1;constraint2];
beq = ones(2*n,1);
A = [];
b = [];
lb = zeros(n^2,1);
ub = ones(n^2,1);
intcon = 1:n^2;
disp('__________Sans contraintes supplémentaires__________');
[x, fval] = intlinprog(dist,intcon, A, b, Aeq, beq, lb , ub);
disp('Distance minimale')
fval
AffichagePoints(transpose(x),obj,box);
title('Question 2');
%% Question 3

const = zeros(n-3,n^2);
count = 1;
for i = 1:n-3
   const(i,count) = 1;
   
   count = count + 1;
end
temp = [zeros(n-1,1) eye(n-1)];
temp2  = zeros(1,n);
temp2(1,n) = 1;
constr1 = [temp ; temp2];
Aeq = [Aeq;[eye(n) -constr1 zeros(n,n^2-2*n)]];
constr_res1 = zeros(n,1);
beq = [beq;constr_res1];

disp('__________l''objet n°1 doit se situer dans la boîte située juste à gauche de la boîte contenant l''objet n°2__________');
[x, fval] = intlinprog(dist,intcon, A, b, Aeq, beq, lb , ub);
disp('Distance minimale')
fval
AffichagePoints(transpose(x),obj,box);
title('Question 3');

%% Question 4

temp3 = [eye(n) triu(ones(n,n))];
constr2 = [zeros(n,2*n) temp3 zeros(n,n^2-4*n)];
A = constr2;
b = ones(1,n);
disp('__________La boîte contenant l?objet n°3 se situe à droite de la boîte contenant l?objet n°4__________');
[x, fval] = intlinprog(dist,intcon, A, b, Aeq, beq, lb , ub);
disp('Distance minimale')
fval
AffichagePoints(transpose(x),obj,box);
title('Question 4');

%% Question 5

disp('__________La boîte contenant l?objet n°7 se situe à côté de la boîte contenant l?objet n°9__________');
alpha = zeros(n-2,1);
alpha(1) = -1;
beta = zeros(n-2,1);
beta(n-2) = -1;
delta = full(gallery('tridiag',13,-1,0,-1));

vec2 = [zeros(n-2, 6*n+1) eye(n-2,n-2) zeros(n-2,n+1) alpha delta beta zeros(n-2,n^2-9*n)];

Aeq = [Aeq; vec2];
beq = [beq; zeros(n-2,1)];

[x, fval] = intlinprog(dist,intcon, A, b, Aeq, beq, lb , ub);
fval
AffichagePoints(transpose(x),obj,box);
title('Question 5');
