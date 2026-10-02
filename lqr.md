---
layout: default
title: 4. Control LQR
nav_order: 5
permalink: /control-lqr/
---

# Control LQR

Una vez obtenido el modelo matemático del **QUBE-Servo 3** y verificada la controlabilidad de la planta, se diseñó un controlador **Linear Quadratic Regulator (LQR)** para mantener el péndulo alrededor de su posición vertical superior.

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

- $\theta$ representa la posición angular del brazo rotacional.
- $\alpha$ representa el ángulo del péndulo respecto a la vertical.
- $\dot{\theta}$ representa la velocidad angular del brazo.
- $\dot{\alpha}$ representa la velocidad angular del péndulo.

La entrada del sistema corresponde al voltaje aplicado al motor:

$$
u=V_m
$$

La ley de control implementada es:

$$
u=-Kx
$$

donde $K$ representa la matriz de ganancias obtenida mediante el diseño LQR.

---

## 4.1 Objetivo del controlador

El objetivo principal del controlador es mantener el péndulo alrededor de la posición de equilibrio vertical superior.

Esta posición es naturalmente inestable, por lo que cualquier perturbación puede provocar que el péndulo se aleje rápidamente del punto de operación si no existe una acción de control.

El LQR utiliza las posiciones y velocidades del sistema para determinar continuamente el voltaje que debe aplicarse al motor.

El movimiento resultante del brazo rotacional permite compensar las desviaciones del péndulo.

---

## 4.2 Fundamento del LQR

El Regulador Cuadrático Lineal determina la matriz de ganancias $K$ buscando minimizar una función de costo cuadrática:

$$
J=
\int_{0}^{\infty}
\left(
x^TQx+u^TRu
\right)dt
$$

donde:

- $x$ representa el vector de estados.
- $u$ representa la señal de control.
- $Q$ pondera el error asociado a los estados.
- $R$ pondera el esfuerzo de control.

De esta manera, el diseño busca un compromiso entre:

- La estabilidad del sistema.
- La desviación de los estados con respecto al equilibrio.
- La rapidez de respuesta.
- El esfuerzo requerido por el motor.

---

## 4.3 Verificación de controlabilidad

Antes de diseñar el controlador LQR se verificó que el sistema fuera completamente controlable.

La matriz de controlabilidad se define como:

$$
\mathcal{C}
=
\begin{bmatrix}
B & AB & A^2B & A^3B
\end{bmatrix}
$$

En MATLAB se implementó mediante:

```matlab
Co = ctrb(A,B);
rango_C = rank(Co);
```

El resultado obtenido fue:

$$
rank(\mathcal{C})=4
$$

Como el sistema posee cuatro estados, el resultado indica que la planta es:

**Completamente controlable.**

Por lo tanto, todos los modos dinámicos del sistema pueden modificarse mediante la entrada disponible.

---

## 4.4 Polos de la planta sin control

Antes de implementar la realimentación se analizaron los polos de la planta mediante:

```matlab
polos_planta = eig(A);
```

Con el modelo utilizado se obtienen aproximadamente:

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

La presencia del polo:

$$
p=12.1485
$$

en el semiplano derecho confirma que el modelo del péndulo invertido es **inestable en lazo abierto**.

Esto corresponde al comportamiento físico esperado: el péndulo no puede mantenerse naturalmente en su posición vertical superior sin una acción activa de control.

---

## 4.5 Selección de las matrices Q y R

Para la versión actual del controlador se utilizan las matrices:

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

La matriz $Q$ determina la importancia relativa de los diferentes estados dentro de la función de costo.

En particular, el segundo estado:

$$
x_2=\alpha
$$

recibe un peso de:

$$
20
$$

mayor que el asignado al resto de las variables.

Esto refleja la prioridad de mantener el ángulo del péndulo próximo a la posición vertical.

Los pesos utilizados son:

| Estado | Variable | Peso |
|---|---|---:|
| $x_1$ | $\theta$ | 1 |
| $x_2$ | $\alpha$ | 20 |
| $x_3$ | $\dot{\theta}$ | 0.1 |
| $x_4$ | $\dot{\alpha}$ | 0.1 |

