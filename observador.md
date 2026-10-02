---
layout: default
title: 7. Observador de estados
nav_order: 7
---

# Observador de estados

En la práctica, los encoders de la plataforma Quanser únicamente miden las posiciones angulares ($\theta$ y $\alpha$). Para implementar la ley de control LQR ($u = -Kx$), es indispensable conocer también las velocidades ($\dot{\theta}$ y $\dot{\alpha}$). 

En lugar de utilizar un observador de Luenberger dependiente del modelo físico de la planta (el cual es vulnerable a variaciones paramétricas), se diseñaron **observadores cinemáticos locales de tercer orden**.

## El problema de la derivada pura

Derivar la posición numéricamente para obtener la velocidad amplifica severamente el ruido eléctrico de alta frecuencia de los sensores. Esto inyecta vibraciones destructivas al motor. Para solucionar esto, el observador cinemático funciona como un diferenciador robusto que estima la velocidad mientras actúa simultáneamente como un filtro pasa-bajas.

## Dinámica del Observador Cinemático

Para estimar la velocidad de cada variable de forma independiente, se definió un subsistema de tres estados internos. Tomando la posición $\theta$ como ejemplo, las variables del observador son:

* $x_1 = \hat{\theta}$ (Posición estimada)
* $x_2 = \hat{\dot{\theta}}$ (Velocidad estimada)
* $x_3 = z$ (Estado interno del tercer integrador)

A partir del diagrama de bloques implementado, el error de estimación se define como $e = \theta - x_1$. Las ecuaciones diferenciales que rigen este observador son:

$$ \dot{x}_1 = x_2 $$

$$ \dot{x}_2 = l(\theta - x_1) + m \cdot x_3 $$

$$ \dot{x}_3 = (\theta - x_1) - \beta \cdot x_3 $$

Expresando este sistema en representación de espacio de estados ($\dot{\hat{x}} = \hat{A}\hat{x} + \hat{B}\theta$), obtenemos las matrices del observador ( $\hat{A}_\theta$ y $\hat{B}_\theta$ ):

$$
\hat{A}_\theta =
\begin{bmatrix}
0 & 1 & 0 \\
-l & 0 & m \\
-1 & 0 & -\beta
\end{bmatrix}
$$

$$
\hat{B}_\theta =
\begin{bmatrix}
0 \\
l \\
1
\end{bmatrix}
$$

## Selección de Polos y Cálculo de Ganancias

> **Nota Importante sobre la Regla de Sintonización:**  
> En el diseño de sistemas de control, existe una regla fundamental: **la dinámica del observador debe ser al menos de 5 a 10 veces más rápida que la del controlador**. Esto garantiza que el error de estimación converja a cero rápidamente y el controlador reciba datos precisos a tiempo. Si el observador fuera más lento, el LQR tomaría decisiones basadas en información atrasada, desestabilizando el péndulo.

Para cumplir rigurosamente con este principio, dado que los polos dominantes del controlador LQR se ubican en $s \approx -3.27$, los polos del observador deben ser significativamente más rápidos (ubicarse mucho más a la izquierda en el semiplano negativo).

Se propuso ubicar los tres polos del observador en:

$$ p_1 = -100, \quad p_2 = -100, \quad p_3 = -100 $$

Al desarrollar el polinomio característico deseado $(s + 100)^3 = 0$ e igualarlo con el polinomio teórico de la matriz $\hat{A}_\theta$, se despejaron algebraicamente las ganancias necesarias mediante MATLAB:

$$
l = 30000
$$

$$
m = -8000000
$$

$$
\beta = 300
$$

Estas mismas ganancias se aplicaron de forma simétrica para el subsistema encargado de estimar la velocidad del péndulo ($\hat{\dot{\alpha}}$).

## Implementación

Con los polos fijos en $-100$, el observador es aproximadamente 30 veces más rápido que la planta física. Esto asegura que la señal de velocidad se limpie del ruido del sensor y converja a su valor real casi instantáneamente, entregando estados precisos a la matriz de retroalimentación $K$ mucho antes de que el motor requiera ejecutar la acción de control de estabilización.
