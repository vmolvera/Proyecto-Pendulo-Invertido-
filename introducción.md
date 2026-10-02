---
layout: default
title: 1. Introducción
nav_order: 2
permalink: /introduccion/
---

# Introducción

El **péndulo invertido** es uno de los sistemas clásicos utilizados para estudiar técnicas de control debido a que su posición vertical superior corresponde a un punto de equilibrio inherentemente inestable.

Una pequeña perturbación puede provocar que el péndulo se aleje rápidamente de dicha posición si no existe una acción de control capaz de compensar su movimiento.

En este proyecto se utiliza la plataforma **QUBE-Servo 3 de Quanser** en configuración de péndulo rotacional invertido para implementar y validar experimentalmente técnicas de **Control Avanzado**.

---

## QUBE-Servo 3

El QUBE-Servo 3 es una plataforma de control rotacional que integra un servomotor, un brazo horizontal, un péndulo y sensores de posición angular.

Para este proyecto se utiliza la configuración de **péndulo invertido**, donde el movimiento del brazo rotacional permite generar las acciones necesarias para mantener el péndulo alrededor de su posición vertical superior.

Las principales variables consideradas son:

- ($\theta$) Posición angular del brazo rotacional.
- ($\alpha$) Posición angular del péndulo.
- ($\dot{\theta}$) Velocidad angular del brazo.
- ($\dot{\alpha}$) Velocidad angular del péndulo.

Estas variables conforman el vector de estados:

$$
x=
\begin{bmatrix}
\theta \\
\alpha \\
\dot{\theta} \\
\dot{\alpha}
\end{bmatrix}
$$

La entrada de control corresponde al voltaje aplicado al motor ($$u = V_m$$)

---

## Desarrollo del proyecto

El proyecto se divide en dos etapas principales.

### Primera etapa: Control LQR

La primera etapa consiste en diseñar e implementar un **Regulador Cuadrático Lineal (LQR)**.

El controlador utiliza la realimentación de los estados del sistema mediante la ley ($$u=-Kx$$) donde:

- ($u$) es la acción de control aplicada al motor.
- ($K$) es la matriz de ganancias del controlador.
- ($x$) es el vector de estados.

El objetivo es mantener el péndulo alrededor de la posición vertical superior.

Debido a que el proyecto se concentra en el control de balance, no se implementa una estrategia no lineal de *swing-up*. El péndulo se lleva manualmente hasta una región cercana a la vertical para que el controlador LQR pueda actuar.

---

### Segunda etapa: Observador de estados

La segunda etapa consiste en implementar un **observador de estados**.

Las técnicas de estimación permiten reconstruir variables del sistema utilizando las mediciones disponibles y un modelo dinámico o cinemático.

En este proyecto se busca analizar principalmente la estimación de las velocidades angulares:

$$
\dot{\theta}
$$

y

$$
\dot{\alpha}
$$

para posteriormente comparar los valores obtenidos mediante distintos métodos de estimación.

La implementación desarrollada contempla un estimador de tercer orden y una comparación con una aproximación de primer orden utilizada para obtener las velocidades a partir de las posiciones medidas.

---

## Implementación experimental

La implementación del proyecto combina herramientas de software y hardware.

### Hardware

- QUBE-Servo 3.
- Servomotor rotacional.
- Brazo rotacional.
- Péndulo.
- Encoder del brazo.
- Encoder del péndulo.

### Software

- MATLAB.
- Simulink.
- Control System Toolbox.
- Herramientas de Quanser para comunicación con el QUBE-Servo 3.

---

## Flujo general

El desarrollo completo del proyecto sigue la secuencia:

```text
Modelo físico
     ↓
Modelo matemático
     ↓
Espacio de estados
     ↓
Análisis de controlabilidad
     ↓
Diseño LQR
     ↓
Implementación en Simulink
     ↓
Prueba experimental
     ↓
Diseño del observador
     ↓
Comparación de estimaciones
     ↓
Análisis de resultados
```
