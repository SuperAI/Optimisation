function lag = lagrangien(han_f,u,lambda)

f = han_f(u);
con = [-u;u-1];
lag = f+lambda'*con;