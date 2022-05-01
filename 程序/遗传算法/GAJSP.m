function [Zp,Y1p,Y2p,Y3p,Xp,LC1,LC2]=GAJSP(M,N,Pm,T,P)
%--------------------------------------------------------------------------
%  JSPGA.m
%  ��ˮ���ͳ�����ҵ�����Ŵ��㷨
%  GreenSim�Ŷӡ���רҵ���㷨���&��д����
%  ��ӭ����GreenSim�Ŷ���ҳ��blog.sina..cn/greensim
%--------------------------------------------------------------------------
%  ��������б�
%  M       �Ŵ�������������
%  N       ��Ⱥ��ģ(ȡż��)
%  Pm      �������
%  T       m��n�ľ��󣬴洢m������n������ļӹ�ʱ��
%  P       1��n��������n�������У�ÿһ�����������еĻ�����Ŀ
%  ��������б�
%  Zp      ���ŵ�Makespanֵ
%  Y1p     ���ŷ����У�������������Ŀ�ʼʱ�̣��ɸ������������ͼ
%  Y2p     ���ŷ����У�������������Ľ���ʱ�̣��ɸ������������ͼ
%  Y3p     ���ŷ����У�������������ʹ�õĻ������
%  Xp      ���ž��߱�����ֵ�����߱�����һ��ʵ�������m��n����
%  LC1     ��������1���������Ÿ�����Ӧֵ�ļ�¼
%  LC2     ��������2������Ⱥ��ƽ����Ӧֵ�ļ�¼
%  ��󣬳��򻹽��������ͼƬ��������������ͼ�͸���ͼ���������ĵ���ʱ��ͼ��
%��һ����������ʼ��
[m,n]=size(T);%m���ܹ�������n���ܹ�����
Xp=zeros(m,n);%���ž��߱���
LC1=zeros(1,M);%��������1
LC2=zeros(1,N);%��������2
%�ڶ��������������ʼ��Ⱥ
farm=cell(1,N);%����ϸ���ṹ�洢��Ⱥ
for k=1:N
    X=zeros(m,n);
    for j=1:n
        for i=1:m
            X(i,j)=1+(P(j)-eps)*rand;
        end
    end
    farm{k}=X;
