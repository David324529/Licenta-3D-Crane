function [c, ceq] = restrictii_x(x)

c = abs(roots([1 x(1)-2 x(2)-1 x(3)])) - 0.99; 
ceq = [];
end