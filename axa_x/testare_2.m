function testare_2(RHO, Te)
    % Încarcă PID-ul şi modelul real
    load dateinitiale.mat;           % aduce RHO, ref etc.
    run('script_3DCrane.m');         % aduce num_X, den_X, Ts     

    N = 900;
    t = 0:Te:(N-1)*Te;

    % Referința de test
    ref = [zeros(1,N);
           0.7*[ones(1,round(N/3)), -ones(1,round(N/3)), zeros(1,N-2*round(N/3))]];

    uPIDHist = zeros(2,N);
    yHist    = zeros(2,N);

    for k = 3:N
        % calculează U_PID
        e_k = ref(2,k) - yHist(2,k);
        uPIDHist(2,k) = uPIDHist(2,k-1) ...
            + RHO(1)*e_k ...
            + RHO(2)*(ref(2,k-1)-yHist(2,k-1)) ...
            + RHO(3)*(ref(2,k-2)-yHist(2,k-2));

        % Simulare plantă reală
        uk_temp = uPIDHist(2,1:k);
        y_temp  = filter(num_X, den_X, uk_temp);  % ← AICI e procesul real
        yHist(2,k+1) = y_temp(end);
    end

    % Calculează performanța
    J_real = mean((yHist(2,1:N) - ref(2,1:N)).^2);
    figure;
    subplot(2,1,1), plot(t, uPIDHist(2,:)), ylabel('u [real]'), grid on;
    subplot(2,1,2), plot(t, yHist(2,1:N), t, ref(2,:), '--'), legend('y','ref'), grid on;
    title(['Eroare medie pătratică pe proces real: ', num2str(J_real)]);
end
