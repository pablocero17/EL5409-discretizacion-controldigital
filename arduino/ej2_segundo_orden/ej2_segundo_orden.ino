// EJEMPLO 2 - Sistema de segundo orden G(s) = 2/(s^2 + 0.4 s + 2), ZOH, T = 0.5 s
//     x(k) = 0.2247 u(k-1) + 0.2099 u(k-2) + 1.3841 x(k-1) - 0.8187 x(k-2)

const float b1 = 0.2247, b2 = 0.2099;    // coeficientes de u(k-1), u(k-2)
const float a1 = 1.3841, a2 = 0.8187;    // coeficientes de x(k-1), x(k-2)
const unsigned long T_MS = 500;          // periodo de muestreo [ms]

float x_1 = 0, x_2 = 0;                  // x(k-1), x(k-2)
float u_1 = 0, u_2 = 0;                  // u(k-1), u(k-2)
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

  float u = 1.0;                                         // escalón unitario
  float x = b1 * u_1 + b2 * u_2 + a1 * x_1 - a2 * x_2;   // <- ecuación de diferencias
  x_2 = x_1;  x_1 = x;                                   // correr las memorias
  u_2 = u_1;  u_1 = u;

  Serial.print(k); Serial.print(',');
  Serial.print(u, 1); Serial.print(',');
  Serial.println(x, 4);
  k++;
}
