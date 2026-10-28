function ejecutar_todo
%EJECUTAR_TODO  Ejecuta todos los ejemplos y guarda la consola en registro_ejecucion.txt
scripts = {'ej1_primer_orden', 'ej2_segundo_orden', 'metodos_c2d', 'filtros_senal', 'pi_pid_discreto'};
if isfile('registro_ejecucion.txt'), delete('registro_ejecucion.txt'); end
diary('registro_ejecucion.txt');
for i = 1:numel(scripts)
    fprintf('\n================ %s ================\n', scripts{i});
    evalin('base', scripts{i});
end
diary off;
end
