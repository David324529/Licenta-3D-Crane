function [c, ceq] = restrictii_x(x)
% Definește restricții pentru polii sistemului (de stabilitate)

% Polinom caracteristic estimat
c = abs(roots([1 x(1)-2 x(2)-1 x(3)])) - 0.99; % Modificat: folosește x(1), x(2), x(3)
ceq = [];
end