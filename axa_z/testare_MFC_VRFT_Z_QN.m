function testare_MFC_VRFT_Z(rho_qn, Te)

    % Extragem coeficientii PID
    K1 = rho_qn(1); 
    K2 = rho_qn(2); 
    K3 = rho_qn(3);

    % Încarcă modelul din Simulink
    run('script_3DCrane.m');  

    % Definirea semnalului de referință (treaptă)
    ref = [ ...
      -0.1*ones(1,45/Te), zeros(1,45/Te); 
       0.1*ones(1,45/Te), zeros(1,45/Te) ...
    ];

    N = size(ref,2);            % număr de pași
    t = 0:Te:(N-1)*Te;          % vector timp

    % Prealocări
    uHist       = zeros(2,N);
    yHist       = zeros(2,N);
    uPIDHist    = zeros(2,N);
    EpsilonHist = zeros(2,N);

    for k = 3:N-1
        %% Calculul erorii de urmărire
        EpsilonHist(2,k) = ref(2,k) - yHist(2,k);

      %% Regulator PID incremental
        uPID = uPIDHist(2,k-1) ...
             + K1 * EpsilonHist(2,k) ...
             + K2 * EpsilonHist(2,k-1) ...
             + K3 * EpsilonHist(2,k-2);

        %% Perturbații externe la 30s și 80s
        if abs(t(k) - 30) < Te/2
            uPID = uPID + 0.15;
        end
        if abs(t(k) - 70) < Te/2
            uPID = uPID - 0.15;
        end

        %% Saturația comenzii în [-0.9 0.9]
        uPID = min(  max(uPID, -0.9),  0.9);

    %% Salvăm comanda saturată
        uPIDHist(2,k) = uPID;
        uHist(2,k)    = uPID;

        %% Simulare răspuns cu model discret
        y_temp = filter(num_Z, den_Z, uPIDHist(2,1:k));
        yHist(2,k+1) = y_temp(end);
    end

  
    Jala = mean( (yHist(2,1:N) - ref(2,:)).^2 );
    fprintf('\nRezultate testare_MFC_VRFT_Z cu saturație:\n');
    fprintf('  K1=%.6f, K2=%.6f, K3=%.6f\n', K1, K2, K3);
    fprintf('  Eroare medie pătratică quasi newton=%.6e\n\n', Jala);

    % Ploturi
    figure;

    subplot(2,1,1);
    plot(t, uHist(2,:), 'LineWidth',1.2);
    ylim([-1.2, 1.2]);
    grid on;
    ylabel('U_z [%]');
    title('Comanda pe axa Z (limitata la [-0.9,0.9])');

    subplot(2,1,2);
    plot(t, yHist(2,1:N), 'b', 'LineWidth',1.2); hold on;
    plot(t, ref(2,:), 'g--', 'LineWidth',1.2);
    xline(30, '--r','LabelOrientation','horizontal');
    xline(70, '--r','LabelOrientation','horizontal');
    grid on;
    ylabel('\alpha_z [rad]');
    legend('y','ref','location','best');
    title(sprintf('Eroare medie pătratică: %.6e', Jala));
    xlabel('Timp [s]');

end
