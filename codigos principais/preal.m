function y = preal()
%   Parâmetro ajustável
    variacao = 0.2; 
    
    % Função auxiliar para aplicar erro
    erro = @(val) val * ((1 - variacao) + (2 * variacao) * rand());
    
    y.m  = erro(0.021);  
    y.g  = 9.81;
    y.L0 = erro(0.05);   
    y.R  = erro(1.2);
    y.b3 = erro(119.10);
    y.b2 = erro(-64.81);
    y.b1 = erro(14.58);
    y.b0 = erro(1.07);
end