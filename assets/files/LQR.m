%% ================================================================
% QUBE-SERVO 3 - PENDULO INVERTIDO
% MODELO + CONTROLABILIDAD + LQR
% ================================================================

%% PARAMETROS

Rm = 7.5;
kt = 0.0422;
km = 0.0422;

mr = 0.095;
r  = 0.085;
br = 1e-3;

mp = 0.024;
Lp = 0.129;
l  = 0.0645;
bp = 5e-5;

g = 9.81;

%% INERCIAS

Jr = mr*r^2/3;
Jp = mp*Lp^2/3;
Jt = (Jr + mp*r^2)*Jp - mp^2*l^2*r^2;

fprintf('\n========================================\n');
fprintf('PARAMETROS CALCULADOS\n');
fprintf('========================================\n');

fprintf('Jr = %.10f kg*m^2\n',Jr);
fprintf('Jp = %.10f kg*m^2\n',Jp);
fprintf('Jt = %.10e\n',Jt);

%% MODELO LINEALIZADO
% x = [theta alpha theta_dot alpha_dot]'

A = [0 0 1 0;
     0 0 0 1;
     0 55.1525 -4.5471 -0.1816;
     0 168.5810 -4.4942 -0.5551];

B = [0;
     0;
     20.6755;
     20.4351];

C = eye(4);
D = zeros(4,1);

fprintf('\nMatriz A =\n');
disp(A)

fprintf('Matriz B =\n');
disp(B)

fprintf('Matriz C =\n');
disp(C)

fprintf('Matriz D =\n');
disp(D)

%% SISTEMA EN ESPACIO DE ESTADOS

sys = ss(A,B,C,D);

%% POLOS DE LA PLANTA

polos_planta = eig(A);

fprintf('\n========================================\n');
fprintf('POLOS DE LA PLANTA\n');
fprintf('========================================\n');

disp(polos_planta)

%% CONTROLABILIDAD

Co = ctrb(A,B);
rango_controlabilidad = rank(Co);

fprintf('\n========================================\n');
fprintf('CONTROLABILIDAD\n');
fprintf('========================================\n');

fprintf('Rango = %d\n',rango_controlabilidad);

if rango_controlabilidad == size(A,1)
    fprintf('El sistema es completamente controlable.\n');
else
    fprintf('El sistema NO es completamente controlable.\n');
end

%% LQR

Q = diag([10 200 1 1]);
R = 0.01;

K = lqr(A,B,Q,R);

fprintf('\n========================================\n');
fprintf('CONTROL LQR\n');
fprintf('========================================\n');

fprintf('Matriz Q =\n');
disp(Q)

fprintf('R =\n');
disp(R)

fprintf('Ganancia K =\n');
disp(K)

%% SISTEMA EN LAZO CERRADO

Acl = A-B*K;
polos_lqr = eig(Acl);

fprintf('\n========================================\n');
fprintf('POLOS CON LQR\n');
fprintf('========================================\n');

disp(polos_lqr)

%% VERIFICACION DE ESTABILIDAD

if all(real(polos_lqr) < 0)
    fprintf('El sistema con LQR es estable.\n');
else
    fprintf('Revisar el diseno: existe al menos un polo no estable.\n');
end

fprintf('\n========================================\n');
fprintf('ANALISIS TERMINADO\n');
fprintf('========================================\n');
