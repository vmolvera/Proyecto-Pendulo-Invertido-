---
layout: default
title: 2. Objetivos
nav_order: 3
permalink: /objetivos/
---

# Objetivos

## Objetivo general

Diseñar, implementar y validar experimentalmente estrategias de **Control Avanzado** sobre la plataforma **QUBE-Servo 3 en configuración de péndulo invertido**, mediante un controlador **(LQR)** y técnicas de estimación de estados, con el propósito de estabilizar el péndulo alrededor de su posición vertical superior y analizar el comportamiento dinámico del sistema.

---

## Objetivos específicos

- Obtener el modelo matemático linealizado del **QUBE-Servo 3** en configuración de péndulo invertido.

- Representar la dinámica del sistema mediante el modelo en **espacio de estados**:

$$
\dot{x}=Ax+Bu
$$

$$
y=Cx+Du
$$

- Determinar las matrices:

$$
A,\quad B,\quad C,\quad D
$$

que describen el comportamiento dinámico de la planta.

- Analizar los polos de la planta sin control para determinar su comportamiento alrededor del punto de equilibrio vertical.

- Verificar la **controlabilidad** del sistema mediante la matriz de controlabilidad.

- Diseñar un **Regulador Cuadrático Lineal (LQR)** para estabilizar el péndulo alrededor de su posición vertical superior.

- Seleccionar las matrices de ponderación ($$Q$$) y ($$R$$). Considerando el compromiso entre el comportamiento de los estados y el esfuerzo de control aplicado al motor.

- Calcular la matriz de ganancias ($$K$$), para implementar la ley de control ($$u=-Kx$$)

- Analizar los polos del sistema en lazo cerrado para verificar la estabilidad obtenida mediante el controlador LQR.

- Implementar el controlador LQR en **MATLAB y Simulink**.

- Validar experimentalmente el funcionamiento del controlador utilizando la plataforma física **QUBE-Servo 3**.

- Procesar las señales obtenidas mediante los encoders para determinar las posiciones angulares ($$\theta$$) y ($$\alpha$$).

- Obtener o estimar las velocidades angulares ($$\dot{\theta}$$) y ($$\dot{\alpha}$$), necesarias para construir el vector de estados.

- Implementar un **observador de tercer orden** para la estimación de posición y velocidad.

- Determinar los polos y ganancias necesarios para definir la dinámica del observador.

- Comparar la estimación de velocidades obtenida mediante el observador de tercer orden con una aproximación de primer orden.

- Analizar el comportamiento de los métodos de estimación tanto en el dominio del tiempo como en el dominio de la frecuencia.

- Integrar el controlador y los métodos de estimación dentro del modelo desarrollado en Simulink.
