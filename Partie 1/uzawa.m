function uz = uzawa(han_f, han_df, lambda, U0, rho)


xn=U0;
temp = lambda;
converged = false;
it = 0;
maxiter = 1000;
while ~converged && it < maxiter
    it = it+1;
    lag = @(x) lagrangien(han_f, x, temp);
    options = optimoptions('fminunc','algorithm','quasi-newton','TolFun',1e-10);
    [X,FVAL,EXITFLAG,OUTPUT] = fminunc(lag,U0,options);
    xn=X;
    gradient = grad_lag(xn);
    lambda = max(lambda+rho*gradient,zeros);
    test = abs(lagrangien(han_f, xn, lambda)-lagrangien(han_f, xn, temp))<1e-6;
    if test
        converged = true;
    end
    disp(abs(lagrangien(han_f, xn, lambda)-lagrangien(han_f, xn, temp)))
    temp = lambda;
end

uz.initial_x=U0;         % vecteur initial
uz.minimum=xn;         % vecteur après optimisation
uz.f_minimum=FVAL;       % valeur optimale de la fonction
uz.iterations=it;        % nombre d'itérations
uz.converged=converged;  % true si l'algorithme a convergé
uz.lambda = lambda