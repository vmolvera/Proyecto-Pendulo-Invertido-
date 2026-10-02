---
layout: default
title: 7. Código Fuente
nav_order: 8
permalink: /codigo/
---

# Código Fuente

En esta sección se presenta el código principal desarrollado en **MATLAB** para el modelado, análisis y diseño del sistema de control del péndulo invertido utilizando el **QUBE-Servo 3**.

El programa integra en un mismo archivo las etapas principales del proyecto:

```text
Parámetros físicos
        ↓
Cálculo de inercias
        ↓
Modelo en espacio de estados
        ↓
Controlabilidad
        ↓
Polos de la planta
        ↓
Diseño LQR
        ↓
Sistema en lazo cerrado
        ↓
Observador de tercer orden
        ↓
Análisis en frecuencia
        ↓
Comparación de estimadores
```

El archivo principal utilizado es:

```text
obslqr.m
```

---

## 7.1 Organización general del programa

El código se encuentra organizado en los siguientes bloques:

| Bloque | Función |
|---|---|
| Parámetros | Define las características físicas del QUBE-Servo 3 |
| Inercias | Calcula $J_r$, $J_p$ y $J_t$ |
| Modelo | Construye las matrices $A$, $B$, $C$ y $D$ |
| Controlabilidad | Verifica si el sistema puede controlarse mediante la entrada |
| Polos | Analiza la estabilidad de la planta |
| LQR | Calcula las matrices $Q$, $R$ y la ganancia $K$ |
| Lazo cerrado | Calcula $A-BK$ y sus polos |
| Observador | Obtiene las ganancias de los estimadores de tercer orden |
| Espacio de estados del observador | Construye el modelo cinemático |
| Bode | Analiza la respuesta en frecuencia |
| Comparación | Compara tercer orden, primer orden y derivador ideal |

---

## 7.2 Definición de los estados

El programa considera los cuatro estados:

$$
x=
\begin{bmatrix}
\theta\\
\alpha\\
\dot{\theta}\\
\dot{\alpha}
\end{bmatrix}
$$

y como entrada:

$$
u=V_m
$$

En MATLAB se documentan de la siguiente manera:

```matlab
%% CONTROL LQR
% x1 = theta       -> angulo del brazo rotatorio [rad]
% x2 = alpha       -> angulo del pendulo respecto a vertical [rad]
% x3 = theta_dot   -> velocidad del brazo [rad/s]
% x4 = alpha_dot   -> velocidad del pendulo [rad/s]
% u = voltaje del motor [V]
```

---

## 7.3 Parámetros físicos

Los parámetros nominales utilizados son:

```matlab
%% 1. PARAMETROS
Rm = 7.5;          % Resistencia motor [Ohm]
kt = 0.0422;       % Constante de torque [N*m/A]
km = 0.0422;       % Constante contraelectromotriz [V*s/rad]

mr = 0.095;        % Masa brazo rotatorio [kg]
r  = 0.085;        % Longitud brazo rotatorio [m]
br = 1e-3;         % Amortiguamiento brazo [N*m*s/rad]

mp = 0.024;        % Masa pendulo [kg]
Lp = 0.129;        % Longitud pendulo [m]

l_cm = Lp/2;       % Centro de masa [m]
                    % Se utiliza l_cm para no interferir
                    % con la ganancia l del observador

bp = 5e-5;         % Amortiguamiento pendulo [N*m*s/rad]
g = 9.81;          % Gravedad [m/s^2]
```

---

## 7.4 Cálculo de inercias

Las inercias utilizadas por el modelo se calculan mediante:

```matlab
%% INERCIA

Jr = mr*r^2/3;

Jp = mp*Lp^2/3;

Jt = (Jr + mp*r^2)*Jp ...
     - mp^2*l_cm^2*r^2;
```

Posteriormente los resultados se muestran en la consola:

```matlab
fprintf('PARAMETROS CALCULADOS\n')

fprintf('Jr = %.10f kg*m^2\n',Jr);

fprintf('Jp = %.10f kg*m^2\n',Jp);

fprintf('Jt = %.10e\n',Jt);
```

