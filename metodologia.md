---
layout: default
title: 3. Metodología
nav_order: 4
permalink: /metodologia/
---

# Metodología

El desarrollo del proyecto se realizó mediante una secuencia que integra el modelado matemático del **QUBE-Servo 3**, la representación del sistema en espacio de estados, el procesamiento de las señales obtenidas mediante sus encoders y la implementación del sistema de control en MATLAB y Simulink.

---

## 3.1 Plataforma experimental

La plataforma utilizada para el desarrollo del proyecto es el **QUBE-Servo 3 de Quanser** en configuración de péndulo rotacional invertido.

El sistema está formado principalmente por:

- Un servomotor rotacional.
- Un brazo horizontal.
- Un péndulo.
- Un encoder para medir la posición del brazo.
- Un encoder para medir la posición del péndulo.
- Una interfaz electrónica para adquisición y actuación.
- Comunicación con MATLAB y Simulink.

El motor produce el movimiento del brazo rotacional, mientras que el péndulo se encuentra unido mecánicamente al sistema y puede girar libremente.

El objetivo del sistema de control es utilizar el movimiento del brazo para mantener el péndulo alrededor de su posición vertical superior.

![Plataforma QUBE-Servo 3]({{ site.baseurl }}/assets/images/qube_pend.png)

*Figura 1. Plataforma QUBE-Servo 3 en configuración de péndulo invertido utilizada durante las pruebas experimentales.*

---

## 3.2 Definición de variables

Para describir la dinámica del sistema se utilizan cuatro variables de estado:

($$\theta$$) Posición angular del brazo rotacional.

($$\alpha$$) Posición angular del péndulo respecto a la vertical

($$\dot{\theta}$$) / ($$\dot{\alpha}$$) Velocidades angulares 

Por lo tanto, el vector de estados se define como:

$$
x=
\begin{bmatrix}
\theta \\
\alpha \\
\dot{\theta} \\
\dot{\alpha}
\end{bmatrix}
$$

o equivalentemente:

$$
x=
\begin{bmatrix}
x_1 \\
x_2 \\
x_3 \\
x_4
\end{bmatrix}
=
\begin{bmatrix}
\theta \\
\alpha \\
\dot{\theta} \\
\dot{\alpha}
\end{bmatrix}
$$

La entrada del sistema corresponde al voltaje aplicado al motor ($$u=V_m$$).

---

## 3.3 Parámetros físicos del sistema

Para construir el modelo matemático se utilizaron los parámetros nominales del QUBE-Servo 3.

### Motor

| Parámetro | Símbolo | Valor | Unidad |
|---|---|---:|---|
| Resistencia del motor | $R_m$ | 7.5 | $\Omega$ |
| Constante de torque | $k_t$ | 0.0422 | N·m/A |
| Constante contraelectromotriz | $k_m$ | 0.0422 | V·s/rad |

### Brazo rotacional

| Parámetro | Símbolo | Valor | Unidad |
|---|---|---:|---|
| Masa del brazo | $m_r$ | 0.095 | kg |
| Longitud del brazo | $r$ | 0.085 | m |
| Amortiguamiento viscoso | $b_r$ | $1\times10^{-3}$ | N·m·s/rad |

### Péndulo

| Parámetro | Símbolo | Valor | Unidad |
|---|---|---:|---|
| Masa del péndulo | $m_p$ | 0.024 | kg |
| Longitud del péndulo | $L_p$ | 0.129 | m |
| Centro de masa | $l$ | 0.0645 | m |
| Amortiguamiento viscoso | $b_p$ | $5\times10^{-5}$ | N·m·s/rad |
| Gravedad | $g$ | 9.81 | m/s² |

El centro de masa del péndulo se considera en ($$l=\frac{L_p}{2}$$), por lo tanto ($$l=\frac{0.129}{2}=0.0645\;m$$).

---

## 3.4 Cálculo de inercias

