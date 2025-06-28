

function J = functie1_Y(RHO, N, eVirt1L, uHist1L)
[uk] = func_MFC_Y(RHO, N/2, eVirt1L);
J = 1/N/2 * sum((uHist1L(2,1:N/2) - uk(2,1:N/2)).^2);
end
