function h0 = H0(v)
if v>=0 && v<=0.1
    h0 = 1;
elseif v>0.15 && v<=0.5
    h0 = 0;
else 
    h0 = 0;
end
