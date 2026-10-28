%% FILTRADO DE LA SEÑAL MEDIDA (planta del ejemplo 1 con ruido de sensor)
clear; clc; close all;
rng(1);
s = tf('s');
G = 1/(s + 1);
Ts = 0.02;  t = (0:Ts:6)';                    % muestreo rápido del sensor
u = double(t >= 0.5);                         % escalón en t = 0.5 s
y = lsim(G, u, t) + 0.04*randn(size(t));      % medición con ruido
picos = rand(size(t)) < 0.02;                 % 2 % de picos (interferencia)
y(picos) = y(picos) + 0.4*sign(randn(sum(picos), 1));

%% 1) Filtros causales: se pueden programar en el microcontrolador
alfa = 0.2;
y_ema = filter(alfa, [1, alfa-1], y);         % EMA: yf(k) = a y(k) + (1-a) yf(k-1)
n = 7;
y_mm = filter(ones(1, n)/n, 1, y);            % media móvil de n muestras (FIR)

%% 2) Filtros no causales (fase cero): solo para datos ya registrados
y_med = movmedian(y, n);                      % mediana móvil: elimina picos
y_sg  = smoothdata(y, 'sgolay', 15);          % Savitzky-Golay: conserva la forma

%% 3) El EMA es un pasa bajos RC discretizado: 1/(tau_f s + 1)
tau_f = -Ts/log(1 - alfa);                    % constante de tiempo equivalente
fprintf('EMA alfa = %.2f  ->  tau_f = %.3f s,  fc = %.2f Hz\n', alfa, tau_f, 1/(2*pi*tau_f));
Fz = c2d(1/(tau_f*s + 1), Ts, 'zoh')          % mismo filtro: (alfa)/(z - (1-alfa))

%% 4) Gráfica
f = nueva_figura(16, 6.5);
plot(t, y, '.', 'Color', [0.65 0.65 0.65], 'MarkerSize', 5); hold on;
plot(t, y_ema, 'Color', [0.75 0.54 0], 'LineWidth', 1.6);
plot(t, y_mm, 'Color', [0.70 0.13 0.13], 'LineWidth', 1.2);
plot(t, y_med, 'Color', [0.05 0.16 0.36], 'LineWidth', 1.6);
xlabel('Tiempo [s]');  ylabel('Medición');  xlim([0 6]);
legend('Medición con ruido', 'EMA (causal)', 'Media móvil (causal)', 'Mediana móvil (no causal)', ...
       'Location', 'southeast');
guardar_figura(f, 'fig_filtros');
