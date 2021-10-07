clc; clearvars; close all;
%%Constantes
syms k d L g I_xx I_yy I_zz m
%Control de velocidad de las helices
syms w [1 4]
%Salidas
syms x(t) y(t) z(t)
syms p(t) q(t) r(t)
syms phi(t) theta(t) psi(t)

%% Ecuaciones de posicion absoluta
F_B = [
    0;
    0;
    k*(w1^2+w2^2+w3^2+w4^2)
];

R = [
    cos(psi)*cos(theta), cos(psi)*sin(theta)*sin(phi) - sin(psi)*cos(phi), cos(psi)*sin(theta)*cos(phi) + sin(psi)*sin(phi);
    sin(psi)*cos(theta), sin(psi)*sin(theta)*sin(phi) + cos(psi)*cos(phi), sin(psi)*sin(theta)*cos(phi) - cos(psi)*sin(phi);
    -sin(theta), cos(theta)*sin(phi), cos(theta)*cos(phi)
];

G = [0; 0; -g];

eq_dd_XYZ = [diff(x, 2); diff(y, 2); diff(z, 2)] == G + R * F_B / m;

%% Ecuaciones de velocidad angular relativa
M_B = [
    k*L*(w4^2-w2^2);
    k*L*(w3^2-w1^2);
    d*(w1^2-w2^2+w3^2-w4^2)
];

I = [
    I_xx, 0, 0;
    0, I_yy, 0;
    0, 0, I_zz
];

nu = [p; q; r];
eq_d_PQR = diff(nu) == inv(I) * (M_B - cross(nu, (I*nu)));

%% Ecuaciones de velocidad angular absoluta
W = [
    1, sin(phi)*tan(theta), cos(phi)*tan(theta);
    0, cos(phi), -sin(phi);
    0, sin(phi)/cos(theta), cos(phi)/cos(theta)
];

eq_d_PTP = [diff(phi); diff(theta); diff(psi)] == W*nu;

%% Convertir a sistema de ecuaciones diferenciales de primer orden
eqs = [eq_dd_XYZ; eq_d_PQR; eq_d_PTP];
[V, S] = odeToVectorField(eqs);