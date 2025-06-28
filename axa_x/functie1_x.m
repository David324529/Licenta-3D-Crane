
function J = functie1_x(RHO, N, eVirt1L, uHist1L)
% functie1_x - calculează costul (J) dintre comanda reală filtrată
% și cea generată de PID
% Intrări:
%   RHO       - vector PID estimat [K1, K2, K3]
%   N         - lungimea semnalului
%   eVirt1L   - eroare filtrată 
%   uHist1L   - comandă filtrată din date reale 
%   J         - valoare cost 

[uk] = func_MFC_x(RHO, N/2, eVirt1L);  

% Funcția calculează costul mediu pătratic(Mean Squared Error) dintre:
% comanda reală filtrată (obținută din datele măsurate în buclă deschisă), și
% comanda generată de regulatorul PID estimat 
% (folosind eroarea virtuală filtrată ca intrare).
J = 1/(N/2) * sum((uHist1L(1,1:N/2) - uk(1,1:N/2)).^2);
end
