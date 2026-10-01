---
layout: default
title: 8. Implementación en Simulink
nav_order: 8
---

# Implementación en Simulink

El controlador diseñado en MATLAB fue implementado posteriormente en Simulink para realizar pruebas sobre el QUBE-Servo 3.

## Arquitectura general

La implementación puede resumirse como:

**QUBE Encoders → Counts to Angles → State x → LQR → Saturation → QUBE Motor**

## 1. Lectura de encoders

Los encoders proporcionan las posiciones del:

- Brazo rotacional.
- Péndulo.

Las señales inicialmente corresponden a cuentas digitales.

## 2. Counts to Angles

El subsistema **Counts to Angles** transforma las cuentas de los encoders a posiciones angulares.

Esto permite trabajar con señales expresadas en radianes.

Las señales principales son:

$$
\theta
$$

y:

$$
\alpha
$$

## 3. Construcción del vector State x

El controlador requiere:

$$
x=
\begin{bmatrix}
\theta\\
\alpha\\
\dot{\theta}\\
\dot{\alpha}
\end{bmatrix}
$$

Las posiciones se obtienen de los encoders.

Las velocidades son obtenidas a partir del procesamiento de las señales correspondientes.

## 4. Control LQR

El vector completo de estados llega al bloque encargado de implementar:

$$
u=-Kx
$$

utilizando:

$$
K=
\begin{bmatrix}
-3.1623&
50.5188&
-2.0542&
4.4057
\end{bmatrix}
$$

## 5. Saturación

Antes de enviar la señal al motor se limita el voltaje utilizando un bloque de saturación.

Este elemento protege al sistema y evita exigir al actuador valores superiores a los permitidos.

## 6. Motor

La señal limitada se envía finalmente al QUBE-Servo 3.

El motor mueve el brazo horizontal para compensar continuamente la desviación del péndulo.

## 7. Lazo cerrado

El proceso completo se ejecuta continuamente:

1. Medición.
2. Conversión.
3. Construcción de estados.
4. Cálculo LQR.
5. Saturación.
6. Acción del motor.
7. Nueva medición.

Esto constituye el lazo de control en tiempo real.

## Resultado

Durante las pruebas experimentales se comprobó que, al llevar manualmente el péndulo cerca de la posición vertical, el sistema es capaz de estabilizarlo mediante el controlador LQR.

## Evidencias por agregar

Las imágenes del proyecto se colocarán en `assets/images/` y posteriormente se insertarán en esta sección.
