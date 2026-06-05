function dxdt = planta_mls(x, u, params_reais)
    x1 = x(1); x2 = x(2); x3 = x(3);
    
    b_nom  = [params.b3, params.b2, params.b1, params.b0];
    Px   = @(y) polyval(b_nom, y);
    
    % Equações de Estado
    dx1 = x2;
    dx2 = params_reais.g - (x3^2)/(params_reais.m * Px(x1));
    dx3 = (1/params_reais.L0) * (u - params_reais.R*x3 - x3*(2/Px(x1))*x2);
    
    dxdt = [dx1; dx2; dx3];
end