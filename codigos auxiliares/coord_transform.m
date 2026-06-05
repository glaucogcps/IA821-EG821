function z = coord_transform(x, x_ref, params)
    % z1 = erro de posição
    % z2 = velocidade (derivada do erro)
    % z3 = aceleração não linear (segunda derivada do erro)
    
    x1 = x(1); x2 = x(2); x3 = x(3);
    b_nom  = [params.b3, params.b2, params.b1, params.b0];
    % Polinômio Denominador e sua derivada
    Px   = @(y) polyval(b_nom, y);
    
    z1 = x1 - x_ref;
    z2 = x2;
    z3 = params.g - (x3^2)/(params.m * Px(x1)); % Lf^2 h
    
    z = [z1; z2; z3];
end