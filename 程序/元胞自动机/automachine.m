close;
clear;
clc;
n = 300;     %元胞矩阵大小
Plight = 0.000001; Pgrowth = 0.001;
UL = [n 1:n-1];
DR = [2:n 1];
veg = zeros(n,n);        %初始化
% The value of veg:
% empty == 0  
% burning == 1
% green == 2
imh = image(cat(3,veg,veg,veg));
m=annotation('textbox',[0.1,0.1,0.1,0.1],'LineStyle','-','LineWidth',1,'String','123');
for i = 1:100000
    sum = (veg(UL,:) == 1) + (veg(:,UL) == 1) + (veg(DR,:) == 1) + (veg(:,DR) == 1);
    %根据规则更新森林矩阵：树 = 树 - 着火的树 + 新生的树
    veg = 2 * (veg == 2) - ( (veg == 2) & (sum > 0 | (rand(n,n) < Plight)) ) + 2 * ( (veg == 0) & rand(n,n) < Pgrowth);
    a=find(veg==2);
    b=find(veg==1);
    aa=length(a);
    bb=length(b);
    shu(i)=aa;
    fire(i)=bb*30;
    if (bb>=0&&bb<=10)
        str1='森林正常';
    elseif (bb>10&&bb<=100)
        str1='火灾发展';
    elseif (bb>100)
        str1='森林大火';
    end
    if ((aa>48000)||(bb>=10))
        str2='火灾预警：红色预警';
    elseif (aa>42000&&aa<=48000)
        str2='火灾预警：黄色预警';
    elseif (aa>35000&&aa<=42000)
        str2='火灾预警：蓝色预警';
    elseif (aa>=0&&aa<=35000)
        str2='火灾预警：安全';
    end 
    str=[str1 10 str2];
    set(imh, 'cdata', cat(3, (veg == 1), (veg == 2), zeros(n)) )
    drawnow
    figure(2)
    delete(m)
    plot(shu);
    hold on
    plot(fire);
    legend(['绿树的数量',num2str(aa)],['火的数量',num2str(bb)]);
    title(['时间T=',num2str(i),'天']);
    m=annotation('textbox',[0.15,0.8,0.1,0.1],'LineStyle','-','LineWidth',1,'String',str);
    hold off
%     pause(0.0001)
end

