%% CONTROL LQR
% x1 = theta -- angulo del brazo rotatorio [rad]
% x2 = alpha -- angulo del pendulo respecto a vertical [rad]
% x3 = theta_dot -- velocidad del brazo [rad/s]
% x4 = alpha_dot -- velocidad del pendulo [rad/s]
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
bp = 5e-5;         % Amortiguamiento pendulo [N*m*s/rad]
g = 9.81;          % Gravedad [m/s^2]

%% INERCIA
Jr = mr*r^2/3;
Jp = mp*Lp^2/3;
Jt = (Jr + mp*r^2)*Jp - mp^2*l_cm^2*r^2;

fprintf('PARAMETROS CALCULADOS\n')
fprintf('Jr = %.10f kg*m^2\n',Jr);
fprintf('Jp = %.10f kg*m^2\n',Jp);
fprintf('Jt = %.10e\n',Jt);

%% TERMINOS DEL MODELO
A32 = mp^2*l_cm^2*r*g/Jt;
A42 = mp*g*l_cm*(Jr + mp*r^2)/Jt;
A33 = -(br*Jp)/Jt - (km^2*Jp)/(Rm*Jt);
A43 = -(mp*l_cm*r*br)/Jt - (km^2*mp*l_cm*r)/(Rm*Jt);
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
disp('Matriz A:')
disp(A)
disp('Matriz B:')
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
disp('Polos de la planta sin control:')
disp(polos_planta)

%% Q Y R DEL LQR
Q = diag([1 20 0.1 0.1]);
R = 1;

%% GANANCIA LQR
[K,S,P] = lqr(A,B,Q,R);
fprintf('CONTROL LQR\n')
disp('Ganancia K:')
disp(K)

%% SISTEMA CONTROLADO
Acl = A - B*K;
polos_LQR = eig(Acl);
disp(' ')
disp('Polos del sistema con LQR:')
disp(polos_LQR)

%% OBSERVADORES DE TERCER ORDEN

% 1. DEFINICION DE POLOS PARA LOS OBSERVADORES
% Los polos deben ser mas rapidos que la dinamica del LQR, en este caso,
% mayor a 33

polos_theta = [-100,-100,-100]; 
polos_alpha = [-100,-100,-100]; 

poly_theta = poly(polos_theta); 
poly_alpha = poly(polos_alpha); 

% 2. CALCULO DE GANANCIAS PARA THETA 
beta = poly_theta(2);
l    = poly_theta(3);
m    = poly_theta(4) - (l * beta);

% 3. CALCULO DE GANANCIAS PARA ALPHA 
beta1 = poly_alpha(2);
l1    = poly_alpha(3);
m1    = poly_alpha(4) - (l1 * beta1);

fprintf('GANANCIAS DE LOS OBSERVADORES\n')
fprintf('Theta:\n')
fprintf('l = %.2f \n', l);
fprintf('m = %.2f \n', m);
fprintf('beta = %.2f \n\n', beta);

fprintf('Alpha:\n')
fprintf('l1 = %.2f \n', l1);
fprintf('m1 = %.2f \n', m1);
fprintf('beta1 = %.2f \n\n', beta1);

% 4. MATRICES DEL OBSERVADOR
A_gorro = [ 0, 1, 0; 
           -l, 0, m; 
           -1, 0, -beta];
         
B_gorro = [ 0; 
            l; 
            1];
          
% Matriz C para extraer posicion estimada y velocidad estimada
C_gorro = [ 1, 0, 0; 
            0, 1, 0]; 
          
D_gorro = [ 0; 
          0];

disp('Matriz A del Observador:')
disp(A_gorro)
disp('Matriz B del Observador:')
disp(B_gorro)

%% VERIFICACION DE POLOS DEL OBSERVADOR
polos_obs_calculados = eig(A_gorro);
disp(' ')
disp('Polos reales del observador:')
disp(polos_obs_calculados)

%%  ANALISIS EN FRECUENCIA DEL OBSERVADOR
% Espacio de estados del observador
sys_observador = ss(A_gorro, B_gorro, C_gorro, D_gorro);
sys_observador.OutputName = {'Posicion Estimada', 'Velocidad Estimada'};
sys_observador.InputName = {'Posicion Medida'};

% Bode en Radianes
opciones_bode = bodeoptions('cstprefs');
opciones_bode.FreqUnits = 'rad/s';
opciones_bode.Grid = 'on';

% Graficar bode
figure('Name', 'Analisis del Observador en Radianes');
bode(sys_observador, opciones_bode);
title('Diagrama de Bode del Observador (Frecuencia en rad)');

%% COMPARACION DE BODE: OBSERVADOR 3ER ORDEN VS FILTRO 1ER ORDEN VS S
% 1. Definir la funcion de transferencia de primer orden
s = tf('s');
filtro_1er_orden = (50*s) / (s + 50);

% 2. Extraer la respuesta de velocidad del observador de 3er orden
obs_3er_orden_vel = sys_observador(2,1); 

% 3. Definir la funcion de transferencia s
derivador_puro = s;

% 4. Configurar opciones del Bode en Radianes
opciones_bode = bodeoptions('cstprefs');
opciones_bode.FreqUnits = 'rad/s';
opciones_bode.Grid = 'on';

% 5. Graficar las metodologias para comprobar respuestas
figure('Name', 'Comparativa de Estimacion de Velocidad');
bode(obs_3er_orden_vel, 'b', filtro_1er_orden, 'r--', derivador_puro, 'g-.', opciones_bode);
title('Estimacion de Velocidad: 3er Orden vs Filtro 1er Orden vs S');
legend('Observador 3er Orden', 'Filtro 1er Orden', 'Derivador Puro (s)', 'Location', 'SouthWest');