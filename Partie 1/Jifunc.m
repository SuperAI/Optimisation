function max = Jifunc(h)
v = h;
max = 0;
nu1 = [0:0.001:0.1];
nu2 = [0.15:0.01:0.5];
nu = [nu1 nu2];
Hz = @(nu) H0(nu);
Hf = @(nu,h) Hfunc(nu,h);
for i = 1:1:length(nu)
    if abs(Hz(nu(i))-Hf(nu(i),v))>max
        max = abs(Hz(nu(i))-Hf(nu(i),h));
    end
end
