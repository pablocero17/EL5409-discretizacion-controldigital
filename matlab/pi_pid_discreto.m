%% PI Y PID DISCRETOS: coeficientes A, B, C y simulación con ecuaciones de diferencias
clear; clc; close all;
T = 0.5;

%% 1) PI discreto para la planta del ejemplo 1:  Kp = 1, Ti = 1 s
Kp = 1;  Ti = 1;
A = Kp*(1 + T/(2*Ti));                       % coeficiente de e(k)
B = -Kp*(1 - T/(2*Ti));                      % coeficiente de e(k-1)
fprintf('PI:  u(k) = u(k-1) + %.4f e(k) %+.4f e(k-1)\n', A, B);
Cpi = pid(Kp, Kp/Ti, 0, 'Ts', T, 'IFormula', 'Trapezoidal');    % comprobación
[q, ~] = tfdata(tf(Cpi), 'v');
fprintf('     tfdata(pid):  [%.4f %.4f]\n', q(1), q(2));

% Lazo cerrado: planta x(k) = 0.3935 u(k-1) + 0.6065 x(k-1) y PI incremental
tsim = 10;  k = 0:T:tsim;  N = numel(k);
r = ones(1, N);  x = zeros(1, N);  u = zeros(1, N);
e_1 = 0;  u_1 = 0;  x_1 = 0;
for n = 1:N
    x(n) = 0.3935*u_1 + 0.6065*x_1;          % planta (ejemplo 1)
    e = r(n) - x(n);                         % error
    u(n) = u_1 + A*e + B*e_1;                % PI discreto
    e_1 = e;  u_1 = u(n);  x_1 = x(n);       % memorias
end
s = tf('s');
lazo_c = feedback(Kp*(1 + 1/(Ti*s)) * 1/(s + 1), 1);      % referencia continua
[yc, tc] = step(lazo_c, tsim);
f = nueva_figura(13, 6.5);
plot(tc, yc, 'Color', [0.6 0.6 0.6], 'LineWidth', 2.5); hold on;
stairs(k, x, 'Color', [0.05 0.16 0.36], 'LineWidth', 1.4);
stairs(k, u, 'Color', [0.75 0.54 0], 'LineWidth', 1.2);
xlabel('Tiempo [s]');  ylabel('Amplitud');  ylim([0 1.4]);
legend('Lazo continuo', 'x(k): salida', 'u(k): acción de control', 'Location', 'east');
guardar_figura(f, 'fig_pi_lazo');

%% 2) PID discreto (forma incremental):  Kp = 1, Ti = 1 s, Td = 0.25 s
Td = 0.25;
A = Kp*(1 + T/(2*Ti) + Td/T);
B = -Kp*(1 - T/(2*Ti) + 2*Td/T);
C = Kp*Td/T;
fprintf('PID: u(k) = u(k-1) + %.4f e(k) %+.4f e(k-1) %+.4f e(k-2)\n', A, B, C);
Cpid = pid(Kp, Kp/Ti, Kp*Td, 'Ts', T, 'IFormula', 'Trapezoidal', 'DFormula', 'BackwardEuler');
[q, ~] = tfdata(tf(Cpid), 'v');
fprintf('     tfdata(pid):  [%.4f %.4f %.4f]\n', q(1), q(2), q(3));