El momento de inercia del brazo rotacional se calcula mediante:

$$
J_r=\frac{m_r r^2}{3}
$$

Sustituyendo los parámetros:

$$
J_r=
\frac{(0.095)(0.085)^2}{3}
$$

se obtiene aproximadamente:

$$
J_r=2.287917\times10^{-4}\;kg\,m^2
$$

Para el péndulo:

$$
J_p=\frac{m_pL_p^2}{3}
$$

por lo tanto:

$$
J_p=
\frac{(0.024)(0.129)^2}{3}
$$

obteniéndose:

$$
J_p=1.33128\times10^{-4}\;kg\,m^2
$$

También se define una inercia total equivalente:

$$
J_t=
(J_r+m_pr^2)J_p
-
m_p^2l^2r^2
$$

obteniéndose aproximadamente:

$$
J_t=3.62297\times10^{-8}
$$

Estas inercias son utilizadas posteriormente para determinar los elementos de las matrices del modelo.

---

## 3.5 Modelo matemático linealizado

Para el diseño del sistema de control se utiliza un modelo linealizado alrededor de la posición vertical superior del péndulo.

La representación general en espacio de estados está dada por:

$$
\dot{x}=Ax+Bu
$$

$$
y=Cx+Du
$$

La matriz de estados tiene la estructura:

$$
A=
\begin{bmatrix}
0 & 0 & 1 & 0\\
0 & 0 & 0 & 1\\
0 & A_{32} & A_{33} & A_{34}\\
0 & A_{42} & A_{43} & A_{44}
\end{bmatrix}
$$

mientras que la matriz de entrada es:

$$
B=
\begin{bmatrix}
0\\
0\\
B_3\\
B_4
\end{bmatrix}
$$

---

## 3.6 Obtención de los términos del modelo

Los elementos de las matrices se calculan a partir de los parámetros físicos del sistema.

### Término $A_{32}$

$$
A_{32}=
\frac{m_p^2l^2rg}{J_t}
$$

### Término $A_{42}$

$$
A_{42}=
\frac{m_pgl(J_r+m_pr^2)}{J_t}
$$

### Término $A_{33}$

$$
A_{33}
=
-\frac{b_rJ_p}{J_t}
-
\frac{k_m^2J_p}{R_mJ_t}
$$

### Término $A_{43}$

$$
A_{43}
=
-\frac{m_plrb_r}{J_t}
-
\frac{k_m^2m_plr}{R_mJ_t}
$$

### Término $A_{34}$

$$
A_{34}
=
-\frac{m_plrb_p}{J_t}
$$

### Término $A_{44}$

$$
A_{44}
=
-\frac{(J_r+m_pr^2)b_p}{J_t}
$$

### Entrada $B_3$

$$
B_3=
\frac{k_mJ_p}{R_mJ_t}
$$

### Entrada $B_4$

$$
B_4=
\frac{k_mm_plr}{R_mJ_t}
$$

---

## 3.7 Matrices numéricas del sistema

Después de sustituir los parámetros físicos se obtiene aproximadamente:

$$
A=
\begin{bmatrix}
0 & 0 & 1 & 0\\
0 & 0 & 0 & 1\\
0 & 55.1525 & -4.5471 & -0.1816\\
0 & 168.5810 & -4.4942 & -0.5551
\end{bmatrix}
$$

La matriz de entrada es:

$$
B=
\begin{bmatrix}
0\\
0\\
20.6755\\
20.4351
\end{bmatrix}
$$

Durante el desarrollo inicial se consideran los cuatro estados como salidas, por lo que:

$$
C=
\begin{bmatrix}
1&0&0&0\\
0&1&0&0\\
0&0&1&0\\
0&0&0&1
\end{bmatrix}
$$

es decir:

$$
C=I_4
$$

La matriz de transmisión directa es:

$$
D=
\begin{bmatrix}
0\\
0\\
0\\
0
\end{bmatrix}
$$

