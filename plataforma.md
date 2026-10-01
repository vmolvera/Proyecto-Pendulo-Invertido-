---
layout: default
title: 3. Plataforma experimental
nav_order: 3
---

# Plataforma experimental

## QUBE-Servo 3

El QUBE-Servo 3 es una plataforma de control rotacional utilizada para experimentación y enseñanza de sistemas de control.

Para este proyecto se utiliza la configuración de **péndulo rotacional invertido**.

El sistema está compuesto principalmente por:

- Servomotor rotacional.
- Brazo horizontal.
- Péndulo.
- Encoders.
- Sistema electrónico de potencia.
- Interfaz de adquisición y control.
- MATLAB/Simulink.

## Variables principales

### Ángulo del brazo

$$
\theta
$$

Representa la posición angular del brazo rotacional accionado por el motor.

### Ángulo del péndulo

$$
\alpha
$$

Representa el ángulo correspondiente al movimiento del péndulo.

Para el problema de estabilización, el objetivo consiste en mantener al péndulo alrededor de la posición vertical invertida.

## Medición

Los encoders incorporados en el QUBE permiten obtener las posiciones angulares.

En Simulink, las cuentas de los encoders son convertidas a unidades angulares antes de utilizarse dentro del controlador.

La cadena de adquisición puede resumirse como:

**Encoder → Counts to Angles → Estados**

## Actuación

La acción calculada por el controlador es aplicada al motor del QUBE.

Antes de llegar al actuador se utiliza un bloque de saturación para mantener la señal dentro de los límites permitidos por el sistema.

## Software

La implementación utiliza:

- MATLAB para cálculos y análisis.
- Simulink para control en tiempo real.
- Control System Toolbox para análisis de sistemas.
- Herramientas de Quanser para comunicación con el hardware.

## Flujo experimental

1. El encoder mide la posición del brazo y del péndulo.
2. Las cuentas son convertidas a ángulos.
3. Se construye el vector de estados.
4. El controlador LQR calcula la acción de control.
5. Se limita la acción mediante saturación.
6. La señal es enviada al motor.
7. El proceso se repite continuamente en lazo cerrado.
