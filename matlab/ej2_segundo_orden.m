%% EJEMPLO 2 - Sistema de segundo orden:  G(s) = 2/(s^2 + 0.4 s + 2),  T = 0.5 s
clear; clc; close all;
s = tf('s');
G = 2/(s^2 + 0.4*s + 2);           % planta en tiempo continuo (ganancia DC = 1)
T = 0.5;                           % periodo de muestreo [s]

%% 1) Discretizar con retenedor de orden cero (ZOH)
Gz = c2d(G, T, 'zoh')              % (0.2247 z + 0.2099) / (z^2 - 1.384 z + 0.8187)
[num, den] = tfdata(Gz, 'v');      % num = [0 b1 b2]   den = [1 -a1 a2]

%% 2) Ecuación de diferencias
%   x(k) = b1 u(k-1) + b2 u(k-2) + a1 x(k-1) - a2 x(k-2)
b1 = num(2);  b2 = num(3);
a1 = -den(2);  a2 = den(3);
fprintf('x(k) = %.4f u(k-1) + %.4f u(k-2) + %.4f x(k-1) - %.4f x(k-2)\n', b1, b2, a1, a2);

tsim = 20;  k = 0:T:tsim;  N = numel(k);
u = ones(1, N);                    % escalón unitario
x = zeros(1, N);
for n = 1:N
    x1 = 0;  x2 = 0;  u1 = 0;  u2 = 0;          % muestras anteriores
    if n > 1, x1 = x(n-1);  u1 = u(n-1);  end
    if n > 2, x2 = x(n-2);  u2 = u(n-2);  end
    x(n) = b1*u1 + b2*u2 + a1*x1 - a2*x2;       % <- ecuación de diferencias
end
fprintf('x(1..5) = %s\n', mat2str(x(1:5), 4));
fprintf('Diferencia máxima con lsim: %.1e\n', max(abs(x - lsim(Gz, u, k)')));

%% 3) Comparar con la respuesta continua
[yc, tc] = step(G, tsim);
f = nueva_figura(13, 6.5);
plot(tc, yc, 'Color', [0.05 0.16 0.36], 'LineWidth', 1.8); hold on;
stairs(k, x, 'Color', [0.75 0.54 0], 'LineWidth', 1.4);
plot(k, x, 'o', 'Color', [0.75 0.54 0], 'MarkerSize', 3.5, 'MarkerFaceColor', [0.75 0.54 0]);
xlabel('Tiempo [s]');  ylabel('Amplitud');
legend('G(s) continua', 'Ecuación de diferencias', 'Location', 'southeast');
guardar_figura(f, 'fig_ej2_segundo_orden');
