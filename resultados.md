---
layout: default
title: 6. Resultados Experimentales
nav_order: 7
permalink: /resultados/
---

# Resultados Experimentales

En esta sección se presentan los principales resultados obtenidos durante el modelado, diseño, implementación y validación del sistema de control para el péndulo invertido QUBE-Servo 3.

El desarrollo matemático y el procedimiento de implementación se presentaron previamente en las secciones de **Metodología**, **Control LQR** y **Observador de Estados**.

---

## 6.1 Resumen de resultados analíticos

A partir del modelo linealizado del QUBE-Servo 3 se obtuvo un sistema de cuatro estados:

$$
x=
\begin{bmatrix}
\theta\\
\alpha\\
\dot{\theta}\\
\dot{\alpha}
\end{bmatrix}
$$

El análisis de controlabilidad produjo ($$rank(\mathcal{C})=4$$), por lo que el sistema es **completamente controlable**.

Los polos de la planta sin control fueron aproximadamente:

$$
\left\{
0,\;
12.1485,\;
-14.2556,\;
-2.9950
\right\}
$$

La presencia del polo ($$p=12.1485$$) con parte real positiva confirma que el sistema es **inestable en lazo abierto** alrededor de la posición vertical superior.

Para el controlador LQR se utilizaron:

$$
Q=
\operatorname{diag}
\left(
1,\;
20,\;
0.1,\;
0.1
\right)
$$

y:

$$
R=1
$$

La ganancia obtenida fue aproximadamente:

$$
K=
\begin{bmatrix}
-1.0000 &
29.5241 &
-0.9390 &
2.4383
\end{bmatrix}
$$

La dinámica del sistema controlado queda definida mediante ($$A_{cl}=A-BK$$) y los polos correspondientes son aproximadamente:

$$
\left\{
-16.0167,\;
-12.9444,\;
-3.2766+0.7998j,\;
-3.2766-0.7998j
\right\}
$$

Todos los polos del sistema controlado presentan parte real negativa.

Por lo tanto, el diseño LQR permite obtener **estabilidad local alrededor del punto de equilibrio vertical superior**.

---

## 6.2 Validación experimental del controlador LQR

Después del diseño y validación analítica, el controlador se implementó en Simulink y se probó sobre la plataforma física QUBE-Servo 3.

El controlador utilizado corresponde a una estrategia de **balance**, por lo que no realiza automáticamente el movimiento de *swing-up*.

Durante la prueba, el péndulo se lleva manualmente hacia una región próxima a la posición vertical superior.

La lógica de habilitación considera aproximadamente ($$|\alpha|\leq0.175\;rad$$) lo cual corresponde aproximadamente a ($$|\alpha|\leq10^\circ$$).

Cuando el péndulo entra en esta región, el controlador utiliza la ley ($$u=-Kx$$) para determinar el voltaje requerido por el motor.

Durante las pruebas experimentales se observó que el brazo rotacional comienza a realizar movimientos correctivos una vez que el control es habilitado.

Estos movimientos compensan continuamente las desviaciones del péndulo alrededor de la vertical.

El resultado experimental permitió comprobar que el controlador LQR diseñado puede mantener el péndulo invertido alrededor de su punto de operación mientras permanece dentro de la región de funcionamiento del controlador.

---

## 6.3 Comportamiento del sistema en lazo cerrado

La estabilización se obtiene mediante una realimentación continua de los estados del sistema.

De manera conceptual:

```text
QUBE-Servo 3
     ↓
Encoders
     ↓
θ , α
     ↓
Estimación de velocidades
     ↓
θ , α , θ̇ , α̇
     ↓
Vector de estados
     ↓
u = -Kx
     ↓
Motor
     ↓
QUBE-Servo 3
```

El comportamiento observado durante las pruebas es consistente con el análisis de polos realizado previamente.

En lazo abierto existe un modo inestable, mientras que después de aplicar la realimentación LQR todos los polos del modelo linealizado se encuentran en el semiplano izquierdo.

Esto explica que el sistema pueda mantenerse alrededor de la posición vertical cuando el péndulo se encuentra suficientemente próximo al punto de equilibrio.

---

## 6.4 Resultados del observador cinemático de tercer orden

Para la segunda etapa del proyecto se implementaron dos observadores cinemáticos de tercer orden:

- Un observador asociado a la posición angular del brazo ($\theta$).
- Un observador asociado a la posición angular del péndulo ($\alpha$).

Para ambos se seleccionaron los polos ($$[-100,-100,-100]$$).

El polinomio característico correspondiente es:

$$
(s+100)^3
=
s^3+300s^2+30000s+1000000
$$

A partir de estos coeficientes se obtuvieron las ganancias:

$$
\beta=300
$$

$$
l=30000
$$

$$
m=-8000000
$$

Para el observador asociado a ($\alpha$) se obtuvieron los mismos valores numéricos:

$$
\beta_1=300
$$

$$
l_1=30000
$$

$$
m_1=-8000000
$$

debido a que ambos observadores utilizan la misma ubicación de polos.

La implementación permite obtener estimaciones de las velocidades ($$\hat{\dot{\theta}}$$) y ($$\hat{\dot{\alpha}}$$) a partir de las posiciones medidas mediante los encoders.

La ubicación de los polos implementados se verifica en MATLAB mediante:

