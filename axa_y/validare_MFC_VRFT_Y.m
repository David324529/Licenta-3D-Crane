function validare_MFC_VRFT_Y(RHO, Te, idx_split, d, uHist2, yHist2, refVirt2, uHist2L, eVirt2L)
K1 = RHO(1); K2 = RHO(2); K3 = RHO(3);
N = size(refVirt2, 2);
t = 0:Te:(N-1)*Te;
uPIDHist = zeros(2, N);
for k = 3:N
    uPIDHist(2,k) = uPIDHist(2,k-1) + K1*eVirt2L(2,k) + K2*eVirt2L(2,k-1) + K3*eVirt2L(2,k-2);
end
figure;
plot(uHist2L(2,:),'g'),hold on,plot(uPIDHist(2,:)),legend('target','achieved');
title('Validare VRFT – Comanda filtrată vs. Comanda PID estimată (axa y)');
end




