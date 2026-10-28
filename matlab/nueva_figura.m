function f = nueva_figura(ancho, alto)
%NUEVA_FIGURA  Figura con fondo claro y tamaño en centímetros (para la presentación).
f = figure('Units', 'centimeters', 'Position', [2 2 ancho alto], 'Color', 'w');
try f.Theme = 'light'; catch, end            % R2025a+ puede abrir figuras en tema oscuro
set(f, 'DefaultAxesFontSize', 10, 'DefaultLineLineWidth', 1.4, ...
       'DefaultAxesXGrid', 'on', 'DefaultAxesYGrid', 'on', 'DefaultAxesGridAlpha', 0.25);
end
