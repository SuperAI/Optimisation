function rho = rho_nb_d_or(han_f, han_df, xn)
% Fonction permettant de minimiser la fonction f(U) par rapport au vecteur U 
% Méthode : gradient à pas fixe
% INPUTS :
% - han_f   : handle vers la fonction à minimiser
% - han_df  : handle vers le gradient de la fonction à minimiser
% - U0      : vecteur initial 
% - rho     : paramètre gérant l'amplitude des déplacement 
% - tol     : tolérance pour définir le critère d'arrêt
% OUTPUT : 
% - GradResults : structure décrivant la solution 

itermax=50;  % nombre maximal d'itérations 

g1 = (3-sqrt(5))/2;
g2 = (sqrt(5)-1)/2;
it=0;          % compteur pour les itérations
x0 = -0.25;
x3 = 0.25;
while it < itermax  
    it=it+1;
    x1=x0+g1*(x3-x0);
    x2=x0+g2*(x3-x0);
    h1=han_f(xn-x1*han_df(xn));
    h2=han_f(xn-x2*han_df(xn));
    if h1<h2
        x3=x2;
    else 
        x0=x1;
    end
end
rho = 1/2*(x0+x3);
end 