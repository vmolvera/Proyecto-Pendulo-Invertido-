---
layout: default
title: Inicio
nav_order: 1
permalink: /
---

# Péndulo Invertido

## Proyecto de Control Avanzado y Robótica

Este portafolio digital documenta el desarrollo, implementación y validación experimental de un sistema de **Control Avanzado** aplicado a la plataforma **QUBE-Servo 3 en configuración de péndulo invertido**.

El proyecto integra el modelado dinámico del sistema, su representación en **espacio de estados**, el diseño de un **Regulador Cuadrático Lineal (LQR)** para estabilizar el péndulo y la implementación de un **observador de estados** para la estimación de variables del sistema.

La implementación se realiza mediante **MATLAB y Simulink**, utilizando la plataforma física QUBE-Servo 3 para validar experimentalmente el comportamiento de las estrategias de control desarrolladas.

---

## Información del proyecto

| Elemento | Información |
|---|---|
| Asignatura | Control Avanzado y Robótica |
| Proyecto | Control Péndulo Invertido |
| Plataforma | QUBE-Servo 3 |
| Software | MATLAB / Simulink |
| Representación | Espacio de estados |
| Controlador | Linear Quadratic Regulator (LQR) |
| Estimación | Observador de estados |
| Periodo | Otoño 2026 |

---

## Descripción del proyecto

El péndulo invertido constituye un problema clásico de control debido a que su posición vertical superior corresponde a un punto de equilibrio inherentemente inestable.

Para este proyecto se utiliza un modelo linealizado del QUBE-Servo 3 alrededor de dicha posición de equilibrio.

El desarrollo se divide en dos etapas principales.

### Control LQR

La primera etapa consiste en diseñar e implementar un controlador por retroalimentación de estados mediante un **Regulador Cuadrático Lineal (LQR)**.

La ley de control utilizada tiene la forma ($$u=-Kx$$), donde:

- ($u$) Voltaje aplicado al motor.
- ($K$) Matriz de ganancias del controlador.
- ($x$) Vector de estados del sistema.

El controlador actúa como un sistema de **balance**, por lo que el péndulo se coloca inicialmente cerca de la posición vertical antes de activar el control.

### Observador de estados

La segunda etapa consiste en implementar un sistema de estimación que permita reconstruir variables del sistema a partir de las mediciones disponibles.

El observador permite comparar los estados medidos o calculados directamente con sus correspondientes valores estimados, analizando la convergencia y el comportamiento dinámico de ambos métodos.

---

## Objetivos principales

El proyecto contempla:

- Obtener el modelo matemático del QUBE-Servo 3.
- Representar el sistema mediante espacio de estados.
- Analizar la estabilidad y controlabilidad de la planta.
- Diseñar un controlador LQR.
- Determinar la matriz de ganancias ($K$).
- Implementar un observador de estados.
- Analizar los resultados obtenidos experimentalmente.

---

## Plataforma experimental

La implementación utiliza la plataforma **QUBE-Servo 3 de Quanser**, compuesta principalmente por:

- Servomotor rotacional.
- Brazo horizontal.
- Péndulo.
- Encoder del brazo.
- Encoder del péndulo.
- Sistema electrónico de adquisición y actuación.
- Interfaz de comunicación con MATLAB y Simulink.

Las mediciones obtenidas mediante los encoders permiten determinar los ángulos del brazo y del péndulo y construir el vector de estados utilizado por el controlador.

---

## Arquitectura general

El flujo general implementado en el sistema es:

```text
                 QUBE-Servo 3
                      ↓
              Lectura de encoders
                      ↓
          Conversión Counts → Angles
                      ↓
               Vector de estados
                      ↓
              Controlador LQR
                   u = -Kx
                      ↓
                 Saturación
                      ↓
                   Motor
                      ↓
           Movimiento correctivo
                      ↓
        Estabilización del péndulo
