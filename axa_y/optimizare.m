clear
Te = 0.1;
Tsim = 90;
t = 0:Te:Tsim-Te;
N = length(t);

comandaProces = idinput(N, 'prbs', [0 0.03], [-0.02 0.02]);
u_total = [zeros(1,N); comandaProces];

uY.time = t';
uY.signals.values = u_total';
save('uY_sim.mat', 'uY');

run('script_3DCrane.m');
sim('Crane3D_testare');

load('date_Y.mat', 'uY', 'yY');
u_data = uY.signals.values';
y_data = yY.signals.values';

uHistSPAB = u_data;
yHist = y_data;

uHist1 = uHistSPAB(:,1:N/2);
uHist2 = uHistSPAB(:,N/2+1:end);
yHist1 = yHist(:,1:N/2);
yHist2 = yHist(:,N/2+1:end);

LB = [0.00001 0.00001 0.00001]';
UB = [30 30 30]';
opts = gaoptimset('PlotFcns', {@gaplotbestf, @gaplotstopping}, 'StallTimeLimit', 300, 'PopulationSize', 300);
[x, fval, EXITFLAG] = ga(@(x) functie_Y(x, uHist1, yHist1, uHist2, yHist2), 3, [],[],[],[],LB,UB,[],opts);

fprintf('Optimizare Y: K1 = %.4f, K2 = %.4f, K3 = %.4f\n', x(1), x(2), x(3));
