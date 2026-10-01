---
layout: default
title: 4. Modelo matemático
nav_order: 4
---

# Modelo matemático

## Variables de estado

El modelo utilizado emplea el vector:

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

- $\theta$: posición angular del brazo.
- $\alpha$: posición angular del péndulo.
- $\dot{\theta}$: velocidad angular del brazo.
- $\dot{\alpha}$: velocidad angular del péndulo.

## Parámetros

| Parámetro | Valor | Descripción |
|---|---:|---|
| $R_m$ | 7.5 Ω | Resistencia del motor |
| $k_t$ | 0.0422 | Constante de torque |
| $k_m$ | 0.0422 | Constante contraelectromotriz |
| $m_r$ | 0.095 kg | Masa del brazo |
| $r$ | 0.085 m | Longitud característica del brazo |
| $b_r$ | $1\times10^{-3}$ | Fricción del brazo |
| $m_p$ | 0.024 kg | Masa del péndulo |
| $L_p$ | 0.129 m | Longitud del péndulo |
| $l$ | 0.0645 m | Distancia al centro de masa |
| $b_p$ | $5\times10^{-5}$ | Fricción del péndulo |
| $g$ | 9.81 m/s² | Gravedad |

## Momentos de inercia

Para el brazo:

$$
J_r = \frac{m_r r^2}{3}
$$

obteniéndose:

$$
J_r = 2.2879\times10^{-4}\;kg\,m^2
$$

Para el péndulo:

$$
J_p = \frac{m_p L_p^2}{3}
$$

obteniéndose:

$$
J_p = 1.3313\times10^{-4}\;kg\,m^2
$$

## Representación en espacio de estados

El modelo linealizado se expresa como:

$$
\dot{x}=Ax+Bu
$$

$$
y=Cx+Du
$$

La matriz de estados obtenida es:

$$
A =
\begin{bmatrix}
0 & 0 & 1 & 0\\
0 & 0 & 0 & 1\\
0 & 55.1525 & -4.5471 & -0.1816\\
0 & 168.5810 & -4.4942 & -0.5551
\end{bmatrix}
$$

La matriz de entrada es:

$$
B =
\begin{bmatrix}
0\\
0\\
20.6755\\
20.4351
\end{bmatrix}
$$

Para el análisis inicial se consideran disponibles los cuatro estados:

$$
C = I_4
$$

y:

$$
D=
\begin{bmatrix}
0\\
0\\
0\\
0
\end{bmatrix}
$$

## Interpretación

Las primeras dos ecuaciones representan la relación cinemática:

$$
\dot{x}_1=x_3
$$

$$
\dot{x}_2=x_4
$$

Las últimas dos ecuaciones contienen la dinámica acoplada entre el brazo y el péndulo.

El término asociado a $\alpha$ tiene una influencia importante sobre la dinámica, consecuencia de trabajar alrededor del equilibrio invertido.
