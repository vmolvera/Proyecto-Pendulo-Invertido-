---
layout: default
title: 4. Control LQR
nav_order: 5
permalink: /control-lqr/
---

# Control LQR

Una vez obtenido el modelo matemático del **QUBE-Servo 3** y verificada la controlabilidad de la planta, se diseñó un controlador **(LQR)** para estabilizar el péndulo alrededor de su posición vertical superior.

El controlador utiliza la realimentación del vector completo de estados:

$$
x=
\begin{bmatrix}
\theta \\
\alpha \\
\dot{\theta} \\
\dot{\alpha}
\end{bmatrix}
$$

donde:

- ($\theta$) Posición angular del brazo rotacional.
- ($\alpha$) Angulo del péndulo respecto a la vertical.
- ($\dot{\theta}$) Velocidad angular del brazo.
- ($\dot{\alpha}$) Velocidad angular del péndulo.

La entrada del sistema corresponde al voltaje aplicado al motor ($$u=V_m$$).

La ley de control implementada es ($$u=-Kx$$), donde ($K$) representa la matriz de ganancias obtenida mediante el diseño LQR.

---

## 4.1 Objetivo del controlador

El objetivo principal del controlador es mantener el péndulo alrededor de la posición de equilibrio vertical superior.

Esta posición es inherentemente inestable, por lo que una perturbación puede provocar que el péndulo se aleje rápidamente del punto de operación si no existe una acción de control capaz de compensar su movimiento.

El controlador LQR utiliza las posiciones y velocidades del sistema para calcular continuamente el voltaje que debe aplicarse al motor.

El movimiento resultante del brazo rotacional permite generar acciones correctivas para mantener el equilibrio del péndulo.

---

## 4.2 Fundamento del LQR

El **Regulador Cuadrático Lineal** determina una matriz de ganancias ($K$) buscando minimizar la función de costo:

$$
J=
\int_{0}^{\infty}
\left(
x^TQx+u^TRu
\right)dt
$$

donde:

- ($x$) Vector de estados.
- ($u$) Señal de control.
- ($Q$) Pondera la importancia de los estados.
- ($R$) Penaliza el esfuerzo de control.

El diseño busca establecer un compromiso entre:

- Mantener los estados próximos al punto de equilibrio.
- Obtener una respuesta suficientemente rápida.
- Evitar acciones de control excesivamente agresivas.
- Mantener el sistema estable.

---

## 4.3 Verificación de controlabilidad

Antes de diseñar el controlador se verificó la controlabilidad mediante:

$$
\mathcal{C}
=
\begin{bmatrix}
B & AB & A^2B & A^3B
\end{bmatrix}
$$

En MATLAB:

```matlab
Co = ctrb(A,B);
rango_C = rank(Co);
```

El resultado obtenido fue ($$rank(\mathcal{C})=4$$)

Como el sistema posee cuatro estados, la planta es **completamente controlable**.

Por lo tanto, es posible proceder con el diseño de un controlador por retroalimentación de estados.

---

## 4.4 Polos de la planta sin control

Antes de implementar el LQR se analizaron los polos de la planta mediante:

```matlab
polos_planta = eig(A);
```

Los polos obtenidos son aproximadamente:

$$
p_1=0
$$

$$
p_2=12.1485
$$

$$
p_3=-14.2556
$$

$$
p_4=-2.9950
$$

La presencia del polo ($$p=12.1485$$) con parte real positiva confirma que la planta es **inestable en lazo abierto**.

Este comportamiento es consistente con la naturaleza física del péndulo invertido, ya que su posición vertical superior no puede mantenerse sin una acción activa de control.

---

## 4.5 Selección de las matrices Q y R

Para el diseño final del controlador se utilizaron:

$$
Q=
\begin{bmatrix}
1 & 0 & 0 & 0\\
0 & 20 & 0 & 0\\
0 & 0 & 0.1 & 0\\
0 & 0 & 0 & 0.1
\end{bmatrix}
$$

y:

$$
R=1
$$

En MATLAB:

```matlab
Q = diag([1 20 0.1 0.1]);
R = 1;
```

Los pesos utilizados son:

| Estado | Variable | Peso |
|---|---|---:|
| $x_1$ | $\theta$ | 1 |
| $x_2$ | $\alpha$ | 20 |
| $x_3$ | $\dot{\theta}$ | 0.1 |
| $x_4$ | $\dot{\alpha}$ | 0.1 |

El segundo estado ($$x_2=\alpha$$), recibe el mayor peso ($$20$$), debido a que el objetivo principal del controlador es mantener el péndulo próximo a la posición vertical superior.

El valor ($$R=1$$) penaliza el esfuerzo de control y permite limitar la agresividad de la acción aplicada al motor.

---

## 4.6 Cálculo de la ganancia K

La matriz de ganancias se obtiene mediante la función `lqr` de MATLAB:

```matlab
[K,S,P] = lqr(A,B,Q,R);
```

La matriz tiene la forma:

$$
K=
\begin{bmatrix}
k_1 & k_2 & k_3 & k_4
\end{bmatrix}
$$

