function W = wtoW(w)
    g = 9.806;
    m = 8.01;
    k = 3E-6;
    w_estable = sqrt(g*m/k)/2;
    W = w^2 - w_estable^2;
end