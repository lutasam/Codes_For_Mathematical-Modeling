clc,clear
format long
x=xlsread('data.xlsx');%把原始数据保存在纯文本文件data.txt中
X=x(:,[1:3]);%X为输入变量，3为输入变量的个数这里可以自己设置
X=X';
Y=x(:,[4:5]);%Y为输出变量，5（3+2），2为输出变量的个数这里可以自己设置
Y=Y';

n=size(X',1);m=size(X,1);s=size(Y,1);
A=[-X' Y'];
b=zeros(n,1);
LB=zeros(m+s,1);UB=[];
for i=1:n;
   f=[zeros(1,m)  -Y(:,i)'];
   Aeq=[X(:,i)',zeros(1,s)];beq=1;
   w(:,i)=linprog(f,A,b,Aeq,beq,LB,UB);
   E(i,i)=Y(:,i)'*w(m+1:m+s,i);
end
theta=diag(E)';
fprintf('用DEA方法对此的相对评价结果为：\n');
disp(theta);
omega=w(1:m,:)
mu=w(m+1:m+s,:)
