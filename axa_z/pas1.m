run('script_3DCrane.m');
sim('Crane3D_testare');
save('date_Z.mat', 'uZ', 'yZ');

clear;
load('date_Z.mat');

figure;
subplot(2,1,1);
plot(uZ.time, uZ.signals.values, 'b');
title('Semnal de intrare uZ');
xlabel('Timp [s]'); ylabel('uZ'); grid on;

subplot(2,1,2);
plot(yZ.time, yZ.signals.values, 'r');
title('Răspuns sistem yZ');
xlabel('Timp [s]'); ylabel('yZ'); grid on;

