%% MÉTODOS DE DISCRETIZACIÓN DE c2d (planta del ejemplo 2)
clear; clc; close all;
s = tf('s');
G = 2/(s^2 + 0.4*s + 2);
T = 0.5;

%% 1) Los métodos disponibles en c2d
metodos = {'zoh', 'foh', 'impulse', 'tustin', 'matched'};
for i = 1:numel(metodos)
    Gz = c2d(G, T, metodos{i});
    [num, den] = tfdata(Gz, 'v');
    num(abs(num) < 1e-9) = 0;
    fprintf('%-8s num = %-26s den = %s\n', metodos{i}, mat2str(num, 4), mat2str(den, 4));
end
% Tustin con pre-distorsión: exacto en la frecuencia natural wn = sqrt(2) rad/s
opc = c2dOptions('Method', 'tustin', 'PrewarpFrequency', sqrt(2));
Gz_pw = c2d(G, T, opc);

%% 2) Respuesta al escalón de cada método (T = 0.5 s)
f = nueva_figura(16, 6.5);
col = {[0.05 0.16 0.36], [0.75 0.54 0], [0.18 0.49 0.20], [0.70 0.13 0.13]};
lista = {'zoh', 'tustin', 'matched', 'impulse'};
subplot(1, 2, 1);
[yc, tc] = step(G, 15);  plot(tc, yc, 'Color', [0.6 0.6 0.6], 'LineWidth', 2.5); hold on;
for i = 1:numel(lista)
    [yz, tz] = step(c2d(G, T, lista{i}), 15);
    stairs(tz, yz, 'Color', col{i});
end
title('T = 0.5 s');  xlabel('Tiempo [s]');  ylabel('Amplitud');
legend(['Continuo', lista], 'Location', 'southeast');

%% 3) Lo mismo con T = 0.1 s (cumple T < T_dom/10)
subplot(1, 2, 2);
plot(tc, yc, 'Color', [0.6 0.6 0.6], 'LineWidth', 2.5); hold on;
for i = 1:numel(lista)
    [yz, tz] = step(c2d(G, 0.1, lista{i}), 15);
    stairs(tz, yz, 'Color', col{i});
end
title('T = 0.1 s');  xlabel('Tiempo [s]');
guardar_figura(f, 'fig_metodos_c2d');
