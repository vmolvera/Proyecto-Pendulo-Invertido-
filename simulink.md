---
layout: default
title: 8. Implementación en Simulink
nav_order: 8
---

# Implementación en Simulink

El controlador diseñado analíticamente en MATLAB fue implementado en Simulink para realizar la validación experimental sobre la plataforma física **QUBE-Servo 3**. 

El modelo se estructuró de manera jerárquica para aislar el procesamiento de señales, facilitar el diseño de los estimadores y cerrar el lazo de control en tiempo real.

![Diagrama Principal](assets/images/diagrama_princ.png)
*Arquitectura general del sistema de control en lazo cerrado implementado en Simulink.*

## Arquitectura general

La implementación puede resumirse en el siguiente flujo de señales:

**QUBE Encoders → Counts to Angles → State X (Observadores) → LQR → Saturación → QUBE Motor**

---

## 1. Interfaz con el Hardware (QUBE-Servo 3 - IO)

El bloque de hardware interactúa directamente con la planta física.
* **Lectura:** Los encoders proporcionan las posiciones del brazo rotacional (`baseEncoder`) y del péndulo (`pendulumEncoder`) expresadas puramente en "cuentas" digitales (counts).
* **Escritura:** Recibe la señal de voltaje de control final para accionar el motor, pasando previamente por una ganancia de `-1` para estandarizar el giro positivo en sentido antihorario (CCW).

![Interfaz Hardware](assets/images/qube_pend.png)
*Interior del subsistema Qube With Pendulum, mostrando la interfaz directa de lectura y escritura con la tarjeta de adquisición del equipo.*

## 2. Acondicionamiento (Counts to Angles)

El subsistema **Counts to Angles** transforma las cuentas digitales a posiciones angulares para trabajar matemáticamente en radianes.
* Se aplica una ganancia de $\frac{2\pi}{512 \times 4}$ a las señales de ambos encoders, correspondiendo a la resolución en cuadratura del sensor.
* Para el péndulo, se incluye una función de MATLAB que corrige la señal en crudo y mantiene la continuidad del ángulo $\alpha$.

![Counts to Angles](assets/images/counts.png)
*Subsistema de acondicionamiento encargado de la conversión geométrica de cuentas a radianes.*

## 3. Construcción del vector (State X) y Observadores

El controlador requiere el vector de estados completo:

$$X= \begin{bmatrix} \theta\\ \alpha\\ \dot{\theta}\\ \dot{\alpha} \end{bmatrix}$$

Dado que las velocidades no se miden directamente, el subsistema **State X** procesa las posiciones de los encoders. Aquí se implementan en paralelo los filtros de primer orden $\left(\frac{50s}{s+50}\right)$ y los observadores cinemáticos. Las señales resultantes se agrupan en un multiplexor para alimentar al controlador, y simultáneamente se envían al Workspace para su análisis.

![Vector de Estados](assets/images/estadox.png)
*Subsistema State X, donde se estructuran los vectores de estado combinando mediciones directas y estimaciones de velocidad.*

### Observador del Brazo Rotatorio ($\theta$)

Para calcular $\hat{\dot{\theta}}$ sin amplificar el ruido del sensor, se construyó un subsistema de estimación dedicado. Utiliza tres integradores en cascada retroalimentados por el error de posición, multiplicados por las ganancias calculadas analíticamente ($l, m, \beta$).

![Observador de Theta](assets/images/obs_t.png)
*Diagrama de bloques del observador de tercer orden encargado de estimar la velocidad del brazo rotatorio.*

### Observador del Péndulo ($\alpha$)

Para mantener el sistema desacoplado, se replicó exactamente la misma topología matemática pero aplicada al sensor del péndulo. Este bloque independiente utiliza sus propias ganancias homólogas ($l_1, m_1, \beta_1$) para obtener una señal limpia de la velocidad de caída ($\hat{\dot{\alpha}}$).

![Observador de Alfa](assets/images/obs_a.png)
*Diagrama homólogo configurado para estimar la velocidad angular del péndulo invertido de manera independiente.*

## 4. Control LQR

El vector completo de estados estimado ($X$) llega al bloque de ganancia `Balance Control`, el cual implementa la ley:

$$u = -KX$$

utilizando la matriz de retroalimentación calculada para reubicar los polos de la planta:

$$K = \begin{bmatrix} -1.0000 & 29.5241 & -0.9390 & 2.4383 \end{bmatrix}$$

## 5. Saturación e Interruptor de Equilibrio

Antes de enviar la señal al motor:
1. El voltaje atraviesa un interruptor (`Enable Balance Control Switch`) que permite activar la acción de control de forma manual y segura.
2. El propio bloque de hardware satura intrínsecamente el voltaje a los límites de la tarjeta de adquisición (típicamente $\pm 24$V o $\pm 15$V dependiendo del amplificador), evitando exigir al actuador valores destructivos.

## 6. Lazo Cerrado en Tiempo Real

Durante la ejecución, el hardware en el bucle (HIL) repite continuamente el siguiente ciclo a la frecuencia de muestreo establecida:

1. **Medición:** Adquisición de `counts` en los encoders.
2. **Conversión:** Transformación a $\theta$ y $\alpha$ (radianes).
3. **Estimación:** Limpieza de ruido y cálculo de $\dot{\theta}$ y $\dot{\alpha}$ mediante el observador cinemático.
4. **Cálculo LQR:** Multiplicación matricial $-KX$.
5. **Acción del motor:** Inyección del voltaje resultante al actuador para compensar la desviación.

## Resultado Experimental

Durante las pruebas físicas se comprobó que, al llevar manualmente el péndulo cerca de la posición vertical ($\alpha \approx 0$), el sistema procesa instantáneamente las señales estimadas y el actuador genera los movimientos correctivos exactos en la base, logrando estabilizar y mantener el péndulo invertido de manera indefinida.
