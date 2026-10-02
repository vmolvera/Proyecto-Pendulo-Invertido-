---
layout: default
title: 1. Introducción
nav_order: 2
permalink: /introduccion/
---

# Introducción

El **péndulo invertido** es uno de los sistemas clásicos utilizados para el estudio y validación de técnicas de control debido a que su posición vertical superior corresponde a un punto de equilibrio inherentemente inestable.

Una pequeña perturbación puede provocar que el péndulo se aleje rápidamente de esta posición si no existe una acción de control capaz de compensar su movimiento.

En este proyecto se utiliza la plataforma **QUBE-Servo 3 de Quanser** en configuración de péndulo rotacional invertido para implementar y validar experimentalmente técnicas de **Control Avanzado**, integrando modelado matemático, representación en espacio de estados, control óptimo y estimación de variables.

---

## QUBE-Servo 3

El **QUBE-Servo 3** es una plataforma de control rotacional compuesta por un servomotor, un brazo horizontal, un péndulo y sensores de posición angular.

Para este proyecto se utiliza la configuración de **péndulo invertido**, en la cual el movimiento del brazo rotacional permite generar las acciones necesarias para mantener el péndulo alrededor de su posición vertical superior.

Las principales variables consideradas son:

- ($\theta$) Posición angular del brazo rotacional.
- ($\alpha$) Posición angular del péndulo respecto a la vertical.
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

La entrada de control corresponde al voltaje aplicado al motor ($$u=V_m$$)

---

## Desarrollo del proyecto

El proyecto se desarrolla en dos etapas principales.

### Primera etapa: Control LQR

La primera etapa consiste en diseñar e implementar un **Regulador Cuadrático Lineal (LQR)** para estabilizar el péndulo alrededor de su posición vertical superior.

El controlador utiliza la realimentación de los estados mediante la ley ($$u=-Kx$$) donde:

- ($u$) Acción de control aplicada al motor.
- ($K$) Matriz de ganancias del controlador.
- ($x$) Vector de estados del sistema.

---

### Segunda etapa: Estimación de estados

La segunda etapa se concentra en la estimación de variables que no se obtienen directamente de la misma manera que las posiciones medidas por los encoders.

En particular, se busca obtener estimaciones de las velocidades angulares ($$\dot{\theta}$$) y ($$\dot{\alpha}$$).

La implementación desarrollada utiliza un **observador de tercer orden** para procesar las señales de posición y obtener estimaciones de posición y velocidad.

Posteriormente, su comportamiento se compara con un observador de primer orden utilizada también para estimar las velocidades a partir de las posiciones medidas.

Esta comparación permite analizar diferencias en rapidez de respuesta, suavidad, desfase y comportamiento en frecuencia.

---

## Implementación experimental

El desarrollo del proyecto combina herramientas de hardware y software para pasar del modelo matemático a una implementación física en tiempo real.

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
- Herramientas de Quanser para la comunicación con el QUBE-Servo 3.

MATLAB se utiliza principalmente para el cálculo de parámetros, construcción del modelo, análisis de controlabilidad, diseño del LQR y análisis del observador.

Simulink permite implementar posteriormente el sistema de control, adquirir las señales de los encoders y ejecutar las pruebas sobre la plataforma física.