---

## 3.8 Implementación del modelo en MATLAB

La construcción del modelo se realizó en MATLAB a partir de los parámetros físicos.

La estructura principal utilizada es:

```matlab
A = [0    0     1     0;
     0    0     0     1;
     0   A32   A33   A34;
     0   A42   A43   A44];

B = [0;
     0;
     B3;
     B4];

C = eye(4);

D = zeros(4,1);
```

Con estas matrices se obtiene la representación linealizada utilizada para el diseño y análisis posterior del controlador.

---

## 3.9 Verificación de controlabilidad

Antes de diseñar el controlador es necesario verificar si todos los estados pueden ser modificados mediante la entrada disponible.

La matriz de controlabilidad se define como:

$$
\mathcal{C}=
\begin{bmatrix}
B & AB & A^2B & A^3B
\end{bmatrix}
$$

En MATLAB se obtiene mediante:

```matlab
Co = ctrb(A,B);
rango_C = rank(Co);
```

---

## 3.10 Análisis de los polos de la planta

El comportamiento natural de la planta se analiza mediante los valores propios de la matriz $A$.

En MATLAB se utiliza:

```matlab
polos_planta = eig(A);
```

Los polos permiten analizar la estabilidad de la planta antes de aplicar el controlador.

Debido a la naturaleza física del péndulo invertido, el sistema presenta dinámica inestable alrededor de la posición vertical superior si no existe una acción activa de control.

El análisis detallado de los polos y su modificación mediante el controlador se presenta en la sección **Control LQR**.

---

## 3.11 Adquisición de señales

La implementación experimental requiere obtener información en tiempo real desde los encoders del QUBE-Servo 3.

Las señales principales obtenidas desde el hardware son:

```text
baseEncoder
pendulumEncoder
```

`baseEncoder` proporciona la medición correspondiente al brazo rotacional.

`pendulumEncoder` proporciona la medición correspondiente al péndulo.

Inicialmente, estas señales se encuentran expresadas en cuentas digitales del encoder.

Por esta razón deben procesarse antes de ser utilizadas dentro del vector de estados.

---

## 3.12 Conversión de cuentas a ángulos

Las señales provenientes de los encoders deben convertirse de cuentas digitales a unidades angulares.

Esta operación se realiza dentro del subsistema:

**Counts to Angles**

Para el brazo rotacional se utiliza una conversión de la forma:

$$
\theta=
N_\theta
\left(
\frac{-2\pi}{512\cdot4}
\right)
$$

donde:

- ($N_\theta$) Cuentas del encoder del brazo.
- ($\theta$) Posición angular expresada en radianes.

Para el péndulo se utiliza:

$$
\alpha_{raw}=
N_\alpha
\left(
\frac{2\pi}{512\cdot4}
\right)
$$

donde:

- ($N_\alpha$) Cuentas del encoder del péndulo.
- ($\alpha_{raw}$) Angulo obtenido directamente después de la conversión.

La variable ($$\alpha_{raw}$$) corresponde a la señal angular antes de aplicar la corrección necesaria para establecer la referencia empleada durante el control del péndulo invertido.

Posteriormente se obtiene ($$\alpha$$) que representa el ángulo utilizado dentro del vector de estados.

![Conversión de cuentas a ángulos]({{ site.baseurl }}/assets/images/counts.png)

*Figura 2. Subsistema `Counts to Angles` utilizado para convertir las cuentas de los encoders en posiciones angulares expresadas en radianes.*

---

## 3.13 Construcción del vector de estados

Después de obtener:

$$
\theta
$$

y:

$$
\alpha
$$

se construye el vector requerido por el controlador:

$$
x=
\begin{bmatrix}
\theta\\
\alpha\\
\dot{\theta}\\
\dot{\alpha}
\end{bmatrix}
$$

Las posiciones ($$\theta,\quad\alpha$$) provienen directamente del procesamiento de las señales de los encoders.

