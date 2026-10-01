%% ================================================================
% QUBE-SERVO 3 - ANALISIS DE BODE
% ================================================================

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

sys = ss(A,B,C,D);

figure
bode(sys)
grid on
title('Respuesta en frecuencia - QUBE Servo 3')

figure
bode(sys(1,1))
grid on
title('Bode - Voltaje a theta')

figure
bode(sys(2,1))
grid on
title('Bode - Voltaje a alpha')

figure
bode(sys(3,1))
grid on
title('Bode - Voltaje a theta dot')

figure
bode(sys(4,1))
grid on
title('Bode - Voltaje a alpha dot')