---

## 7.5 Construcción del modelo

Los términos que forman las matrices del modelo se calculan mediante:

```matlab
%% TERMINOS DEL MODELO

A32 = mp^2*l_cm^2*r*g/Jt;

A42 = mp*g*l_cm*(Jr + mp*r^2)/Jt;

A33 = -(br*Jp)/Jt ...
      - (km^2*Jp)/(Rm*Jt);

A43 = -(mp*l_cm*r*br)/Jt ...
      - (km^2*mp*l_cm*r)/(Rm*Jt);

A34 = -(mp*l_cm*r*bp)/Jt;

A44 = -((Jr + mp*r^2)*bp)/Jt;

B3 = km*Jp/(Rm*Jt);

B4 = km*mp*l_cm*r/(Rm*Jt);
```

---

## 7.6 Representación en espacio de estados

Las matrices se construyen como:

```matlab
%% ESPACIO DE ESTADOS

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

Los valores obtenidos se muestran mediante:

```matlab
disp(' ')
disp('Matriz A =')
disp(A)

disp('Matriz B =')
disp(B)
```

---

## 7.7 Verificación de controlabilidad

La controlabilidad se verifica mediante:

```matlab
%% CONTROLABILIDAD

Co = ctrb(A,B);

rango_C = rank(Co);

fprintf('CONTROLABILIDAD\n')

fprintf('Rango = %d\n',rango_C)

if rango_C == 4

    disp('El sistema es completamente controlable')

else

    disp('El sistema NO es completamente controlable')

end
```

Debido a que el sistema posee cuatro estados, se requiere:

$$
rank(\mathcal{C})=4
$$

para considerarlo completamente controlable.

---

## 7.8 Polos de la planta

Los polos de la planta antes de aplicar el controlador se obtienen mediante:

```matlab
%% POLOS DE LA PLANTA SIN CONTROL

polos_planta = eig(A);

disp(' ')

disp('Polos de la planta sin control =')

disp(polos_planta)
```

Estos valores permiten estudiar la estabilidad natural del péndulo invertido.

---

## 7.9 Diseño del controlador LQR

Las matrices seleccionadas en la versión actual del programa son:

```matlab
%% Q Y R DEL LQR

Q = diag([1 20 0.1 0.1]);

R = 1;
```

La ganancia óptima se obtiene mediante:

```matlab
%% GANANCIA LQR

[K,S,P] = lqr(A,B,Q,R);

fprintf('CONTROL LQR\n')

disp('Ganancia K =')

disp(K)
```

La ley de control utilizada es:

$$
u=-Kx
$$

---

## 7.10 Sistema controlado

La matriz del sistema en lazo cerrado se calcula mediante:

```matlab
%% SISTEMA CONTROLADO

Acl = A - B*K;

polos_LQR = eig(Acl);

disp(' ')

disp('Polos del sistema con LQR =')

disp(polos_LQR)
```

Posteriormente se verifica automáticamente la estabilidad:

```matlab
%% VERIFICACION DE ESTABILIDAD

if all(real(polos_LQR) < 0)

    disp('LQR ESTABLE: todos los polos estan en el semiplano izquierdo.')

else

    disp('ADVERTENCIA: el sistema LQR no es estable.')

end
```

---

# Código del observador

## 7.11 Observadores cinemáticos de tercer orden

Después del controlador LQR se definen los observadores utilizados en Simulink.

En la implementación realizada se emplea un **diferenciador cinemático de tercer orden** para cada variable.

```matlab
%% OBSERVADORES CINEMATICOS DE TERCER ORDEN (SIMULINK)

% Este observador no utiliza las matrices de la planta (A, B).
% Es un diferenciador de tercer orden que funciona como un
% modelo cinematico local para cada variable.
```

---

## 7.12 Selección de polos

Los polos utilizados son:

```matlab
% 1. DEFINICION DE POLOS PARA LOS OBSERVADORES

% Los polos deben ser mas rapidos que la dinamica del LQR.

polos_theta = [-100,-100,-100];

polos_alpha = [-100,-100,-100];

