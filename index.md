---
layout: default
title: Inicio
nav_order: 1
---

# Control de un Péndulo Invertido

## QUBE-Servo 3

Este proyecto presenta el modelado, análisis, diseño e implementación experimental de un sistema de control para un **péndulo invertido utilizando la plataforma QUBE-Servo 3**.

El péndulo invertido constituye uno de los sistemas clásicos de la ingeniería de control debido a que su posición vertical superior corresponde a un punto de equilibrio inherentemente inestable.

El objetivo principal consiste en mantener el péndulo alrededor de dicha posición mediante técnicas de **control moderno en espacio de estados**.

---

## Desarrollo del proyecto

El proyecto contempla las siguientes etapas:

1. Caracterización de la plataforma experimental.
2. Obtención del modelo matemático.
3. Representación mediante espacio de estados.
4. Análisis de estabilidad y controlabilidad.
5. Diseño de un controlador LQR.
6. Implementación en MATLAB y Simulink.
7. Implementación experimental sobre el QUBE-Servo 3.
8. Diseño de un observador de estados.
9. Análisis de la respuesta dinámica.
10. Análisis en frecuencia.

---

## Arquitectura general

La implementación experimental sigue la cadena:

**Encoders → Conversión de ángulos → Vector de estados → Control LQR → Saturación → Motor**

Los encoders del QUBE-Servo 3 proporcionan información sobre la posición angular del brazo y del péndulo.

A partir de estas mediciones se construye el vector de estados utilizado por el controlador LQR para calcular la acción de control aplicada al motor.

---

## Estado actual

Actualmente se ha completado:

- Modelado matemático.
- Representación en espacio de estados.
- Análisis de los polos de la planta.
- Verificación de controlabilidad.
- Diseño del controlador LQR.
- Implementación del LQR en Simulink.
- Pruebas experimentales con QUBE-Servo 3.
- Estabilización física del péndulo alrededor de la posición vertical.

Actualmente se continúa trabajando en:

- Observador de estados.
- Comparación entre estados medidos y estimados.
- Análisis en frecuencia.
- Documentación y análisis de resultados experimentales.

---

## Herramientas utilizadas

- MATLAB
- Simulink
- Control System Toolbox
- QUBE-Servo 3
- Quanser
- GitHub
- GitHub Pages
- Just-the-Docs
