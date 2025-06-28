clear
Te = 0.1; Tsim = 90; t = 0:Te:Tsim-Te; N = length(t);
comandaProces = idinput(N, 'prbs', [0 0.03], [-0.02 0.02]);
uZ.time = t'; uZ.signals.values = comandaProces'; save('uZ_sim.mat', 'uZ');
run('script_3DCrane.m'); sim('Crane3D_testare');
load('date_Z.mat', 'uZ', 'yZ');
u_data = uZ.signals.values'; y_data = yZ.signals.values';
uHistSPAB = zeros(2,N); yHist = zeros(2,N);
uHistSPAB(2,:) = u_data; yHist(2,:) = y_data;
uHist1 = uHistSPAB(:,1:N/2); uHist2 = uHistSPAB(:,N/2+1:end);
yHist1 = yHist(:,1:N/2); yHist2 = yHist(:,N/2+1:end);
LB = [0.00001 0.00001 0.00001]; UB = [30 30 30];
opts = gaoptimset('PlotFcns', {@gaplotbestf, @gaplotstopping}, 'StallTimeLimit', 300, 'PopulationSize', 300);
[x, fval, EXITFLAG] = ga(@(x) functie_z(x, uHist1, yHist1, uHist2, yHist2), 3, [], [], [], [], LB, UB, [], opts);
toc
fprintf('Optimizare completă axa Z: K1 = %.4f, K2 = %.4f, K3 = %.4f\n', x(1), x(2), x(3));
