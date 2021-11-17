%% inicio
clc; clearvars; close all
espacioestado;

A = double(subs(A, g, 9.806));
B = double(subs(B, ...
    {k,         d,   L,     Ixx,     Iyy,    Izz,     m}, ... 
    {3E-6, 7.5E-7, 0.3, 8.15E-2, 8.15E-2, 1.28E-1, 8.01} ...
));

sistema = ss(A,B,C,0);

%% escalon
step(sistema, 1000)

%% impulso unitario
impulse(sistema, 100)

%% rampa unitaria
gg = tf(1, [1 0 0]);
impulse(gg*sistema, 50)