poly_theta = poly(polos_theta);

poly_alpha = poly(polos_alpha);
```

Por lo tanto:

$$
p_\theta=
[-100,-100,-100]
$$

y:

$$
p_\alpha=
[-100,-100,-100]
$$

---

## 7.13 Ganancias del observador para theta

Las ganancias correspondientes al brazo se calculan mediante:

```matlab
% 2. CALCULO DE GANANCIAS PARA THETA

beta = poly_theta(2);

l = poly_theta(3);

m = poly_theta(4) - (l * beta);
```

---

## 7.14 Ganancias del observador para alpha

Para el péndulo se utiliza:

```matlab
% 3. CALCULO DE GANANCIAS PARA ALPHA

beta1 = poly_alpha(2);

l1 = poly_alpha(3);

m1 = poly_alpha(4) - (l1 * beta1);
```

Las ganancias calculadas se muestran mediante:

```matlab
fprintf('GANANCIAS DE LOS OBSERVADORES CINEMATICOS\n')

fprintf('Subsistema Theta:\n')
fprintf('l = %.4f \n', l);
fprintf('m = %.4f \n', m);
fprintf('beta = %.4f \n\n', beta);

fprintf('Subsistema Alpha:\n')
fprintf('l1 = %.4f \n', l1);
fprintf('m1 = %.4f \n', m1);
fprintf('beta1 = %.4f \n\n', beta1);
```

---

## 7.15 Matrices del observador

La estructura cinemática de tercer orden se representa mediante:

```matlab
% 4. MATRICES DEL OBSERVADOR
% ESTRUCTURA CINEMATICA

A_kin_theta = [ 0,  1,      0;
               -l,  0,      m;
               -1,  0, -beta];

B_kin_theta = [0;
               l;
               1];
```

Para extraer posición y velocidad estimadas se utilizan:

```matlab
C_kin = [1, 0, 0;    % Posicion estimada
         0, 1, 0];   % Velocidad estimada

D_kin = [0;
         0];
```

Las matrices también pueden visualizarse en la consola:

```matlab
disp('Matriz A del Observador Cinematico (A_kin) =')
disp(A_kin_theta)

disp('Matriz B del Observador Cinematico (B_kin) =')
disp(B_kin_theta)
```

---

## 7.16 Modelo del observador en espacio de estados

El sistema correspondiente al observador se construye mediante:

```matlab
sys_observador = ss( ...
    A_kin_theta, ...
    B_kin_theta, ...
    C_kin, ...
    D_kin);
```

Posteriormente se asignan nombres a sus entradas y salidas:

```matlab
sys_observador.OutputName = { ...
    'Posicion Estimada', ...
    'Velocidad Estimada'};

sys_observador.InputName = { ...
    'Posicion Medida'};
```

---

## 7.17 Análisis en frecuencia

Las opciones del diagrama de Bode se configuran mediante:

```matlab
opciones_bode = bodeoptions('cstprefs');

opciones_bode.FreqUnits = 'rad/s';

opciones_bode.Grid = 'on';
```

La gráfica se genera mediante:

```matlab
figure( ...
    'Name', ...
    'Analisis del Observador Cinematico en Frecuencia');

bode(sys_observador, opciones_bode);

title( ...
    'Diagrama de Bode del Observador Cinematico (Frecuencia en rad)');
```

> **Nota:** en algunos comentarios del archivo original se menciona "Hz", pero la configuración actual del programa utiliza explícitamente `FreqUnits = 'rad/s'`.

---

## 7.18 Comparación con el filtro de primer orden

Para comparar las metodologías se define:

```matlab
s = tf('s');

filtro_1er_orden = (50*s)/(s + 50);

derivador_puro = s;
```

El filtro de primer orden corresponde a:

$$
G_1(s)=\frac{50s}{s+50}
$$

mientras que el derivador ideal es:

$$
G_D(s)=s
$$

---

## 7.19 Salida de velocidad del observador

Como el sistema tiene dos salidas:

```text
Salida 1 → Posición estimada
Salida 2 → Velocidad estimada
```

se selecciona la segunda mediante:

```matlab
obs_3er_orden_vel = sys_observador(2,1);
```

---

## 7.20 Comparación mediante Bode

La comparación completa se genera mediante:

```matlab
figure( ...
    'Name', ...
    'Comparativa de Estimacion de Velocidad');

