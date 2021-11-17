clc; clearvars; close all
dron;

% a angulo pequeño

% sin(a) ~ a
eqs = subs(eqs, sin(phi(t)), phi(t));
eqs = subs(eqs, sin(psi(t)), psi(t));
eqs = subs(eqs, sin(theta(t)), theta(t));

% cos(a) ~ 1
eqs = subs(eqs, cos(phi(t)), 1);
eqs = subs(eqs, cos(psi(t)), 1);
eqs = subs(eqs, cos(theta(t)), 1);

% tan(a) ~ a
eqs = subs(eqs, tan(theta(t)), theta(t));

% a*a ~ 0
eqs = subs(eqs, phi(t)*psi(t), 0);
eqs = subs(eqs, psi(t)*theta(t), 0);
eqs = subs(eqs, phi(t)*theta(t), 0);

% q*r ~ 0, p*r ~ 0, q*p ~ 0
eqs = subs(eqs, {q(t)*r(t), p(t)*r(t), q(t)*p(t)}, {0, 0, 0});

% r*theta ~ 0, phi*r ~ 0, phi*q ~ 0
eqs = subs(eqs, {r(t)*theta(t), phi(t)*r(t), phi(t)*q(t)}, {0, 0, 0});

% d2z/dt2 ~ 0
eqs = subs(eqs, (k*theta(t)*(w1(t)^2 + w2(t)^2 + w3(t)^2 + w4(t)^2))/m, theta(t) * g);
eqs = subs(eqs, (k*phi(t)*(w1(t)^2 + w2(t)^2 + w3(t)^2 + w4(t)^2))/m, phi(t) * g);

%nueva definicion de W
syms W1(t) W2(t) W3(t) W4(t)
eqs = subs(eqs, {w1(t)^2, w2(t)^2, w3(t)^2, w4(t)^2}, {W1(t), W2(t), W3(t), W4(t)});
eqs = subs(eqs, (k*(W1(t) + W2(t) + W3(t) + W4(t)))/m - g, (k*(W1(t) + W2(t) + W3(t) + W4(t)))/m);

%las ultimas 3 ecuaciones son redundantes
eqs = formula(eqs);
eqs = eqs(1:6);
eqs = subs(eqs, diff(p(t), t), diff(phi(t), t, 2));
eqs = subs(eqs, diff(q(t), t), diff(theta(t), t, 2));
eqs = subs(eqs, diff(r(t), t), diff(psi(t), t, 2));
