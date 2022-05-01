function GATSP
 
% mainly amended by Chen Zhen, 2012~2016
 
CityNum = 10; % 城市数目，可以选 10, 30, 50, 75
[dislist, Clist] = tsp(CityNum); % dislist 为城市之间相互的距离，Clist 为各城市的坐标
 
inn = 100; % 初始种群大小
gnMax = 500;  % 最大代数
crossProb = 0.8; % 交叉概率
muteProb = 0.8; % 变异概率
 
% 随机产生初始种群
population = zeros(inn, CityNum); % population 为初始种群，包括多条染色体
for i = 1 : inn
    population(i,:) = randperm(CityNum);
end
[~, cumulativeProbs] = calPopulationValue(population, dislist); % 计算种群每条染色体的累计概率
 
generationNum = 1;
generationMeanValue = zeros(generationNum, 1); % 每一代的平均距离
generationMaxValue = zeros(generationNum, 1);  % 每一代的最短距离
bestRoute = zeros(inn, CityNum); % 最佳路径
newPopulation = zeros(inn, CityNum); % 新的种群
while generationNum < gnMax + 1
   for j = 1 : 2 : inn
      selectedChromos = select(cumulativeProbs);  % 选择操作，选出两条需要交叉编译的染色体，即父亲母亲
      crossedChromos = cross(population, selectedChromos, crossProb);  % 交叉操作，返回交叉后的染色体
      newPopulation(j, :) = mut(crossedChromos(1, :),muteProb);  % 对交叉后的染色体进行变异操作
      newPopulation(j + 1, :) = mut(crossedChromos(2, :), muteProb); % 对交叉后的染色体进行变异操作
   end
   population = newPopulation;  %产生了新的种群
   [populationValue, cumulativeProbs] = calPopulationValue(population, dislist);  % 计算新种群的适应度
   % 记录当前代最好和平均的适应度
   [fmax, nmax] = max(populationValue); % 因为计算适应度时取距离的倒数，这里面取最大的倒数，即最短的距离
   generationMeanValue(generationNum) = 1 / mean(populationValue); 
   generationMaxValue(generationNum) = 1 / fmax;   
   bestChromo = population(nmax, :);  % 前代最佳染色体，即对应的路径
   bestRoute(generationNum, :) = bestChromo; % 记录每一代的最佳染色体
   drawTSP(Clist, bestChromo, generationMaxValue(generationNum), generationNum, 0);
   generationNum = generationNum + 1;
end
[bestValue,index] = min(generationMaxValue);
drawTSP(Clist, bestRoute(index, :), bestValue, index,1);
 
figure(2);
plot(generationMaxValue, 'r');  
hold on;
plot(generationMeanValue, 'b'); 
grid;
title('搜索过程');
legend('最优解', '平均解');
fprintf('遗传算法得到的最短距离: %.2f\n', bestValue);
fprintf('遗传算法得到的最短路线');
disp(bestRoute(index, :));
end
 
%------------------------------------------------
% 计算所有染色体的适应度
function [chromoValues, cumulativeProbs] = calPopulationValue(s, dislist)
inn = size(s, 1);  % 读取种群大小
chromoValues = zeros(inn, 1);
for i = 1 : inn
    chromoValues(i) = CalDist(dislist, s(i, :));  % 计算每条染色体的适应度
end
chromoValues = 1./chromoValues'; % 因为让距离越小，选取的概率越高，所以取距离倒数
 
% 根据个体的适应度计算其被选择的概率
fsum = 0;
for i = 1 : inn
    % 乘以15次方的原因是让好的个体被选取的概率更大（因为适应度取距离的倒数，若不乘次方，则个体相互之间的适应度差别不大），换成一个较大的数也行
    fsum = fsum + chromoValues(i)^15;   
end
 
% 计算单个概率
probs = zeros(inn, 1);
for i = 1: inn
    probs(i) = chromoValues(i)^15 / fsum;
end
 
% 计算累积概率
cumulativeProbs = zeros(inn,1);
cumulativeProbs(1) = probs(1);
for i = 2 : inn
    cumulativeProbs(i) = cumulativeProbs(i - 1) + probs(i);
end
cumulativeProbs = cumulativeProbs';
end
 
%--------------------------------------------------
%“选择”操作，返回所选择染色体在种群中对应的位置
% cumulatedPro 所有染色体的累计概率
function selectedChromoNums = select(cumulatedPro)
selectedChromoNums = zeros(2, 1);
% 从种群中选择两个个体，最好不要两次选择同一个个体
for i = 1 : 2
   r = rand;  % 产生一个随机数
   prand = cumulatedPro - r;
   j = 1;
   while prand(j) < 0
       j = j + 1;
   end
   selectedChromoNums(i) = j; % 选中个体的序号
   if i == 2 && j == selectedChromoNums(i - 1)    % 若相同就再选一次
       r = rand;  % 产生一个随机数
       prand = cumulatedPro - r;
       j = 1;
       while prand(j) < 0
           j = j + 1;
       end
   end