bode( ...
    obs_3er_orden_vel, ...
    'b', ...
    filtro_1er_orden, ...
    'r--', ...
    opciones_bode, ...
    derivador_puro, ...
    'g--');

title( ...
    'Estimacion de Velocidad: 3er Orden vs Filtro 1er Orden');

legend( ...
    'Observador Cinemático (3er Orden)', ...
    'Filtro Simple (1er Orden)', ...
    'Location', ...
    'SouthWest');
```

Esta comparación permite estudiar la respuesta del observador de tercer orden frente al estimador de primer orden y al comportamiento teórico de un derivador ideal.

---

# Código completo

## 7.21 Archivo `obslqr.m`

A continuación se presenta el código completo utilizado para el modelado, diseño del LQR y análisis del observador.

```matlab
%% CONTROL LQR
% x1 = theta       -> angulo del brazo rotatorio [rad]
% x2 = alpha       -> angulo del pendulo respecto a vertical [rad]
% x3 = theta_dot   -> velocidad del brazo [rad/s]
% x4 = alpha_dot   -> velocidad del pendulo [rad/s]
% u = voltaje del motor [V]

%% 1. PARAMETROS
Rm = 7.5;          % Resistencia motor [Ohm]
kt = 0.0422;       % Constante de torque [N*m/A]
km = 0.0422;       % Constante contraelectromotriz [V*s/rad]

mr = 0.095;        % Masa brazo rotatorio [kg]
r  = 0.085;        % Longitud brazo rotatorio [m]
br = 1e-3;         % Amortiguamiento brazo [N*m*s/rad]

mp = 0.024;        % Masa pendulo [kg]
Lp = 0.129;        % Longitud pendulo [m]

l_cm = Lp/2;       % Centro de masa [m]
                   % Cambiado a l_cm para no chocar con ganancia l

bp = 5e-5;         % Amortiguamiento pendulo [N*m*s/rad]
g = 9.81;          % Gravedad [m/s^2]

%% INERCIA
Jr = mr*r^2/3;
Jp = mp*Lp^2/3;

Jt = (Jr + mp*r^2)*Jp ...
     - mp^2*l_cm^2*r^2;

fprintf('PARAMETROS CALCULADOS\n')
fprintf('Jr = %.10f kg*m^2\n',Jr);
fprintf('Jp = %.10f kg*m^2\n',Jp);
fprintf('Jt = %.10e\n',Jt);

%% TERMINOS DEL MODELO
A32 = mp^2*l_cm^2*r*g/Jt;

A42 = mp*g*l_cm*(Jr + mp*r^2)/Jt;

A33 = -(br*Jp)/Jt ...
      - (km^2*Jp)/(Rm*Jt);

A43 = -(mp*l_cm*r*br)/Jt ...
      - (km^2*mp*l_cm*r)/(Rm*Jt);

A34 = -(mp*l_cm*r*bp)/Jt;

A44 = -((Jr + mp*r^2)*bp)/Jt;

B3 = km*Jp/(Rm*Jt);

B4 = km*mp*l_cm*r/(Rm*Jt);

%% ESPACIO DE ESTADOS
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

disp(' ')
disp('Matriz A =')
disp(A)

disp('Matriz B =')
disp(B)

%% CONTROLABILIDAD
Co = ctrb(A,B);

rango_C = rank(Co);

fprintf('CONTROLABILIDAD\n')

fprintf('Rango = %d\n',rango_C)

if rango_C == 4

    disp('El sistema es completamente controlable')

else

    disp('El sistema NO es completamente controlable')

end

%% POLOS DE LA PLANTA SIN CONTROL
polos_planta = eig(A);

disp(' ')

disp('Polos de la planta sin control =')

disp(polos_planta)

%% Q Y R DEL LQR
Q = diag([1 20 0.1 0.1]);

