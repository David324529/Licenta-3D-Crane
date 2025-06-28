run('script_3DCrane.m');
sim('Crane3D_testare');  % Model Simulink salveaza uY, yY
save('date_Y.mat', 'uY', 'yY');

clear;
load('date_Y.mat');

figure;
subplot(2,1,1);
plot(uY.time, uY.signals.values, 'b');
title('Semnal de intrare uY');
xlabel('Timp [s]'); ylabel('uY'); grid on;

subplot(2,1,2);
plot(yY.time, yY.signals.values, 'r');
title('Raspuns sistem yY');
xlabel('Timp [s]'); ylabel('yY'); grid on;
