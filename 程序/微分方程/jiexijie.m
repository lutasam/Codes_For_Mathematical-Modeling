% ½âÎö½â
s = dsolve('D2y=3*y+2*x','x')

s = dsolve('D2y=3*y+2*t','y(0)=5')

s = dsolve('x*D2y - 3*Dy =x^2','y(1)=0','y(5) = 0','x')

s = dsolve('D2y =cos(2*x) - y','y(0) =1','Dy(0) = 0','x')
simplify(s);

[f,g]= dsolve('Df = f + g','Dg = -f + g','f(0)=1','g(0) = 2','x'); 