---
layout: default
title: 2. Objetivo y alcance
nav_order: 2
---

# Objetivo y alcance

## Objetivo general

Diseñar e implementar un sistema de control capaz de estabilizar un péndulo invertido utilizando la plataforma experimental **QUBE-Servo 3**, aplicando técnicas de control moderno basadas en una representación mediante espacio de estados.

El controlador debe generar la señal necesaria para mantener el péndulo alrededor de la posición vertical superior, correspondiente a un punto de equilibrio inestable.

## Objetivos específicos

- Obtener el modelo matemático del sistema.
- Representar el sistema mediante variables de estado.
- Obtener las matrices $A$, $B$, $C$ y $D$.
- Analizar los polos de la planta.
- Determinar la estabilidad del sistema en lazo abierto.
- Verificar la controlabilidad.
- Diseñar un controlador LQR.
- Implementar el controlador en MATLAB.
- Implementar el controlador en Simulink.
- Validar experimentalmente el controlador.
- Diseñar un observador de estados.
- Comparar los estados reales y estimados.
- Analizar la respuesta temporal.
- Obtener y analizar la respuesta en frecuencia.

## Alcance

El proyecto se concentra principalmente en la estabilización del péndulo alrededor de su posición vertical superior.

Para realizar el diseño del controlador se emplea un modelo linealizado alrededor de este punto de operación.

La implementación final utiliza MATLAB/Simulink y el hardware QUBE-Servo 3.
