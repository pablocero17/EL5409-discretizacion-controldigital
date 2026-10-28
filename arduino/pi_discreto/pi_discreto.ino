// PI DISCRETO controlando la planta del ejemplo 1 (planta virtual), T = 0.5 s
//     PI:      u(k) = u(k-1) + A e(k) + B e(k-1)      A = Kp(1 + T/2Ti), B = -Kp(1 - T/2Ti)
//     planta:  x(k) = 0.3935 u(k-1) + 0.6065 x(k-1)
// Con una planta real: medir x con analogRead y aplicar u con analogWrite.

const float A = 1.25, B = -0.75;         // PI con Kp = 1, Ti = 1 s
const float U_MIN = 0.0, U_MAX = 5.0;    // límites del actuador
const unsigned long T_MS = 500;

float r = 1.0;                           // referencia
float x = 0;                             // salida de la planta virtual
float e_1 = 0, u_1 = 0;                  // memorias: e(k-1), u(k-1)
unsigned long tAnterior;
int k = 0;

void setup() {
  Serial.begin(9600);
  Serial.println("k,r,x,u");
  tAnterior = millis();
}

void loop() {
  if (millis() - tAnterior < T_MS) return;   // esperar a que pase T
  tAnterior += T_MS;

  x = 0.3935 * u_1 + 0.6065 * x;             // 1) medir (planta virtual)
  float e = r - x;                           // 2) error
  float u = u_1 + A * e + B * e_1;           // 3) PI: ecuación de diferencias
  u = constrain(u, U_MIN, U_MAX);            // 4) límites del actuador
  e_1 = e;  u_1 = u;                         // 5) memorias

  Serial.print(k); Serial.print(',');
  Serial.print(r, 1); Serial.print(',');
  Serial.print(x, 4); Serial.print(',');
  Serial.println(u, 4);
  k++;
}
