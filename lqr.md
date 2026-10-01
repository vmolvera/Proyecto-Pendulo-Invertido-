---
layout: default
title: 6. Control LQR
nav_order: 6
---

# Control LQR

Para estabilizar el sistema se implementó un controlador **Linear Quadratic Regulator (LQR)**.

El LQR obtiene una matriz de ganancias que minimiza el funcional:

$$
J=
\int_0^\infty
\left(
x^TQx+u^TRu
\right)dt
$$

## Ley de control

La realimentación de estados utilizada es:

$$
u=-Kx
$$

donde:

- $x$ es el vector de estados.
- $K$ es la ganancia LQR.
- $u$ es la señal enviada al actuador.

## Matriz Q

Se utilizó:

$$
Q=
\begin{bmatrix}
10&0&0&0\\
0&200&0&0\\
0&0&1&0\\
0&0&0&1
\end{bmatrix}
$$

El peso correspondiente a $\alpha$ es mayor debido a que la prioridad principal del controlador consiste en mantener al péndulo alrededor de la posición vertical.

## Matriz R

Se utilizó:

$$
R=0.01
$$

La matriz $R$ penaliza el esfuerzo de control.

## Ganancia obtenida

Mediante MATLAB se obtuvo aproximadamente:

$$
K=
\begin{bmatrix}
-3.1623 &
50.5188 &
-2.0542 &
4.4057
\end{bmatrix}
$$

Por lo tanto:

$$
u=-Kx
$$

## Implementación experimental

La ganancia obtenida en MATLAB fue posteriormente implementada en Simulink.

La estructura básica es:

**Estados → -K → Saturación → Motor**

Durante las pruebas físicas, al colocar el péndulo cerca de la posición vertical, el controlador fue capaz de generar movimientos correctivos del brazo y mantener el péndulo invertido.

Este resultado confirma experimentalmente el funcionamiento del controlador LQR alrededor del punto de operación para el cual fue diseñado.

## Consideraciones

El controlador LQR corresponde a un controlador lineal diseñado alrededor del equilibrio vertical.

Por esta razón no sustituye por sí solo a una estrategia de swing-up para elevar el péndulo desde su posición inferior.

La estabilización se realiza cuando el péndulo se encuentra suficientemente próximo a la región vertical.