R = 1;

%% GANANCIA LQR
[K,S,P] = lqr(A,B,Q,R);

fprintf('CONTROL LQR\n')

disp('Ganancia K =')

disp(K)

%% SISTEMA CONTROLADO
Acl = A - B*K;

polos_LQR = eig(Acl);

disp(' ')

disp('Polos del sistema con LQR =')

disp(polos_LQR)

%% VERIFICACION DE ESTABILIDAD
if all(real(polos_LQR) < 0)

    disp('LQR ESTABLE: todos los polos estan en el semiplano izquierdo.')

else

    disp('ADVERTENCIA: el sistema LQR no es estable.')

end

%% OBSERVADORES CINEMATICOS DE TERCER ORDEN (SIMULINK)
% Este observador no utiliza las matrices de la planta (A, B).
% Es un diferenciador de tercer orden que funciona como un
% modelo cinematico local para cada variable.

%% 1. DEFINICION DE POLOS PARA LOS OBSERVADORES
% Los polos deben ser mas rapidos que la dinamica del LQR.

polos_theta = [-100,-100,-100];

polos_alpha = [-100,-100,-100];

poly_theta = poly(polos_theta);

poly_alpha = poly(polos_alpha);

%% 2. CALCULO DE GANANCIAS PARA THETA
beta = poly_theta(2);

l = poly_theta(3);

m = poly_theta(4) - (l * beta);

%% 3. CALCULO DE GANANCIAS PARA ALPHA
beta1 = poly_alpha(2);

l1 = poly_alpha(3);

m1 = poly_alpha(4) - (l1 * beta1);

fprintf('GANANCIAS DE LOS OBSERVADORES CINEMATICOS\n')

fprintf('Subsistema Theta:\n')

fprintf('l = %.4f \n', l);

fprintf('m = %.4f \n', m);

fprintf('beta = %.4f \n\n', beta);

fprintf('Subsistema Alpha:\n')

fprintf('l1 = %.4f \n', l1);

fprintf('m1 = %.4f \n', m1);

fprintf('beta1 = %.4f \n\n', beta1);

%% 4. MATRICES DEL OBSERVADOR
% Estructura cinematica de tercer orden

A_kin_theta = [ 0,  1,      0;
               -l,  0,      m;
               -1,  0, -beta];

B_kin_theta = [0;
               l;
               1];

% Matriz C para extraer posicion y velocidad estimadas
C_kin = [1, 0, 0;
         0, 1, 0];

D_kin = [0;
         0];

disp('Matriz A del Observador Cinematico (A_kin) =')

disp(A_kin_theta)

disp('Matriz B del Observador Cinematico (B_kin) =')

disp(B_kin_theta)

%% ANALISIS EN FRECUENCIA DEL OBSERVADOR

sys_observador = ss( ...
    A_kin_theta, ...
    B_kin_theta, ...
    C_kin, ...
    D_kin);

sys_observador.OutputName = { ...
    'Posicion Estimada', ...
    'Velocidad Estimada'};

sys_observador.InputName = { ...
    'Posicion Medida'};

opciones_bode = bodeoptions('cstprefs');

opciones_bode.FreqUnits = 'rad/s';

opciones_bode.Grid = 'on';

figure( ...
    'Name', ...
    'Analisis del Observador Cinematico en Frecuencia');

bode(sys_observador, opciones_bode);

title( ...
    'Diagrama de Bode del Observador Cinematico (Frecuencia en rad)');

%% ================================================================
% COMPARACION DE BODE:
% OBSERVADOR 3ER ORDEN VS FILTRO 1ER ORDEN
% ================================================================

s = tf('s');

filtro_1er_orden = (50*s)/(s + 50);

derivador_puro = s;

% Salida 2 del observador = velocidad estimada
obs_3er_orden_vel = sys_observador(2,1);

opciones_bode = bodeoptions('cstprefs');

opciones_bode.FreqUnits = 'rad/s';

opciones_bode.Grid = 'on';

figure( ...
    'Name', ...
    'Comparativa de Estimacion de Velocidad');

