function guardar_figura(f, nombre)
%GUARDAR_FIGURA  Guarda la figura en figuras/<nombre>.pdf (vectorial).
if ~isfolder('figuras'), mkdir('figuras'); end
exportgraphics(f, fullfile('figuras', [nombre '.pdf']), 'ContentType', 'vector', ...
               'BackgroundColor', 'white');
end
