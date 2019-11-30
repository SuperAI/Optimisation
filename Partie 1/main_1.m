close all, clear all
[Aineq,B,S] = definition_constantes;

%% Paramètres pour tout le TP
d=5; U0 = zeros(d,1);
tolerance=1e-6; pas=[0.5,0.1,0.01,1e-3,1e-4,1e-5];
Ub=ones(5,1);
Lb=zeros(5,1);
han_f1  = @(u) f1(u,B,S);
han_f2  = @(u) f2(u,S);
han_f3  = @(u) f1(u,B,S)+10*sin(2*f1(u,B,S));
han_df1 = @(u) df1(u,B,S);
han_df2  = @(u) df2(u,S);
%han_df3 = @(u) df1(u,B,S)+20*df1(u,B,S)*cos(2*f1(u,B,S));
f_df = @(u) deal(f1(u,B,S),df1(u,B,S));
f_df2 = @(u) deal(f2(u,S),df2(u,S));
beta_f1 = @(u) beta_penal(Lb,Ub,u);
epsilon=1e-5
f1penal = @(u) f1(u,B,S)+beta_penal(Lb,Ub,u)*1/epsilon;


%% 1.1.1 Test avec différents pas et comparaisons (rho constant, relaxation, section d'or)
% Pour la foinction f1
disp('_____________gradient sur f1____________') 


for i = 1:1:6
    disp('rho')
    disp(pas(i))
    disp('Gradient à pas constant')
    tic
    GradResults=gradient_rho_constant(han_f1,han_df1,U0,pas(i),tolerance)
    toc
    sprintf('\n Gradient à pas adaptatif')
    tic
    GradResults_ad=gradient_rho_adaptatif(han_f1,han_df1,U0,pas(i),tolerance)
    toc
end
disp('Section d or')
tic
GradResults_or=gradient_rho_nbOR(han_f1,han_df1,U0,tolerance)
toc

disp(['gradient_rho_constant : minimum=',num2str(GradResults.f_minimum)]);


% Pour la foinction f2
disp('_____________gradient sur f2____________') 

for i = 1:1:6
    disp('rho')
    disp(pas(i))
    disp('Gradient à pas constant')
    tic
    GradResults2=gradient_rho_constant(han_f2,han_df2,U0,pas(i),tolerance)
    toc
    sprintf('\n Gradient à pas adaptatif')
    tic
    GradResults_ad2=gradient_rho_adaptatif(han_f2,han_df2,U0,pas(i),tolerance)
    toc
end

disp('Section d or')
tic
GradResults_or2=gradient_rho_nbOR(han_f2,han_df2,U0,tolerance)
toc

disp(['gradient_rho_constant : minimum=',num2str(GradResults.f_minimum)]);



%% 1.1.2 Utilisation des routines d?optimisation de la Toolbox Optimization. Méthode de Quasi-Newton (version BFGS)  
% Pour la foinction f1
disp('_____________Quasi-Newton (BFGS) sur f1____________') 


options = optimoptions('fminunc','algorithm','quasi-newton','TolFun',tolerance); 
options2 = optimoptions('fminunc','SpecifyObjectiveGradient',true); 
[X1,FVAL1,EXITFLAG1,OUTPUT1] = fminunc(f_df,U0,options2);
[X,FVAL,EXITFLAG,OUTPUT] = fminunc(f_df,U0,options2);

FVAL
OUTPUT 


% Pour la fonction f2
disp('_____________Quasi-Newton (BFGS) sur f2____________') 


options21 = optimoptions('fminunc','algorithm','quasi-newton','TolFun',tolerance); 
options22 = optimoptions('fminunc','SpecifyObjectiveGradient',true); 
[X2,FVAL1,EXITFLAG1,OUTPUT1] = fminunc(f_df2,U0,options22);
[X,FVAL,EXITFLAG,OUTPUT] = fminunc(f_df2,U0,options22);

FVAL
OUTPUT


%% 1.2.1 Optimisation sous contraintes avec SQP


disp('_____________SQP sur f1____________') 

options = optimoptions('fmincon','algorithm','sqp','TolFun',tolerance); 
lb = zeros(5,1);
ub = ones(5,1);
A = [];
b = [];
Aeq = [];
beq = [];
Nonlcon=[];
[X,FVAL,EXITFLAG,OUTPUT] = fmincon(han_f1,U0,A,b,Aeq,beq,lb,ub, Nonlcon, options);
FVAL
OUTPUT



disp('_____________SQP sur f2____________') 
options = optimoptions('fmincon','algorithm','sqp','TolFun',tolerance); 
lb = zeros(5,1);
ub = ones(5,1);
A = [];
b = [];
Aeq = [];
beq = [];
Nonlcon=[];
[X,FVAL,EXITFLAG,OUTPUT] = fmincon(han_f2,U0,A,b,Aeq,beq,lb,ub, Nonlcon, options);
FVAL
OUTPUT


%% 1.2.2 Optimisation sous contraintes et pénalisation

disp('_____________Méthode avec pénalisation sur f1____________') 
% Pénalisation avec bêta
lb = zeros(5,1);
ub = ones(5,1);
A = [];
b = [];
Aeq = [];
beq = [];
Nonlcon=[];
[X,FVAL,EXITFLAG,OUTPUT] = fmincon(f1penal,U0,A,b,Aeq,beq,lb,ub, Nonlcon, options);
FVAL
OUTPUT



%% 1.2.3  Méthodes duales pour l'optimisation sous contraintes

disp('_____________Uzawa sur f1____________') 
lambda=[0.7;0.5;0.4;0.8;0.2;0.5;0.2;0.4;0.8;0.2];
rho1=0.5;
uz = uzawa(han_f1, han_df1, lambda, U0, rho1);



%% 1.3 Optimisation non convexe - Recuit simulé

disp('_____________Recuit simulé sur f3____________') 

options = optimoptions('fminunc','algorithm','quasi-newton','TolFun',tolerance); 
[X1,FVAL1,EXITFLAG1,OUTPUT1] = fminunc(han_f3,ones(5,1)*3.8,options);
[X2,FVAL2,EXITFLAG2,OUTPUT2] = fminunc(han_f3,ones(5,1),options);
[X3,FVAL3,EXITFLAG3,OUTPUT3] = fminunc(han_f3,U0,options);

%différent
val = zeros(5,100);
for i = 1:1:100
    val(:,i) = simulannealbnd(han_f3,U0+ones(5,1));
end

subplot(231);
hist(val(1,:))
subplot(232);
hist(val(2,:))
subplot(233);
hist(val(3,:))
subplot(234);
hist(val(4,:))
subplot(235);
hist(val(5,:))

%La distribution est concentré à +-1 en écart maximum. 


%% 1.4 Synthèse d'un filtre à réponse impulsionnelle fini

disp(sprintf("_____________Synthèse d'un filtre à réponse impulsionnelle finie____________"));

h0 = [ones(1,30)/10];
Ji = @(h) Jifunc(h);
Hf = @(nu,h) Hfunc(nu,h);
options = optimoptions('fminunc','algorithm','quasi-newton','TolFun',tolerance); 
[X1,FVAL1,EXITFLAG1,OUTPUT1] = fminunc(Ji,h0,options);
FVAL1
figure(1)
stem(1:1:30,X1);
hold on
plot(1:0.1:30, 1/5*pi*sinc((1:0.1:30)/5));
xlabel('i');
ylabel('h[i]');
title("Réponse impulsionnelle")
hold off

figure(2)
hold on
stem(0:0.01:0.5,Hf((0:0.01:0.5),X1));
plot(0:0.001:0.5,rectangularPulse(0,0.1,0:0.001:0.5))
title('Réponse frequentielle')
xlabel('\nu')
ylabel('H(\nu)')
hold off
