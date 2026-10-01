---
layout: default
title: 7. Observador de estados
nav_order: 7
---

# Observador de estados

Una etapa posterior del proyecto consiste en diseñar un observador para reconstruir estados que no se desean medir directamente.

Un observador utiliza:

- El modelo matemático.
- La entrada aplicada al sistema.
- Las salidas disponibles.

para obtener una estimación del vector de estados.

## Modelo

El observador de Luenberger puede expresarse como:

$$
\dot{\hat{x}}
=
A\hat{x}
+
Bu
+
L(y-C\hat{x})
$$

donde:

- $\hat{x}$ corresponde al estado estimado.
- $L$ es la ganancia del observador.
- $y-C\hat{x}$ es el error entre la medición y la salida estimada.

## Error de estimación

Definiendo:

$$
e=x-\hat{x}
$$

la dinámica del error es:

$$
\dot{e}=(A-LC)e
$$

Por lo tanto, los polos del observador corresponden a los valores propios de:

$$
A-LC
$$

## Selección de polos

Los polos del observador no tienen que ser exactamente iguales a los polos del controlador.

Normalmente se seleccionan con una dinámica más rápida que la del sistema controlado, de forma que el error de estimación converja suficientemente rápido.

Sin embargo, seleccionar polos excesivamente rápidos puede incrementar la sensibilidad al ruido experimental.

## Observador de orden reducido

Para este proyecto se contempla la implementación de un observador de tercer orden.

Esto implica utilizar directamente una de las variables disponibles mediante medición y estimar los tres estados restantes.

El diseño definitivo dependerá de la salida seleccionada como medición directa.

## Estado actual

Esta etapa se encuentra actualmente en desarrollo.

Una vez implementada se incluirán:

- Matriz $L$.
- Polos seleccionados.
- Diagrama de Simulink.
- Estados medidos.
- Estados estimados.
- Error de estimación.
- Gráficas superpuestas de $x$ y $\hat{x}$.
