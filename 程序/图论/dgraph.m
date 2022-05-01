%% �Ͻ�˹�������·��
clc;
W = [.41 .99 .51 .32 .15 .45 .38 .32 .36 .29 .21];
DG = sparse([6 1 2 2 3 4 4 5 5 6 1],[2 6 3 5 4 1 6 3 4 3 5],W);
h=view(biograph(DG,[],'ShowWeights','on'))
[dist,path,pred]=graphshortestpath(DG,1,6,'Directed','true')
set(h.Nodes(path),'Color',[1 0.4 0.4])
edges=getedgesbynodeid(h,get(h.Nodes(path),'ID'));%�Ҿ���������ǻ�����·���ıߺ�ID
set(edges,'LineColor',[1 0 0])
set(edges,'LineWidth',1.5)
UG=tril(DG+DG');
bg=biograph(UG,[],'ShowArrows','off','ShowWeights','on');
h=view(bg)
set(bg.nodes,'shape','circle');
[dist,path,pred]=graphshortestpath(UG,1,6,'Directed','false')
set(h.Nodes(path),'Color',[1 0.4 0.4])
fowEdges=getedgesbynodeid(h,get(h.Nodes(path),'ID'));
revEdges=getedgesbynodeid(h,get(h.Nodes(fliplr(path)),'ID'));%����fliplr�Ƿ�ת�����������[1 2 3]���[3 2 1]������������ͼ������������Ҫ��
edges=[fowEdges;revEdges];
set(edges,'LineColor',[0.6 0.4 0.1])
set(edges,'LineWidth',1.5)

%% �����������·��
w=[41 99 51 32 15 45 38 32 36 29 21];%Ȩֵ����
dg=sparse([6 1 2 2 3 4 4 5 5 6 1],[2 6 3 5 4 1 6 3 4 3 5],w)%�����ϡ������ʾͼ
h=view(biograph(dg,[],'ShowWeights','on'))%��ʾͼ�Ľṹ
dist=graphallshortestpaths(dg)%��ʾͼ��ÿ�Խ��֮������·��

ug=tril(dg+dg');%Ҫ�����ɵ�����ͼ��һ�������Ǿ���
view(biograph(ug,[],'ShowArrows','off','ShowWeights','on'));
dist=graphallshortestpaths(ug,'directed',false)

%% ��С������
w=[ 41    29    51    32    50    45    38    32    36    29    21];
dg=sparse([1 1 2 2 3 4 4 5 5 6 6],[2 6 3 5 4 1 6 3 4 2 5],w)
ug=tril(dg+dg');
view(biograph(ug,[],'ShowArrows','off','ShowWeights','on'));
[st,pred]=graphminspantree(ug)%������С������
h=view(biograph(st,[],'ShowArrows','off','ShowWeights','on'));
Edges=getedgesbynodeid(h);%��ȡ����ͼh�ı߼�
set(Edges,'LineColor',[0 0 0]);%������ɫ����
set(Edges,'LineWidth',1.5)%���ñ�ֵ����

%% �������С��
cm=sparse([1 1 2 2 3 3 4 5],[2 3 4 5 4 5 6 6],[2 3 3 1 1 1 2 3 ],6,6);
%6���ڵ�8����
[M,F,K]=graphmaxflow(cm,1,6);%�����1������6���ڵ�������
h=view(biograph(cm,[],'ShowWeights','on'));%��ʾԭʼ����ͼ��ͼ�ṹ
h1=view(biograph(F,[],'ShowWeights','on'));%��ʾ��������������ͼ�ṹ

%% �����㷨
DG=sparse([1 2 3 4 5 5 5 6 7 8 8 9],[2 4 1 5 3 6 7 9 8 1 10 2],true,10,10)
h1=view(biograph(DG));
order=graphtraverse(DG,4)%ʹ����������㷨�ӵ�4���ڵ㿪ʼ����
order2=graphtraverse(DG,4,'Method','BFS')%ʹ�ù�����ȱ���
index=graphtraverse(DG,4,'depth',2)%�����ڵ�4�ڽ������Ϊ2�Ľڵ