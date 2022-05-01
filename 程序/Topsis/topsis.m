%data是n个对象、m个评价指标的正向化后的n行m列的数据。data是唯一需要从外界输入的数据
X = data;  
[n,m] = size(X);

Z = X ./ repmat(sum(X.*X) .^ 0.5,n,1); %标准化

for i = 1 : n
    for j = 1 : m
        p(i,j) = Z(i,j) / sum(Z(:,j));
    end
end
for j = 1 : m
    s = 0;
    for i = 1 : n
        if p(i,j) ~= 0
            s = s + p(i,j) * log(p(i,j)); %防止分母=0
        end
    end
    e(j) = -1 / log(n) * s; %信息熵
end
W = (1 - e) / sum(1 - e); %熵权

D_P = sum((Z - repmat(max(Z),n,1)) .^ 2 .* repmat(W,n,1),2) .^ 0.5; %加权D+
D_N = sum((Z - repmat(min(Z),n,1)) .^ 2  .* repmat(W,n,1),2) .^ 0.5; %加权D-
S = D_N ./ (D_P + D_N); %未归一化的评分（加权Topsis方法）
S1 = S ./ sum(S) %归一化的评分（加权Topsis方法）