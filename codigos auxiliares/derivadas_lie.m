clear; clc; close all;

syms x1 x2 x3 g m R L_med b0 b1 b2 b3 real

% Polinômio e sua derivada
Px = b0 + b1*x1 + b2*x1^2 + b3*x1^3;
dPx = diff(Px, x1);

% Vetores f(x) e g(x) conforme sua dedução
f = [x2; 
     g - (x3^2)/(m*Px); 
     (1/L_med)*(-R*x3 - x3*(2/Px)*x2)];
g_vec = [0; 0; 1/L_med];

% Saída
h = x1;

% Derivadas de Lie
Lfh = jacobian(h, [x1 x2 x3]) * f;
Lf2h = jacobian(Lfh, [x1 x2 x3]) * f;
Lf3h = jacobian(Lf2h, [x1 x2 x3]) * f;
LgLf2h = jacobian(Lf2h, [x1 x2 x3]) * g_vec;
