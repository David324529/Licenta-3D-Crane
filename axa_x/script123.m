%% 1) Încarci PID‐ul optimizat şi modelul
load('dateinitiale.mat','uHist1L','eVirt1L','mrefdfiltru');
run('script_3DCrane.m');   % aduce num_X,den_X,Ts

%% 2) Defineşti un vector de valori pentru primul parametru K1
RHO_opt = [K1_opt; K2_opt; K3_opt];   % pune aici RHO‐ul tău optim
K1_vals = linspace(RHO_opt(1)-2, RHO_opt(1)+2, 200);

J_vrft  = zeros(size(K1_vals));
J_real  = zeros(size(K1_vals));
Te      = Ts;   % pasul de eşantionare

for i = 1:length(K1_vals)
    rho = [K1_vals(i); RHO_opt(2); RHO_opt(3)];

    % --- 2a) cost VRFT folosind funcția ta de cost VRFT ---
    % varianta prescurtată din functie1_x:
    uk_v = func_MFC_x(rho, numel(eVirt1L), eVirt1L);
    J_vrft(i) = mean((uHist1L(2,1:numel(uk_v)) - uk_v(2,:)).^2);

    % --- 2b) cost real pe procesul real (fără plot) ---
    % simulare pe procesul real:
    Nsim = 900;
    ref  = [zeros(1,Nsim); 0.7*[ones(1,Nsim/3) -ones(1,Nsim/3) zeros(1,Nsim-2*Nsim/3)]];
    y = zeros(2,Nsim); uPID = zeros(2,Nsim);
    for k=3:Nsim
        e = ref(2,k)-y(2,k);
        uPID(2,k) = uPID(2,k-1) + rho(1)*e + rho(2)*(ref(2,k-1)-y(2,k-1)) + rho(3)*(ref(2,k-2)-y(2,k-2));
        y_temp = filter(num_X, den_X, uPID(2,1:k));
        y(2,k+1) = y_temp(end);
    end
    J_real(i) = mean((y(2,1:Nsim) - ref(2,1:Nsim)).^2);
end

%% 3) Plot-ezi ambele curbe
figure('Color','w');
plot(K1_vals, J_vrft, 'b--','LineWidth',1.5); hold on;
plot(K1_vals, J_real, 'r-','LineWidth',1.5);
xline(RHO_opt(1),'k:','LineWidth',1.2);
legend('J_{VRFT}','J_{real}','\theta_{opt}','Location','Best');
xlabel('K_1','FontSize',12);
ylabel('Cost','FontSize',12);
title('J_{VRFT} vs J_{real} pentru variaţie K_1','FontSize',14);
grid on;
