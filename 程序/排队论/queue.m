clc
clear all
ave_t = zeros(10,100);
p = zeros(10,100);
nn = 10:10:5000;    %����·�ڵĳ���
count = zeros(size(nn,2),100);    %���г���

for d = 1:length(nn)
    for s = 1:100 
        n = nn(d);    %ģ�⳵����Ŀ
        dt = exprnd(6.7,1,n);    %ģ�⵽��ʱ����
        st = exprnd(6.3,1,n);    %ÿ��������·�����õ�ʱ��
        a = zeros(1,n);    %ÿ��������ʱ��
        b = zeros(1,n);    %ÿ��������·�ڵ�ʱ��
        c = zeros(1,n);    %ÿ�����뿪ʱ��
        a(1) = 0;
        
        for i = 2:n
            a(i) = a(i-1) + dt(i-1);
        end
        
        b(1) = 0;
        c(1) = b(1) + st(1);
        
        for i = 2:n
%�����i��������·�ڱ�ǰһ���뿪��ʱ���磬���䵽��·��ͣ���ߵ�ʱ��Ϊǰһ�����뿪ʱ��
           if(a(i) <= c(i-1))
               b(i) = c(i-1);
%�����i��������·�ڱ�ǰһ���뿪��ʱ�������䵽��·��ͣ���ߵ�ʱ��Ϊ�䵽��ʱ��
           else
               b(i) = a(i);
           end
%��i�����뿪ʱ��Ϊ�䵽��·��ͣ���ߵ�ʱ��+ͨ��·����Ҫ��ʱ��
           c(i) = b(i) + st(i);
       end
           
       for i = 2:n
           if(a(i) <= c(i-1))
               count(d,s) = count(d,s) + 1;
           else
               break;
           end
       end
           
        cost = zeros(1,n);
        for i = 1:n
            cost(i)=c(i)-a(i);    %��i�����ڶ����еȴ���ʱ��
        end
        T = c(n);    %��ʱ��
        p(d,s) = sum(st)/T;
        ave_t(d,s) = sum(cost)/n;
    end
end
pc = sum(p,2)/100;    %����ǿ��
aver_tc = sum(ave_t,2) / 100;    %�ڶ����кķѵ�ƽ��ʱ��
count = sum(count,2) / 100;

%��ͼ����
figure;
subplot(2,1,1)
plot(nn,aver_tc);
grid on;
title('ƽ���ȴ�ʱ���浽��·�ڳ��������仯����  ��λ����')
xlabel('����·�ڳ�������')
ylabel('ƽ���ȴ�ʱ��')   

subplot(2,1,2)
plot(nn,count);
grid on;
%ylim([0,2])
title('�����еĽ�ͨ�����浽��·�ڳ��������仯����  ��λ��pcu')
xlabel('����·�ڳ�������')
ylabel('�����еĳ�����') 
set(gcf,'color','w');
%p = fig2plotly(gcf,'offline',true);  