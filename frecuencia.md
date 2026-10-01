---
layout: default
title: 9. Análisis en frecuencia
nav_order: 9
---

# Análisis en frecuencia

Además del análisis mediante espacio de estados, se estudia la respuesta del sistema en el dominio de la frecuencia.

Para ello se utilizan diagramas de Bode.

## Modelo

Partiendo de:

$$
\dot{x}=Ax+Bu
$$

$$
y=Cx+Du
$$

MATLAB permite construir el sistema mediante:

```matlab
sys = ss(A,B,C,D);
```

Posteriormente:

```matlab
bode(sys)
grid on
```

## Interpretación

### Magnitud

Indica cómo cambia la amplitud de la respuesta del sistema dependiendo de la frecuencia de excitación.

### Fase

Representa el desfase introducido por la dinámica del sistema.

## Sistema multisalida

El modelo posee una entrada y cuatro estados utilizados inicialmente como salidas:

$$
y=
\begin{bmatrix}
\theta\\
\alpha\\
\dot{\theta}\\
\dot{\alpha}
\end{bmatrix}
$$

Por esta razón pueden analizarse individualmente las funciones de transferencia correspondientes a cada salida.

Por ejemplo:

```matlab
bode(sys(1,1))
```

para la posición del brazo, y:

```matlab
bode(sys(2,1))
```

para el ángulo del péndulo.

## Estado actual

El análisis detallado de las gráficas se incorporará una vez obtenidas las respuestas definitivas.
