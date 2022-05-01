datas=xlsread('RSR.xlsx');
X=datas(:,2:end);
w=[0.093 0.418 0.132 0.100 0.098 0.159];
X(:,[2 6])=-X(:,[2 6]); %����ָ��ת��Ϊ����ָ��
R=tiedrank(X); %��X�ĸ��зֱ����
[n,m]=size(R);
W=repmat(w,n,1);
WRSR=sum(W.*R,2)/n; %�����Ȩ�Ⱥͱ�: ��Ȩ,�������,�ٳ���n
freq=tabulate(WRSR); %ͳ��WRSR��Ƶ��,Ƶ��, freq�ĵ�3��ΪƵ��
p=cumsum(freq(:,3))/100; %�����ۻ�Ƶ��
p(end)=p(end)-1/(4*n); %�������һ���ۻ�Ƶ��
Probit=norminv(p,0,1)+5; %�����׼��̬�ֲ���p��λ��+5
Probit=[ones(n,1), Probit, Probit.^2, Probit.^3];
[b,bint,r,rint,stats]=regress(WRSR,Probit);
%���ζ���ʽ�ع�, һ�λ���ζ���ʽ�ع�R����pֵ�ϲ�
b
stats
WRSRfit=Probit*b %����WRSR�Ĺ���ֵ
[s,ind]=sort(WRSRfit,'descend') %��WRSR����ֵ�Ӵ�С����