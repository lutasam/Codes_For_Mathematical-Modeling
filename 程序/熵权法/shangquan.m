function [s,w]=shangquan(x)
% 函数weight.m, 实现用熵值法求各指标(列）的权重及各数据行的得分
% x为原始数据矩阵, 一行代表一个对象, 每列对应一个指标
% s返回各行得分, w返回各列权重
[n,m]=size(x); % 返回对象个数n, 指标个数m

%% 数据的归一化处理
% Matlab2010b,2011a,b版本都有bug,需如下处理. 其它版本直接用[X,ps]=mapminmax(x’,0,1);即可
[X,ps]=mapminmax(x’);
ps.ymin=0.002; % 归一化后的最小值
ps.ymax=0.996; % 归一化后的最大值
ps.yrange=ps.ymax-ps.ymin; % 归一化后的极差,若不调整该值, 则逆运算会出错
X=mapminmax(x’,ps);
% mapminmax(‘reverse’,xx,ps); % 反归一化, 回到原数据
X=X’; % X为归一化后的数据, n行(对象), m列(指标)

%% 计算第j个指标下，第i个记录占该指标的比重p(i,j)
for i=1:n
for j=1:m
p(i,j)=X(i,j)/sum(X(:,j));
end
end

%% 计算第j个指标的熵值e(j)
k=1/log(n);
for j=1:m
e(j)=-k*sum(p(:,j).log(p(:,j)));
end
d=ones(1,m)-e; % 计算信息熵冗余度
w=d./sum(d); % 求权值w
s=wp’; % 求综合得分[\code]