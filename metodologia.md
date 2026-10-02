---
layout: default
title: 3. Metodología
nav_order: 4
permalink: /metodologia/
---

# Metodología

El desarrollo del proyecto se realizó mediante una secuencia que integra el modelado matemático del QUBE-Servo 3, el procesamiento de las señales obtenidas mediante sus encoders y la implementación del sistema de control en MATLAB y Simulink.

El procedimiento general puede representarse como:

```text
QUBE-Servo 3
      ↓
Definición de parámetros físicos
      ↓
Modelo matemático
      ↓
Representación en espacio de estados
      ↓
Lectura de encoders
      ↓
Conversión de cuentas a ángulos
      ↓
Construcción del vector de estados
      ↓
Control LQR
      ↓
Implementación experimental
      ↓
Observador de estados
      ↓
Análisis de resultados
```