end
end
 
%------------------------------------------------
% “交叉”操作
function crossedChromos = cross(population, selectedChromoNums, crossProb)
length = size(population, 2); % 染色体的长度
crossProbc = crossMuteOrNot(crossProb);  %根据交叉概率决定是否进行交叉操作，1则是，0则否
crossedChromos(1,:) = population(selectedChromoNums(1), :);
crossedChromos(2,:) = population(selectedChromoNums(2), :);
if crossProbc == 1
   c1 = round(rand * (length - 2)) + 1;  %在[1,bn - 1]范围内随机产生一个交叉位 c1
   c2 = round(rand * (length - 2)) + 1;  %在[1,bn - 1]范围内随机产生一个交叉位 c2
   chb1 = min(c1, c2);
   chb2 = max(c1,c2);
   middle = crossedChromos(1,chb1+1:chb2); % 两条染色体 chb1 到 chb2 之间互换位置
   crossedChromos(1,chb1 + 1 : chb2)= crossedChromos(2, chb1 + 1 : chb2);
   crossedChromos(2,chb1 + 1 : chb2)= middle;
   for i = 1 : chb1 % 看交叉后，染色体上是否有相同编码的情况（路径上重复出现两个城市）。若有，则该编码不参与交叉
       while find(crossedChromos(1,chb1 + 1: chb2) == crossedChromos(1, i))
           location = find(crossedChromos(1,chb1 + 1: chb2) == crossedChromos(1, i));
           y = crossedChromos(2,chb1 + location);
           crossedChromos(1, i) = y;
       end
       while find(crossedChromos(2,chb1 + 1 : chb2) == crossedChromos(2, i))
           location = find(crossedChromos(2, chb1 + 1 : chb2) == crossedChromos(2, i));
           y = crossedChromos(1, chb1 + location);
           crossedChromos(2, i) = y;
       end
   end
   for i = chb2 + 1 : length
       while find(crossedChromos(1, 1 : chb2) == crossedChromos(1, i))
           location = logical(crossedChromos(1, 1 : chb2) == crossedChromos(1, i));
           y = crossedChromos(2, location);
           crossedChromos(1, i) = y;
       end
       while find(crossedChromos(2, 1 : chb2) == crossedChromos(2, i))
           location = logical(crossedChromos(2, 1 : chb2) == crossedChromos(2, i));
           y = crossedChromos(1, location);
           crossedChromos(2, i) = y;
       end
   end
end
end
 
%--------------------------------------------------
%“变异”操作
% choromo 为一条染色体
function snnew = mut(chromo,muteProb)
length = size(chromo, 2); % 染色体的的长度
snnew = chromo;
muteProbm = crossMuteOrNot(muteProb);  % 根据变异概率决定是否进行变异操作，1则是，0则否
if muteProbm == 1
    c1 = round(rand*(length - 2)) + 1;  % 在 [1, bn - 1]范围内随机产生一个变异位
    c2 = round(rand*(length - 2)) + 1;  % 在 [1, bn - 1]范围内随机产生一个变异位
    chb1 = min(c1, c2);
    chb2 = max(c1, c2);
    x = chromo(chb1 + 1 : chb2);
    snnew(chb1 + 1 : chb2) = fliplr(x); % 变异，则将两个变异位置的染色体倒转
end
end
 
% 根据变异或交叉概率，返回一个 0 或 1 的数
function crossProbc = crossMuteOrNot(crossMuteProb)
test(1: 100) = 0;
l = round(100 * crossMuteProb);
test(1 : l) = 1;
n = round(rand * 99) + 1;
crossProbc = test(n);
end
 
%------------------------------------------------
% 计算一条染色体的适应度
% dislist 为所有城市相互之间的距离矩阵
% chromo 为一条染色体，即一条路径
function chromoValue = CalDist(dislist, chromo)
DistanV = 0;
n = size(chromo, 2); % 染色体的长度
for i = 1 : (n - 1)
    DistanV = DistanV + dislist(chromo(i), chromo(i + 1));
end
DistanV = DistanV + dislist(chromo(n), chromo(1));
chromoValue = DistanV;
end
 