```matlab
polos_obs_calculados = eig(A_theta);
```

Esta comprobación permite verificar que la dinámica construida para el observador corresponde con la selección realizada durante el diseño.

---

## 6.5 Comparación de métodos de estimación

Además del observador cinemático de tercer orden, se implementó una aproximación de primer orden para obtener las velocidades angulares.

El estimador de primer orden se representa mediante ($$G_1(s)=\frac{50s}{s+50}$$)

De esta manera se dispone de dos métodos diferentes para obtener las velocidades.

### Método de primer orden

A partir de las posiciones medidas se obtienen ($$\dot{\theta}_{1er}$$) y ($$\dot{\alpha}_{1er}$$) mediante el derivador filtrado.

### Observador de tercer orden

A partir de la estructura del observador se obtienen ($$\hat{\dot{\theta}}_{3er}$$) y ($$\hat{\dot{\alpha}}_{3er}$$). Esto permite construir dos representaciones del vector de estados.

Mediante el método de primer orden:

$$
X=
\begin{bmatrix}
\theta\\
\alpha\\
\dot{\theta}_{1er}\\
\dot{\alpha}_{1er}
\end{bmatrix}
$$

y mediante el observador de tercer orden:

$$
X_1=
\begin{bmatrix}
\theta\\
\alpha\\
\hat{\dot{\theta}}_{3er}\\
\hat{\dot{\alpha}}_{3er}
\end{bmatrix}
$$

La implementación de ambos métodos dentro del mismo modelo permite analizar su comportamiento bajo las mismas señales de posición.

La comparación se concentra principalmente en las velocidades, ya que las posiciones ($\theta$) y ($\alpha$) provienen directamente de las mediciones procesadas de los encoders.

---

## 6.6 Análisis en frecuencia de los estimadores

Para complementar el análisis temporal se estudió el comportamiento de los métodos de estimación en el dominio de la frecuencia.

La respuesta asociada a la velocidad se obtiene mediante:

```matlab
obs_3er_orden_vel = sys_observador(2,1);
```

El estimador de primer orden corresponde a:

```matlab
s = tf('s');

filtro_1er_orden = (50*s)/(s+50);
```

También se utiliza como referencia el derivador ideal ($$G_D(s)=s$$).

La comparación implementada en MATLAB es:

```matlab
bode( ...
    obs_3er_orden_vel, ...
    'b', ...
    filtro_1er_orden, ...
    'r--', ...
    derivador_puro, ...
    'g-.', ...
    opciones_bode);
```

De esta manera se estudian simultáneamente:

```text
Observador de tercer orden
          vs
Filtro de primer orden
          vs
Derivador ideal
```

El análisis permite estudiar la manera en que cada metodología aproxima la operación de derivación para diferentes frecuencias.

El filtro de primer orden limita el comportamiento del derivador a altas frecuencias, mientras que el observador de tercer orden introduce una dinámica determinada por los polos seleccionados.

Debido a que no se calcularon métricas cuantitativas específicas de error para esta comparación, no se reportan valores de RMSE o error máximo entre los métodos.

---

## 6.7 Discusión de resultados

Los resultados obtenidos permiten relacionar el comportamiento experimental con el análisis matemático realizado durante el proyecto.

### Control LQR

El modelo de la planta presenta un polo con parte real positiva, lo que confirma la inestabilidad natural del péndulo invertido.

Después de aplicar la retroalimentación ($$u=-Kx$$) los polos del modelo linealizado se desplazan completamente al semiplano izquierdo.

La validación física permitió comprobar que, cuando el péndulo se encuentra dentro de la región de activación, el controlador genera movimientos correctivos del brazo que permiten conservar el balance alrededor de la posición vertical.

### Observador

El observador cinemático de tercer orden permite obtener estimaciones de las velocidades angulares sin utilizar directamente las matrices completas $A$ y $B$ de la planta.

La dinámica del estimador se determina mediante la ubicación de sus polos ($$[-100,-100,-100]$$) y las ganancias calculadas a partir del polinomio característico correspondiente.

---

## 6.8 Tabla resumen de resultados

| Aspecto | Resultado |
|---|---|
| Número de estados | 4 |
| Rango de controlabilidad | 4 |
| Sistema controlable | Sí |
| Polo inestable en lazo abierto | $12.1485$ |
| Matriz $Q$ | $\operatorname{diag}(1,20,0.1,0.1)$ |
| $R$ | 1 |
| Ganancia LQR $K$ | $[-1.0000,\;29.5241,\;-0.9390,\;2.4383]$ |
| Polos en lazo cerrado | $-16.0167,\;-12.9444,\;-3.2766\pm0.7998j$ |
| Estabilidad con LQR | Estable alrededor del punto de operación |
| Tipo de control | Control de balance |
| Región aproximada de habilitación | $\pm0.175\;rad\approx\pm10^\circ$ |
| Polos del observador | $[-100,-100,-100]$ |
| Orden del observador | Tercer orden |
| $\beta$ | 300 |
| $l$ | 30000 |
| $m$ | -8000000 |
| Estimador alternativo | $\frac{50s}{s+50}$ |
| Comparación en frecuencia | Observador vs filtro vs derivador ideal |
| Plataforma experimental | QUBE-Servo 3 |
| Validación física del LQR | Realizada |
