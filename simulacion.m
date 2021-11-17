clc; clearvars; close all;
dron;

%Cambiar entrada respecto al tiempo a entradas tipo constantes
syms w1c w2c w3c w4c Vxc Vyc
eqs = subs(eqs, {w1(t), w2(t), w3(t), w4(t), Vx(t), Vy(t)}, {w1c, w2c, w3c, w4c, Vxc, Vyc});

%Constantes
h = 1/60;
C = num2cell([
    5e-3	%I_xx
    5e-3	%I_yy
    10e-3	%I_zz
    0.3     %L
    1e-6	%d
    9.81	%g
    3e-6	%k
    0.5 	%m 
]);

%convertir a sistema de primer orden
[V, S] = odeToVectorField(eqs);
F = matlabFunction(V, 'vars', {'Y','I_xx','I_yy','I_zz','L','d','g','k','m','w1c','w2c','w3c','w4c','Vxc','Vyc'});

%Condición inicial
%         y dy  x dx  z dz  p  q  r ph th ps
Y(1,:) = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];

%entradas
w1 = 650;
w2 = 650;
w3 = 650;
w4 = 650;
Vx = 0;
Vy = 0;

%metodo de euler
steps = 600;
for n = 2:steps
    Y(n,:) = Y(n-1,:) + h*F(Y(n-1,:), C{:}, w1, w2, w3, w4, Vx, Vy)';
end

%Graficar
set(0, 'DefaultAxesFontName', 'times');
set(0, 'DefaultTextFontName', 'times');

plot(0:h:(steps-1)*h, Y(:, 5))
title("Ascenso de dron con hélices a 650 rad/s")
xlabel("Tiempo [s]")
ylabel("Altura [m]")
grid on

