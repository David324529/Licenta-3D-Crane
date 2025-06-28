
function testare_MFC_VRFT_x(RHO, Te)

K1 = RHO(1); K2 = RHO(2); K3 = RHO(3);
load dateinitiale mrefdfiltru


N = 900;
t = 0:Te:(N-1)*Te;

% Referință de testare (pitch)
ref = [zeros(1,N); 0.7 * [ones(1,round(N/3)), -ones(1,round(N/3)), zeros(1,N - 2*round(N/3))]];

% Inițializare
uPIDHist = zeros(2,N);
uHist = zeros(2,N);
yHist = zeros(2,N);
EpsilonHist = zeros(2,N);


buffer = zeros(1, length(mrefdfiltru.num{1}));

% Rulare algoritm VRFT (fără simulare fizică)
for k = 3:N
    EpsilonHist(2,k) = ref(2,k) - yHist(2,k);
    uPIDHist(2,k) = uPIDHist(2,k-1) + K1*EpsilonHist(2,k) + K2*EpsilonHist(2,k-1) + K3*EpsilonHist(2,k-2);

 
    uk_temp = uPIDHist(2,1:k);
    y_temp = filter(mrefdfiltru.num{1}, mrefdfiltru.den{1}, uk_temp);
    yHist(2,k+1) = y_temp(end);

    uHist(2,k) = uPIDHist(2,k);  
end

Jala = 1/N * sum((yHist(2,1:N) - ref(2,:)).^2);
disp('Rezultatele pentru testare_MFC_VRFT_x:');
fprintf('K1 = %.6f, K2 = %.6f, K3 = %.6f\n', K1, K2, K3);
fprintf('Eroare medie pătratică (Jala) = %.6e\n', Jala);

% Plot rezultate
figure;
subplot(2,1,1);
plot(t, uHist(2,:)); ylabel('U_{pitch} [%]'); grid on;
subplot(2,1,2);
plot(t, yHist(2,1:N), 'b', t, ref(2,:), 'g--'); ylabel('\alpha_{pitch} [rad]'); legend('y', 'ref'); grid on;
title(['Eroare medie pătratică: ', num2str(Jala)]);



end