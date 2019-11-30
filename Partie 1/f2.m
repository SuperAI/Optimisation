function fU=f2(U,S)

fU = transpose(U) * S * U + U' * exp(U);
