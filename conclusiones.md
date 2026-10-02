---
layout: default
title: 8. Conclusiones
nav_order: 9
permalink: /conclusiones/
---

# Conclusiones

El desarrollo de este proyecto permitió integrar diferentes herramientas de **Control Avanzado** sobre una plataforma física real mediante el QUBE-Servo 3 en configuración de péndulo invertido.

A lo largo del proyecto se trabajó desde el modelado matemático de la planta hasta la implementación experimental del controlador, pasando por el análisis de controlabilidad, el diseño de un controlador LQR, la estimación de velocidades mediante observadores cinemáticos de tercer orden y la comparación de diferentes metodologías de estimación.

De esta manera fue posible relacionar los conceptos estudiados en espacio de estados con el comportamiento real de un sistema dinámico inherentemente inestable.

---

## 8.1 Modelado del sistema

La primera etapa consistió en obtener el modelo linealizado del péndulo invertido a partir de los parámetros físicos del QUBE-Servo 3.

El sistema fue representado mediante:

$$
\dot{x}=Ax+Bu
$$

con el vector de estados:

$$
x=
\begin{bmatrix}
\theta\\
\alpha\\
\dot{\theta}\\
\dot{\alpha}
\end{bmatrix}
$$

y la entrada:

$$
u=V_m
$$

A partir de las características físicas del sistema se calcularon las inercias y posteriormente los elementos de las matrices de espacio de estados.

Este procedimiento permitió establecer una representación matemática que posteriormente fue utilizada para el diseño del controlador.

---

## 8.2 Controlabilidad

Antes de implementar el LQR se verificó la controlabilidad del sistema mediante:

$$
\mathcal{C}
=
\begin{bmatrix}
B & AB & A^2B & A^3B
\end{bmatrix}
$$

El rango obtenido fue:

$$
rank(\mathcal{C})=4
$$

Debido a que el sistema posee cuatro estados, este resultado indica que la planta es **completamente controlable**.

Esta condición es fundamental porque confirma que la entrada del motor puede modificar todos los modos dinámicos considerados por el modelo.

---

## 8.3 Comportamiento de la planta sin control

El análisis de los polos mostró que la planta presenta comportamiento inestable alrededor de la posición vertical superior.

Entre los polos obtenidos se encuentra aproximadamente:

$$
p=12.1485
$$

el cual se encuentra en el semiplano derecho.

Este resultado corresponde con el comportamiento físico esperado del péndulo invertido, ya que la posición vertical superior no puede mantenerse de manera natural sin una acción activa de control.

La inestabilidad observada justificó la implementación de una estrategia de realimentación de estados.

---

## 8.4 Diseño del controlador LQR

Para estabilizar el sistema se implementó un controlador **Linear Quadratic Regulator**.

La ley de control utilizada fue:

$$
u=-Kx
$$

y las matrices de ponderación seleccionadas fueron:

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

La mayor ponderación asignada a:

$$
\alpha
$$

permite dar prioridad al ángulo del péndulo dentro de la función de costo, debido a que mantener esta variable próxima a la posición vertical constituye el objetivo principal del sistema.

El diseño LQR permitió obtener una matriz de ganancias $K$ capaz de modificar la dinámica original de la planta.

---

## 8.5 Estabilidad en lazo cerrado

Después de calcular la ganancia del controlador se obtuvo:

$$
A_{cl}=A-BK
$$

Los polos del sistema controlado presentan parte real negativa.

Esto permite concluir que el controlador LQR transforma la dinámica inestable de la planta en una dinámica localmente estable alrededor del punto de equilibrio considerado.

La comparación entre los polos antes y después de aplicar el controlador mostró claramente el efecto de la realimentación de estados sobre el comportamiento dinámico del sistema.

---

## 8.6 Implementación experimental del LQR

El controlador fue posteriormente implementado en Simulink y probado directamente sobre el QUBE-Servo 3.

