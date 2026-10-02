---
layout: default
title: 5. Análisis del sistema
nav_order: 5
---

# Análisis del sistema

Una vez obtenido el modelo en espacio de estados de la plataforma Quanser Aero 2, se procedió a analizar sus propiedades fundamentales para justificar las estrategias de control y estimación.

## Polos en lazo abierto

Los polos dictan el comportamiento dinámico natural de la planta y se calculan resolviendo la ecuación característica, que equivale a encontrar los valores propios (eigenvalores) de la matriz $A$:

$$
\det(sI - A) = 0 \quad \Rightarrow \quad \lambda(A)
$$

Los valores obtenidos computacionalmente fueron:

$$
p_1 = 0
$$

$$
p_2 = 12.1485
$$

$$
p_3 = -14.2556
$$

$$
p_4 = -2.9950
$$

## Análisis de Estabilidad

A partir de la ubicación de los polos, se extraen las siguientes conclusiones sobre la planta física:

1. **Inestabilidad Estructural:** El polo $p_2 = 12.1485$ se encuentra en el semiplano derecho (parte real positiva). Esto confirma analíticamente que el péndulo invertido es **inestable en lazo abierto**. Cualquier perturbación mínima hará que el ángulo $\alpha$ diverja exponencialmente de la vertical por efecto de la gravedad.
2. **Dinámica del Brazo:** El polo en el origen ($p_1 = 0$) corresponde a la posición del brazo rotatorio ($\theta$). Actúa como un integrador puro, lo que significa que el brazo no tiene una posición de reposo predeterminada; si gira libremente, no intentará regresar a un punto de origen natural.
3. **Amortiguamiento Natural:** Los polos negativos ($p_3$ y $p_4$) representan la disipación de energía del sistema, originada por la fricción viscosa del motor y los rodamientos.

## Controlabilidad

Para determinar si es matemáticamente posible estabilizar el sistema y modificar la dinámica de todos sus modos mediante el voltaje del motor, se evaluó la matriz de controlabilidad:

$$
\mathcal{C} = \begin{bmatrix} B & AB & A^2B & A^3B \end{bmatrix}
$$

El resultado obtenido indica que la matriz tiene rango completo:

$$
\text{rank}(\mathcal{C}) = 4
$$

**Conclusión:** Al coincidir el rango con la dimensión del vector de estados, **el sistema es completamente controlable**. Esto garantiza que existe una matriz de ganancias $K$ (como la del LQR) capaz de reubicar el polo inestable y estabilizar la planta.

## Observabilidad (Justificación para la Estimación)

En la práctica, los encoders físicos del sistema Quanser solo proporcionan las posiciones ($\theta$ y $\alpha$), pero no sus derivadas (velocidades). Definiendo la matriz de medición real:

$$
C_{med} =
\begin{bmatrix}
1 & 0 & 0 & 0 \\
0 & 1 & 0 & 0
\end{bmatrix}
$$

Se analizó la matriz de observabilidad para confirmar si es posible reconstruir los estados faltantes:

$$
\mathcal{O} = \begin{bmatrix} C_{med} \\ C_{med}A \\ C_{med}A^2 \\ C_{med}A^3 \end{bmatrix}
$$

El cálculo arrojó un $\text{rank}(\mathcal{O}) = 4$. Por lo tanto, el sistema es **completamente observable**. Esta propiedad es la que justifica matemáticamente el uso de diferenciadores y observadores de estados en Simulink para estimar $\dot{\theta}$ y $\dot{\alpha}$ de forma precisa sin necesidad de instalar sensores de velocidad adicionales.