Las velocidades ($$\dot{\theta},\quad\dot{\alpha}$$) deben obtenerse mediante procesamiento de las posiciones angulares.

Durante el proyecto se utilizan diferentes metodologías para obtener o estimar estas velocidades, las cuales posteriormente son comparadas dentro de las secciones **Observador de Estados** y **Resultados**.

![Construcción del vector de estados]({{ site.baseurl }}/assets/images/estadox.png)

*Figura 3. Subsistema `State X` utilizado para construir y procesar las variables del vector de estados.*

---

## 3.14 Arquitectura general en Simulink

Una vez definido el modelo matemático y procesadas las señales provenientes de los encoders, el sistema completo se implementa en Simulink.

La arquitectura general sigue la cadena:

```text
QUBE-Servo 3 I/O
        ↓
Lectura de encoders
        ↓
Counts to Angles
        ↓
θ , α
        ↓
State X
        ↓
[θ  α  θ̇  α̇]ᵀ
        ↓
Control LQR
        ↓
Enable Balance Control
        ↓
Saturación
        ↓
Voltaje del motor
        ↓
QUBE-Servo 3
```

El proceso se ejecuta continuamente, formando un sistema de **control en lazo cerrado**.

El movimiento generado por el motor modifica nuevamente las posiciones del brazo y del péndulo, las cuales son medidas por los encoders y retroalimentadas al controlador.

![Arquitectura general del sistema en Simulink]({{ site.baseurl }}/assets/images/diagrama_princ.png)

*Figura 4. Arquitectura general implementada en Simulink para el control del péndulo invertido mediante el QUBE-Servo 3.*

---

## 3.15 Funcionamiento en lazo cerrado

La implementación completa funciona mediante realimentación continua de las variables del sistema.

El funcionamiento puede resumirse como:

```text
        ┌───────────────────────┐
        │     QUBE-Servo 3      │
        └───────────┬───────────┘
                    ↓
                 Encoders
                    ↓
              θ, α, θ̇, α̇
                    ↓
               Control LQR
                    ↓
                 u = -Kx
                    ↓
                Saturación
                    ↓
              Voltaje del motor
                    ↓
        ┌───────────────────────┐
        │     QUBE-Servo 3      │
        └───────────────────────┘
```

Esta realimentación permite que el controlador responda continuamente ante las desviaciones del péndulo con respecto a la posición vertical.

---

## 3.16 Región de operación del controlador

El controlador LQR utilizado en el proyecto se diseña alrededor del punto de equilibrio correspondiente a la posición vertical superior.

Por esta razón, el sistema no utiliza una estrategia automática de *swing-up*.

Durante las pruebas experimentales, el péndulo se lleva manualmente hasta una región cercana a la posición vertical.

Una vez dentro de esta zona de operación, el controlador comienza a generar movimientos correctivos del brazo con el objetivo de mantener el equilibrio.

La habilitación del controlador se implementó mediante una función que verifica si el péndulo se encuentra dentro de la región cercana a la vertical:

```matlab
function y = fcn(u)

if abs(u) <= 0.175
    y = 1;
else
    y = 0;
end

end
```

---

## 3.17 Integración del sistema de estimación

Después de validar la implementación del controlador LQR se incorpora la segunda etapa del proyecto correspondiente a la estimación de variables.

El sistema desarrollado permite analizar principalmente las estimaciones de las velocidades angulares ($$\dot{\theta}$$) y ($$\dot{\alpha}$$).

La implementación utiliza un **observador cinemático de tercer orden**, además de una metodología de primer orden para realizar una comparación entre ambas aproximaciones.

Estas señales permiten completar el vector de estados requerido por el controlador y estudiar las diferencias entre las distintas metodologías de estimación.

La estructura, selección de polos, cálculo de ganancias y análisis detallado del observador se presentan en la sección **Observador de Estados**.
