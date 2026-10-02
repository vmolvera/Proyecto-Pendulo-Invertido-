---
layout: default
title: 6. Resultados
nav_order: 7
permalink: /resultados/
---

# Resultados

En esta sección se presentan los principales resultados obtenidos durante el modelado, diseño e implementación del sistema de control para el **QUBE-Servo 3 en configuración de péndulo invertido**.

Los resultados se dividen en:

1. Resultados del modelo matemático.
2. Análisis de controlabilidad.
3. Estabilidad de la planta sin control.
4. Desempeño del controlador LQR.
5. Implementación experimental.
6. Resultados del observador de tercer orden.
7. Comparación entre métodos de estimación.
8. Análisis en frecuencia.
9. Discusión general.

---

## 6.1 Resultados del modelo matemático

A partir de los parámetros físicos del QUBE-Servo 3 se obtuvieron los momentos de inercia:

$$
J_r=2.2879167\times10^{-4}\;kg\,m^2
$$

$$
J_p=1.33128\times10^{-4}\;kg\,m^2
$$

y la inercia equivalente:

$$
J_t=3.62296758\times10^{-8}
$$

Las matrices numéricas obtenidas para el modelo linealizado son:

$$
A=
\begin{bmatrix}
0 & 0 & 1 & 0\\
0 & 0 & 0 & 1\\
0 & 55.1525 & -4.5471 & -0.1816\\
0 & 168.5810 & -4.4942 & -0.5551
\end{bmatrix}
$$

y:

$$
B=
\begin{bmatrix}
0\\
0\\
20.6755\\
20.4351
\end{bmatrix}
$$

Además:

$$
C=I_4
$$

y:

$$
D=
\begin{bmatrix}
0\\
0\\
0\\
0
\end{bmatrix}
$$

Estos valores constituyen la representación en espacio de estados utilizada para el diseño del controlador.

---

## 6.2 Controlabilidad

La matriz de controlabilidad se calculó mediante:

```matlab
Co = ctrb(A,B);
rango_C = rank(Co);
```

El resultado obtenido es:

$$
rank(\mathcal{C})=4
$$

Como el sistema posee cuatro estados:

$$
n=4
$$

se cumple:

$$
rank(\mathcal{C})=n
$$

por lo tanto, el sistema es:

**Completamente controlable.**

Este resultado permite diseñar una estrategia de retroalimentación de estados capaz de modificar la dinámica completa del sistema.

---

## 6.3 Polos de la planta sin control

Los polos se obtuvieron mediante:

```matlab
polos_planta = eig(A);
```

Con el modelo utilizado se obtienen aproximadamente:

$$
p_1=0
$$

$$
p_2=12.1485
$$

$$
p_3=-14.2556
$$

$$
p_4=-2.9950
$$

La presencia del polo:

$$
p=12.1485
$$

con parte real positiva confirma que la planta es **inestable en lazo abierto**.

Por lo tanto, el péndulo no puede permanecer de manera natural alrededor de su posición vertical superior.

| Polo | Valor aproximado | Interpretación |
|---|---:|---|
| $p_1$ | 0 | Modo marginal |
| $p_2$ | 12.1485 | Inestable |
| $p_3$ | -14.2556 | Estable |
| $p_4$ | -2.9950 | Estable |

<!--
IMAGEN PENDIENTE

Generar posteriormente una gráfica de los polos de la planta.

Nombre:

assets/images/polos_planta.png

Activar después:

![Polos de la planta]({{ site.baseurl }}/assets/images/polos_planta.png)

*Figura 1. Ubicación de los polos de la planta sin control en el plano complejo.*
-->

---

## 6.4 Resultados del controlador LQR

Para el diseño utilizado se seleccionaron:

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

En MATLAB:

```matlab
Q = diag([1 20 0.1 0.1]);
R = 1;

[K,S,P] = lqr(A,B,Q,R);
```

La ganancia obtenida con estos parámetros es aproximadamente:

