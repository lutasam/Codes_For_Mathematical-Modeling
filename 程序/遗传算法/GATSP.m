function GATSP
 
% mainly amended by Chen Zhen, 2012~2016
 
CityNum = 10; % ������Ŀ������ѡ 10, 30, 50, 75
[dislist, Clist] = tsp(CityNum); % dislist Ϊ����֮���໥�ľ��룬Clist Ϊ�����е�����
 
inn = 100; % ��ʼ��Ⱥ��С
gnMax = 500;  % ������
crossProb = 0.8; % �������
muteProb = 0.8; % �������
 
% ���������ʼ��Ⱥ
population = zeros(inn, CityNum); % population Ϊ��ʼ��Ⱥ����������Ⱦɫ��
for i = 1 : inn
    population(i,:) = randperm(CityNum);
end
[~, cumulativeProbs] = calPopulationValue(population, dislist); % ������Ⱥÿ��Ⱦɫ����ۼƸ���
 
generationNum = 1;
generationMeanValue = zeros(generationNum, 1); % ÿһ����ƽ������
generationMaxValue = zeros(generationNum, 1);  % ÿһ������̾���
bestRoute = zeros(inn, CityNum); % ���·��
newPopulation = zeros(inn, CityNum); % �µ���Ⱥ
while generationNum < gnMax + 1
   for j = 1 : 2 : inn
      selectedChromos = select(cumulativeProbs);  % ѡ�������ѡ��������Ҫ��������Ⱦɫ�壬������ĸ��
      crossedChromos = cross(population, selectedChromos, crossProb);  % ������������ؽ�����Ⱦɫ��
      newPopulation(j, :) = mut(crossedChromos(1, :),muteProb);  % �Խ�����Ⱦɫ����б������
      newPopulation(j + 1, :) = mut(crossedChromos(2, :), muteProb); % �Խ�����Ⱦɫ����б������
   end
   population = newPopulation;  %�������µ���Ⱥ
   [populationValue, cumulativeProbs] = calPopulationValue(population, dislist);  % ��������Ⱥ����Ӧ��
   % ��¼��ǰ����ú�ƽ������Ӧ��
   [fmax, nmax] = max(populationValue); % ��Ϊ������Ӧ��ʱȡ����ĵ�����������ȡ���ĵ���������̵ľ���
   generationMeanValue(generationNum) = 1 / mean(populationValue); 
   generationMaxValue(generationNum) = 1 / fmax;   
   bestChromo = population(nmax, :);  % ǰ�����Ⱦɫ�壬����Ӧ��·��
   bestRoute(generationNum, :) = bestChromo; % ��¼ÿһ�������Ⱦɫ��
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
title('��������');
legend('���Ž�', 'ƽ����');
fprintf('�Ŵ��㷨�õ�����̾���: %.2f\n', bestValue);
fprintf('�Ŵ��㷨�õ������·��');
disp(bestRoute(index, :));
end
 
%------------------------------------------------
% ��������Ⱦɫ�����Ӧ��
function [chromoValues, cumulativeProbs] = calPopulationValue(s, dislist)
inn = size(s, 1);  % ��ȡ��Ⱥ��С
chromoValues = zeros(inn, 1);
for i = 1 : inn
    chromoValues(i) = CalDist(dislist, s(i, :));  % ����ÿ��Ⱦɫ�����Ӧ��
end
chromoValues = 1./chromoValues'; % ��Ϊ�þ���ԽС��ѡȡ�ĸ���Խ�ߣ�����ȡ���뵹��
 
% ���ݸ������Ӧ�ȼ����䱻ѡ��ĸ���
fsum = 0;
for i = 1 : inn
    % ����15�η���ԭ�����úõĸ��屻ѡȡ�ĸ��ʸ�����Ϊ��Ӧ��ȡ����ĵ����������˴η���������໥֮�����Ӧ�Ȳ�𲻴󣩣�����һ���ϴ����Ҳ��
    fsum = fsum + chromoValues(i)^15;   
end
 
% ���㵥������
probs = zeros(inn, 1);
for i = 1: inn
    probs(i) = chromoValues(i)^15 / fsum;
end
 
% �����ۻ�����
cumulativeProbs = zeros(inn,1);
cumulativeProbs(1) = probs(1);
for i = 2 : inn
    cumulativeProbs(i) = cumulativeProbs(i - 1) + probs(i);
end
cumulativeProbs = cumulativeProbs';
end
 
%--------------------------------------------------
%��ѡ�񡱲�����������ѡ��Ⱦɫ������Ⱥ�ж�Ӧ��λ��
% cumulatedPro ����Ⱦɫ����ۼƸ���
function selectedChromoNums = select(cumulatedPro)
selectedChromoNums = zeros(2, 1);
% ����Ⱥ��ѡ���������壬��ò�Ҫ����ѡ��ͬһ������
for i = 1 : 2
   r = rand;  % ����һ�������
   prand = cumulatedPro - r;
   j = 1;
   while prand(j) < 0
       j = j + 1;
   end
   selectedChromoNums(i) = j; % ѡ�и�������
   if i == 2 && j == selectedChromoNums(i - 1)    % ����ͬ����ѡһ��
       r = rand;  % ����һ�������
       prand = cumulatedPro - r;
       j = 1;
       while prand(j) < 0
           j = j + 1;
       end
   end
