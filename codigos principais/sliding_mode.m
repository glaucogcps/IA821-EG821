clear; clc; close all;

x0 = [0.005; 0; 0.5];
ref = 0.09;

lambda = 10;
k1 = lambda^2;
k2 = 2*lambda;
paramsr = preal();
sim('controlador_smc_diag.slx');

% 1. Configurações Gerais
num_sims = 10;          % Número de simulações (Aumente se quiser)
t_final = 10.0;          % Tempo de simulação (segundos)
t_comum = linspace(0, t_final, 1001)'; % Eixo de tempo fixo para o Python

%% Script de Simulação Monte Carlo - Robustez SMC

% Matrizes para armazenar resultados (cada coluna será uma simulação)
pos_matrix = zeros(length(t_comum), num_sims);
vel_matrix = zeros(length(t_comum), num_sims);
corr_matrix = zeros(length(t_comum), num_sims);
tens_matrix = zeros(length(t_comum), num_sims);

fprintf('Iniciando Monte Carlo (%d simulações)...\n', num_sims);

figure('Name', 'Monte Carlo - Robustez SMC', 'Color', 'w');

% 3. Loop de Simulação
for i = 1:num_sims
    fprintf('Simulando iteração %d/%d...\n', i, num_sims);
    
    % Gera parâmetros REAIS aleatórios com 25% de variação
    paramsr = preal(); 
    
    % Executa a simulação
    out = sim('controlador_smc_diag.slx', 'StopTime', num2str(t_final));
    
    % Extração de dados (ajustado para lidar com objetos de simulação modernos)
    t_raw = out.x.Time;
    pos_raw = out.x.Data(:,1);
    vel_raw = out.x.Data(:,2);
    corr_raw = out.x.Data(:,3);
    tens_raw = out.u.Data;
    
    % Interpolação para o tempo comum (essencial para CSV estruturado)
    pos_matrix(:,i) = interp1(t_raw, pos_raw, t_comum, 'linear', 'extrap');
    vel_matrix(:,i) = interp1(t_raw, vel_raw, t_comum, 'linear', 'extrap');
    corr_matrix(:,i) = interp1(t_raw, corr_raw, t_comum, 'linear', 'extrap');
    tens_matrix(:,i) = interp1(t_raw, tens_raw, t_comum, 'linear', 'extrap');
    
    % Plotagem "on-the-fly" para acompanhamento
    subplot(2,2,1); plot(t_comum, pos_matrix(:,i)*1000, 'Color', [0.7 0.7 0.7]); hold on;
    subplot(2,2,2); plot(t_comum, vel_matrix(:,i), 'Color', [0.8 0.9 0.8]); hold on;
    subplot(2,2,3); plot(t_comum, corr_matrix(:,i), 'Color', [0.8 0.8 0.8]); hold on;
    subplot(2,2,4); plot(t_comum, tens_matrix(:,i), 'Color', [0.9 0.8 0.8]); hold on;
end

%% 4. Formatação Final dos Gráficos (MATLAB)
subplot(2,2,1); grid on; ylabel('Posição (mm)'); title('Robustez: Posição');
yline(ref*1000, 'r--', 'LineWidth', 1.5);
subplot(2,2,2); grid on; ylabel('Velocidade (m/s)'); title('Velocidade');
subplot(2,2,3); grid on; ylabel('Corrente (A)'); title('Corrente');
subplot(2,2,4); grid on; ylabel('Tensão (V)'); title('Esforço de Controle');

%% 5. Exportação para Python (CSV Estruturado)
% Criamos tabelas onde a primeira coluna é o Tempo e as outras são as Simulações
T_pos = array2table([t_comum, pos_matrix]);
T_vel = array2table([t_comum, vel_matrix]);
T_corr = array2table([t_comum, corr_matrix]);
T_tens = array2table([t_comum, tens_matrix]);

% Nomeia as colunas: Tempo, Sim1, Sim2, ..., SimN
nomes = cell(1, num_sims + 1);
nomes{1} = 'Tempo';
for k = 1:num_sims
    nomes{k+1} = sprintf('Sim_%d', k);
end
T_pos.Properties.VariableNames = nomes;
T_vel.Properties.VariableNames = nomes;
T_corr.Properties.VariableNames = nomes;
T_tens.Properties.VariableNames = nomes;

% Salva os arquivos
writetable(T_pos, 'mc_posicao_smci.csv');
writetable(T_vel, 'mc_velocidade_smci.csv');
writetable(T_corr, 'mc_corrente_smci.csv');
writetable(T_tens, 'mc_tensao_smci.csv');

fprintf('Finalizado! Arquivos CSV gerados para reconstrução no Python.\n');

% print('-scontrolador_smc_diag', '-dpdf', 'diagrama_ismc.pdf')