end
counter=0;%���õ���������
while counter<M%ֹͣ����Ϊ�ﵽ����������    
    %������������
    newfarm=cell(1,N);%�������������Ⱥ��������
    Ser=randperm(N);
    for i=1:2:(N-1)
        A=farm{Ser(i)};%��������
        Manner=unidrnd(2);%���ѡ�񽻲淽ʽ
        if Manner==1
            cp=unidrnd(m-1);%���ѡ�񽻲��
            %˫��˫�ӵ��㽻��
            a=[A(1:cp,:);B((cp+1):m,:)];%�Ӵ�����
            b=[B(1:cp,:);A((cp+1):m,:)];
        else
            cp=unidrnd(n-1);%���ѡ�񽻲��
            b=[B(:,1:cp),A(:,(cp+1):n)];
        end
        newfarm{i}=a;%�������Ӵ�����newfarm
        newfarm{i+1}=b;
    end
    %�¾���Ⱥ�ϲ�
    FARM=[farm,newfarm];    
    %���Ĳ���ѡ����
    FITNESS=zeros(1,2*N);
    fitness=zeros(1,N);
    plotif=0;
    for i=1:(2*N)
        X=FARM{i};
        Z=COST(X,T,P,plotif);%���ü�����õ��Ӻ���
        FITNESS(i)=Z;
    end
    %ѡ���Ʋ�ȡ���������Ծ����ķ�ʽ�����б������Ÿ��������
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
    %��¼��Ѹ������������
    minfitness=min(fitness)
    meanfitness=mean(fitness)
    LC1(counter+1)=minfitness;%��������1���������Ÿ�����Ӧֵ�ļ�¼
    LC2(counter+1)=meanfitness;%��������2������Ⱥ��ƽ����Ӧֵ�ļ�¼
    pos=find(fitness==minfitness);
    Xp=farm{pos(1)};    
    %���岽������
    for i=1:N
        if Pm>rand;%�������ΪPm
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
%����������ͼ
figure(1);
plotif=1;
X=Xp;
[Zp,Y1p,Y2p,Y3p]=COST(X,T,P,plotif);
figure(2);
plot(LC1);
figure(3);
plot(LC2);
function [Zp,Y1p,Y2p,Y3p]=COST(X,T,P,plotif)
%  JSPGA�����Ӻ�������������ȷ�����Makespanֵ
%  ��������б�
%  X       ���ȷ����ı��������һ��ʵ�������m��n����
%  T       m��n�ľ��󣬴洢m������n������ļӹ�ʱ��
%  P       1��n��������n�������У�ÿһ�����������еĻ�����Ŀ
%  plotif  �Ƿ�����ͼ�Ŀ��Ʋ���
%  ��������б�
%  Zp      ���ŵ�Makespanֵ
%  Y1p     ���ŷ����У�������������Ŀ�ʼʱ��
%  Y2p     ���ŷ����У�������������Ľ���ʱ��
%  Y3p     ���ŷ����У�������������ʹ�õĻ������
%��һ����������ʼ��
[m,n]=size(X);
Y1p=zeros(m,n);
Y2p=zeros(m,n);
Y3p=zeros(m,n);
%�ڶ����������һ������İ���
Q1=zeros(m,1);
Q2=zeros(m,1);
R=X(:,1);%ȡ����һ������
Q3=floor(R);%����ȡ�����õ��������ڵ�һ������ʹ�õĻ����ı��
%��������������һ������Ŀ�ʼʱ�̺ͽ���ʱ��
for i=1:P(1)%ȡ���������
    pos=find(Q3==i);%ȡ��ʹ�ñ��Ϊi�Ļ���Ϊ��ӹ��Ĺ����ı��
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
%������������ʣ�๤��İ���
for k=2:n
    R=X(:,k);%ȡ����k������
    Q3=floor(R);%����ȡ�����õ��������ڵ�k������ʹ�õĻ����ı��
    %��������������k������Ŀ�ʼʱ�̺ͽ���ʱ��
    for i=1:P(k)%ȡ���������
        pos=find(Q3==i);%ȡ��ʹ�ñ��Ϊi�Ļ���Ϊ��ӹ��Ĺ����ı��
        lenpos=length(pos);
        if lenpos>=1
            EndTime=Y2p(pos,k-1);%ȡ����Щ��������һ�������еĽ���ʱ��
            POS=zeros(1,lenpos);%��һ���������ʱ�����絽�������
            for jj=1:lenpos
                POS(jj)=ppp(1);
                EndTime(ppp(1))=Inf;
            end            
            %������һ���������ʱ�̵����������������k������Ŀ�ʼʱ�̺ͽ���ʱ��
            Q1(pos(POS(1)))=Y2p(pos(POS(1)),k-1);
            Q2(pos(POS(1)))=Q1(pos(POS(1)))+T(pos(POS(1)),k);%ǰһ�������Ľ���ʱ��
            if lenpos>=2
                for j=2:lenpos
                    Q1(pos(POS(j)))=Y2p(pos(POS(j)),k-1);%Ԥ���Ŀ�ʼʱ��Ϊ��һ������Ľ���ʱ��
                    if Q1(pos(POS(j)))<Q2(pos(POS(j-1)))%�����ǰ��Ĺ����Ľ���ʱ�̻���
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
%���Ĳ����������ŵ�Makespanֵ
Y2m=Y2p(:,n);
Zp=max(Y2m);
%���岽�������ͼ
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
%  �˺�������С����
%  ����: 
%  mPoint1    �����1,��С,������
%  mPoint2    �����2,�ϴ�,������
%  mText      ������ı�,���,������
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