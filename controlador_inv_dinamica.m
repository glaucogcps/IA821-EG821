function u = controlador_inv_dinamica(x, v, params)
    % x = [posicao; velocidade; corrente]
    % v = sinal do controlador linear
    % params = struct com m, g, R, L0, b0, b1, b2, b3
    
    x1 = x(1); x2 = x(2); x3 = x(3);
    b_nom  = [params.b3, params.b2, params.b1, params.b0];
    % Polinômio Denominador e sua derivada
    Px   = @(y) polyval(b_nom, y);
    dPx  = @(y) polyval(polyder(b_nom), y);
    
    % Cálculo de LgLf2h (Ganho de controle)
    LgLf2h = -(2 * x3) / (params.L0 * params.m * Px(x1));
    
    % Cálculo de Lf3h (Dinâmica livre)
    term1 = (2*x3 * (params.R*x3 + (2*x2*x3)/Px(x1))) / (params.L0 * params.m * Px(x1));
    term2 = (x2 * x3^2 * dPx(x1)) / (params.m * Px(x1)^2);
    Lf3h = term1 + term2;
    
    % Lei de Controle por Inversão
    % Adicionado um pequeno valor (1e-6) para evitar divisão por zero se x3=0
    u = (1 / (LgLf2h + 1e-6)) * (-Lf3h + v);
    
    % Saturação física (Tabela I do artigo: 5V)
    if u > 5, u = 5; end
    if u < -5, u = -5; end
end