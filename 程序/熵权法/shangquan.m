function [s,w]=shangquan(x)
% ����weight.m, ʵ������ֵ�����ָ��(�У���Ȩ�ؼ��������еĵ÷�
% xΪԭʼ���ݾ���, һ�д���һ������, ÿ�ж�Ӧһ��ָ��
% s���ظ��е÷�, w���ظ���Ȩ��
[n,m]=size(x); % ���ض������n, ָ�����m

%% ���ݵĹ�һ������
% Matlab2010b,2011a,b�汾����bug,�����´���. �����汾ֱ����[X,ps]=mapminmax(x��,0,1);����
[X,ps]=mapminmax(x��);
ps.ymin=0.002; % ��һ�������Сֵ
ps.ymax=0.996; % ��һ��������ֵ
ps.yrange=ps.ymax-ps.ymin; % ��һ����ļ���,����������ֵ, ������������
X=mapminmax(x��,ps);
% mapminmax(��reverse��,xx,ps); % ����һ��, �ص�ԭ����
X=X��; % XΪ��һ���������, n��(����), m��(ָ��)

%% �����j��ָ���£���i����¼ռ��ָ��ı���p(i,j)
for i=1:n
for j=1:m
p(i,j)=X(i,j)/sum(X(:,j));
end
end

%% �����j��ָ�����ֵe(j)
k=1/log(n);
for j=1:m
e(j)=-k*sum(p(:,j).log(p(:,j)));
end
d=ones(1,m)-e; % ������Ϣ�������
w=d./sum(d); % ��Ȩֵw
s=wp��; % ���ۺϵ÷�[\code]