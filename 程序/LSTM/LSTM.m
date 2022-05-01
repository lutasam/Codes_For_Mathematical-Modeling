%% lstm 单变量多步(只与一个特征属性有关）
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
% 负荷数据特征观察
autocorr(ytrain.data,100);                                         %自相关图
figure                             
plot(ytrain.data)                                                  %样本图
% 数据处理
y =[ytrain.data;ytest.data];
clear ytrain  ytest
%  归一化
[ynorm,option] =mapminmax(y',0,1);
%  时间步长设置
                                                                    % 这里简单起见，故不考虑周，月的周期性，只考虑日内的相关性
k =24;                                                              %时间步长
for  i = 1:size(ynorm,2)-k+1
    input.normdatacell{i,1} = ynorm(:,i:i+k-1);
    output.normdatacell(i,1) = ynorm(i+k-1);
end

% 划分数据集
n = floor(0.8*size(input.normdatacell,1));                          %训练集，测试集样本数目划分
input.xtraincell = input.normdatacell(1:n,:);                                
output.ytraincell = output.normdatacell(1:n,:);
input.xtestcell = input.normdatacell(n+1:end,:);
output.ytestcell = output.normdatacell(n+1:end,:);

% LSTM 层设置，参数设置
inputSize = size(input.normdatacell,2);   %数据输入x的特征维度
outputSize = size(output.normdatacell,2);  %数据输出y的特征维度  
numhidden_units1=100;
numhidden_units2=200;
% lstm
layers = [ ...
    sequenceInputLayer(inputSize,'name','input')                             %输入层设置
   % lstmLayer(numhidden_units1,'Outputmode','sequence')                     %学习层设置(cell层）
    lstmLayer(numhidden_units1,'Outputmode','sequence','name','hidden1')     %隐藏层1
    dropoutLayer(0.3,'name','dropout_1')                                     %隐藏层1权重丢失率，防止过拟合
    lstmLayer(numhidden_units2,'Outputmode','last','name','hidden2')         %隐藏层2
     dropoutLayer(0.3,'name','dropout_2')                                    %隐藏层2权重丢失率，防止过拟合
    fullyConnectedLayer(outputSize,'name','fullconnect')                     %全连接层设置（outputsize:预测值的特征维度）
    regressionLayer('name','out')];                                          %回归层（因为负荷预测值为连续值，所以为回归层） 

% trainoption
opts = trainingOptions('adam', ...        %优化算法
    'MaxEpochs',5, ...                    %遍历样本最大循环数
    'GradientThreshold',1,...             %梯度阈值
    'ExecutionEnvironment','cpu',...      %运算环境
    'InitialLearnRate',0.001, ...         %初始学习率
    'LearnRateSchedule','piecewise', ...  % 学习率计划
    'LearnRateDropPeriod',2, ...          %2个epoch后学习率更新
    'LearnRateDropFactor',0.5, ...        %学习率衰减速度
    'Shuffle','once',...                  % 是否重排数据顺序，防止数据中因连续异常值而影响预测精度
    'SequenceLength',24,...               %LSTM时间步长
    'MiniBatchSize',24*30,...             % 批处理样本大小
    'Verbose',0, ...                      %命令控制台是否打印训练过程
    'Plots','training-progress'...        % 打印训练进度
    );

% 网络训练
tic
trainperiod =24;
net = trainNetwork(input.xtraincell,output.ytraincell,layers,opts);      %网络训练
% 预测
k =7;                                                                    %预测天数
for i =1:k
period = 1+(i-1)*24:i*24;                                                %每次预测周期长度，这里为24小时
[net,yprenorm] = predictAndUpdateState(net,input.xtestcell(period,:));   %动态更新，预测
ypre(period,1) = mapminmax('reverse',yprenorm',option);          %预测值反归一化
ytest(period,1) = mapminmax('reverse',output.ytestcell(period)',option); 
subplot(4,2,i)
plot(ypre(period),'r--')
hold on;
plot(ytest(period),'b--');
stem(ypre(period)-ytest(period));
legend('ypre','real','Location','westoutside')
end

%% LSTM 多变量多步预测（与多个特征属性有关）
clear all;
clc;
close all;
load('loadmutlseason.mat');
raw.data =loadmutlseason;
raw.remainder = raw.data(:,'Remainder');
raw.data(:,'Remainder')=[];
raw.data= table2array(raw.data);
warning off;
% 负荷数据特征观察
autocorr(ytrain.data,100);
figure
plot(ytrain.data)
% 数据处理
% 归一化（全部特征 均归一化）
output.data =raw.data(:,1);
input.data =raw.data(:,2:end);
autocorr(output.data);
[input.normdata,input.normopt] =mapminmax(input.data',0,1);
[output.normdata,output.normopt] = mapminmax(output.data',0,1);
% 负荷与过去24小时有关 sequence to one predict (简单化，考虑过取八小时每个样本的全部特征）
k =24;                                                             % 这里简单起见，故不考虑周，月的周期性，只考虑日内的相关性
for  i = 1:size(input.normdata,2)-k+1
    input.normdatacell{i,1} = input.normdata(:,i:i+k-1);
    output.normdatacell(i,1) = output.normdata(i+k-1);
end
%  时间步长设置
                                                                    


% 划分数据集
n = floor(0.8*size(input.normdatacell,1));                          %训练集，测试集样本数目划分
input.xtraincell = input.normdatacell(1:n,:);                                
output.ytraincell = output.normdatacell(1:n,:);
input.xtestcell = input.normdatacell(n+1:end,:);
output.ytestcell = output.normdatacell(n+1:end,:);

% LSTM 层设置，参数设置
inputSize = size(input.normdata,1);   %数据输入x的特征维度
outputSize = size(output.normdata,1);  %数据输出y的特征维度  
numhidden_units1=100;
numhidden_units2=200;
% lstm
layers = [ ...
    sequenceInputLayer(inputSize,'name','input')                             %输入层设置
   % lstmLayer(numhidden_units1,'Outputmode','sequence')                     %学习层设置(cell层）
    lstmLayer(numhidden_units1,'Outputmode','sequence','name','hidden1')     %隐藏层1
    dropoutLayer(0.3,'name','dropout_1')                                     %隐藏层1权重丢失率，防止过拟合
    lstmLayer(numhidden_units2,'Outputmode','last','name','hidden2')         %隐藏层2
     dropoutLayer(0.3,'name','dropout_2')                                    %隐藏层2权重丢失率，防止过拟合
    fullyConnectedLayer(outputSize,'name','fullconnect')                     %全连接层设置（outputsize:预测值的特征维度）
    regressionLayer('name','out')];                                          %回归层（因为负荷预测值为连续值，所以为回归层） 

% trainoption
opts = trainingOptions('adam', ...        %优化算法
    'MaxEpochs',5, ...                   %遍历样本最大循环数
    'GradientThreshold',1,...             %梯度阈值
    'ExecutionEnvironment','cpu',...      %运算环境
    'InitialLearnRate',0.001, ...         %初始学习率
    'LearnRateSchedule','piecewise', ...  % 学习率计划
    'LearnRateDropPeriod',2, ...          %2个epoch后学习率更新
    'LearnRateDropFactor',0.5, ...        %学习率衰减速度
    'Shuffle','once',...                  % 是否重排数据顺序，防止数据中因连续异常值而影响预测精度
    'SequenceLength',24,...               %LSTM时间步长
    'MiniBatchSize',24*30,...             % 批处理样本大小
    'Verbose',0, ...                      %命令控制台是否打印训练过程
    'Plots','training-progress'...        % 打印训练进度
    );

% 网络训练
tic
trainperiod =24;
net = trainNetwork(input.xtraincell,output.ytraincell,layers,opts);      %网络训练
% 预测
k =7;                                                                    %预测天数
for i =1:k
period = 1+(i-1)*24:i*24;                                                %每次预测周期长度，这里为24小时
[net,yprenorm] = predictAndUpdateState(net,input.xtestcell(period,:));   %动态更新，预测
ypre(period,1) = mapminmax('reverse',yprenorm',output.normopt);          %预测值反归一化
yytest(period,1) = mapminmax('reverse',output.ytestcell(period)',output.normopt); 
subplot(4,2,i)
plot(ypre(period),'r--')
hold on;
plot(yytest(period),'b--');
stem(ypre(period)-yytest(period));
legend('ypre','real','Location','westoutside')
end




