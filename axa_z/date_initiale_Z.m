clear;
load('date_Z.mat');
%partea de preluare a semnalelor din simulink 
u = uZ.signals.values;
y = yZ.signals.values;
t = uZ.time;
Te = t(2) - t(1);

N = length(u);
idx_split = floor(N / 2);

uHistSPAB = zeros(1,N);
yHist = zeros(1,N);
uHistSPAB(:) = u(:)';
yHist(:) = y(:)';

refVirt1 = zeros(1, idx_split);
refVirt2 = zeros(1, N - idx_split);
eVirt1   = zeros(1, idx_split);
eVirt2   = zeros(1, N - idx_split);
eVirt1L  = zeros(1, idx_split);
eVirt2L  = zeros(1, N - idx_split);
uHist1L  = zeros(1, idx_split);
uHist2L  = zeros(1, N - idx_split);

s = tf('s');
w0 = 2; zetta = 0.9;
MrefC = w0^2/(s^2+2*zetta*w0*s+w0^2);
MrefD = c2d(MrefC,Te,'zoh');
mrefdfiltru = filt(MrefD.num{1},MrefD.den{1},Te);
num = mrefdfiltru.num{1}; den = mrefdfiltru.den{1};
b1 = num(2); b2 = num(3); a1 = den(2); a2 = den(3);
L = (1 - mrefdfiltru)*mrefdfiltru;

uHist1 = uHistSPAB(:,1:idx_split);
uHist2 = uHistSPAB(:,idx_split+1:end);
yHist1 = yHist(:,1:idx_split);
yHist2 = yHist(:,idx_split+1:end);

for k=3:idx_split-1
    refVirt1(k-1) = (1/b1)*(-b2*refVirt1(k-2) + yHist1(k) + a1*yHist1(k-1) + a2*yHist1(k-2));
end

for k=3:(N - idx_split)-1
    refVirt2(k-1) = (1/b1)*(-b2*refVirt2(k-2) + yHist2(k) + a1*yHist2(k-1) + a2*yHist2(k-2));
end

eVirt1 = refVirt1 - yHist1(1:idx_split);
eVirt2 = refVirt2 - yHist2(1:(N - idx_split));
eVirt1L = filter(L.num{1},L.den{1},eVirt1);
eVirt2L = filter(L.num{1},L.den{1},eVirt2);
uHist1L = filter(L.num{1},L.den{1},uHist1);
uHist2L = filter(L.num{1},L.den{1},uHist2);

Y = zeros(idx_split,1);
for k=3:idx_split
    Y(k-2) = uHist1L(k) - uHist1L(k-1);
end

PHI = [eVirt1L(3:idx_split)' eVirt1L(2:idx_split-1)' eVirt1L(1:idx_split-2)'];
RHO = pinv(PHI'*PHI)*PHI'*Y(1:idx_split-2); % cele mai mici patrate

%%Quasi-Newton
p = size(PHI,2);           

[rho_qn,fval,exitflag] = fminunc(@(r) sum((PHI*r - Y(1:idx_split-2)).^2), zeros(p,1), optimoptions('fminunc','Algorithm','quasi-newton','Display','off'));
fprintf('Parametri Quasi-Newton:\n');
disp(rho_qn');
fprintf('Valoarea costului: %.4e\n', fval);
fprintf('Stare optimizare: %d\n', exitflag);



rho_sqp = fmincon(@(r) sum((PHI*r - Y(1:idx_split-2)).^2), zeros(p,1), [], [], [], [], -inf(p,1), inf(p,1), [], optimoptions('fmincon','Algorithm','sqp','Display','off'));

disp('Parametri via SQP:'), disp(rho_sqp');





d = 0;
save('dateinitiale_Z.mat','refVirt1','refVirt2','eVirt1','eVirt2','yHist1','uHist1','yHist2','uHist2','b1','b2','a1','a2','N','Te','d','mrefdfiltru','uHist1L','uHist2L','eVirt1L','eVirt2L')
functie1_z(RHO,idx_split,eVirt1L,uHist1L)
validare_MFC_VRFT_Z(RHO,Te,idx_split,d,uHist2,yHist2,refVirt2,uHist2L,eVirt2L)
testare_MFC_VRFT_Z_QN(rho_qn,Te)
testare_MFC_VRFT_Z(RHO,Te)
