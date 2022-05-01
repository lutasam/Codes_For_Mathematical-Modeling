function [W, Lmax, CI, CR] = AHP(A)
% 实现单层次结构的层次分析法
% 输入: A为成对比较矩阵
% 输出: W为权重向量, Lmax为最大特征值, CI为一致性指标, CR为一致性比率
 
[V,D] = eig(A);
[Lmax,ind] = max(diag(D));       % 求最大特征值及其位置
W = V(:,ind) / sum(V(:,ind));    % 最大特征值对应的特征向量做标准化
Lmax = mean((A * W) ./ W);       % 计算最大特征值
n = size(A, 1);                  % 矩阵行数
CI = (Lmax - n) / (n - 1);       % 计算一致性指标
% Saaty随机一致性指标值
RI = [0 0 0.58 0.90 1.12 1.24 1.32 1.41 1.45 1.49 1.51]; 
CR = CI / RI(n);                 % 计算一致性比率