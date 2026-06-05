clear; clc; close all;

x0 = [0.005; 0; 0.05];
ref = 0.1;

A = [0, 1, 0;
    0, 0, 1;
    0, 0, 0];
B = [ 0; 0; 1];
polos = [-30, -5, -5];
K = acker(A, B, polos);

paramsr = preal();
sim('controlador_inv_diag.slx');

% Extrai o vetor de tempo
t = x.Time;

% O x.Data é uma matriz N x 3. 
posicao   = x.Data(:, 1); % Primeira coluna: x1 (posição em metros)
velocidade = x.Data(:, 2); % Segunda coluna: x2 (velocidade em m/s)
corrente   = x.Data(:, 3); % Terceira coluna: x3 (corrente em Amperes)
tensao = u.Data;

% Se você quiser em milímetros para o gráfico
posicao_mm = posicao * 1000;

figure('Name', 'Resultados da Levitação Magnética');

% Subplot 1: Posição
subplot(2,2,1);
plot(t, posicao_mm, 'b');
hold on;
yline(ref*1000, 'r--', 'Referência'); % Linha da referência
grid on;
ylabel('Posição (mm)');
title('Rastreamento de Trajetória - Inversão Dinâmica');

% Subplot 2: Velocidade
subplot(2,2,2);
plot(t, velocidade, 'g');
grid on;
ylabel('Velocidade (m/s)');

% Subplot 3: Corrente
subplot(2,2,3);
plot(t, corrente, 'k');
grid on;
ylabel('Corrente (A)');
xlabel('Tempo (s)');

% Subplot 4: Tensão
subplot(2,2,4);
plot(t, tensao, 'r');
grid on;
ylabel('Tensão (V)');
xlabel('Tempo (s)');

% Exportação para CSV (Python Reconstruct)
writetable(table(t, posicao_mm, 'VariableNames', {'Tempo', 'Posicao_mm'}), 'posicaor.csv');
writetable(table(t, velocidade, 'VariableNames', {'Tempo', 'Velocidade'}), 'velocidader.csv');
writetable(table(t, corrente, 'VariableNames', {'Tempo', 'Corrente'}), 'correnter.csv');
writetable(table(t, tensao, 'VariableNames', {'Tempo', 'Tensao'}), 'tensaor.csv');