$$
K=
\begin{bmatrix}
-1.0000 &
29.5241 &
-0.9390 &
2.4383
\end{bmatrix}
$$

Por lo tanto, la ley de control utilizada es:

$$
u=-Kx
$$

o:

$$
u=
-\left(
-1.0000\theta
+
29.5241\alpha
-
0.9390\dot{\theta}
+
2.4383\dot{\alpha}
\right)
$$

---

## 6.5 Polos del sistema con LQR

La matriz en lazo cerrado se obtiene mediante:

$$
A_{cl}=A-BK
$$

y los polos mediante:

```matlab
Acl = A-B*K;
polos_LQR = eig(Acl);
```

Los resultados aproximados son:

$$
p_1=-16.0167
$$

$$
p_2=-12.9444
$$

$$
p_{3,4}
=
-3.2766
\pm
0.7998j
$$

Todos presentan parte real negativa:

$$
Re(p_i)<0
$$

por lo tanto, el sistema con LQR es estable alrededor del punto de equilibrio considerado.

### Comparación

| Condición | Polos |
|---|---|
| Planta sin control | $0,\;12.1485,\;-14.2556,\;-2.9950$ |
| Planta con LQR | $-16.0167,\;-12.9444,\;-3.2766\pm0.7998j$ |

El polo positivo presente en la planta sin control desaparece después de aplicar la retroalimentación LQR.

<!--
IMAGEN PENDIENTE

Generar comparación de polos antes y después del LQR.

Nombre:

assets/images/polos_lqr_comparacion.png

Activar después:

![Comparación de polos]({{ site.baseurl }}/assets/images/polos_lqr_comparacion.png)

*Figura 2. Comparación entre los polos de la planta sin control y los polos del sistema controlado mediante LQR.*
-->

---

## 6.6 Comportamiento experimental del LQR

Después de implementar la ganancia $K$ dentro de Simulink, el controlador se probó sobre la plataforma física QUBE-Servo 3.

El procedimiento consiste en llevar manualmente el péndulo hacia la región próxima a la posición vertical superior y habilitar el controlador de balance.

Una vez habilitado, el controlador utiliza:

$$
\theta,\quad
\alpha,\quad
\dot{\theta},\quad
\dot{\alpha}
$$

para calcular continuamente:

$$
u=-Kx
$$

y producir los movimientos correctivos del brazo.

### Señales a documentar

Las principales señales que deben analizarse experimentalmente son:

- Ángulo del brazo $\theta$.
- Ángulo del péndulo $\alpha$.
- Velocidad del brazo $\dot{\theta}$.
- Velocidad del péndulo $\dot{\alpha}$.
- Voltaje de control $u$.

<!--
IMAGEN PENDIENTE

Gráfica de theta durante la prueba LQR.

Nombre:

assets/images/resultado_theta_lqr.png

Activar:

![Respuesta theta LQR]({{ site.baseurl }}/assets/images/resultado_theta_lqr.png)

*Figura 3. Evolución temporal de la posición angular del brazo durante la prueba experimental del LQR.*
-->

<!--
IMAGEN PENDIENTE

Gráfica de alpha durante la estabilización.

Nombre:

assets/images/resultado_alpha_lqr.png

Activar:

![Respuesta alpha LQR]({{ site.baseurl }}/assets/images/resultado_alpha_lqr.png)

*Figura 4. Evolución temporal del ángulo del péndulo durante la estabilización mediante LQR.*
-->

<!--
IMAGEN PENDIENTE

Señal de control.

Nombre:

assets/images/resultado_control_lqr.png

Activar:

![Señal de control LQR]({{ site.baseurl }}/assets/images/resultado_control_lqr.png)

*Figura 5. Voltaje de control aplicado al motor durante la operación del LQR.*
-->

---

## 6.7 Evidencia física del control LQR

La validación final del controlador debe complementarse con evidencia del comportamiento del sistema físico.

La evidencia debe mostrar al QUBE-Servo 3 operando con el péndulo alrededor de la posición vertical.

<!--
IMAGEN PENDIENTE