%------------------------------------------------
% 画图
% Clist 为城市坐标
% route 为一条路径
function drawTSP(Clist, route, generationValue, generationNum,isBestGeneration)
CityNum = size(Clist, 1);
for i = 1 : CityNum - 1
    plot([Clist(route(i), 1),Clist(route(i + 1), 1)], [Clist(route(i),2),Clist(route(i+1),2)],'ms-','LineWidth',2,'MarkerEdgeColor','k','MarkerFaceColor','g');
    text(Clist(route(i), 1),Clist(route(i), 2), ['  ', int2str(route(i))]);
    text(Clist(route(i+1), 1),Clist(route(i + 1), 2), ['  ', int2str(route(i+1))]);
    hold on;
end
plot([Clist(route(CityNum), 1), Clist(route(1), 1)], [Clist(route(CityNum), 2), Clist(route(1), 2)],'ms-','LineWidth',2,'MarkerEdgeColor','k','MarkerFaceColor','g');
title([num2str(CityNum),'城市TSP']);
if isBestGeneration == 0 && CityNum ~= 10
    text(5, 5, ['第 ',int2str(generationNum),' 代','  最短距离为 ', num2str(generationValue)]);
else
    text(5, 5, ['最终搜索结果：最短距离 ',num2str(generationValue),'， 在第 ',num2str(generationNum),' 代达到']);
end
if CityNum == 10  % 因为文字显示位置不一样，所以将城市数目为 10 时单独编写
    if isBestGeneration == 0
        text(0, 0, ['第 ',int2str(generationNum),' 代','  最短距离为 ', num2str(generationValue)]);
    else
        text(0, 0, ['最终搜索结果：最短距离 ',num2str(generationValue),'， 在第 ', num2str(generationNum),' 代达到']);
    end
end
hold off;
pause(0.005);
end
 
%------------------------------------------------
%城市位置坐标
function [DLn, cityn] = tsp(n)
DLn = zeros(n, n);
if n == 10
    city10 = [0.4 0.4439;0.2439 0.1463;0.1707 0.2293;0.2293 0.761;0.5171 0.9414;
        0.8732 0.6536;0.6878 0.5219;0.8488 0.3609;0.6683 0.2536;0.6195 0.2634];%10 cities d'=2.691
    for i = 1 : 10
        for j = 1 : 10
            DLn(i, j) = ((city10(i,1)-city10(j,1))^2 + (city10(i,2)-city10(j,2))^2)^0.5;
        end
    end
    cityn = city10;
end
if n == 30
    city30 = [41 94;37 84;54 67;25 62;7 64;2 99;68 58;71 44;54 62;83 69;64 60;18 54;22 60;
        83 46;91 38;25 38;24 42;58 69;71 71;74 78;87 76;18 40;13 40;82 7;62 32;58 35;45 21;41 26;44 35;4 50]; % 30 cities d' = 423.741 by D B Fogel
    for i = 1 : 30
        for j = 1 : 30
            DLn(i,j) = ((city30(i,1)-city30(j,1))^2+(city30(i,2)-city30(j,2))^2)^0.5;
        end
    end
    cityn = city30;
end
 
if n == 50
    city50 = [31 32;32 39;40 30;37 69;27 68;37 52;38 46;31 62;30 48;21 47;25 55;16 57;
        17 63;42 41;17 33;25 32;5 64;8 52;12 42;7 38;5 25; 10 77;45 35;42 57;32 22;
        27 23;56 37;52 41;49 49;58 48;57 58;39 10;46 10;59 15;51 21;48 28;52 33;
        58 27;61 33;62 63;20 26;5 6;13 13;21 10;30 15;36 16;62 42;63 69;52 64;43 67];%50 cities d'=427.855 by D B Fogel
    for i = 1 : 50
        for j = 1:50
            DLn(i, j) = ((city50(i,1) - city50(j,1))^2 + (city50(i,2) - city50(j,2))^2)^0.5;
        end
    end
    cityn = city50;
end
 
if n == 75
    city75 = [48 21;52 26;55 50;50 50;41 46;51 42;55 45;38 33;33 34;45 35;40 37;50 30;
        55 34;54 38;26 13;15 5;21 48;29 39;33 44;15 19;16 19;12 17;50 40;22 53;21 36;
        20 30;26 29;40 20;36 26;62 48;67 41;62 35;65 27;62 24;55 20;35 51;30 50;
        45 42;21 45;36 6;6 25;11 28;26 59;30 60;22 22;27 24;30 20;35 16;54 10;50 15;
        44 13;35 60;40 60;40 66;31 76;47 66;50 70;57 72;55 65;2 38;7 43;9 56;15 56;
        10 70;17 64;55 57;62 57;70 64;64 4;59 5;50 4;60 15;66 14;66 8;43 26]; % 75 cities d'=549.18 by D B Fogel
    for i = 1 : 75
        for j = 1 : 75
            DLn(i,j) = ((city75(i,1)-city75(j,1))^2 + (city75(i,2)-city75(j,2))^2)^0.5;
        end
    end
    cityn = city75;
end
end