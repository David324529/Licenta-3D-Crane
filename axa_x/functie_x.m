function J = functie_x(x, uHist1, yHist1, uHist2, yHist2)

RHOuri = x;

load('dateinitiale.mat', 'N', 'eVirt1L', 'uHist1L');

uk = func_MFC_x(RHOuri, N/2, eVirt1L);  
J = 1/(N/2) * sum((uHist1L(1,1:N/2) - uk(1,1:N/2)).^2);
end