bode( ...
    obs_3er_orden_vel, ...
    'b', ...
    filtro_1er_orden, ...
    'r--', ...
    opciones_bode, ...
    derivador_puro, ...
    'g--');

title( ...
    'Estimacion de Velocidad: 3er Orden vs Filtro 1er Orden');

legend( ...
    'Observador Cinemático (3er Orden)', ...
    'Filtro Simple (1er Orden)', ...
    'Location', ...
    'SouthWest');
```

---

## 7.22 Relación entre MATLAB y Simulink

El archivo `obslqr.m` genera las variables necesarias para utilizar posteriormente el modelo de Simulink.

Entre las variables principales se encuentran:

```text
A
B
C
D

Q
R
K

Acl

polos_planta
polos_LQR

l
m
beta

l1
m1
beta1
```

Estas variables quedan disponibles en el **Workspace de MATLAB** y pueden ser utilizadas por los bloques correspondientes del modelo de Simulink.

La secuencia de trabajo es:

```text
Ejecutar obslqr.m
        ↓
Crear variables en Workspace
        ↓
Abrir modelo de Simulink
        ↓
Leer señales de encoders
        ↓
Construir State X
        ↓
Aplicar K
        ↓
Ejecutar controlador LQR
        ↓
Ejecutar estimadores
```

---

## 7.23 Archivos del proyecto

La estructura recomendada del repositorio para el código es:

```text
Proyecto-Pendulo-Invertido-/
│
├── obslqr.m
│
├── modelo_simulink.slx
│
├── index.md
├── introduccion.md
├── objetivos.md
├── metodologia.md
├── control_lqr.md
├── observador.md
├── resultados.md
├── codigo.md
├── conclusiones.md
│
└── assets/
    └── images/
```

El nombre del archivo `.slx` deberá sustituirse por el nombre real utilizado por el equipo.

---

## 7.24 Ejecución del programa

Para ejecutar el sistema se utiliza el siguiente procedimiento:

```text
1. Abrir MATLAB
        ↓
2. Abrir la carpeta del proyecto
        ↓
3. Ejecutar obslqr.m
        ↓
4. Verificar parámetros y matrices
        ↓
5. Verificar controlabilidad
        ↓
6. Verificar K y polos LQR
        ↓
7. Verificar ganancias del observador
        ↓
8. Abrir Simulink
        ↓
9. Ejecutar el modelo
        ↓
10. Realizar la prueba experimental
```

---

## 7.25 Salidas principales del programa

Al ejecutar el archivo se obtienen en MATLAB resultados correspondientes a:

- Inercias del sistema.
- Matrices $A$ y $B$.
- Rango de controlabilidad.
- Polos de la planta.
- Ganancia $K$ del LQR.
- Polos en lazo cerrado.
- Verificación de estabilidad.
- Ganancias del observador para $\theta$.
- Ganancias del observador para $\alpha$.
- Matrices del observador cinemático.
- Diagrama de Bode del observador.
- Comparación en frecuencia de los métodos de estimación.

Los resultados cuantitativos y las gráficas correspondientes se analizan en la sección **Resultados**.

---

## 7.26 Reproducibilidad

El código concentra los parámetros y cálculos principales utilizados durante el proyecto.

Esto permite reproducir el procedimiento partiendo de los parámetros físicos del sistema y obtener nuevamente:

$$
A,\quad B,\quad C,\quad D
$$

posteriormente:

$$
K
$$

y finalmente los parámetros asociados a los observadores de tercer orden.

La separación del programa en secciones facilita identificar la relación entre el desarrollo matemático, MATLAB y la implementación experimental en Simulink.

---

## 7.27 Resumen

El archivo `obslqr.m` integra las etapas principales del desarrollo:

```text
Modelo físico
      ↓
Espacio de estados
      ↓
Controlabilidad
      ↓
Diseño LQR
      ↓
Verificación de estabilidad
      ↓
Observador de tercer orden
      ↓
Análisis en frecuencia
```

De esta manera, el programa sirve como base para la configuración de los parámetros utilizados posteriormente por el modelo experimental en Simulink.
