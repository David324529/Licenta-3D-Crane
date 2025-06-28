clear;
load('date_X.mat');  
% Extragem datele din structuri Simulink
u = uX.signals.values;
y = yX.signals.values;
t = uX.time;
Te = t(2) - t(1); 


N = length(u);
idx_split = floor(N / 2); 
uHistSPAB = zeros(2,N);
yHist = zeros(2,N);
uHistSPAB(2,:) = u(:)';
yHist(2,:) = y(:)';

% Inițializare
refVirt1 = zeros(2, idx_split);
refVirt2 = zeros(2, N - idx_split);
eVirt1   = zeros(2, idx_split);
eVirt2   = zeros(2, N - idx_split);
eVirt1L  = zeros(2, idx_split);
eVirt2L  = zeros(2, N - idx_split);
uHist1L  = zeros(2, idx_split);
uHist2L  = zeros(2, N - idx_split);

%% Modelul de referință
s = tf('s');
w0 = 2.5; zetta = 0.9;
MrefC = w0^2/(s^2+2*zetta*w0*s+w0^2);
MrefD = c2d(MrefC,Te,'zoh');
mrefdfiltru = filt(MrefD.num{1},MrefD.den{1},Te);
num = mrefdfiltru.num{1}; den = mrefdfiltru.den{1};
b1 = num(2); b2 = num(3); a1 = den(2); a2 = den(3);
L = (1 - mrefdfiltru)*mrefdfiltru;

%% Împărțire seturi
uHist1 = uHistSPAB(:,1:idx_split);
uHist2 = uHistSPAB(:,idx_split+1:end);
yHist1 = yHist(:,1:idx_split);
yHist2 = yHist(:,idx_split+1:end);

%% Calcul referință virtuală
for k=3:idx_split-1
    refVirt1(2,k-1) = (1/b1)*(-b2*refVirt1(2,k-2) + yHist1(2,k) + a1*yHist1(2,k-1) + a2*yHist1(2,k-2));
end

for k=3:(N - idx_split)-1
    refVirt2(2,k-1) = (1/b1)*(-b2*refVirt2(2,k-2) + yHist2(2,k) + a1*yHist2(2,k-1) + a2*yHist2(2,k-2));
end

eVirt1(2,:) = refVirt1(2,:) - yHist1(2,1:idx_split);
eVirt2(2,:) = refVirt2(2,:) - yHist2(2,1:(N - idx_split));

eVirt1L(2,:) = filter(L.num{1},L.den{1},eVirt1(2,:));
eVirt2L(2,:) = filter(L.num{1},L.den{1},eVirt2(2,:));
uHist1L(2,:) = filter(L.num{1},L.den{1},uHist1(2,:));
uHist2L(2,:) = filter(L.num{1},L.den{1},uHist2(2,:));

%% Estimare RHO cu metoda CMMPS
Y = zeros(idx_split,1);
for k=3:idx_split
    Y(k-2) = uHist1L(2,k) - uHist1L(2,k-1);
end

PHI = [eVirt1L(2,3:idx_split)' eVirt1L(2,2:idx_split-1)' eVirt1L(2,1:idx_split-2)'];
RHO = pinv(PHI'*PHI)*PHI'*Y(1:idx_split-2);

%%Quasi-Newton
p = size(PHI,2);           

[rho_qn,fval,exitflag] = fminunc(@(r) sum((PHI*r - Y(1:idx_split-2)).^2), zeros(p,1), ...
    optimoptions('fminunc','Algorithm','quasi-newton','Display','off'));
fprintf('Parametri Quasi-Newton:\n');
disp(rho_qn');
fprintf('Valoarea costului: %.4e\n', fval);
fprintf('Stare optimizare: %d\n', exitflag);
%%Sequential quadratic programming
rho_sqp = fmincon(@(r) sum((PHI*r - Y(1:idx_split-2)).^2), zeros(p,1), [], [], [], [], ...
    -inf(p,1), inf(p,1), [], optimoptions('fmincon','Algorithm','sqp','Display','off'));

disp('Parametri via SQP:'), disp(rho_sqp');

d = 0;
save('dateinitiale.mat','refVirt1','refVirt2','eVirt1','eVirt2','yHist1','uHist1','yHist2', ...
    'uHist2','b1','b2','a1','a2','N','Te', ...
    'd','mrefdfiltru','uHist1L','uHist2L','eVirt1L','eVirt2L')
functie1_x(RHO,idx_split,eVirt1L,uHist1L)
validare_MFC_VRFT_x(RHO,Te,idx_split,d,uHist2,yHist2,refVirt2,uHist2L,eVirt2L)
testare_MFC_VRFT_x(RHO,Te)

figure;
subplot(3,1,1);
plot(refVirt1(2,:), 'g'); hold on;
plot(yHist1(2,1:idx_split), 'r'); grid on;
legend('Ref. Virtuală', 'Ieșire reală');
title('Răspuns sistem față de referință virtuală');

subplot(3,1,2);
plot(eVirt1(2,:)); title('Eroarea virtuală'); grid on;

subplot(3,1,3);
plot(uHist1L(2,:), 'k'); title('Comandă filtrată L'); grid on;