Para los parámetros utilizados se obtiene aproximadamente:

$$
K=
\begin{bmatrix}
-1.0000 &
29.5241 &
-0.9390 &
2.4383
\end{bmatrix}
$$

Por lo tanto, la ley de control es:

$$
u=-Kx
$$

y de forma desarrollada:

$$
u=
-\left(
-1.0000\theta
+
29.5241\alpha
-
0.9390\dot{\theta}
+
2.4383\dot{\alpha}
\right)
$$

Cada elemento de $K$ determina la influencia de un estado específico sobre el voltaje aplicado al motor.

---

## 4.7 Sistema en lazo cerrado

Una vez obtenida la matriz $K$, la dinámica del sistema controlado queda definida por:

$$
\dot{x}=(A-BK)x
$$

por lo tanto:

$$
A_{cl}=A-BK
$$

En MATLAB:

```matlab
Acl = A - B*K;
```

Los polos del sistema en lazo cerrado se calculan mediante:

```matlab
polos_LQR = eig(Acl);
```

Los valores obtenidos son aproximadamente:

$$
p_1=-16.0167
$$

$$
p_2=-12.9444
$$

$$
p_{3,4}
=
-3.2766
\pm
0.7998j
$$

Todos los polos presentan parte real negativa ($$Re(p_i)<0$$) por lo tanto, el sistema en lazo cerrado es estable alrededor del punto de operación considerado.

---

## 4.8 Comparación de polos

La aplicación del controlador modifica la ubicación de los polos de la planta.

### Planta sin control

$$
\left\{
0,\;
12.1485,\;
-14.2556,\;
-2.9950
\right\}
$$

### Planta con LQR

$$
\left\{
-16.0167,\;
-12.9444,\;
-3.2766+0.7998j,\;
-3.2766-0.7998j
\right\}
$$

Antes del control existe un polo positivo, responsable de la inestabilidad del sistema.

Después de aplicar la realimentación LQR, todos los polos se encuentran en el semiplano izquierdo.

Esto confirma matemáticamente el efecto estabilizador del controlador.

---

## 4.9 Verificación de estabilidad en MATLAB

La estabilidad del sistema se verifica automáticamente mediante:

```matlab
if all(real(polos_LQR) < 0)

    disp('LQR ESTABLE: todos los polos estan en el semiplano izquierdo.')

else

    disp('ADVERTENCIA: el sistema LQR no es estable.')

end
```

La condición ($$Re(p_i)<0$$) para todos los polos confirma la estabilidad del sistema linealizado en lazo cerrado.

---

## 4.10 Interpretación de la ley de control

La ecuación ($$u=-Kx$$) indica que el controlador utiliza simultáneamente:

$$
\theta,\quad
\alpha,\quad
\dot{\theta},\quad
\dot{\alpha}
$$

para determinar el voltaje aplicado al motor.

Cuando el péndulo se desvía de la vertical, la realimentación modifica el voltaje aplicado al motor para producir un movimiento correctivo del brazo.

---

## 4.11 Implementación del LQR en Simulink

Después del diseño en MATLAB, la ganancia ($K$) se incorpora al modelo de Simulink.

La cadena principal del controlador es:

```text
State X
   ↓
[θ  α  θ̇  α̇]ᵀ
   ↓
Ganancia -K
   ↓
Enable Balance Control
   ↓
Saturación
   ↓
Voltaje del motor
   ↓
QUBE-Servo 3
```

El bloque `State X` proporciona el vector requerido por el controlador.

La ganancia ($$-K$$) permite calcular la acción de control ($$u=-Kx$$).

Posteriormente, la señal pasa por la lógica de habilitación y por el bloque de saturación antes de enviarse al motor.

La saturación evita que la acción de control sobrepase los límites establecidos para el actuador.

---

## 4.12 Control de balance

El controlador implementado funciona únicamente como un controlador de **balance**.

No se implementa una estrategia no lineal de *swing-up* basada en energía.

Por esta razón, durante las pruebas el péndulo debe llevarse manualmente hacia una región cercana a la posición vertical superior.

La habilitación del proyecto considera una zona de operación aproximadamente de     ($$0.175\;rad$$) alrededor de la vertical, equivalente a ($$\pm10^\circ$$) .

Una vez que el péndulo entra en esta región, el controlador comienza a generar acciones correctivas para mantenerlo estable.

```text
function y = fcn(u)
if abs(u) <= 0.175
    y=1;
else
    y=0;
end
end
```

---

## 4.13 Funcionamiento en lazo cerrado

El funcionamiento completo del sistema puede representarse como:

```text
                  QUBE-Servo 3
                       ↓
                    Encoders
                       ↓
                  θ, α, θ̇, α̇
                       ↓
                Vector de estados
                       ↓
                    u = -Kx
                       ↓
                   Saturación
                       ↓
                 Voltaje motor
                       ↓
                  QUBE-Servo 3
                       ↑
                       │
                 Realimentación
```

Este ciclo se ejecuta continuamente durante la operación del sistema.

Cada nueva medición modifica el vector de estados y, por lo tanto, el voltaje calculado por el controlador.
