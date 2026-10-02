---
layout: default
title: 5. Observador de Estados
nav_order: 6
permalink: /observador/
---

# Observador de Estados

Después de implementar y validar el controlador LQR, la segunda etapa del proyecto consiste en desarrollar un sistema de estimación capaz de reconstruir variables de interés a partir de las señales medidas.

En la implementación realizada por el equipo se utiliza un **observador cinemático de tercer orden** para procesar por separado las señales correspondientes al brazo rotacional y al péndulo.

El objetivo principal es obtener estimaciones de las posiciones y velocidades angulares:

$$
\theta,\qquad
\dot{\theta}
$$

y:

$$
\alpha,\qquad
\dot{\alpha}
$$

a partir de las posiciones medidas mediante los encoders.

---

## 5.1 Necesidad de estimar los estados

El controlador LQR utiliza el vector:

$$
x=
\begin{bmatrix}
\theta\\
\alpha\\
\dot{\theta}\\
\dot{\alpha}
\end{bmatrix}
$$

Sin embargo, los encoders del QUBE-Servo 3 proporcionan principalmente información de posición.

Las señales:

$$
\theta
$$

y:

$$
\alpha
$$

pueden obtenerse directamente a partir de las mediciones de los encoders después de convertir las cuentas a unidades angulares.

Por otro lado, las velocidades:

$$
\dot{\theta}
$$

y:

$$
\dot{\alpha}
$$

requieren un procedimiento adicional de estimación.

Por esta razón se implementaron diferentes métodos para obtener las velocidades y posteriormente comparar su comportamiento.

---

## 5.2 Métodos de estimación considerados

Durante el proyecto se analizaron dos metodologías principales.

### Método de primer orden

Se utiliza una aproximación basada en un derivador filtrado de primer orden.

Su función de transferencia se representa mediante:

$$
G_1(s)=\frac{50s}{s+50}
$$

Este sistema permite aproximar la derivada de la posición evitando utilizar directamente un derivador ideal.

---

### Método de tercer orden

Se implementa un observador cinemático de tercer orden.

Este método utiliza tres estados internos y polos seleccionados para obtener una respuesta más rápida en la estimación de las variables.

Se implementan dos subsistemas independientes:

- Observador para $\theta$.
- Observador para $\alpha$.

<!--
IMAGEN PENDIENTE

Utilizar la captura general del subsistema State X donde se
observan las ramas de primer orden y tercer orden.

Nombre sugerido:

assets/images/state_x_observadores.png

Después quitar estos comentarios:

![Métodos de estimación dentro de State X]({{ site.baseurl }}/assets/images/state_x_observadores.png)

*Figura 1. Implementación de los métodos de estimación de primer y tercer orden dentro del subsistema State X.*
-->

---

## 5.3 Observador cinemático de tercer orden

La implementación utilizada no emplea directamente las matrices:

$$
A
$$

y:

$$
B
$$

del modelo completo de la planta.

En su lugar se utiliza una estructura cinemática local de tercer orden para cada variable angular.

El modelo general utilizado puede escribirse como:

$$
\dot{x}_o=A_{kin}x_o+B_{kin}y
$$

donde:

- $x_o$ representa los estados internos del observador.
- $y$ representa la posición angular medida.
- $A_{kin}$ representa la dinámica interna del estimador.
- $B_{kin}$ representa la influencia de la medición sobre el observador.

Las salidas permiten obtener:

$$
\hat{\theta}
$$

y:

$$
\hat{\dot{\theta}}
$$

para el brazo, así como:

$$
\hat{\alpha}
$$

y:

$$
\hat{\dot{\alpha}}
$$

para el péndulo.

---

## 5.4 Selección de polos

Los polos utilizados para ambos observadores fueron:

$$
p_{\theta}=
\begin{bmatrix}
-100 & -100 & -100
\end{bmatrix}
$$

y:

$$
p_{\alpha}=
\begin{bmatrix}
-100 & -100 & -100
\end{bmatrix}
$$

En MATLAB:

```matlab
polos_theta = [-100,-100,-100];
polos_alpha = [-100,-100,-100];
```

La intención es que la dinámica del estimador sea más rápida que la dinámica del sistema controlado.

Un observador rápido permite que el error entre la señal real y la estimada disminuya rápidamente.

Sin embargo, una dinámica excesivamente rápida también puede incrementar la sensibilidad al ruido, por lo que la selección de polos debe evaluarse experimentalmente.

---

## 5.5 Polinomio característico

Los coeficientes asociados a los polos se obtienen mediante:

```matlab
poly_theta = poly(polos_theta);
poly_alpha = poly(polos_alpha);
```

Para:

