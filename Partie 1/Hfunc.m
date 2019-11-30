function H = Hfunc(nu, h)

H = 0;
for i = 1:1:30
    H = H + h(i)*cos(2*pi*nu*i);
end
