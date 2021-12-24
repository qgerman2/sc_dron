clc; clearvars; close all hidden; clear global
syms k d m L g Ixx Iyy Izz
%Controlador y sistema
ai = 0.1;
vp = round([-0.4500;   -0.4700;   -0.4600;   -0.4500;   -0.4800;   -0.4600;   -0.4800;   -0.4700;   -0.4800;   -0.4900;   -0.4700;   -0.0900], 2);
A = double(subs([
        0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0;
        0, 0, 0, 0, 0, 0, 0, 0, g, 0, 0, 0;
        0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0;
        0, 0, 0, 0, 0, 0,-g, 0, 0, 0, 0, 0;
        0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0;
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0;
        0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0;
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0;
        0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0;
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0;
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1;
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0;
    ], g, 9.806));
B = double(subs([
             0,        0,       0,       0;
             0,        0,       0,       0;
             0,        0,       0,       0;
             0,        0,       0,       0;
             0,        0,       0,       0;
           k/m,      k/m,     k/m,     k/m;
             0,        0,       0,       0;
             0, -L*k/Ixx,       0, L*k/Ixx;
             0,        0,       0,       0;
      -L*k/Iyy,        0, L*k/Iyy,       0;
             0,        0,       0,       0;
         d/Izz,   -d/Izz,   d/Izz,  -d/Izz;
], ...
    {   k,      d,   L,     Ixx,     Iyy,    Izz,     m}, ... 
    {3E-6, 7.5E-7, 0.3, 8.15E-2, 8.15E-2, 1.28E-1, 8.01} ...
));
C = [
    1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0; %x
    0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0; %y
    0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0; %z
    0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0; %phi
    0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0; %theta
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0; %psi
];

%Primer viaje
x0 = [0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0];
yr = [0; 5; 5; 0; 0; 0];
[t1, X1] = viaje(yr, x0, 60, ai, vp, A, B, C);
%Segundo viaje
x0 = transpose(X1(end,1:12));
yr = [5; 5; 10; 0; 0; 0];
[t2, X2] = viaje(yr, x0, 60, ai, vp, A, B, C);
%Tercer viaje
x0 = transpose(X2(end,1:12));
yr = [5; 0; 5; 0; 0; 0];
[t3, X3] = viaje(yr, x0, 60, ai, vp, A, B, C);
%Cuarto viaje
x0 = transpose(X3(end,1:12));
yr = [0; 0; 0; 0; 0; 0];
[t4, X4] = viaje(yr, x0, 60, ai, vp, A, B, C);


f = figure('Position', [630 250 1280 720]);
%Velocidad
subplot(2, 2, 1);
plot( ...
     [t1; t2+t1(end); t3+t2(end)+t1(end); t4+t3(end)+t2(end)+t1(end)], [X1(:,2); X2(:,2); X3(:,2); X4(:,2)], ...
     [t1; t2+t1(end); t3+t2(end)+t1(end); t4+t3(end)+t2(end)+t1(end)], [X1(:,4); X2(:,4); X3(:,4); X4(:,4)] ...
)
legend("dx", "dy");
title("Velocidad");
grid on
%Velocidad vertical
subplot(2, 2, 2);
plot( ...
    [t1; t2+t1(end); t3+t2(end)+t1(end); t4+t3(end)+t2(end)+t1(end)], [X1(:,5); X2(:,5); X3(:,5); X4(:,5)], ...
    [t1; t2+t1(end); t3+t2(end)+t1(end); t4+t3(end)+t2(end)+t1(end)], [X1(:,6); X2(:,6); X3(:,6); X4(:,6)] ...
)
legend("z", "dz");
title("Altura y velocidad vertical");
grid on
%Inclinación
subplot(2, 2, 4);
plot( ...
    [t1; t2+t1(end); t3+t2(end)+t1(end); t4+t3(end)+t2(end)+t1(end)], [X1(:,7); X2(:,7); X3(:,7); X4(:,7)], ...
    [t1; t2+t1(end); t3+t2(end)+t1(end); t4+t3(end)+t2(end)+t1(end)], [X1(:,9); X2(:,9); X3(:,9); X4(:,9)], ...
    [t1; t2+t1(end); t3+t2(end)+t1(end); t4+t3(end)+t2(end)+t1(end)], [X1(:,11); X2(:,11); X3(:,11); X4(:,11)] ...
)
legend("phi", "theta", "psi");
title("Inclinación");
grid on
%Mapa
subplot(2, 2, 3);
plot([X1(:, 1); X2(:,1); X3(:,1); X4(:,1)], [X1(:, 3); X2(:,3); X3(:,3); X4(:,3)]);
title("Trayectoria");
grid on