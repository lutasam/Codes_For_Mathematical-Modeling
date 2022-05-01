%data��n������m������ָ������򻯺��n��m�е����ݡ�data��Ψһ��Ҫ��������������
X = data;  
[n,m] = size(X);

Z = X ./ repmat(sum(X.*X) .^ 0.5,n,1); %��׼��

for i = 1 : n
    for j = 1 : m
        p(i,j) = Z(i,j) / sum(Z(:,j));
    end
end
for j = 1 : m
    s = 0;
    for i = 1 : n
        if p(i,j) ~= 0
            s = s + p(i,j) * log(p(i,j)); %��ֹ��ĸ=0
        end
    end
    e(j) = -1 / log(n) * s; %��Ϣ��
end
W = (1 - e) / sum(1 - e); %��Ȩ

D_P = sum((Z - repmat(max(Z),n,1)) .^ 2 .* repmat(W,n,1),2) .^ 0.5; %��ȨD+
D_N = sum((Z - repmat(min(Z),n,1)) .^ 2  .* repmat(W,n,1),2) .^ 0.5; %��ȨD-
S = D_N ./ (D_P + D_N); %δ��һ�������֣���ȨTopsis������
S1 = S ./ sum(S) %��һ�������֣���ȨTopsis������