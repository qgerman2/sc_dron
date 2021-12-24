function [t, X] = viaje(yr, x0, tiempo, ai, vp, A, B, C)
    p = length(yr);
    % Condicion inicial
    disp(x0)
    X0 = [x0; C*x0];
    % Acción integral
    kz = -ai*ones(1, size(C, 1));
    % Controlador
    K = place(A, B, vp);
    Ag = A-B*K;
    M = -C*inv(Ag)*B*K;
    xr = M\yr;
    % Simulación
    % -ode15s
    h = 1/60;
    tspan = 0:h:tiempo;
    [t, X] = ode15s(@(t, X) ODE(t, X, A, B, C, p, K, xr, kz, yr), tspan, X0);
    % Ecuación diferencial
    function [dXdt, u] = ODE(t, X, A, B, C, p, K, xr, kz, yr)
        x = X(1:end-p);
        z = X(end-p+1:end);
        u = -K*(x-xr) - kz*z;
        dxdt = A*x + B*u;
        dzdt = C*x-yr;
        dXdt = [dxdt; dzdt];
    end
end