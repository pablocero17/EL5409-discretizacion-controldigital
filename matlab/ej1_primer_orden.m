%% EJEMPLO 1 - Sistema de primer orden:  G(s) = 1/(s+1),  T = 0.5 s
clear; clc; close all;
s = tf('s');
G = 1/(s + 1);                     % planta en tiempo continuo
T = 0.5;                           % periodo de muestreo [s]

%% 1) Discretizar con retenedor de orden cero (ZOH)
Gz = c2d(G, T, 'zoh')              % resultado: 0.3935 / (z - 0.6065)
[num, den] = tfdata(Gz, 'v');      % num = [0 0.3935]   den = [1 -0.6065]

%% 2) Ecuación de diferencias:  x(k) = 0.3935 u(k-1) + 0.6065 x(k-1)
b1 = num(2);                       % coeficiente de u(k-1)
a1 = -den(2);                      % coeficiente de x(k-1)  (cambia de signo)
fprintf('x(k) = %.4f u(k-1) + %.4f x(k-1)\n', b1, a1);

tsim = 12;  k = 0:T:tsim;  N = numel(k);
u = ones(1, N);                    % escalón unitario
x = zeros(1, N);
for n = 1:N
    x1 = 0;  u1 = 0;               % muestras anteriores (cero antes de empezar)
    if n > 1, x1 = x(n-1);  u1 = u(n-1);  end
    x(n) = b1*u1 + a1*x1;          % <- ecuación de diferencias
end
fprintf('x(1..5) = %s\n', mat2str(x(1:5), 4));

%% 3) Comparar con la respuesta continua
[yc, tc] = step(G, tsim);
f = nueva_figura(13, 6.5);
plot(tc, yc, 'Color', [0.05 0.16 0.36], 'LineWidth', 1.8); hold on;
stairs(k, x, 'Color', [0.75 0.54 0], 'LineWidth', 1.4);
plot(k, x, 'o', 'Color', [0.75 0.54 0], 'MarkerSize', 3.5, 'MarkerFaceColor', [0.75 0.54 0]);
xlabel('Tiempo [s]');  ylabel('Amplitud');  ylim([0 1.15]);
legend('G(s) continua', 'Ecuación de diferencias', 'Location', 'southeast');
guardar_figura(f, 'fig_ej1_primer_orden');
