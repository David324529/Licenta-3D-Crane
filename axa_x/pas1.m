run('script_3DCrane.m');
sim('Crane3D_testare');  
save('date_X.mat', 'uX', 'yX');

clear;  % Șterge variabilele din workspace
load('date_X.mat');  % Încarcă datele salvate

figure;  

subplot(2,1,1);  
plot(uX.time, uX.signals.values, 'b');
title('Semnal de intrare uX');
xlabel('Timp [s]');
ylabel('uX');
grid on;

subplot(2,1,2);  
plot(yX.time, yX.signals.values, 'r');
title('Răspuns sistem yX');
xlabel('Timp [s]');
ylabel('yX');
grid on;
