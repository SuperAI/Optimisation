function beta = beta_penal(Lb, Ub, X)
beta = 0;
for i = 1:1:5
    beta=beta + max(X(i)-Ub(i),0)^2 + max(Lb(i)-X(i),0)^2;
end

