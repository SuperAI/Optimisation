%% Méthode gloutone
close all, clear all
disp('_______________Méthode Gloutone_______________')

a = (0.02:(1-0.02)/10000:1);
b = [];
ap = [];
bp = [];
lPoids = zeros(1,10000);
lDeform = zeros(1,10000);

frontpoids = [];
frontdef = [];

for i = 1:length(a)
    b(i) = (a(i)-0.01)*rand(1,1);
    lPoids(i) = poids([a(i);b(i)]);
    lDeform(i) = deformation([a(i);b(i)]);
end

for i = 1:length(a)
   dom = true;
   for j = 1:length(a)
      if i ~= j && lPoids(j)<=lPoids(i) && lDeform(j)<lDeform(i)
          dom = false;
      end
   end
   if dom == true
      frontpoids = [frontpoids lPoids(i)];
      frontdef = [frontdef lDeform(i)];
      ap = [ap a(i)];
      bp = [bp b(i)];
   end
end

scatter(lPoids,lDeform, '.b');
hold on 
scatter(frontpoids,frontdef, '.r');
xlabel('Poids')
ylabel('Deflexion')
title('Valeurs aux points satisfaisant la condition')
figure()
scatter(a,b,'.b')
hold on;
scatter(ap,bp,'.r')
xlabel('Section pleine (a)');
ylabel('Section creuse (b)');
title('Points satisfaisants la condition')

% Si N trop grand, ça prend du temps. 
% Front de Pareto convex. 
% Calcul du min 



%% Méthode sophistiquée 
disp('_______________Méthode sophistiquée_______________')
N=500;

res = zeros(N,2);
x0 =[0.02;0]; %point d'initialisation
A = [-1 1 ; 1 0 ];%domaine de definition de a et b
b = [-0.01;1];
lb=[0.02; 0]; %minimum admissible de a et de b
optionsfmincon =optimoptions(@fmincon,'Algorithm','interior-point','Display','off');
for alpha = 1:N
    func=@(x) poids(x)+alpha*deformation(x);
    x = fmincon(func,x0,A,b,[],[],lb,[],[], optionsfmincon);
    f(alpha,1)=poids(x);
    f(alpha,2)=deformation(x);   
end
figure
plot(f(:,1),f(:,2),'.r');
xlabel('Poids');
ylabel('Deformation');
title('Méthode plus sophistiquée');

%% Algorithme génétique 
disp('_______________Algorithme Génétique_______________')
ff=@(x) poids_def(transpose(x));
options = optimoptions('gamultiobj','PlotFcn',@gaplotpareto,'MaxGenerations',10000,'ConstraintTolerance',10^(-5));
A = [-1 1 ; 1 0 ];
b = [-0.01;1];
bm=[0.02;0];
[x,fval] = gamultiobj(ff,2,A,b,[],[],bm,[],[], options);
