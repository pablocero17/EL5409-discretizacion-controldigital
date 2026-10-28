// EJEMPLO 1 - Sistema de primer orden G(s) = 1/(s+1), discretizado con ZOH y T = 0.5 s
//     x(k) = 0.3935 u(k-1) + 0.6065 x(k-1)
// El Arduino calcula la respuesta al escalón y la imprime (Monitor/Serial Plotter).

const float b1 = 0.3935;            // coeficiente de u(k-1)
const float a1 = 0.6065;            // coeficiente de x(k-1)
const unsigned long T_MS = 500;     // periodo de muestreo [ms]

float x_1 = 0, u_1 = 0;             // muestras anteriores: x(k-1), u(k-1)
unsigned long tAnterior;
int k = 0;

void setup() {
  Serial.begin(9600);
  Serial.println("k,u,x");
  tAnterior = millis();
}

void loop() {
  if (millis() - tAnterior < T_MS) return;   // esperar a que pase T
  tAnterior += T_MS;

  float u = 1.0;                             // entrada: escalón unitario
  float x = b1 * u_1 + a1 * x_1;             // <- ecuación de diferencias
  x_1 = x;  u_1 = u;                         // guardar para el siguiente periodo

  Serial.print(k); Serial.print(',');
  Serial.print(u, 1); Serial.print(',');
  Serial.println(x, 4);
  k++;
}
