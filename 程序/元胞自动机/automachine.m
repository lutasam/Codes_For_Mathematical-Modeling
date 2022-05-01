close;
clear;
clc;
n = 300;     %Ԫ�������С
Plight = 0.000001; Pgrowth = 0.001;
UL = [n 1:n-1];
DR = [2:n 1];
veg = zeros(n,n);        %��ʼ��
% The value of veg:
% empty == 0  
% burning == 1
% green == 2
imh = image(cat(3,veg,veg,veg));
m=annotation('textbox',[0.1,0.1,0.1,0.1],'LineStyle','-','LineWidth',1,'String','123');
for i = 1:100000
    sum = (veg(UL,:) == 1) + (veg(:,UL) == 1) + (veg(DR,:) == 1) + (veg(:,DR) == 1);
    %���ݹ������ɭ�־����� = �� - �Ż���� + ��������
    veg = 2 * (veg == 2) - ( (veg == 2) & (sum > 0 | (rand(n,n) < Plight)) ) + 2 * ( (veg == 0) & rand(n,n) < Pgrowth);
    a=find(veg==2);
    b=find(veg==1);
    aa=length(a);
    bb=length(b);
    shu(i)=aa;
    fire(i)=bb*30;
    if (bb>=0&&bb<=10)
        str1='ɭ������';
    elseif (bb>10&&bb<=100)
        str1='���ַ�չ';
    elseif (bb>100)
        str1='ɭ�ִ��';
    end
    if ((aa>48000)||(bb>=10))
        str2='����Ԥ������ɫԤ��';
    elseif (aa>42000&&aa<=48000)
        str2='����Ԥ������ɫԤ��';
    elseif (aa>35000&&aa<=42000)
        str2='����Ԥ������ɫԤ��';
    elseif (aa>=0&&aa<=35000)
        str2='����Ԥ������ȫ';
    end 
    str=[str1 10 str2];
    set(imh, 'cdata', cat(3, (veg == 1), (veg == 2), zeros(n)) )
    drawnow
    figure(2)
    delete(m)
    plot(shu);
    hold on
    plot(fire);
    legend(['����������',num2str(aa)],['�������',num2str(bb)]);
    title(['ʱ��T=',num2str(i),'��']);
    m=annotation('textbox',[0.15,0.8,0.1,0.1],'LineStyle','-','LineWidth',1,'String',str);
    hold off
%     pause(0.0001)
end

