clc; clearvars; close all;
dron;

%Cambiar entrada respecto al tiempo a entradas tipo constantes
syms w1c w2c w3c w4c Vxc Vyc
eqs = subs(eqs, {w1(t), w2(t), w3(t), w4(t), Vx(t), Vy(t)}, {w1c, w2c, w3c, w4c, Vxc, Vyc});

%Condición inicial
%         y dy  x dx  z dz  p  q  r ph th ps
Y(1,:) = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];

%tiempo
tiempo = 5;

%Entradas
w1 = 2560; %rad/s
w2 = 2560;
w3 = 2560;
w4 = 2560;
Vx = 0;
Vy = 0;

%% metodo ode 45
I_xx = 8.15e-2;
I_yy = 8.15e-2;	%I_yy
I_zz = 1.28e-1;	%I_zz
L = 0.3;     %L
d = 7.5e-7;	%d
g = 9.81;	%g
k = 3e-6;	%k
m = 8.01 ;	%m 
[V, S] = odeToVectorField(eqs);
F = matlabFunction(V, 'vars', {'Y','I_xx','I_yy','I_zz','L','d','g','k','m','w1c','w2c','w3c','w4c','Vxc','Vyc'});
FF=@(t,z)[z(2);Vy./m-(k.*(cos(z(12)).*sin(z(10))-cos(z(10)).*sin(z(11)).*sin(z(12))).*(w1.^2+w2.^2+w3.^2+w4.^2))./m;z(4);Vx./m+(k.*(sin(z(10)).*sin(z(12))+cos(z(10)).*cos(z(12)).*sin(z(11))).*(w1.^2+w2.^2+w3.^2+w4.^2))./m;z(6);-g+(k.*cos(z(10)).*cos(z(11)).*(w1.^2+w2.^2+w3.^2+w4.^2))./m;-(-I_yy.*z(8).*z(9)+I_zz.*z(8).*z(9)+L.*k.*(w2.^2-w4.^2))./I_xx;-(I_xx.*z(7).*z(9)-I_zz.*z(7).*z(9)+L.*k.*(w1.^2-w3.^2))./I_yy;(d.*(w1.^2-w2.^2+w3.^2-w4.^2)+I_xx.*z(7).*z(8)-I_yy.*z(7).*z(8))./I_zz;z(7)+cos(z(10)).*tan(z(11)).*z(9)+sin(z(10)).*tan(z(11)).*z(8);cos(z(10)).*z(8)-sin(z(10)).*z(9);(cos(z(10)).*z(9))./cos(z(11))+(sin(z(10)).*z(8))./cos(z(11))];
[a,b]=ode45(FF, [0 tiempo], Y(1,:));

%% metodo de euler
C = num2cell([
    8.15e-2	%I_xx
    8.15e-2	%I_yy
    1.28e-1	%I_zz
    0.3     %L
    7.5e-7	%d
    9.81	%g
    3e-6	%k
    8.01 	%m 
]);
h = 1/60;
steps = 300;
for n = 2:steps
   Y(n,:) = Y(n-1,:) + h*F(Y(n-1,:), C{:}, w1, w2, w3, w4, Vx, Vy)';
end

%% Graficar
set(0, 'DefaultAxesFontName', 'times');
set(0, 'DefaultTextFontName', 'times');

plot(a, b(:,5), 0:h:(steps-1)*h, Y(:,5));
legend("ode", "euler");
title("Altura del dron")
xlabel("Tiempo [s]")
ylabel("Altura [m]")
grid on