---
layout: default
title: 10. Resultados experimentales
nav_order: 10
---

# Resultados experimentales

En esta sección se documentan los resultados obtenidos durante el desarrollo e implementación del sistema.

## 1. Planta sin control

Los polos obtenidos para la planta incluyen:

$$
p=12.1485
$$

Este polo se encuentra en el semiplano derecho, confirmando que el péndulo invertido es inestable en lazo abierto.

## 2. Controlabilidad

Se obtuvo:

$$
rank(\mathcal{C})=4
$$

Por lo tanto, los cuatro estados del sistema son controlables.

## 3. Controlador LQR

El controlador diseñado utiliza:

$$
Q=diag(10,200,1,1)
$$

$$
R=0.01
$$

y produce aproximadamente:

$$
K=
\begin{bmatrix}
-3.1623&
50.5188&
-2.0542&
4.4057
\end{bmatrix}
$$

## 4. Implementación en Simulink

Se construyó el sistema de control en tiempo real utilizando:

- Lectura de encoders.
- Conversión de cuentas a ángulos.
- Generación del vector de estados.
- Control LQR.
- Saturación.
- Actuación del motor.

## 5. Prueba experimental

Una vez iniciado el modelo de Simulink, se elevó manualmente el péndulo hacia la región vertical.

Al aproximarse al punto de equilibrio, el controlador comenzó a mover el brazo para compensar las desviaciones del péndulo.

El sistema logró mantener el péndulo invertido mediante movimientos correctivos continuos.

## 6. Observador

Esta sección será completada una vez implementado el observador de estados.

Se incluirán gráficas comparando:

$$
x
$$

contra:

$$
\hat{x}
$$

para analizar la convergencia del estimador.

## 7. Respuesta en frecuencia

Los diagramas de Bode y su interpretación serán incorporados como parte del análisis final del proyecto.

## Evidencias pendientes

Se incorporarán posteriormente:

- Captura del Simulink completo.
- Subsistema Counts to Angles.
- Subsistema State x.
- Gráfica de $\theta$.
- Gráfica de $\alpha$.
- Señal de control.
- Comparación real-estimada.
- Diagrama de Bode.
- Video experimental del péndulo estabilizado.
