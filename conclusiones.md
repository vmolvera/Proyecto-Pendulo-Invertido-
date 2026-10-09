---
layout: default
title: 8. Conclusiones
nav_order: 9
permalink: /conclusiones/
---

# Conclusiones
El desarrollo de este proyecto representó un desafío integral de ingeniería que culminó exitosamente con la estabilización de un sistema subactuado y altamente no lineal, utilizando la plataforma **QUBE-Servo 3**. A través de la validación experimental, se comprobó que el éxito de un sistema de control físico depende no solo de una sólida base matemática, sino también de un tratamiento riguroso de las señales en tiempo real.

A partir del trabajo realizado, se establecen las siguientes conclusiones:

## 1. Modelado dinámico y estabilización (LQR)
El análisis en el espacio de estados permitió cuantificar la naturaleza inestable del péndulo invertido, evidenciada por la presencia de un polo en lazo abierto en el semiplano derecho ($12.1485$). El diseño del **Regulador Cuadrático Lineal (LQR)** demostró ser una estrategia altamente efectiva para abordar este problema, ya que permitió establecer un balance óptimo entre el esfuerzo de control y el error del sistema. 

Al asignar un peso significativamente mayor al estado de la posición del péndulo ($Q_{22} = 20$), el controlador priorizó la verticalidad por encima de los desplazamientos del brazo, logrando reubicar todos los polos de lazo cerrado en el semiplano izquierdo. Experimentalmente, esta sintonización se tradujo en una respuesta física capaz de mantener el balance de forma robusta dentro de la región de operación planificada ($\pm0.175 \text{ rad}$).

## 2. Filtrado óptimo y estimación de velocidades
Uno de los hallazgos más importantes del proyecto fue evidenciar las severas limitaciones geométricas y eléctricas de utilizar derivadas puras o filtros de primer orden. En el hardware real, derivar directamente la posición amplifica el ruido de cuantización de los encoders, lo que puede causar saturación y daño físico al motor.

La implementación del **observador de tercer orden** con polos ubicados en $-100$ resolvió esta problemática de manera sobresaliente. Como se comprobó en el análisis en frecuencia (diagramas de Bode):
*   **Rechazo de ruido:** El observador actuó con una atenuación agresiva en altas frecuencias, bloqueando el ruido eléctrico que el derivador ideal habría amplificado al infinito.
*   **Respuesta temporal:** A diferencia del filtro de primer orden, el observador de tercer orden minimizó el retardo de fase. Esto garantizó que el controlador LQR recibiera estimaciones de velocidad precisas y "a tiempo", previniendo oscilaciones y caídas del péndulo debido a latencias en el procesamiento.

## 3. Cierre de la brecha entre simulación y hardware
La arquitectura implementada en **MATLAB y Simulink** validó el flujo de trabajo moderno en el diseño de sistemas de control. Se logró una integración perfecta entre la conversión de señales raw (cuentas a radianes), la estimación de estados faltantes y el cálculo de la acción de control ($u = -Kx$) en un ciclo continuo. 

El bloque de saturación comprobó ser una medida de seguridad vital para proteger el hardware, mientras que la lógica de habilitación por zonas (exclusiva para la región de balance) demostró que el modelo linealizado es extremadamente preciso siempre y cuando el sistema opere cerca de su punto de equilibrio.

---

## Síntesis del Proyecto
El proyecto evidencia que en el control avanzado, el controlador y el observador deben diseñarse como un ecosistema. Una acción de control óptima (LQR) es inútil si se alimenta de señales ruidosas o desfasadas. Al combinar matemáticas de control moderno con técnicas avanzadas de estimación cinemática, el equipo logró transformar una plataforma inherentemente inestable en un sistema equilibrado, predecible y seguro.
