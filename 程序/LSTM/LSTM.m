%% lstm �������ಽ(ֻ��һ�����������йأ�
clear all;
clc;
close all;

load('loadmutlseason.mat');
raw.data =loadmutlseason;
raw.remainder = raw.data(:,'Remainder');
raw.data(:,'Remainder')=[];
raw.data= table2array(raw.data);
warning off;
clear loadmutlseason raw train
% �������������۲�
autocorr(ytrain.data,100);                                         %�����ͼ
figure                             
plot(ytrain.data)                                                  %����ͼ
% ���ݴ���
y =[ytrain.data;ytest.data];
clear ytrain  ytest
%  ��һ��
[ynorm,option] =mapminmax(y',0,1);
%  ʱ�䲽������
                                                                    % �����������ʲ������ܣ��µ������ԣ�ֻ�������ڵ������
k =24;                                                              %ʱ�䲽��
for  i = 1:size(ynorm,2)-k+1
    input.normdatacell{i,1} = ynorm(:,i:i+k-1);
    output.normdatacell(i,1) = ynorm(i+k-1);
end

% �������ݼ�
n = floor(0.8*size(input.normdatacell,1));                          %ѵ���������Լ�������Ŀ����
input.xtraincell = input.normdatacell(1:n,:);                                
output.ytraincell = output.normdatacell(1:n,:);
input.xtestcell = input.normdatacell(n+1:end,:);
output.ytestcell = output.normdatacell(n+1:end,:);

% LSTM �����ã���������
inputSize = size(input.normdatacell,2);   %��������x������ά��
outputSize = size(output.normdatacell,2);  %�������y������ά��  
numhidden_units1=100;
numhidden_units2=200;
% lstm
layers = [ ...
    sequenceInputLayer(inputSize,'name','input')                             %���������
   % lstmLayer(numhidden_units1,'Outputmode','sequence')                     %ѧϰ������(cell�㣩
    lstmLayer(numhidden_units1,'Outputmode','sequence','name','hidden1')     %���ز�1
    dropoutLayer(0.3,'name','dropout_1')                                     %���ز�1Ȩ�ض�ʧ�ʣ���ֹ�����
    lstmLayer(numhidden_units2,'Outputmode','last','name','hidden2')         %���ز�2
     dropoutLayer(0.3,'name','dropout_2')                                    %���ز�2Ȩ�ض�ʧ�ʣ���ֹ�����
    fullyConnectedLayer(outputSize,'name','fullconnect')                     %ȫ���Ӳ����ã�outputsize:Ԥ��ֵ������ά�ȣ�
    regressionLayer('name','out')];                                          %�ع�㣨��Ϊ����Ԥ��ֵΪ����ֵ������Ϊ�ع�㣩 

% trainoption
opts = trainingOptions('adam', ...        %�Ż��㷨
    'MaxEpochs',5, ...                    %�����������ѭ����
    'GradientThreshold',1,...             %�ݶ���ֵ
    'ExecutionEnvironment','cpu',...      %���㻷��
    'InitialLearnRate',0.001, ...         %��ʼѧϰ��
    'LearnRateSchedule','piecewise', ...  % ѧϰ�ʼƻ�
    'LearnRateDropPeriod',2, ...          %2��epoch��ѧϰ�ʸ���
    'LearnRateDropFactor',0.5, ...        %ѧϰ��˥���ٶ�
    'Shuffle','once',...                  % �Ƿ���������˳�򣬷�ֹ�������������쳣ֵ��Ӱ��Ԥ�⾫��
    'SequenceLength',24,...               %LSTMʱ�䲽��
    'MiniBatchSize',24*30,...             % ������������С
    'Verbose',0, ...                      %�������̨�Ƿ��ӡѵ������
    'Plots','training-progress'...        % ��ӡѵ������
    );

% ����ѵ��
tic
trainperiod =24;
net = trainNetwork(input.xtraincell,output.ytraincell,layers,opts);      %����ѵ��
% Ԥ��
k =7;                                                                    %Ԥ������
for i =1:k
period = 1+(i-1)*24:i*24;                                                %ÿ��Ԥ�����ڳ��ȣ�����Ϊ24Сʱ
[net,yprenorm] = predictAndUpdateState(net,input.xtestcell(period,:));   %��̬���£�Ԥ��
ypre(period,1) = mapminmax('reverse',yprenorm',option);          %Ԥ��ֵ����һ��
ytest(period,1) = mapminmax('reverse',output.ytestcell(period)',option); 
subplot(4,2,i)
plot(ypre(period),'r--')
hold on;
plot(ytest(period),'b--');
stem(ypre(period)-ytest(period));
legend('ypre','real','Location','westoutside')
end

%% LSTM ������ಽԤ�⣨�������������йأ�
clear all;
clc;
close all;
load('loadmutlseason.mat');
raw.data =loadmutlseason;
raw.remainder = raw.data(:,'Remainder');
raw.data(:,'Remainder')=[];
raw.data= table2array(raw.data);
warning off;
% �������������۲�
autocorr(ytrain.data,100);
figure
plot(ytrain.data)
% ���ݴ���
% ��һ����ȫ������ ����һ����
output.data =raw.data(:,1);
input.data =raw.data(:,2:end);
autocorr(output.data);
[input.normdata,input.normopt] =mapminmax(input.data',0,1);
[output.normdata,output.normopt] = mapminmax(output.data',0,1);
% �������ȥ24Сʱ�й� sequence to one predict (�򵥻������ǹ�ȡ��Сʱÿ��������ȫ��������
k =24;                                                             % �����������ʲ������ܣ��µ������ԣ�ֻ�������ڵ������
for  i = 1:size(input.normdata,2)-k+1
    input.normdatacell{i,1} = input.normdata(:,i:i+k-1);
    output.normdatacell(i,1) = output.normdata(i+k-1);
end
%  ʱ�䲽������
                                                                    


% �������ݼ�
n = floor(0.8*size(input.normdatacell,1));                          %ѵ���������Լ�������Ŀ����
input.xtraincell = input.normdatacell(1:n,:);                                
output.ytraincell = output.normdatacell(1:n,:);
input.xtestcell = input.normdatacell(n+1:end,:);
output.ytestcell = output.normdatacell(n+1:end,:);

% LSTM �����ã���������
inputSize = size(input.normdata,1);   %��������x������ά��
outputSize = size(output.normdata,1);  %�������y������ά��  
numhidden_units1=100;
numhidden_units2=200;
% lstm
layers = [ ...
    sequenceInputLayer(inputSize,'name','input')                             %���������
   % lstmLayer(numhidden_units1,'Outputmode','sequence')                     %ѧϰ������(cell�㣩
    lstmLayer(numhidden_units1,'Outputmode','sequence','name','hidden1')     %���ز�1
    dropoutLayer(0.3,'name','dropout_1')                                     %���ز�1Ȩ�ض�ʧ�ʣ���ֹ�����
    lstmLayer(numhidden_units2,'Outputmode','last','name','hidden2')         %���ز�2
     dropoutLayer(0.3,'name','dropout_2')                                    %���ز�2Ȩ�ض�ʧ�ʣ���ֹ�����
    fullyConnectedLayer(outputSize,'name','fullconnect')                     %ȫ���Ӳ����ã�outputsize:Ԥ��ֵ������ά�ȣ�
    regressionLayer('name','out')];                                          %�ع�㣨��Ϊ����Ԥ��ֵΪ����ֵ������Ϊ�ع�㣩 

% trainoption
opts = trainingOptions('adam', ...        %�Ż��㷨
    'MaxEpochs',5, ...                   %�����������ѭ����
    'GradientThreshold',1,...             %�ݶ���ֵ
    'ExecutionEnvironment','cpu',...      %���㻷��
    'InitialLearnRate',0.001, ...         %��ʼѧϰ��
    'LearnRateSchedule','piecewise', ...  % ѧϰ�ʼƻ�
    'LearnRateDropPeriod',2, ...          %2��epoch��ѧϰ�ʸ���
    'LearnRateDropFactor',0.5, ...        %ѧϰ��˥���ٶ�
    'Shuffle','once',...                  % �Ƿ���������˳�򣬷�ֹ�������������쳣ֵ��Ӱ��Ԥ�⾫��
    'SequenceLength',24,...               %LSTMʱ�䲽��
    'MiniBatchSize',24*30,...             % ������������С
    'Verbose',0, ...                      %�������̨�Ƿ��ӡѵ������
    'Plots','training-progress'...        % ��ӡѵ������
    );

% ����ѵ��
tic
trainperiod =24;
net = trainNetwork(input.xtraincell,output.ytraincell,layers,opts);      %����ѵ��
% Ԥ��
k =7;                                                                    %Ԥ������
for i =1:k
period = 1+(i-1)*24:i*24;                                                %ÿ��Ԥ�����ڳ��ȣ�����Ϊ24Сʱ
[net,yprenorm] = predictAndUpdateState(net,input.xtestcell(period,:));   %��̬���£�Ԥ��
ypre(period,1) = mapminmax('reverse',yprenorm',output.normopt);          %Ԥ��ֵ����һ��
yytest(period,1) = mapminmax('reverse',output.ytestcell(period)',output.normopt); 
subplot(4,2,i)
plot(ypre(period),'r--')
hold on;
plot(yytest(period),'b--');
stem(ypre(period)-yytest(period));
legend('ypre','real','Location','westoutside')
end