Fotografía o captura del video del péndulo balanceado.

Nombre:

assets/images/qube_balance_experimental.png

Activar:

![Péndulo estabilizado]({{ site.baseurl }}/assets/images/qube_balance_experimental.png)

*Figura 6. Prueba experimental del QUBE-Servo 3 con el péndulo estabilizado mediante el controlador LQR.*
-->

<!--
VIDEO PENDIENTE

Agregar aquí posteriormente el video experimental.

Puede utilizarse un enlace de YouTube, Google Drive o archivo
publicado por el equipo.

Ejemplo:

## Video experimental

[Ver prueba experimental del péndulo invertido](ENLACE_DEL_VIDEO)
-->

---

# Resultados del observador

## 6.8 Configuración del observador de tercer orden

Para los observadores correspondientes a:

$$
\theta
$$

y:

$$
\alpha
$$

se seleccionaron los polos:

$$
[-100,\;-100,\;-100]
$$

Por lo tanto:

$$
(s+100)^3
=
s^3+300s^2+30000s+1000000
$$

Las ganancias obtenidas son:

$$
\beta=300
$$

$$
l=30000
$$

$$
m=-8000000
$$

Para el observador de $\alpha$:

$$
\beta_1=300
$$

$$
l_1=30000
$$

$$
m_1=-8000000
$$

Debido a que ambos utilizan los mismos polos, sus parámetros poseen los mismos valores numéricos.

---

## 6.9 Resultados del observador para theta

Para el brazo rotacional se busca comparar la posición medida:

$$
\theta
$$

con la posición estimada:

$$
\hat{\theta}
$$

y posteriormente analizar la velocidad estimada:

$$
\hat{\dot{\theta}}
$$

El comportamiento ideal consiste en que la señal estimada siga rápidamente a la variable medida, manteniendo un error de estimación reducido.

<!--
IMAGEN PENDIENTE

Theta medida vs theta estimada.

Nombre:

assets/images/theta_real_vs_estimada.png

Activar:

![Theta medida y estimada]({{ site.baseurl }}/assets/images/theta_real_vs_estimada.png)

*Figura 7. Comparación entre la posición angular medida del brazo y la posición estimada mediante el observador.*
-->

<!--
IMAGEN PENDIENTE

Velocidad theta estimada.

Nombre:

assets/images/theta_dot_observadores.png

Activar:

![Velocidad theta estimada]({{ site.baseurl }}/assets/images/theta_dot_observadores.png)

*Figura 8. Comparación de las estimaciones de velocidad angular del brazo.*
-->

---

## 6.10 Resultados del observador para alpha

De manera equivalente, para el péndulo se compara:

$$
\alpha
$$

con:

$$
\hat{\alpha}
$$

y se analiza:

$$
\hat{\dot{\alpha}}
$$

La velocidad angular del péndulo es una variable especialmente relevante debido a su participación directa en el vector utilizado por el controlador.

<!--
IMAGEN PENDIENTE

Alpha medida vs estimada.

Nombre:

assets/images/alpha_real_vs_estimada.png

Activar:

![Alpha medida y estimada]({{ site.baseurl }}/assets/images/alpha_real_vs_estimada.png)

*Figura 9. Comparación entre el ángulo medido del péndulo y su estimación mediante el observador.*
-->

<!--
IMAGEN PENDIENTE

Velocidad alpha.

Nombre:

assets/images/alpha_dot_observadores.png

Activar:

![Velocidad alpha estimada]({{ site.baseurl }}/assets/images/alpha_dot_observadores.png)

*Figura 10. Comparación de las estimaciones de velocidad angular del péndulo.*
-->

---

## 6.11 Comparación entre primer y tercer orden

Uno de los análisis principales consiste en comparar dos metodologías para estimar las velocidades.

### Primer orden

El filtro utilizado es:

$$
G_1(s)=\frac{50s}{s+50}
$$

### Tercer orden

El observador utiliza tres polos:

$$
[-100,-100,-100]
$$