Por otro lado:

$$
R=1
$$

penaliza el esfuerzo de control aplicado al motor.

---

## 4.6 Cálculo de la ganancia K

La matriz de ganancias óptima se obtiene mediante la función `lqr` de MATLAB:

```matlab
[K,S,P] = lqr(A,B,Q,R);
```

La matriz tiene la estructura:

$$
K=
\begin{bmatrix}
k_1 & k_2 & k_3 & k_4
\end{bmatrix}
$$

Utilizando los parámetros y matrices de la versión actual del programa, se obtiene aproximadamente:

$$
K=
\begin{bmatrix}
-1.0000 &
29.5241 &
-0.9390 &
2.4383
\end{bmatrix}
$$

Por lo tanto, la ley de control queda aproximadamente:

$$
u=
-
\begin{bmatrix}
-1.0000 &
29.5241 &
-0.9390 &
2.4383
\end{bmatrix}
x
$$

o, de forma desarrollada:

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

Cada término representa la contribución de una variable del sistema al voltaje calculado por el controlador.

---

## 4.7 Sistema en lazo cerrado

Una vez obtenida la matriz $K$, la dinámica de la planta controlada queda determinada por:

$$
\dot{x}
=
(A-BK)x
$$

por lo tanto:

$$
A_{cl}=A-BK
$$

En MATLAB:

```matlab
Acl = A - B*K;
```

Los polos del sistema controlado se calculan mediante:

```matlab
polos_LQR = eig(Acl);
```

Utilizando la configuración actual se obtienen aproximadamente:

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

Todos los polos poseen parte real negativa.

Por lo tanto, el sistema controlado es estable alrededor del punto de operación considerado.

---

## 4.8 Comparación de polos

La realimentación LQR modifica significativamente la ubicación de los polos.

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

Antes del control existe un polo positivo, responsable de la inestabilidad del péndulo.

Después de aplicar la realimentación LQR todos los polos se encuentran en el semiplano izquierdo.

Esto confirma matemáticamente el efecto estabilizador del controlador.

<!--
IMAGEN PENDIENTE OPCIONAL

Posteriormente se puede generar una gráfica del plano complejo
comparando los polos antes y después del LQR.

Nombre sugerido:

assets/images/polos_lqr.png

Después quitar los comentarios:

![Comparación de polos]( {{ site.baseurl }}/assets/images/polos_lqr.png )

*Figura 1. Comparación entre los polos de la planta sin control y los polos del sistema con LQR.*
-->

---

## 4.9 Verificación de estabilidad en MATLAB

El programa realiza automáticamente una comprobación de estabilidad:

```matlab
if all(real(polos_LQR) < 0)
    disp('LQR ESTABLE: todos los polos estan en el semiplano izquierdo.')
else
    disp('ADVERTENCIA: el sistema LQR no es estable.')
end
```

La condición:

$$
Re(p_i)<0
$$

para todos los polos indica que el sistema en lazo cerrado es estable.

---

## 4.10 Interpretación de la ley de control

La ecuación:

$$
u=-Kx
$$

indica que el controlador utiliza simultáneamente:

$$
\theta,\quad
\alpha,\quad
\dot{\theta},\quad
\dot{\alpha}
$$

para calcular el voltaje aplicado al motor.

De forma conceptual:

```text
θ
α
θ̇
α̇
 │
 └──────────────┐
                ↓
             x(t)
                ↓
              -K
                ↓
             u(t)
                ↓
        Motor QUBE-Servo 3
```

Cuando el péndulo se desvía de la vertical, el controlador modifica el movimiento del brazo para intentar compensar dicha desviación.

---

## 4.11 Implementación del LQR en Simulink

Después del diseño en MATLAB, la ganancia $K$ se implementa dentro del modelo de Simulink.

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
Voltaje
   ↓
