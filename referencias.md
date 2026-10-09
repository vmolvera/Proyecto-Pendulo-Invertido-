---
layout: default
title: 9. Referencias
nav_order: 10
permalink: /referencias/
---

# Referencias

En esta sección se presentan las principales fuentes utilizadas para el desarrollo del proyecto del **péndulo invertido QUBE-Servo 3**, incluyendo la documentación proporcionada para la asignatura, el manual de la plataforma y la documentación de MATLAB utilizada durante el diseño del controlador y el análisis del sistema.

---

## 9.1 Documento del proyecto

Molano Jiménez, A. G., & Caballero Mora, J. A. (2026).  
*Proyecto Práctico - Control Avanzado y Robótica*.  
Universidad Iberoamericana.  
24 de septiembre de 2026.

Este documento fue utilizado como referencia principal para definir:

- Los objetivos del proyecto.
- El modelo matemático del QUBE-Servo 3.
- Los parámetros nominales de la planta.
- El diseño del controlador LQR.
- La implementación del observador.
- Los entregables y criterios de evaluación.

---

## 9.2 Manual del QUBE-Servo 3

Quanser. (2024).  
*Qube-Servo 3 User Manual: Setup and Configuration*.  
Versión 1.1, 1 de septiembre de 2024.

Documento en repositorio:

[https://github.com/quanser/Quanser_Academic_Resources/blob/dev-windows/3_user_manuals/qube_servo3/Qube_Servo3_user_manual.pdf](https://github.com/quanser/Quanser_Academic_Resources/blob/dev-windows/3_user_manuals/qube_servo3/Qube_Servo3_user_manual.pdf)

Este manual fue utilizado como referencia para comprender:

- La arquitectura de la plataforma.
- El funcionamiento del motor.
- Los encoders.
- La adquisición de señales.
- La configuración del péndulo.
- La comunicación con MATLAB y Simulink.
- La operación segura del sistema.

---

## 9.3 Recursos Académicos - QUBE-Servo 3

Quanser.  
*Quanser Academic Resources*.

Repositorio de recursos (GitHub):

[https://github.com/quanser/Quanser_Academic_Resources/tree/dev-windows](https://github.com/quanser/Quanser_Academic_Resources/tree/dev-windows)

Los recursos y la documentación oficial del repositorio de Quanser presentan las características generales de la plataforma, así como aplicaciones y modelos de Simulink relacionados con:

- Modelado en espacio de estados.
- Estabilidad.
- Control de balance.
- Control LQR.
- Péndulo invertido.
- Integración con MATLAB y Simulink.

---

## 9.4 MATLAB — Controlador LQR

MathWorks.  
*Linear-Quadratic Regulator (LQR) design — MATLAB*.

Documentación:

[https://www.mathworks.com/help/control/ref/lti.lqr.html](https://www.mathworks.com/help/control/ref/lti.lqr.html)

La función:

```matlab
[K,S,P] = lqr(A,B,Q,R);
```