y una dinámica interna diseñada a partir de estos valores.

La comparación permite evaluar diferencias en:

- Rapidez de respuesta.
- Seguimiento de la señal.
- Ruido.
- Suavidad.
- Desfase.
- Comportamiento a diferentes frecuencias.

<!--
IMAGEN PENDIENTE

Comparación temporal theta_dot:
1er orden vs 3er orden.

Nombre:

assets/images/theta_dot_1orden_vs_3orden.png

Activar:

![Comparación theta dot]({{ site.baseurl }}/assets/images/theta_dot_1orden_vs_3orden.png)

*Figura 11. Comparación entre los métodos de primer y tercer orden para la estimación de la velocidad del brazo.*
-->

<!--
IMAGEN PENDIENTE

Comparación temporal alpha_dot:
1er orden vs 3er orden.

Nombre:

assets/images/alpha_dot_1orden_vs_3orden.png

Activar:

![Comparación alpha dot]({{ site.baseurl }}/assets/images/alpha_dot_1orden_vs_3orden.png)

*Figura 12. Comparación entre los métodos de primer y tercer orden para la estimación de la velocidad del péndulo.*
-->

---

## 6.12 Respuesta en frecuencia del observador

El observador de tercer orden también fue representado mediante un sistema en espacio de estados:

```matlab
sys_observador = ss( ...
    A_kin_theta, ...
    B_kin_theta, ...
    C_kin, ...
    D_kin);
```

A partir de este modelo se obtiene su diagrama de Bode.

Este análisis permite estudiar:

- Magnitud.
- Fase.
- Comportamiento a bajas frecuencias.
- Comportamiento a altas frecuencias.
- Capacidad para aproximar la derivación.

<!--
IMAGEN PENDIENTE

Bode únicamente del observador de tercer orden.

Nombre:

assets/images/bode_observador_3orden.png

Activar:

![Bode observador tercer orden]({{ site.baseurl }}/assets/images/bode_observador_3orden.png)

*Figura 13. Respuesta en frecuencia del observador cinemático de tercer orden.*
-->

---

## 6.13 Comparación en frecuencia

Para analizar el comportamiento relativo de los diferentes métodos se comparan:

### Observador de tercer orden

$$
G_{obs}(s)
$$

### Filtro de primer orden

$$
G_1(s)=\frac{50s}{s+50}
$$

### Derivador ideal

$$
G_D(s)=s
$$

El derivador ideal funciona como referencia teórica.

En MATLAB la comparación se realiza mediante:

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

<!--
IMAGEN PENDIENTE

Esta será una de las gráficas principales de resultados.

Nombre:

assets/images/bode_comparacion_estimadores.png

Activar:

![Comparación Bode]({{ site.baseurl }}/assets/images/bode_comparacion_estimadores.png)

*Figura 14. Comparación en frecuencia entre el observador de tercer orden, el filtro de primer orden y el derivador ideal.*
-->

---

## 6.14 Error de estimación

Una forma de evaluar cuantitativamente el observador consiste en definir el error:

$$
e_{\theta}
=
\theta-\hat{\theta}
$$

y:

$$
e_{\alpha}
=
\alpha-\hat{\alpha}
$$

De manera equivalente, para las velocidades:

$$
e_{\dot{\theta}}
=
\dot{\theta}-\hat{\dot{\theta}}
$$

$$
e_{\dot{\alpha}}
=
\dot{\alpha}-\hat{\dot{\alpha}}
$$

Estas señales permiten analizar la convergencia del sistema de estimación.

<!--
IMAGEN PENDIENTE

Si se generan errores explícitamente:

assets/images/error_estimacion_theta.png
assets/images/error_estimacion_alpha.png
-->

### Métricas opcionales

Si las señales experimentales se exportan desde Simulink, posteriormente pueden calcularse métricas como:

$$
RMSE=
\sqrt{
\frac{1}{N}
\sum_{k=1}^{N}
(y_k-\hat{y}_k)^2
}
$$

