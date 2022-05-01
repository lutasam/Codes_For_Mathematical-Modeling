function [g,h]=NonlinearConstraint(x) %非线性限制条件，g为<=条件，h为=条件
g=[-x(1).^2+x(2)-x(3).^2
    x(1)+x(2).^2+x(3).^3-20];
h=[-x(1)-x(2).^2+2
    x(2)+2*x(3).^2-3];
end