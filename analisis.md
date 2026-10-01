---
layout: default
title: 5. Análisis del sistema
nav_order: 5
---

# Análisis del sistema

Una vez obtenido el modelo en espacio de estados se analizaron sus propiedades antes de diseñar el controlador.

## Polos en lazo abierto

Los polos corresponden a los valores propios de la matriz $A$:

$$
\lambda(A)
$$

Los valores obtenidos fueron:

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

## Estabilidad

Uno de los polos se encuentra en:

$$
s=12.1485
$$

y posee parte real positiva.

Por lo tanto, el modelo linealizado del péndulo invertido es **inestable en lazo abierto**.

Este resultado es coherente con el comportamiento físico del sistema: pequeñas perturbaciones alrededor de la posición vertical provocan que el péndulo se aleje del punto de equilibrio si no existe una acción de control.

## Controlabilidad

Para determinar si es posible controlar todos los estados se construye la matriz de controlabilidad:

$$
\mathcal{C}
=
\begin{bmatrix}
B & AB & A^2B & A^3B
\end{bmatrix}
$$

El resultado obtenido es:

$$
rank(\mathcal{C})=4
$$

El sistema posee cuatro estados y la matriz de controlabilidad tiene rango cuatro.

Por lo tanto:

**El sistema es completamente controlable.**

## Importancia

La controlabilidad garantiza que mediante una entrada apropiada es posible modificar la dinámica de todos los modos del sistema.

Esto permite diseñar posteriormente el controlador LQR.
