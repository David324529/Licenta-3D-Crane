function [uk] = func_MFC_Y(RHO, N, eVirt1L)
K1 = RHO(1); K2 = RHO(2); K3 = RHO(3);
uk = zeros(2, N);
for k = 3:N
    uk(2,k) = uk(2,k-1) + K1*eVirt1L(2,k) + K2*eVirt1L(2,k-1) + K3*eVirt1L(2,k-2);
end
end