Estas métricas solo se incorporarán cuando se disponga de los datos experimentales correspondientes.

---

# Discusión de resultados

## 6.15 Efecto del controlador LQR

El análisis de polos muestra que la planta original posee un modo inestable.

Después de implementar el controlador LQR, todos los polos del sistema en lazo cerrado presentan parte real negativa.

Esto indica que la realimentación:

$$
u=-Kx
$$

modifica la dinámica del sistema y permite obtener estabilidad local alrededor del punto de equilibrio vertical.

La validación experimental debe analizarse conjuntamente con las señales obtenidas durante las pruebas físicas.

---

## 6.16 Efecto del observador

El observador de tercer orden introduce una dinámica de estimación definida por polos ubicados en:

$$
-100
$$

La elección de estos polos produce una dinámica rápida con respecto a la del sistema controlado.

Sin embargo, una respuesta más rápida también puede aumentar la sensibilidad del estimador frente al ruido presente en las mediciones.

Por esta razón, la evaluación final debe considerar tanto la rapidez de seguimiento como la calidad de las señales obtenidas experimentalmente.

---

## 6.17 Primer orden frente a tercer orden

La comparación entre ambos métodos no debe realizarse únicamente observando cuál responde más rápido.

También deben considerarse:

- Nivel de ruido.
- Desfase.
- Suavidad de la estimación.
- Seguimiento de cambios rápidos.
- Comportamiento en frecuencia.
- Facilidad de implementación.
- Utilidad de la señal dentro del controlador.

Las gráficas temporales y los diagramas de Bode permitirán determinar las diferencias reales entre ambas metodologías.

---

## 6.18 Tabla resumen

| Aspecto | Resultado |
|---|---|
| Número de estados | 4 |
| Rango de controlabilidad | 4 |
| Sistema controlable | Sí |
| Polo inestable sin control | $12.1485$ |
| Matriz $Q$ | $\operatorname{diag}(1,20,0.1,0.1)$ |
| $R$ | 1 |
| Ganancia $K$ | $[-1.0000,\;29.5241,\;-0.9390,\;2.4383]$ |
| Sistema con LQR | Estable alrededor del punto de operación |
| Polos del observador | $[-100,-100,-100]$ |
| Orden del observador | 3 |
| Estimador alternativo | $\frac{50s}{s+50}$ |
| Comparación en frecuencia | Observador vs filtro vs derivador |
| Validación experimental | Documentada mediante señales, gráficas y video |

---

## 6.19 Evidencias requeridas

Para completar esta sección se incorporarán las siguientes evidencias:

### Control LQR

- Polos de la planta.
- Comparación de polos antes y después del LQR.
- Respuesta temporal de $\theta$.
- Respuesta temporal de $\alpha$.
- Señal de control.
- Evidencia física del péndulo estabilizado.

### Observador

- $\theta$ medida vs $\hat{\theta}$.
- $\alpha$ medida vs $\hat{\alpha}$.
- Estimación de $\dot{\theta}$.
- Estimación de $\dot{\alpha}$.
- Comparación primer orden vs tercer orden.
- Bode del observador.
- Bode comparativo.

### Sistema físico

- Fotografía del montaje.
- Captura de Simulink durante ejecución.
- Video del sistema físico funcionando.

---

## 6.20 Resumen de resultados

Los resultados analíticos muestran que la planta del péndulo invertido es inestable en lazo abierto y completamente controlable.

El controlador LQR modifica la ubicación de los polos del sistema, trasladándolos al semiplano izquierdo y obteniendo una dinámica estable alrededor del punto de operación.

Posteriormente, el observador cinemático de tercer orden permite obtener estimaciones de posición y velocidad que pueden compararse con metodologías de primer orden.

La evaluación experimental completa se realiza mediante las señales registradas en Simulink, la comparación temporal entre las variables y el análisis de la respuesta en frecuencia.

Las evidencias gráficas y audiovisuales permitirán complementar estos resultados y relacionar el desarrollo matemático con el comportamiento real del QUBE-Servo 3.
