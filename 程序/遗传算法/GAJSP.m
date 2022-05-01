function [Zp,Y1p,Y2p,Y3p,Xp,LC1,LC2]=GAJSP(M,N,Pm,T,P)
%--------------------------------------------------------------------------
%  JSPGA.m
%  流水线型车间作业调度遗传算法
%  GreenSim团队——专业级算法设计&代写程序
%  欢迎访问GreenSim团队主页→blog.sina..cn/greensim
%--------------------------------------------------------------------------
%  输入参数列表
%  M       遗传进化迭代次数
%  N       种群规模(取偶数)
%  Pm      变异概率
%  T       m×n的矩阵，存储m个工件n个工序的加工时间
%  P       1×n的向量，n个工序中，每一个工序所具有的机床数目
%  输出参数列表
%  Zp      最优的Makespan值
%  Y1p     最优方案中，各工件各工序的开始时刻，可根据它绘出甘特图
%  Y2p     最优方案中，各工件各工序的结束时刻，可根据它绘出甘特图
%  Y3p     最优方案中，各工件各工序使用的机器编号
%  Xp      最优决策变量的值，决策变量是一个实数编码的m×n矩阵
%  LC1     收敛曲线1，各代最优个体适应值的记录
%  LC2     收敛曲线2，各代群体平均适应值的记录
%  最后，程序还将绘出三副图片：两条收敛曲线图和甘特图（各工件的调度时序图）
%第一步：变量初始化
[m,n]=size(T);%m是总工件数，n是总工序数
Xp=zeros(m,n);%最优决策变量
LC1=zeros(1,M);%收敛曲线1
LC2=zeros(1,N);%收敛曲线2
%第二步：随机产生初始种群
farm=cell(1,N);%采用细胞结构存储种群
for k=1:N
    X=zeros(m,n);
    for j=1:n
        for i=1:m
            X(i,j)=1+(P(j)-eps)*rand;
        end
    end
    farm{k}=X;
end
counter=0;%设置迭代计数器
while counter<M%停止条件为达到最大迭代次数    
    %第三步：交叉
    newfarm=cell(1,N);%交叉产生的新种群存在其中
    Ser=randperm(N);
    for i=1:2:(N-1)
        A=farm{Ser(i)};%父代个体
        Manner=unidrnd(2);%随机选择交叉方式
        if Manner==1
            cp=unidrnd(m-1);%随机选择交叉点
            %双亲双子单点交叉
            a=[A(1:cp,:);B((cp+1):m,:)];%子代个体
            b=[B(1:cp,:);A((cp+1):m,:)];
        else
            cp=unidrnd(n-1);%随机选择交叉点
            b=[B(:,1:cp),A(:,(cp+1):n)];
        end
        newfarm{i}=a;%交叉后的子代存入newfarm
        newfarm{i+1}=b;
    end
    %新旧种群合并
    FARM=[farm,newfarm];    
    %第四步：选择复制
    FITNESS=zeros(1,2*N);
    fitness=zeros(1,N);
    plotif=0;
    for i=1:(2*N)
        X=FARM{i};
        Z=COST(X,T,P,plotif);%调用计算费用的子函数
        FITNESS(i)=Z;
    end
    %选择复制采取两两随机配对竞争的方式，具有保留最优个体的能力
    Ser=randperm(2*N);
    for i=1:N
        f2=FITNESS(Ser(2*i));
        if f1<=f2
            farm{i}=FARM{Ser(2*i-1)};
            fitness(i)=FITNESS(Ser(2*i-1));
        else
            farm{i}=FARM{Ser(2*i)};
        end
    end
    %记录最佳个体和收敛曲线
    minfitness=min(fitness)
    meanfitness=mean(fitness)
    LC1(counter+1)=minfitness;%收敛曲线1，各代最优个体适应值的记录
    LC2(counter+1)=meanfitness;%收敛曲线2，各代群体平均适应值的记录
    pos=find(fitness==minfitness);
    Xp=farm{pos(1)};    
    %第五步：变异
    for i=1:N
        if Pm>rand;%变异概率为Pm
            X=farm{i};
            I=unidrnd(m);
            J=unidrnd(n);
            X(I,J)=1+(P(J)-eps)*rand;
            farm{i}=X;
        end
    end
    farm{pos(1)}=Xp;    
    counter=counter+1
