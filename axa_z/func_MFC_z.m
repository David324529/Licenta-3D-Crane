function [uk] = func_MFC_z(RHO, N, eVirt1L)
K1 = RHO(1); K2 = RHO(2); K3 = RHO(3);
uk = zeros(1, N);

for k = 3:N
    uk(1,k) = uk(1,k-1) + K1 * eVirt1L(1,k) + K2 * eVirt1L(1,k-1) + K3 * eVirt1L(1,k-2);
end
end
