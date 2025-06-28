function [uk] = func_MFC_x(RHO, N, eVirt1L)
% Generează comanda PID incrementală u[k] pe baza erorii filtrate
% RHO = [K1, K2, K3], coeficienții PID estimați
% N = lungimea semnalului
% eVirt1L = eroarea filtrată 

K1 = RHO(1); K2 = RHO(2); K3 = RHO(3);
uk = zeros(1, floor(N)); 
for k = 3:N
    uk(k) = uk(k-1) + K1 * eVirt1L(k) + K2 * eVirt1L(k-1) + K3 * eVirt1L(k-2);
end
end
