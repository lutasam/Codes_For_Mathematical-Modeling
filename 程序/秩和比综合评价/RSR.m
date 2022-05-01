datas=xlsread('RSR.xlsx');
X=datas(:,2:end);
w=[0.093 0.418 0.132 0.100 0.098 0.159];
X(:,[2 6])=-X(:,[2 6]); %负向指标转换为正向指标
R=tiedrank(X); %对X的各列分别编秩
[n,m]=size(R);
W=repmat(w,n,1);
WRSR=sum(W.*R,2)/n; %计算加权秩和比: 加权,按行求和,再除以n
freq=tabulate(WRSR); %统计WRSR的频数,频率, freq的第3列为频率
p=cumsum(freq(:,3))/100; %计算累积频率
p(end)=p(end)-1/(4*n); %修正最后一个累积频率
Probit=norminv(p,0,1)+5; %计算标准正态分布的p分位数+5
Probit=[ones(n,1), Probit, Probit.^2, Probit.^3];
[b,bint,r,rint,stats]=regress(WRSR,Probit);
%三次多项式回归, 一次或二次多项式回归R方和p值较差
b
stats
WRSRfit=Probit*b %计算WRSR的估计值
[s,ind]=sort(WRSRfit,'descend') %对WRSR估计值从大到小排序