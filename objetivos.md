---
layout: default
title: 2. Objetivos
nav_order: 3
permalink: /objetivos/
---

# Objetivos

## 2.1 Objetivo general

Diseñar, implementar y validar experimentalmente estrategias de **Control Avanzado** sobre la plataforma **QUBE-Servo 3 en configuración de péndulo invertido**, utilizando un controlador **LQR** y un sistema de estimación de estados para mantener la estabilidad del péndulo y analizar el comportamiento dinámico del sistema.

---

## 2.2 Objetivos específicos

- Obtener el modelo matemático linealizado del QUBE-Servo 3.

- Representar el sistema mediante variables de estado.

- Determinar las matrices:

$$
A,\quad B,\quad C,\quad D
$$

- Analizar los polos de la planta sin control.

- Verificar la controlabilidad del sistema.

- Diseñar un **Regulador Cuadrático Lineal (LQR)**.

- Seleccionar las matrices de ponderación:

$$
Q
$$

y

$$
R
$$

- Calcular la matriz de ganancias:

$$
K
$$

para implementar la ley de control:

$$
u=-Kx
$$

- Implementar el controlador LQR en MATLAB y Simulink.

- Validar experimentalmente el controlador utilizando la plataforma física QUBE-Servo 3.

- Implementar un observador o sistema de estimación de estados.

- Determinar las ganancias necesarias para el estimador.

- Comparar los estados medidos o calculados directamente con los estados estimados.

- Analizar diferentes metodologías para la estimación de velocidades angulares.

- Analizar el comportamiento del estimador en el dominio de la frecuencia.

- Documentar y discutir los resultados experimentales obtenidos.