QUBE-Servo 3
```

El bloque `State X` proporciona el vector de estados requerido por el controlador.

La ganancia:

$$
-K
$$

genera la acción de control.

Posteriormente, la señal pasa por la lógica de habilitación y por los límites establecidos para el actuador antes de enviarse al motor.

<!--
IMAGEN PENDIENTE

Utilizar una captura donde se observe principalmente:
State X → LQR / -K → Enable Balance Control → Motor.

Nombre sugerido:

assets/images/lqr_simulink.png

Después quitar los comentarios:

![Implementación LQR en Simulink]({{ site.baseurl }}/assets/images/lqr_simulink.png)

*Figura 2. Implementación del controlador LQR dentro del modelo de Simulink.*
-->

---

## 4.12 Control de balance

El controlador implementado se utiliza como un controlador de **balance**.

Esto significa que el sistema no realiza automáticamente el movimiento necesario para elevar el péndulo desde su posición inferior.

No se implementa una estrategia de:

**Swing-up**

basada en energía.

En su lugar, durante la prueba experimental el péndulo se lleva manualmente hasta una región cercana a la posición vertical superior.

Una vez que el péndulo entra en la zona de operación, el controlador LQR comienza a actuar.

La especificación del proyecto establece una región cercana a:

$$
\pm10^\circ
$$

alrededor de la vertical para realizar esta operación.

---

## 4.13 Funcionamiento en lazo cerrado

El proceso completo puede representarse como:

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

Cada nueva desviación medida modifica el voltaje calculado por el controlador.

---

## 4.14 Procedimiento experimental

El procedimiento utilizado para realizar la prueba del LQR puede resumirse en:

1. Conectar el QUBE-Servo 3.

2. Ejecutar el modelo de Simulink.

3. Verificar las señales provenientes de los encoders.

4. Comprobar las posiciones:

$$
\theta
$$

y:

$$
\alpha
$$

5. Verificar la construcción correcta del vector de estados.

6. Mantener inicialmente deshabilitado el control.

7. Elevar manualmente el péndulo hacia la región vertical.

8. Habilitar el controlador LQR.

9. Permitir que la ley:

$$
u=-Kx
$$

calcule el voltaje requerido por el motor.

10. Observar los movimientos correctivos del brazo.

11. Registrar las señales del sistema.

12. Analizar posteriormente el comportamiento obtenido.

---

## 4.15 Validación experimental

Durante las pruebas físicas realizadas con el QUBE-Servo 3 se verificó que el controlador pudiera actuar alrededor de la posición vertical.

Cuando el péndulo es llevado manualmente hasta la región de operación, el brazo comienza a generar movimientos correctivos.

Estos movimientos buscan compensar continuamente las desviaciones del péndulo y conservar el equilibrio.

<!--
IMAGEN / VIDEO PENDIENTE

Aquí puede colocarse UNA evidencia breve del QUBE funcionando.

Nombre sugerido para fotografía:

assets/images/qube_lqr_balance.png

Después activar:

![Prueba física del LQR]({{ site.baseurl }}/assets/images/qube_lqr_balance.png)

*Figura 3. Prueba experimental del controlador LQR sobre el QUBE-Servo 3.*

La evidencia principal, gráficas y video completo se colocarán
en la sección Resultados.
-->

---

## 4.16 Evidencias contempladas

Para documentar posteriormente esta etapa se incluirán:

- Implementación del LQR en Simulink.
- Ubicación de los polos antes y después del control.
- Señal de control aplicada al motor.
- Comportamiento del ángulo del péndulo.
- Movimiento del brazo rotacional.
- Evidencia física del péndulo estabilizado.

Las gráficas cuantitativas correspondientes se presentarán principalmente en la sección **Resultados**.

---

## 4.17 Resumen del diseño LQR

El procedimiento desarrollado puede resumirse mediante:

```text
Modelo matemático
       ↓
Espacio de estados
       ↓
Controlabilidad
       ↓
Polos de la planta
       ↓
Selección de Q y R
       ↓
Cálculo de K
       ↓
u = -Kx
       ↓
Acl = A - BK
       ↓
Polos en lazo cerrado
       ↓
Verificación de estabilidad
       ↓
Implementación en Simulink
       ↓
Prueba sobre QUBE-Servo 3
```

El controlador LQR constituye la primera estrategia de control avanzada implementada durante el proyecto y permite estabilizar el péndulo alrededor de su posición vertical superior.
