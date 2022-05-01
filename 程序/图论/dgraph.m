%% 迪杰斯特拉最短路径
clc;
W = [.41 .99 .51 .32 .15 .45 .38 .32 .36 .29 .21];
DG = sparse([6 1 2 2 3 4 4 5 5 6 1],[2 6 3 5 4 1 6 3 4 3 5],W);
h=view(biograph(DG,[],'ShowWeights','on'))
[dist,path,pred]=graphshortestpath(DG,1,6,'Directed','true')
set(h.Nodes(path),'Color',[1 0.4 0.4])
edges=getedgesbynodeid(h,get(h.Nodes(path),'ID'));%我觉得这里就是获得最短路径的边和ID
set(edges,'LineColor',[1 0 0])
set(edges,'LineWidth',1.5)
UG=tril(DG+DG');
bg=biograph(UG,[],'ShowArrows','off','ShowWeights','on');
h=view(bg)
set(bg.nodes,'shape','circle');
[dist,path,pred]=graphshortestpath(UG,1,6,'Directed','false')
set(h.Nodes(path),'Color',[1 0.4 0.4])
fowEdges=getedgesbynodeid(h,get(h.Nodes(path),'ID'));
revEdges=getedgesbynodeid(h,get(h.Nodes(fliplr(path)),'ID'));%这里fliplr是反转操作，比如把[1 2 3]变成[3 2 1]。由于是无向图，所以正反都要求。
edges=[fowEdges;revEdges];
set(edges,'LineColor',[0.6 0.4 0.1])
set(edges,'LineWidth',1.5)

%% 弗洛伊德最短路径
w=[41 99 51 32 15 45 38 32 36 29 21];%权值向量
dg=sparse([6 1 2 2 3 4 4 5 5 6 1],[2 6 3 5 4 1 6 3 4 3 5],w)%构造的稀疏矩阵表示图
h=view(biograph(dg,[],'ShowWeights','on'))%显示图的结构
dist=graphallshortestpaths(dg)%显示图中每对结点之间的最短路径

ug=tril(dg+dg');%要求生成的无向图是一个下三角矩阵
view(biograph(ug,[],'ShowArrows','off','ShowWeights','on'));
dist=graphallshortestpaths(ug,'directed',false)

%% 最小生成树
w=[ 41    29    51    32    50    45    38    32    36    29    21];
dg=sparse([1 1 2 2 3 4 4 5 5 6 6],[2 6 3 5 4 1 6 3 4 2 5],w)
ug=tril(dg+dg');
view(biograph(ug,[],'ShowArrows','off','ShowWeights','on'));
[st,pred]=graphminspantree(ug)%生成最小生成树
h=view(biograph(st,[],'ShowArrows','off','ShowWeights','on'));
Edges=getedgesbynodeid(h);%提取无向图h的边集
set(Edges,'LineColor',[0 0 0]);%设置颜色属性
set(Edges,'LineWidth',1.5)%设置边值属性

%% 最大流最小流
cm=sparse([1 1 2 2 3 3 4 5],[2 3 4 5 4 5 6 6],[2 3 3 1 1 1 2 3 ],6,6);
%6个节点8条边
[M,F,K]=graphmaxflow(cm,1,6);%计算第1个到第6个节点的最大流
h=view(biograph(cm,[],'ShowWeights','on'));%显示原始有向图的图结构
h1=view(biograph(F,[],'ShowWeights','on'));%显示计算最大流矩阵的图结构

%% 遍历算法
DG=sparse([1 2 3 4 5 5 5 6 7 8 8 9],[2 4 1 5 3 6 7 9 8 1 10 2],true,10,10)
h1=view(biograph(DG));
order=graphtraverse(DG,4)%使用深度优先算法从第4个节点开始遍历
order2=graphtraverse(DG,4,'Method','BFS')%使用广度优先遍历
index=graphtraverse(DG,4,'depth',2)%标记与节点4邻近的深度为2的节点