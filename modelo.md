---
layout: default
title: 4. Modelo matemático
nav_order: 4
---

# Modelo matemático

## Variables de estado

El modelo utilizado emplea el vector de estados para representar la dinámica de la plataforma Quanser Aero 2:

$$
x =
\begin{bmatrix}
\theta \\
\alpha \\
\dot{\theta} \\
\dot{\alpha}
\end{bmatrix}
$$

donde:

- $\theta$: posición angular del brazo [rad].
- $\alpha$: posición angular del péndulo respecto a la vertical [rad].
- $\dot{\theta}$: velocidad angular del brazo [rad/s].
- $\dot{\alpha}$: velocidad angular del péndulo [rad/s].

## Parámetros

| Parámetro | Valor | Descripción |
|---|---:|---|
| $R_m$ | 7.5 Ω | Resistencia del motor |
| $k_t$ | 0.0422 N·m/A | Constante de torque |
| $k_m$ | 0.0422 V·s/rad | Constante contraelectromotriz |
| $m_r$ | 0.095 kg | Masa del brazo rotatorio |
| $r$ | 0.085 m | Longitud característica del brazo |
| $b_r$ | $1\times10^{-3}$ N·m·s/rad | Amortiguamiento del brazo |
| $m_p$ | 0.024 kg | Masa del péndulo |
| $L_p$ | 0.129 m | Longitud del péndulo |
| $l_{cm}$ | 0.0645 m | Distancia al centro de masa del péndulo |
| $b_p$ | $5\times10^{-5}$ N·m·s/rad | Amortiguamiento del péndulo |
| $g$ | 9.81 m/s² | Aceleración de la gravedad |

## Momentos de inercia y Acoplamiento

Para el brazo rotatorio:

$$
J_r = \frac{m_r r^2}{3} = 2.2879\times10^{-4}\;kg\cdot m^2
$$

Para el péndulo:

$$
J_p = \frac{m_p L_p^2}{3} = 1.3313\times10^{-4}\;kg\cdot m^2
$$

Inercia total acoplada del sistema ($J_t$):
Este término es fundamental para el cálculo del espacio de estados, ya que representa la interacción física entre las inercias individuales y el centro de masa:

$$
J_t = (J_r + m_p r^2)J_p - m_p^2 l_{cm}^2 r^2 = 3.6229\times10^{-8}
$$

## Representación en espacio de estados

El modelo linealizado alrededor de su punto de equilibrio inestable se expresa como:

$$
\dot{x}=Ax+Bu
$$

$$
y=Cx+Du
$$

Sustituyendo los parámetros físicos y las inercias calculadas, la matriz de dinámica del sistema obtenida es:

$$
A =
\begin{bmatrix}
0 & 0 & 1 & 0\\
0 & 0 & 0 & 1\\
0 & 55.1525 & -4.5471 & -0.1816\\
0 & 168.5810 & -4.4942 & -0.5551
\end{bmatrix}
$$

La matriz de entrada, que relaciona el voltaje del motor ($u$) con las aceleraciones, es:

$$
B =
\begin{bmatrix}
0\\
0\\
20.6755\\
20.4351
\end{bmatrix}
$$

Para el análisis inicial, la matriz de salida asume la disponibilidad de los cuatro estados:

$$
C = I_4
$$

y la matriz de transmisión directa es nula:

$$
D=
\begin{bmatrix}
0\\
0\\
0\\
0
\end{bmatrix}
$$

## Interpretación de la Dinámica

*   **Cinemática:** Las primeras dos filas de la matriz $A$ representan la relación cinemática directa ($\dot{x}_1=x_3$ y $\dot{x}_2=x_4$).
*   **Acoplamiento Inestable:** El valor de $168.5810$ en la matriz $A$ (término $A_{42}$) demuestra una fuerte dependencia de la aceleración del péndulo respecto a su propio ángulo $\alpha$. Al ser un valor positivo de gran magnitud, confirma matemáticamente que el sistema es un péndulo invertido inestable que caerá rápidamente por la gravedad si no se aplica una acción de control.
*   **Autoridad de Control:** Los valores en la matriz $B$ ($20.6755$ y $20.4351$) indican que el voltaje del motor influye casi en la misma proporción sobre la aceleración del brazo y la del péndulo.
