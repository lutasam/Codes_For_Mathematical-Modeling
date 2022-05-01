function dy = func(x,y)
dy = zeros(2,1);
dy(1) = y(2);
dy(2) = 2*x/(1+x.^2)*y(2);
end