%% inicio
clc; clearvars; close all
espacioestado;

A = double(subs(A, g, 9.806));
B = double(subs(B, ...
    {   k,      d,   L,     Ixx,     Iyy,    Izz,     m}, ... 
    {3E-6, 7.5E-7, 0.3, 8.15E-2, 8.15E-2, 1.28E-1, 8.01} ...
));
sistema = ss(A,B,C,0);

%% escalon
step(sistema, 200)

%% impulso unitario
impulse(sistema, 100)

%% rampa unitaria
gg = tf(1, [1 0 0]);
impulse(gg*sistema, 50)

%% ascenso sin viento
C = [
    0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0;
    0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0;
];
sistema = ss(A,B,C,0);
f = figure(1);
f.Position = [100 100 400 300];
entrada = [
    repelem([wtoW_n(10), wtoW_n(10), wtoW_n(10), wtoW_n(10), 0, 0], length(0:0.1:11.3-0.1), 1);
    repelem([wtoW_n(-10), wtoW_n(-10), wtoW_n(-10), wtoW_n(-10), 0, 0], length(11.3:0.1:22.7-0.1), 1);
    repelem([wtoW_n(0), wtoW_n(0), wtoW_n(0), wtoW_n(0), 0, 0], length(22.7:0.1:25), 1);
];
plot(0:0.1:25, entrada(:, [1 2 3 4]))
legend("W1", "W2", "W3", "W4");
xlabel("Tiempo [s]");
ylabel("Entrada");
grid on
f = figure(2);
f.Position = [100 100 400 300];
h = lsimplot(sistema, entrada, 0:0.1:25);
grid on
setoptions(h, "YLim", {[0, 12], [0, 1]});

%% movimiento lateral sin viento
C = [
    1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0;
    0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0;
    0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0;
];
sistema = ss(A,B,C,0);
f = figure(1);
f.Position = [100 100 400 300];
entrada = [
    repelem([wtoW_n(-3), wtoW_n(0), wtoW_n(3), wtoW_n(0), 0, 0], length(0  :0.1:0.5-0.1), 1);
    repelem([wtoW_n(3), wtoW_n(0), wtoW_n(-3), wtoW_n(0), 0, 0], length(0.5:0.1:1.5-0.1), 1);
    repelem([wtoW_n(-3), wtoW_n(0), wtoW_n(3), wtoW_n(0), 0, 0], length(1.5:0.1:2  -0.1), 1);
    repelem([wtoW_n(0), wtoW_n(0), wtoW_n(0), wtoW_n(0), 0, 0],  length(2  :0.1:4  -0.1), 1);
    repelem([wtoW_n(3), wtoW_n(0), wtoW_n(-3), wtoW_n(0), 0, 0], length(4  :0.1:4.5-0.1), 1);
    repelem([wtoW_n(-3), wtoW_n(0), wtoW_n(3), wtoW_n(0), 0, 0], length(4.5:0.1:5.5-0.1), 1);
    repelem([wtoW_n(3), wtoW_n(0), wtoW_n(-3), wtoW_n(0), 0, 0], length(5.5:0.1:6  -0.1), 1);
    repelem([wtoW_n(0), wtoW_n(0), wtoW_n(0), wtoW_n(0), 0, 0], length(6:0.1:8), 1);
];
plot([0:0.1:8], entrada(:,[1 3]))
xlabel("Tiempo [s]");
ylabel("Entrada");
legend("W1", "W3");
grid on
figure(2)
h = lsimplot(sistema, entrada, 0:0.1:8);
grid on
setoptions(h, "YLim", {[0, 5], [-1, 1], [-0.1, 0.1]});

%% estabilizacion frente al viento
C = [
    1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0;
    0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0;
    0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0;
];
sistema = ss(A,B,C,0);
f = figure(1);
f.Position = [100 100 400 300];
entrada = [
    repelem([wtoW_n(-3), wtoW_n(0), wtoW_n(3), wtoW_n(0), -5, 0], length(0  :0.01:0.45-0.01), 1);
    repelem([wtoW_n(3), wtoW_n(0), wtoW_n(-3), wtoW_n(0), -5, 0], length(0.45:0.01:0.9-0.01), 1);
    repelem([wtoW_n(0), wtoW_n(0), wtoW_n(0), wtoW_n(0), -5, 0], length(0.9:0.01:6-0.01), 1);
    repelem([wtoW_n(1), wtoW_n(0), wtoW_n(-1), wtoW_n(0), -5, 0], length(6:0.01:6.21-0.01), 1);
    repelem([wtoW_n(-1), wtoW_n(0), wtoW_n(1), wtoW_n(0), -5, 0], length(6.21:0.01:6.42-0.01), 1);
    repelem([wtoW_n(0), wtoW_n(0), wtoW_n(0), wtoW_n(0), -5, 0], length(6.42:0.01:10), 1);
];
plot(0:0.01:10, entrada(:, [1 3]));
xlabel("Tiempo [s]");
ylabel("Entrada");
legend("W1", "W3");
grid on
f = figure(2);
h = lsimplot(sistema, entrada, 0:0.01:10);
grid on
setoptions(h, "YLim", {[-2, 2], [-1, 1], [0, 0.08]});