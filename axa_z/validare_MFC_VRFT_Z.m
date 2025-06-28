function validare_MFC_VRFT_Z(RHO, Te, idx_split, d, uHist2, yHist2, refVirt2, uHist2L, eVirt2L)
% Validare MFC-VRFT pentru axa Z 

K1 = RHO(1); K2 = RHO(2); K3 = RHO(3);
N = size(refVirt2, 2);
t = 0:Te:(N-1)*Te;

% Inițializare
uPIDHist = zeros(1, N);


for k = 3:N
    uPIDHist(1,k) = uPIDHist(1,k-1) + K1 * eVirt2L(1,k) + K2 * eVirt2L(1,k-1) + K3 * eVirt2L(1,k-2);
end
figure;
plot(uHist2L(1,:),'g'),hold on,plot(uPIDHist(1,:)),legend('target','achieved');
title('Validare VRFT – Comanda filtrată vs. Comanda PID estimată (axa z)');

end