$$
(s+100)^3
$$

se obtiene:

$$
(s+100)^3
=
s^3+300s^2+30000s+1000000
$$

Por lo tanto:

$$
poly=
\begin{bmatrix}
1 & 300 & 30000 & 1000000
\end{bmatrix}
$$

---

## 5.6 Cálculo de ganancias para theta

Para el observador correspondiente a $\theta$ se utilizan las relaciones:

$$
\beta = poly_{\theta}(2)
$$

$$
l = poly_{\theta}(3)
$$

$$
m=poly_{\theta}(4)-l\beta
$$

En MATLAB:

```matlab
beta = poly_theta(2);
l    = poly_theta(3);
m    = poly_theta(4) - (l * beta);
```

Con los polos seleccionados:

$$
\beta=300
$$

$$
l=30000
$$

y:

$$
m=
1000000-(30000)(300)
$$

por lo tanto:

$$
m=-8000000
$$

Las ganancias utilizadas para el observador de $\theta$ son entonces:

| Ganancia | Valor |
|---|---:|
| $\beta$ | 300 |
| $l$ | 30000 |
| $m$ | -8000000 |

---

## 5.7 Cálculo de ganancias para alpha

Para el observador correspondiente a $\alpha$ se utilizan las mismas relaciones:

$$
\beta_1 = poly_{\alpha}(2)
$$

$$
l_1 = poly_{\alpha}(3)
$$

$$
m_1=poly_{\alpha}(4)-l_1\beta_1
$$

En MATLAB:

```matlab
beta1 = poly_alpha(2);
l1    = poly_alpha(3);
m1    = poly_alpha(4) - (l1 * beta1);
```

Como se utilizan los mismos polos:

$$
\beta_1=300
$$

$$
l_1=30000
$$

$$
m_1=-8000000
$$

Por lo tanto:

| Ganancia | Valor |
|---|---:|
| $\beta_1$ | 300 |
| $l_1$ | 30000 |
| $m_1$ | -8000000 |

---

## 5.8 Estructura matricial del observador

Para representar matemáticamente la estructura implementada en Simulink se utiliza:

$$
A_{kin}=
\begin{bmatrix}
0 & 1 & 0\\
-l & 0 & m\\
-1 & 0 & -\beta
\end{bmatrix}
$$

y:

$$
B_{kin}=
\begin{bmatrix}
0\\
l\\
1
\end{bmatrix}
$$

Sustituyendo las ganancias:

$$
A_{kin}=
\begin{bmatrix}
0 & 1 & 0\\
-30000 & 0 & -8000000\\
-1 & 0 & -300
\end{bmatrix}
$$

y:

$$
B_{kin}=
\begin{bmatrix}
0\\
30000\\
1
\end{bmatrix}
$$

En MATLAB:

```matlab
A_kin_theta = [ 0, 1, 0;
               -l, 0, m;
               -1, 0, -beta];

B_kin_theta = [0;
               l;
               1];
```

---

## 5.9 Matriz de salida

El observador genera dos variables principales:

1. Posición estimada.
2. Velocidad estimada.

La matriz utilizada para extraer estas señales es:

$$
C_{kin}=
\begin{bmatrix}
1 & 0 & 0\\
0 & 1 & 0
\end{bmatrix}
$$

y:

$$
D_{kin}=
\begin{bmatrix}
0\\
0
\end{bmatrix}
$$

En MATLAB:

```matlab
C_kin = [1 0 0;
         0 1 0];

D_kin = [0;
         0];
```

La primera salida corresponde a la posición estimada:

$$
\hat{\theta}
$$

o:

$$
\hat{\alpha}
$$

mientras que la segunda corresponde a la velocidad estimada:

$$
\hat{\dot{\theta}}
$$

o:

$$
\hat{\dot{\alpha}}
$$

---

## 5.10 Observador de tercer orden para theta

Para la posición angular del brazo se utiliza como entrada la medición:

$$
\theta
$$

El subsistema procesa esta señal utilizando las ganancias:

$$
l,\qquad
m,\qquad
\beta
$$

y produce principalmente:

$$
\hat{\theta}
$$

y:

$$
\hat{\dot{\theta}}
$$

La velocidad estimada:

$$
\hat{\dot{\theta}}
$$

puede utilizarse posteriormente para compararla con otras metodologías de obtención de velocidad.

<!--
IMAGEN PENDIENTE

Esta es la captura ampliada del observador de tercer orden
correspondiente a theta.

Nombre sugerido:

assets/images/observador_theta_3orden.png

Después quitar estos comentarios:

![Observador de tercer orden para theta]({{ site.baseurl }}/assets/images/observador_theta_3orden.png)

