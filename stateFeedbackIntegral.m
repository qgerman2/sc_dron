clc; clearvars; close all hidden; clear global 

global ai vp f sld
% Variables state-feedback
ai = 0.1;
vp = round([-0.4500;   -0.4200;   -0.4400;   -0.4200;   -0.4500;   -0.4300;   -0.4500;   -0.4400;   -0.4500;   -0.4400;   -0.4600;   -0.0300], 2);
% Crear sliders
ui = uifigure("Position", [100 350 500 13.5*50]);
sld = zeros(12);
% -Valores propios
for i = 1:12
    sld(i) = uislider(ui, ...
        "Position", [20 (13-i)*50 500-60 3], ...
        "ValueChangedFcn", @(sld, event) actualizarVp(i, round(sld.Value, 2)), ...
        "ValueChangingFcn", @(sld, event) printVal(round(event.Value, 2)), ...        
        "Limits", [-0.5 0], ...
        "MajorTicks", -0.5:0.1:0, ...
        "Value", vp(i)...
    );
end
% -Acción integral
sld_int = uislider(ui, ...
        "Position", [20 13*50 500-60 3], ...
        "ValueChangedFcn", @(sld, event) actualizarAI(round(sld.Value, 2)), ...
        "ValueChangingFcn", @(sld, event) printVal(round(event.Value, 2)), ...        
        "Limits", [0 2], ...
        "MajorTicks", 0:0.5:2, ...
        "Value", ai...
);
% Simular
f = figure('Position', [630 250 1280 720]);
actualizarRespuesta(ai, vp, f);
% Actualizar grafico de respuesta
function actualizarRespuesta(ai, vp, f)
    % Constantes del sistema
    syms k d m L g Ixx Iyy Izz
    % Matrices
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
    % Referencia
    yr = [0; 0; 10; 0; 0; 0];
    p = length(yr);
    % Condicion inicial
    x0 = [0; 0; 0; 0; 5; 0; 0; 0; 0; 0; 0; 0];
    X0 = [x0; C*x0];
    disp(X0);
    % Acción integral
    kz = -ai*ones(1, size(C, 1));
    % Controlador
    K = place(A, B, vp);
    disp(K);
    Ag = A-B*K;
    M = -C*inv(Ag)*B*K;
    xr = M\yr;
    disp(xr);
    % Simulación
    tspan = 0:0.01:200;
    [t, X] = ode15s(@(t, X) ODE(t, X, A, B, C, p, K, xr, kz, yr), tspan, X0);
    % Encontrar entrada generada
    w_estable = sqrt(9.806*8.01/3E-6)/2;
    input = zeros(length(tspan), size(B, 2));
    for i = 1:length(tspan)
        [~, u] = ODE(0, transpose(X(i,:)), A, B, C, p, K, xr, kz, yr);
        input(i,:) = sqrt(u + w_estable^2) * 9.549297; %Conversión de W a RPM
    end
    % Imprimir
    figure(f);
    subplot(2, 2, 1);
    plot(t, X(:, 1), t, X(:, 3), t, X(:, 5), t, X(:, 6));
    legend("x", "y", "z", "dz");
    title("Posición");
    grid on
    subplot(2, 2, 2);
    plot(t, X(:, 7), t, X(:, 9), t, X(:, 11));
    legend("phi", "theta", "psi");
    title("Inclinación");
    grid on
    subplot(2, 2, 3);
    bar(reordercats(categorical( ... 
        {'x','dx','y','dy','z','dz','phi','dphi','theta','dtheta','psi','dpsi'}), ...
        {'x','dx','y','dy','z','dz','phi','dphi','theta','dtheta','psi','dpsi'}), abs(vp));
    title("Valores propios (-)");
    grid on
    subplot(2, 2, 4);
    plot(t, input);
    legend("W1", "W2", "W3", "W4");
    title("Velocidad hélices")
    ylabel("rpm")
    grid on
end
% Ecuación diferencial
function [dXdt, u] = ODE(t, X, A, B, C, p, K, xr, kz, yr)
    x = X(1:end-p);
    z = X(end-p+1:end);
    u = -K*(x-xr) - kz*z;
    dxdt = A*x + B*u;
    dzdt = C*x-yr;
    dXdt = [dxdt; dzdt];
end

% Funciones de slider
function printVal(v)
    clc;
    disp(v)
end
function actualizarVp(i, v)
    global ai vp f sld
    vp(i) = v;
    set(sld(i), 'Value', v);
    disp(transpose(vp));
    actualizarRespuesta(ai, vp, f);
end
function actualizarAI(v)
    global ai vp f
    ai = v;
    disp(transpose(vp));
    actualizarRespuesta(ai, vp, f);
end