---
layout: default
title: 6. Control LQR
nav_order: 6
---

# Control LQR

Para estabilizar el sistema en su punto de equilibrio inestable se implementó un controlador **Linear Quadratic Regulator (LQR)**.

El controlador LQR calcula una matriz de retroalimentación de estados óptima al minimizar la siguiente función de costo cuadrática:

$$J = \int_0^\infty \left( x^T Q x + u^T R u \right) dt$$

## Ley de control

La realimentación de estados utilizada es:

$$u = -Kx$$

donde:
- $x$ es el vector de estados del sistema.
- $K$ es la matriz de ganancias óptimas LQR.
- $u$ es la señal de voltaje enviada al motor.

## Matrices de Ponderación (Q y R)

Para sintonizar el comportamiento del controlador, se ajustaron las matrices de peso buscando un equilibrio entre la agresividad del péndulo y la suavidad del brazo.

Se utilizó la matriz de estados $Q$:

$$Q = \begin{bmatrix} 1 & 0 & 0 & 0\\ 0 & 20 & 0 & 0\\ 0 & 0 & 0.1 & 0\\ 0 & 0 & 0 & 0.1 \end{bmatrix}$$

El peso asignado a $\alpha$ (20) es significativamente mayor que el del resto de las variables debido a que la prioridad crítica del sistema es mantener el péndulo invertido. A las velocidades ($\dot{\theta}$ y $\dot{\alpha}$) se les asignó un peso bajo (0.1) para evitar que el controlador amplifique el ruido y genere oscilaciones indeseadas.

Se utilizó el escalar de entrada $R$:

$$R = 1$$

Un valor de $R=1$ establece una penalización equitativa sobre el esfuerzo de control ($u$), garantizando que el motor trabaje sin llegar a voltajes destructivos de manera abrupta.

## Ganancia Obtenida y Estabilidad en Lazo Cerrado

Resolviendo la Ecuación Algebraica de Riccati en MATLAB (`lqr(A,B,Q,R)`), se obtuvo la siguiente matriz de ganancias:

$$K = \begin{bmatrix} -1.0000 & 29.5241 & -0.9390 & 2.4383 \end{bmatrix}$$

**Verificación de Estabilidad:** 
Al aplicar esta ley de control, la dinámica de la planta cambia a la matriz de lazo cerrado $A_{cl} = A - BK$. Los nuevos polos del sistema controlados calculados son:

$$
p_1 = -16.0167
$$

$$
p_2 = -12.9444
$$

$$
p_{3,4} = -3.2766 \pm 0.7998i
$$

Dado que todos los polos se ubican en el semiplano izquierdo (parte real estrictamente negativa), se comprobó analíticamente que la ganancia $K$ elegida **estabiliza el sistema asintóticamente**.

## Implementación Experimental

La ganancia $K$ obtenida fue posteriormente exportada al entorno de Quanser/Simulink.

La arquitectura básica del lazo de control consiste en:

**Estados medidos/estimados → Multiplicación por Ganancia (-K) → Saturación de voltaje (±24V) → Motor DC**

Durante las pruebas físicas, al colocar el péndulo cerca de la posición vertical ($\alpha \approx 0$), el controlador LQR comenzó a operar instantáneamente, calculando y ejecutando pequeños movimientos correctivos del brazo rotatorio para mantener al péndulo suspendido contra la gravedad. Este resultado físico es la confirmación definitiva del éxito del modelado y cálculo de control.

## Consideraciones

* **Naturaleza lineal:** El controlador LQR corresponde a un diseño lineal válido exclusivamente alrededor del equilibrio vertical. Solo es efectivo si el péndulo inicia o es llevado manualmente a una zona próxima a $0^\circ$ (típicamente $\pm 10^\circ$).
* **Falta de estrategia de levantamiento:** Por su misma naturaleza lineal local, esta ganancia no sustituye por sí sola a una estrategia de *swing-up*. No tiene la capacidad para inyectar energía y elevar el péndulo desde su posición colgante (reposo inferior) hacia la vertical.