*Figura 2. Implementación en Simulink del observador cinemático de tercer orden para la posición y velocidad del brazo.*
-->

---

## 5.11 Observador de tercer orden para alpha

De manera equivalente, para el péndulo se utiliza como entrada:

$$
\alpha
$$

El observador emplea las ganancias:

$$
l_1,\qquad
m_1,\qquad
\beta_1
$$

y genera:

$$
\hat{\alpha}
$$

y:

$$
\hat{\dot{\alpha}}
$$

La velocidad estimada:

$$
\hat{\dot{\alpha}}
$$

representa una de las señales principales para evaluar el desempeño del estimador.

<!--
IMAGEN PENDIENTE

Esta es la captura ampliada del observador de tercer orden
correspondiente a alpha.

Nombre sugerido:

assets/images/observador_alpha_3orden.png

Después quitar estos comentarios:

![Observador de tercer orden para alpha]({{ site.baseurl }}/assets/images/observador_alpha_3orden.png)

*Figura 3. Implementación en Simulink del observador cinemático de tercer orden para la posición y velocidad del péndulo.*
-->

---

## 5.12 Integración dentro de State X

Los estimadores se integran dentro del subsistema encargado de construir los estados utilizados por el controlador.

De forma conceptual:

```text
                   θ
                   │
         ┌─────────┴─────────┐
         ↓                   ↓
   Método 1er orden    Observador 3er orden
         ↓                   ↓
       θ̇_1                 θ̇_3
                             
                   α
                   │
         ┌─────────┴─────────┐
         ↓                   ↓
   Método 1er orden    Observador 3er orden
         ↓                   ↓
       α̇_1                 α̇_3
```

Esta arquitectura permite obtener simultáneamente las velocidades mediante diferentes metodologías y compararlas durante las pruebas.

<!--
IMAGEN PENDIENTE OPCIONAL

Si no se utiliza ya en Metodología, aquí puede colocarse la
captura completa de State X.

Nombre sugerido:

assets/images/state_x_completo.png

Después activar:

![Integración de estimadores en State X]({{ site.baseurl }}/assets/images/state_x_completo.png)

*Figura 4. Integración de los diferentes métodos de estimación dentro del subsistema State X.*
-->

---

## 5.13 Modelo en espacio de estados del observador

Para analizar la respuesta del observador en MATLAB se crea el sistema:

```matlab
sys_observador = ss( ...
    A_kin_theta, ...
    B_kin_theta, ...
    C_kin, ...
    D_kin);
```

Las salidas se identifican como:

```matlab
sys_observador.OutputName = {
    'Posicion Estimada',
    'Velocidad Estimada'
};

sys_observador.InputName = {
    'Posicion Medida'
};
```

Por lo tanto, el sistema puede interpretarse como:

```text
Posición medida
      ↓
Observador de 3er orden
      ↓
 ┌───────────────┐
 │               │
 ↓               ↓
Posición       Velocidad
estimada       estimada
```

---

## 5.14 Análisis en frecuencia

Además del análisis temporal, el programa estudia la respuesta en frecuencia del observador.

Las opciones utilizadas en MATLAB son:

```matlab
opciones_bode = bodeoptions('cstprefs');

opciones_bode.FreqUnits = 'rad/s';
opciones_bode.Grid = 'on';
```

Posteriormente:

```matlab
bode(sys_observador, opciones_bode);
```

El diagrama permite analizar:

- Magnitud.
- Fase.
- Comportamiento de la posición estimada.
- Comportamiento de la velocidad estimada.
- Respuesta ante diferentes frecuencias.

La implementación actual muestra la frecuencia en:

$$
rad/s
$$

<!--
IMAGEN PENDIENTE

Generar o utilizar la gráfica Bode del observador.

Nombre sugerido:

assets/images/bode_observador_3orden.png

Después quitar estos comentarios:

![Bode del observador de tercer orden]({{ site.baseurl }}/assets/images/bode_observador_3orden.png)

*Figura 5. Respuesta en frecuencia del observador cinemático de tercer orden.*
-->

---

## 5.15 Comparación con estimador de primer orden

Para comparar ambas metodologías se utiliza el filtro:

$$
G_1(s)=\frac{50s}{s+50}
$$

En MATLAB:

```matlab
s = tf('s');

filtro_1er_orden = (50*s)/(s+50);
```

También se define un derivador ideal:

$$
G_D(s)=s
$$

mediante:

```matlab
derivador_puro = s;
```

La respuesta correspondiente a la velocidad estimada mediante el observador se obtiene con:

```matlab
obs_3er_orden_vel = sys_observador(2,1);
```

Posteriormente se comparan:

