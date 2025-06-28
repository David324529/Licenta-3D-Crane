function testare_MFC_VRFT_x(RHO, Te)

K1 = RHO(1); K2 = RHO(2); K3 = RHO(3);

run('script_3DCrane.m');  


 ref=[-0.1*ones(1,45/Te) zeros(1,45/Te);  0.1*ones(1,45/Te) zeros(1,45/Te)];

d = 0/Te;
N = size(ref,2);
t = 0:Te:(N-1)*Te;

% Inițializare
uHist       = zeros(2,N);
yHist       = zeros(2,N);
uPIDHist    = zeros(2,N);
EpsilonHist = zeros(2,N);

% Rulare algoritm VRFT 
for k = 3:N-1
    EpsilonHist(2,k) = ref(2,k-d) - yHist(2,k);
    uPIDHist(2,k)   = uPIDHist(2,k-1) + K1*EpsilonHist(2,k) + K2*EpsilonHist(2,k-1) + K3*EpsilonHist(2,k-2);

    % Simulare cu modelul discretizat din Simulink
    uk_temp = uPIDHist(2,1:k);
    y_temp  = filter(num_X, den_X, uk_temp);
    yHist(2,k+1) = y_temp(end);

    uHist(2,k) = uPIDHist(2,k);  
end

Jala = 1/N * ((yHist(2,:) - ref(2,:)) * (yHist(2,:) - ref(2,:))');
disp('Rezultatele pentru testare_MFC_VRFT_x (proces Simulink):');
fprintf('K1 = %.6f, K2 = %.6f, K3 = %.6f\n', K1, K2, K3);
fprintf('Funcție de cost pătratică (Jala) = %.6e\n', Jala);

% Plot rezultate
t = 0:Te:(N-1)*Te;
figure;
subplot(2,1,1);
plot(t, uHist(2,:));
ylabel('U_{x} [%]'); grid on;
title(['Comanda aplicata pe axa x ']);

subplot(2,1,2);
plot(t, yHist(2,1:N), 'b', t, ref(2,:), 'g--');
ylabel('\alpha_{x} [rad]'); legend('y', 'ref'); grid on;
title(['Eroare medie pătratică: ', num2str(Jala)]);


end