end
end
 
%------------------------------------------------
% �����桱����
function crossedChromos = cross(population, selectedChromoNums, crossProb)
length = size(population, 2); % Ⱦɫ��ĳ���
crossProbc = crossMuteOrNot(crossProb);  %���ݽ�����ʾ����Ƿ���н��������1���ǣ�0���
crossedChromos(1,:) = population(selectedChromoNums(1), :);
crossedChromos(2,:) = population(selectedChromoNums(2), :);
if crossProbc == 1
   c1 = round(rand * (length - 2)) + 1;  %��[1,bn - 1]��Χ���������һ������λ c1
   c2 = round(rand * (length - 2)) + 1;  %��[1,bn - 1]��Χ���������һ������λ c2
   chb1 = min(c1, c2);
   chb2 = max(c1,c2);
   middle = crossedChromos(1,chb1+1:chb2); % ����Ⱦɫ�� chb1 �� chb2 ֮�以��λ��
   crossedChromos(1,chb1 + 1 : chb2)= crossedChromos(2, chb1 + 1 : chb2);
   crossedChromos(2,chb1 + 1 : chb2)= middle;
   for i = 1 : chb1 % �������Ⱦɫ�����Ƿ�����ͬ����������·�����ظ������������У������У���ñ��벻���뽻��
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
%�����족����
% choromo Ϊһ��Ⱦɫ��
function snnew = mut(chromo,muteProb)
length = size(chromo, 2); % Ⱦɫ��ĵĳ���
snnew = chromo;
muteProbm = crossMuteOrNot(muteProb);  % ���ݱ�����ʾ����Ƿ���б��������1���ǣ�0���
if muteProbm == 1
    c1 = round(rand*(length - 2)) + 1;  % �� [1, bn - 1]��Χ���������һ������λ
    c2 = round(rand*(length - 2)) + 1;  % �� [1, bn - 1]��Χ���������һ������λ
    chb1 = min(c1, c2);
    chb2 = max(c1, c2);
    x = chromo(chb1 + 1 : chb2);
    snnew(chb1 + 1 : chb2) = fliplr(x); % ���죬����������λ�õ�Ⱦɫ�嵹ת
end
end
 
% ���ݱ���򽻲���ʣ�����һ�� 0 �� 1 ����
function crossProbc = crossMuteOrNot(crossMuteProb)
test(1: 100) = 0;
l = round(100 * crossMuteProb);
test(1 : l) = 1;
n = round(rand * 99) + 1;
crossProbc = test(n);
end
 
%------------------------------------------------
% ����һ��Ⱦɫ�����Ӧ��
% dislist Ϊ���г����໥֮��ľ������
% chromo Ϊһ��Ⱦɫ�壬��һ��·��
function chromoValue = CalDist(dislist, chromo)
DistanV = 0;
n = size(chromo, 2); % Ⱦɫ��ĳ���
for i = 1 : (n - 1)
    DistanV = DistanV + dislist(chromo(i), chromo(i + 1));
end
DistanV = DistanV + dislist(chromo(n), chromo(1));
chromoValue = DistanV;
end
 
%------------------------------------------------
% ��ͼ
% Clist Ϊ��������
% route Ϊһ��·��
function drawTSP(Clist, route, generationValue, generationNum,isBestGeneration)
CityNum = size(Clist, 1);
for i = 1 : CityNum - 1
    plot([Clist(route(i), 1),Clist(route(i + 1), 1)], [Clist(route(i),2),Clist(route(i+1),2)],'ms-','LineWidth',2,'MarkerEdgeColor','k','MarkerFaceColor','g');
    text(Clist(route(i), 1),Clist(route(i), 2), ['  ', int2str(route(i))]);
    text(Clist(route(i+1), 1),Clist(route(i + 1), 2), ['  ', int2str(route(i+1))]);
    hold on;
end
plot([Clist(route(CityNum), 1), Clist(route(1), 1)], [Clist(route(CityNum), 2), Clist(route(1), 2)],'ms-','LineWidth',2,'MarkerEdgeColor','k','MarkerFaceColor','g');
title([num2str(CityNum),'����TSP']);
if isBestGeneration == 0 && CityNum ~= 10
    text(5, 5, ['�� ',int2str(generationNum),' ��','  ��̾���Ϊ ', num2str(generationValue)]);
else
    text(5, 5, ['���������������̾��� ',num2str(generationValue),'�� �ڵ� ',num2str(generationNum),' ���ﵽ']);
end
if CityNum == 10  % ��Ϊ������ʾλ�ò�һ�������Խ�������ĿΪ 10 ʱ������д
    if isBestGeneration == 0
        text(0, 0, ['�� ',int2str(generationNum),' ��','  ��̾���Ϊ ', num2str(generationValue)]);
    else
        text(0, 0, ['���������������̾��� ',num2str(generationValue),'�� �ڵ� ', num2str(generationNum),' ���ﵽ']);
    end
end
hold off;
pause(0.005);
end
 
%------------------------------------------------
%����λ������
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