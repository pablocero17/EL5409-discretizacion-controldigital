# Discretización y ecuación de diferencias

**Laboratorio de Control Automático (EL5409)** · Prof. Pablo César Rodríguez Vargas

Enlace del repositorio: https://github.com/pablocero17/EL5409-discretizacion-controldigital

Material de la clase sobre cómo pasar un sistema de control del tiempo continuo al tiempo discreto, para programarlo en un computador o un microcontrolador. Incluye la presentación en PDF, los ejemplos en MATLAB y los mismos ejemplos programados en Arduino.

## Descargar los archivos

1. Presione el botón verde **`<> Code`**, en la parte superior de esta página.
2. Seleccione **Download ZIP**.
3. Descomprima el archivo en su computadora.

> No se necesita una cuenta de GitHub para descargar.

## ¿De qué trata la clase?

Un controlador digital mide la salida de la planta cada **T** segundos (periodo de muestreo), calcula la acción de control con una **ecuación de diferencias** y la mantiene constante hasta la siguiente muestra. La clase recorre ese camino completo, del modelo continuo al código:

```
G(s)  ──►  escoger T  ──►  G(z) = c2d(G, T)  ──►  ecuación de diferencias  ──►  código (MATLAB / Arduino)
```

| Tema | Contenido |
| --- | --- |
| 1. Fundamentos del control digital | Esquema del lazo digital (A/D, controlador, D/A con ZOH), selección del periodo de muestreo, señales discretas y el operador retardo $z^{-1}$ |
| 2. Filtrado de la medición | Filtro anti-*aliasing*, filtros causales (exponencial, media móvil, Butterworth) y no causales (mediana, Savitzky-Golay, fase cero) |
| 3. Métodos de discretización | `c2d` con `zoh`, `impulse`, `tustin`, `matched`, `foh`, `least-squares`; deducción del retenedor de orden cero |
| 4. Del dominio z a la ecuación de diferencias | Procedimiento en 4 pasos, resuelto con los dos ejemplos de la clase |
| 5. Implementación del compensador | Despeje de $G_c(z)$, condición de realizabilidad y diagrama de bloques con retardos |
| 6. PI y PID discretos | PID ideal, PI y PID discretos en forma incremental: $u(k) = u(k-1) + A\,e(k) + B\,e(k-1) + C\,e(k-2)$ |

### Ejemplos que se usan en toda la clase (T = 0.5 s)

| Ejemplo | Planta continua | Función discreta (ZOH) | Ecuación de diferencias |
| --- | --- | --- | --- |
| 1 | $G(s) = \dfrac{1}{s+1}$ | $\dfrac{0.3935}{z - 0.6065}$ | $x(k) = 0.3935\,u(k-1) + 0.6065\,x(k-1)$ |
| 2 | $G(s) = \dfrac{2}{s^2 + 0.4s + 2}$ | $\dfrac{0.2247z + 0.2099}{z^2 - 1.384z + 0.8187}$ | $x(k) = 0.2247\,u(k-1) + 0.2099\,u(k-2) + 1.384\,x(k-1) - 0.8187\,x(k-2)$ |

> El periodo T = 0.5 s se escogió para que los escalones se vean claramente en las gráficas. Según las reglas de la clase, el valor recomendado para estos sistemas sería T ≤ 0.1 s.

## Contenido del repositorio

```
presentacion/
  discretizacion_ecuacion_diferencias.pdf   Presentación de la clase
matlab/
  ejecutar_todo.m          Ejecuta todos los ejemplos y guarda la consola en registro_ejecucion.txt
  ej1_primer_orden.m       Ejemplo 1: c2d, ecuación de diferencias con un for, comparación con la respuesta continua
  ej2_segundo_orden.m      Ejemplo 2: lo mismo para un sistema de segundo orden, verificado con lsim
  metodos_c2d.m            Compara los métodos de discretización con T = 0.5 s y T = 0.1 s
  filtros_senal.m          Filtros aplicados a una medición con ruido y picos
  pi_pid_discreto.m        PI discreto en lazo cerrado con la planta del ejemplo 1; constantes A, B, C del PID
  nueva_figura.m, guardar_figura.m   Funciones auxiliares para las gráficas
  figuras/                 Gráficas generadas por los scripts (las que aparecen en la presentación)
  registro_ejecucion.txt   Salida de consola esperada (útil para comparar resultados)
arduino/
  ej1_primer_orden/        Ejemplo 1 en Arduino
  ej2_segundo_orden/       Ejemplo 2 en Arduino
  pi_discreto/             PI discreto controlando la planta del ejemplo 1 (planta simulada en el micro)
```

## Cómo usar los archivos

### MATLAB

Requiere MATLAB con **Control System Toolbox** (funciones `tf`, `c2d`, `lsim`, `pid`).

1. Abra MATLAB y cambie la carpeta actual a `matlab/`.
2. Abra un script, por ejemplo `ej1_primer_orden.m`, y ejecútelo por secciones (**Ctrl+Enter** en cada bloque `%%`), o completo con **Run**.
3. Para correr todo de una vez, escriba en la consola: `ejecutar_todo`.

Orden recomendado, el mismo de la presentación: `filtros_senal` → `metodos_c2d` → `ej1_primer_orden` → `ej2_segundo_orden` → `pi_pid_discreto`.

### Arduino

Los sketches no necesitan sensores ni actuadores: la planta se calcula dentro del microcontrolador y los resultados se envían por el puerto serie.

**Con una placa (Arduino Uno):**
1. Abra el archivo `.ino` en el IDE de Arduino.
2. Seleccione la placa *Arduino Uno* y el puerto, y cargue el programa.
3. Abra el **Monitor serie** a **9600 baudios** para ver los valores, o el **Serial Plotter** para ver la curva.

**Sin placa (Tinkercad):** cree un circuito con un Arduino Uno, vaya a *Código* → *Texto*, pegue el contenido del sketch, presione *Iniciar simulación* y abra el monitor serie.

Las primeras muestras deben coincidir con MATLAB. Por ejemplo, en el ejemplo 2: `0, 0.2247, 0.7456, 1.2826, 1.5995`.

## Videos de referencia

- [Sistemas de Control Digital: Controlador PID Digital](https://youtu.be/q90q4TYOpwA)
- [Diseño completo de un controlador PID Digital / PID Arduino](https://youtu.be/F9vyPtHhjQ8)
- [PI y PID discreto en Arduino](https://youtu.be/EEuB2GI9s0o)
- [Implementación de PID discreto en planta física](https://youtu.be/iD-AoALbGH0)

## Bibliografía

- K. Ogata, *Sistemas de control en tiempo discreto*, 2.ª ed. Prentice Hall, 1996.
- C. L. Phillips y H. T. Nagle, *Digital Control System Analysis and Design*, 4.ª ed. Pearson, 2015.
- K. J. Åström y T. Hägglund, *Advanced PID Control*. ISA, 2006.
- MathWorks, documentación de [`c2d`](https://www.mathworks.com/help/control/ref/dynamicsystem.c2d.html) y [`pid`](https://www.mathworks.com/help/control/ref/pid.html).
