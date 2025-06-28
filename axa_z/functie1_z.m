function J = functie1_z(RHO, N, eVirt1L, uHist1L)
[uk] = func_MFC_z(RHO, N/2, eVirt1L);  
J = 1/(N/2) * sum((uHist1L(1,1:N/2) - uk(1,1:N/2)) .^ 2);
end