Debido a que el proyecto utiliza únicamente control de balance y no una estrategia de *swing-up*, el péndulo debe llevarse manualmente hacia una región cercana a la posición vertical superior.

Una vez que el péndulo se encuentra dentro de esta zona de operación, el controlador utiliza continuamente:

$$
\theta,\quad
\alpha,\quad
\dot{\theta},\quad
\dot{\alpha}
$$

para calcular:

$$
u=-Kx
$$

Durante las pruebas físicas se logró observar que el sistema genera movimientos correctivos del brazo y mantiene el péndulo invertido cuando éste se encuentra dentro de la región de operación del controlador.

Este resultado permitió validar experimentalmente el funcionamiento del LQR sobre la plataforma física.

---

## 8.7 Procesamiento de las señales

Otro aspecto importante del proyecto fue el procesamiento de las mediciones provenientes de los encoders.

Las cuentas digitales obtenidas desde el hardware fueron transformadas en posiciones angulares:

$$
\theta
$$

y:

$$
\alpha
$$

expresadas en radianes.

Posteriormente estas señales se utilizaron para construir el vector de estados requerido por el controlador.

Esta etapa permitió establecer una conexión entre las mediciones físicas del sistema y las variables matemáticas utilizadas por el modelo de control.

---

## 8.8 Estimación de velocidades

Debido a que las velocidades angulares no se obtienen directamente de la misma manera que las posiciones, se analizaron diferentes estrategias para estimarlas.

Se consideró un estimador de primer orden representado por:

$$
G_1(s)=\frac{50s}{s+50}
$$

y un observador cinemático de tercer orden.

El objetivo de estas metodologías fue obtener estimaciones para:

$$
\dot{\theta}
$$

y:

$$
\dot{\alpha}
$$

que pudieran ser utilizadas y comparadas dentro del sistema de control.

---

## 8.9 Observador cinemático de tercer orden

Para el estimador de tercer orden se seleccionaron los polos:

$$
[-100,-100,-100]
$$

tanto para el brazo como para el péndulo.

A partir del polinomio:

$$
(s+100)^3
$$

se obtuvieron las ganancias necesarias para construir la dinámica interna del estimador.

El observador permite obtener estimaciones de posición y velocidad a partir de la posición medida.

De esta manera se dispone de una alternativa más elaborada al filtro derivativo de primer orden para obtener las velocidades requeridas por el controlador.

---

## 8.10 Comparación de metodologías

El análisis realizado permite comparar tres comportamientos:

```text
Derivador ideal
      ↓
Filtro de primer orden
      ↓
Observador cinemático de tercer orden
```

El derivador ideal:

$$
G_D(s)=s
$$

sirve como referencia teórica.

El filtro de primer orden introduce una dinámica adicional para evitar una derivación directa de la señal.

Por otra parte, el estimador de tercer orden utiliza una estructura dinámica diseñada mediante la selección de polos.

La comparación mediante diagramas de Bode permite analizar las diferencias de magnitud y fase entre estas metodologías a diferentes frecuencias.

Las pruebas experimentales y las gráficas temporales permiten complementar este análisis al considerar también ruido, rapidez y suavidad de las señales.

---

## 8.11 Integración MATLAB-Simulink

Uno de los resultados más relevantes del proyecto fue la integración entre MATLAB, Simulink y la plataforma física.

MATLAB fue utilizado principalmente para:

- Definir los parámetros físicos.
- Calcular las inercias.
- Construir las matrices del sistema.
- Verificar la controlabilidad.
- Analizar los polos.
- Diseñar el controlador LQR.
- Calcular las ganancias de los estimadores.
- Analizar la respuesta en frecuencia.

Simulink permitió utilizar posteriormente estos resultados para implementar el sistema en tiempo real y comunicarse directamente con el QUBE-Servo 3.

Esta integración permitió pasar del desarrollo matemático a una implementación física funcional.

---

## 8.12 Cumplimiento de los objetivos