end
%输出结果并绘图
figure(1);
plotif=1;
X=Xp;
[Zp,Y1p,Y2p,Y3p]=COST(X,T,P,plotif);
figure(2);
plot(LC1);
figure(3);
plot(LC2);
function [Zp,Y1p,Y2p,Y3p]=COST(X,T,P,plotif)
%  JSPGA的联子函数，用于求调度方案的Makespan值
%  输入参数列表
%  X       调度方案的编码矩阵，是一个实数编码的m×n矩阵
%  T       m×n的矩阵，存储m个工件n个工序的加工时间
%  P       1×n的向量，n个工序中，每一个工序所具有的机床数目
%  plotif  是否绘甘特图的控制参数
%  输出参数列表
%  Zp      最优的Makespan值
%  Y1p     最优方案中，各工件各工序的开始时刻
%  Y2p     最优方案中，各工件各工序的结束时刻
%  Y3p     最优方案中，各工件各工序使用的机器编号
%第一步：变量初始化
[m,n]=size(X);
Y1p=zeros(m,n);
Y2p=zeros(m,n);
Y3p=zeros(m,n);
%第二步：计算第一道工序的安排
Q1=zeros(m,1);
Q2=zeros(m,1);
R=X(:,1);%取出第一道工序
Q3=floor(R);%向下取整即得到各工件在第一道工序使用的机器的编号
%下面计算各工件第一道工序的开始时刻和结束时刻
for i=1:P(1)%取出机器编号
    pos=find(Q3==i);%取出使用编号为i的机器为其加工的工件的编号
    lenpos=length(pos);
    if lenpos>=1
        Q1(pos(1))=0;
        if lenpos>=2
            for j=2:lenpos
                Q1(pos(j))=Q2(pos(j-1));
                Q2(pos(j))=Q2(pos(j-1))+T(pos(j),1);
            end
        end
    end
end
Y1p(:,1)=Q1;
Y3p(:,1)=Q3;
%第三步：计算剩余工序的安排
for k=2:n
    R=X(:,k);%取出第k道工序
    Q3=floor(R);%向下取整即得到各工件在第k道工序使用的机器的编号
    %下面计算各工件第k道工序的开始时刻和结束时刻
    for i=1:P(k)%取出机器编号
        pos=find(Q3==i);%取出使用编号为i的机器为其加工的工件的编号
        lenpos=length(pos);
        if lenpos>=1
            EndTime=Y2p(pos,k-1);%取出这些机器在上一个工序中的结束时刻
            POS=zeros(1,lenpos);%上一个工序完成时间由早到晚的排序
            for jj=1:lenpos
                POS(jj)=ppp(1);
                EndTime(ppp(1))=Inf;
            end            
            %根据上一个工序完成时刻的早晚，计算各工件第k道工序的开始时刻和结束时刻
            Q1(pos(POS(1)))=Y2p(pos(POS(1)),k-1);
            Q2(pos(POS(1)))=Q1(pos(POS(1)))+T(pos(POS(1)),k);%前一个工件的结束时刻
            if lenpos>=2
                for j=2:lenpos
                    Q1(pos(POS(j)))=Y2p(pos(POS(j)),k-1);%预定的开始时刻为上一个工序的结束时刻
                    if Q1(pos(POS(j)))<Q2(pos(POS(j-1)))%如果比前面的工件的结束时刻还早
                        Q1(pos(POS(j)))=Q2(pos(POS(j-1)));
                    end
                end
            end
        end
    end
    Y1p(:,k)=Q1;
    Y2p(:,k)=Q2;
    Y3p(:,k)=Q3;
end
%第四步：计算最优的Makespan值
Y2m=Y2p(:,n);
Zp=max(Y2m);
%第五步：绘甘特图
if plotif
    for i=1:m
        for j=1:n
            mPoint1=Y1p(i,j);
            mPoint2=Y2p(i,j);
            mText=m+1-i;
            PlotRec(mPoint1,mPoint2,mText);
            Word=num2str(Y3p(i,j));
            %text(0.5*mPoint1+0.5*mPoint2,mText-0.5,Word);
            hold on
            x1=mPoint1;y1=mText-1;
            x2=mPoint2;y2=mText-1;
            x4=mPoint1;y4=mText;
            %fill([x1,x2,x3,x4],[y1,y2,y3,y4],'r');
            fill([x1,x2,x3,x4],[y1,y2,y3,y4],[1,0.5,1]);
            text(0.5*mPoint1+0.5*mPoint2,mText-0.5,Word);
        end
    end
end
function PlotRec(mPoint1,mPoint2,mText)
%  此函数画出小矩形
%  输入: 
%  mPoint1    输入点1,较小,横坐标
%  mPoint2    输入点2,较大,横坐标
%  mText      输入的文本,序号,纵坐标
vPoint = zeros(4,2) ;
vPoint(1,:) = [mPoint1,mText-1];
vPoint(2,:) = [mPoint2,mText-1];
vPoint(3,:) = [mPoint1,mText];
vPoint(4,:) = [mPoint2,mText];
plot([vPoint(1,1),vPoint(2,1)],[vPoint(1,2),vPoint(2,2)]);
hold on ;
plot([vPoint(1,1),vPoint(3,1)],[vPoint(1,2),vPoint(3,2)]);
plot([vPoint(2,1),vPoint(4,1)],[vPoint(2,2),vPoint(4,2)]);
plot([vPoint(3,1),vPoint(4,1)],[vPoint(3,2),vPoint(4,2)]);