```matlab
bode( ...
    obs_3er_orden_vel, ...
    'b', ...
    filtro_1er_orden, ...
    'r--', ...
    opciones_bode, ...
    derivador_puro, ...
    'g--');
```

De esta forma se analizan simultáneamente:

```text
Observador de tercer orden
          vs
Filtro de primer orden
          vs
Derivador ideal
```

El objetivo de esta comparación es estudiar cómo cada metodología aproxima la operación de derivación en función de la frecuencia.

<!--
IMAGEN PENDIENTE

Utilizar la gráfica donde se comparan:
- Observador 3er orden
- Filtro 1er orden
- Derivador puro

Nombre sugerido:

assets/images/bode_comparacion_estimadores.png

Después quitar estos comentarios:

![Comparación de estimadores]({{ site.baseurl }}/assets/images/bode_comparacion_estimadores.png)

*Figura 6. Comparación en frecuencia entre el observador de tercer orden, el filtro de primer orden y el derivador ideal.*
-->

---

## 5.16 Relación con el controlador LQR

Las velocidades estimadas pueden utilizarse para completar el vector:

$$
\hat{x}=
\begin{bmatrix}
\theta\\
\alpha\\
\hat{\dot{\theta}}\\
\hat{\dot{\alpha}}
\end{bmatrix}
$$

y analizar su aplicación dentro de la realimentación del sistema.

De manera conceptual:

```text
θ ────────────────┐
                  │
α ────────────────┤
                  │
Observador θ ─→ θ̇_hat
                  │
Observador α ─→ α̇_hat
                  │
                  ↓
               x_hat
                  ↓
                -K
                  ↓
                  u
                  ↓
              QUBE-Servo 3
```

Esta arquitectura permite estudiar el comportamiento del controlador cuando algunas variables son obtenidas mediante estimación.

---

## 5.17 Procedimiento de implementación

El procedimiento general utilizado para implementar los estimadores fue:

1. Obtener las posiciones:

$$
\theta
$$

y:

$$
\alpha
$$

a partir de los encoders.

2. Seleccionar los polos del observador.

3. Calcular los polinomios característicos.

4. Obtener las ganancias:

$$
l,\quad m,\quad\beta
$$

y:

$$
l_1,\quad m_1,\quad\beta_1
$$

5. Implementar los subsistemas de tercer orden en Simulink.

6. Obtener las velocidades estimadas:

$$
\hat{\dot{\theta}}
$$

y:

$$
\hat{\dot{\alpha}}
$$

7. Implementar el estimador de primer orden.

8. Comparar las señales obtenidas mediante ambos métodos.

9. Analizar su respuesta en frecuencia.

10. Registrar los resultados experimentales.

---

## 5.18 Variables a comparar

Las principales comparaciones contempladas son:

### Brazo rotacional

$$
\theta
\quad vs \quad
\hat{\theta}
$$

y:

$$
\dot{\theta}_{1er}
\quad vs \quad
\dot{\theta}_{3er}
$$

### Péndulo

$$
\alpha
\quad vs \quad
\hat{\alpha}
$$

y:

$$
\dot{\alpha}_{1er}
\quad vs \quad
\dot{\alpha}_{3er}
$$

Estas señales permiten evaluar:

- Rapidez de respuesta.
- Suavidad de la estimación.
- Sensibilidad al ruido.
- Diferencia entre métodos.
- Comportamiento dinámico.

Las gráficas correspondientes se presentan en la sección **Resultados**.

---

## 5.19 Evidencias contempladas

Para documentar esta etapa se incorporarán posteriormente:

- Subsistema general `State X`.
- Observador de tercer orden para $\theta$.
- Observador de tercer orden para $\alpha$.
- Gráfica de posición medida y estimada.
- Gráfica de velocidad estimada.
- Diagrama de Bode del observador.
- Comparación del observador de tercer orden con el filtro de primer orden.
- Comparación con el derivador ideal.

Las evidencias cuantitativas principales se presentarán en la sección **Resultados**.

---

## 5.20 Resumen del observador

El procedimiento desarrollado puede resumirse mediante:

```text
Posición medida
      ↓
Selección de polos
[-100 -100 -100]
      ↓
Polinomio característico
      ↓
Cálculo de ganancias
l, m, beta
      ↓
Observador cinemático
de tercer orden
      ↓
Posición estimada
+
Velocidad estimada
      ↓
Comparación con
estimador de 1er orden
      ↓
Análisis temporal
+
Análisis en frecuencia
```

La implementación permite estudiar diferentes métodos para estimar las velocidades requeridas por el sistema y evaluar su comportamiento antes de analizar los resultados experimentales.