El proyecto permitió desarrollar las principales etapas planteadas inicialmente.

Se obtuvo un modelo linealizado de la planta, se verificó su controlabilidad, se diseñó un controlador LQR y se implementó sobre el sistema físico.

También se incorporaron métodos para estimar las velocidades angulares y analizar su comportamiento tanto en el dominio del tiempo como en frecuencia.

Por lo tanto, el proyecto permitió aplicar de manera práctica conceptos de:

$$
\text{Espacio de estados}
$$

$$
\text{Control óptimo}
$$

$$
\text{Retroalimentación de estados}
$$

$$
\text{Estimación}
$$

y:

$$
\text{Análisis en frecuencia}
$$

sobre una plataforma experimental real.

---

## 8.13 Limitaciones

El modelo utilizado corresponde a una linealización alrededor de la posición vertical superior del péndulo.

Por esta razón, el controlador LQR presenta una región limitada de operación y requiere que el péndulo sea colocado manualmente cerca del punto de equilibrio.

No se implementó una estrategia no lineal de *swing-up* que permita elevar automáticamente el péndulo desde su posición inferior.

Además, las velocidades deben obtenerse mediante métodos de estimación, por lo que su calidad depende del comportamiento de los filtros, la selección de polos y el ruido presente en las mediciones.

Otra consideración importante es que la implementación desarrollada para la estimación corresponde a un **observador cinemático de tercer orden**, el cual funciona como un modelo local para procesar las señales de posición y no utiliza directamente las matrices $A$ y $B$ de la planta.

---

## 8.14 Trabajo futuro

Como continuación del proyecto podrían evaluarse diferentes mejoras:

1. Implementar una estrategia de *swing-up* para llevar automáticamente el péndulo hasta la región vertical.

2. Realizar un ajuste experimental más extenso de las matrices:

$$
Q
$$

y:

$$
R
$$

para estudiar diferentes compromisos entre rapidez y esfuerzo de control.

3. Evaluar diferentes ubicaciones de polos para los estimadores.

4. Comparar cuantitativamente las estimaciones mediante métricas como RMSE.

5. Analizar con mayor detalle la sensibilidad al ruido de los diferentes métodos.

6. Implementar y comparar un observador de estados basado explícitamente en el modelo completo de la planta.

7. Incorporar estrategias de control y estimación más robustas frente a incertidumbres del modelo y perturbaciones externas.

Estas mejoras permitirían ampliar el rango de operación y analizar con mayor profundidad el desempeño del sistema.

---

## 8.15 Aprendizajes del proyecto

El desarrollo permitió comprobar que el diseño de un controlador no termina con obtener una ganancia en MATLAB.

Para que el sistema funcione físicamente también es necesario considerar:

- La correcta interpretación de los encoders.
- Las unidades utilizadas.
- La referencia angular del péndulo.
- La construcción del vector de estados.
- La estimación de velocidades.
- Las limitaciones del actuador.
- La región de operación del modelo linealizado.
- La integración entre software y hardware.

Estos elementos fueron fundamentales para transformar el modelo matemático en un sistema experimental funcional.

---

## 8.16 Conclusión general

El proyecto permitió implementar un sistema de control avanzado sobre el QUBE-Servo 3 en configuración de péndulo invertido.

El análisis inicial confirmó que la planta es controlable y que presenta una dinámica inestable alrededor de la posición vertical superior.

Mediante el controlador LQR fue posible modificar esta dinámica y obtener un sistema estable alrededor del punto de operación.

Posteriormente se implementaron métodos de estimación destinados a obtener las velocidades requeridas por el vector de estados y se analizaron diferentes alternativas mediante herramientas temporales y de frecuencia.

La implementación experimental permitió relacionar directamente el desarrollo matemático con el comportamiento físico de la plataforma.

En conjunto, el proyecto demuestra la aplicación práctica del modelado en espacio de estados, el control óptimo mediante LQR y las técnicas de estimación dentro de un sistema mecatrónico real.
