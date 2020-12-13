close all;
clear all;
clc;
Network=[1000 1000 1000];
numberofNodes=100;  % Number of Nodes
NodeX=rand(1,numberofNodes)*Network(1);
NodeY=rand(1,numberofNodes)*Network(2);
NodeZ=rand(1,numberofNodes)*Network(3);
figure,
plot3(NodeX,NodeY,NodeZ,'ko','Markersize',15,'MarkerFaceColor','g');
for ii=1:numberofNodes
    text(NodeX(ii),NodeY(ii),NodeZ(ii),num2str(ii));
end

indexPrediction=linspace(0,Network(1),sqrt(numberofNodes));
for ii=1:length(indexPrediction)
    for jj=1:length(indexPrediction)
        GroupIndex{ii,jj}=[indexPrediction(ii) indexPrediction(jj)];
    end
end
GroupIndex1=GroupIndex(:);
ii=1;
valIdx=500:50:700;
while length(GroupIndex1)>=ii
    for jj=1:length(valIdx)
        GroupIndex1{ii}(1,3)=valIdx(jj);
        ii=ii+1;
    end
end

minNodeLoc=[];
for jj=1:length(GroupIndex1)
    aa=1;
    for ii=1:length(NodeX)
        dist(ii)=sqrt(((NodeX(ii)-GroupIndex1{jj}(1))^2)+((NodeY(ii)-GroupIndex1{jj}(2))^2)+((NodeZ(ii)-GroupIndex1{jj}(2))^2));
    end
    [min_val min_id]=sort(dist,'ascend');
    temp=find(minNodeLoc==min_id(aa));
    while ~isempty(temp)
        aa=aa+1;
        temp=find(minNodeLoc==min_id(aa));
    end
    minNodeLoc=[minNodeLoc min_id(aa)];
end

figure,
for ii=1:numberofNodes
    plot3(GroupIndex1{minNodeLoc(ii)}(1),ii+10,GroupIndex1{minNodeLoc(ii)}(3),'ko','Markersize',15,'MarkerFaceColor','g');hold on;
end
for ii=1:length(minNodeLoc)
    text(GroupIndex1{(ii)}(1),ii+10,GroupIndex1{(ii)}(3),num2str(minNodeLoc(ii)));hold on;
end

% Node Allignment based on PSO
param.nVar = 2;
param.ub = 50 * ones(1, 2);
param.lb = -50 * ones(1, 2);
param.fobj = @ObjectiveFunction;
param.NetD = Network(1);
param.NoNodes = numberofNodes;
param.NX = NodeX;
param.NY = NodeY;
param.NZ = NodeZ;
noP = 4;
maxIter = 500;
visFlag = 1;
RunNo  = 30;
BestSolutions_PSO = zeros(1 , RunNo);


[ GBEST  , GroupIndex,minNodeLoc ] = PSO( noP , maxIter, param , visFlag ) ;

disp('Best solution found')
GBEST.X
disp('Best objective value')
GBEST.O


figure,
for ii=1:numberofNodes
    plot3(GroupIndex{minNodeLoc(ii)}(1),GroupIndex{minNodeLoc(ii)}(2),GroupIndex{minNodeLoc(ii)}(3),'ko','Markersize',15,'MarkerFaceColor','g');hold on;
end
for ii=1:length(minNodeLoc)
    text(GroupIndex{(ii)}(1),GroupIndex{(ii)}(2),GroupIndex{(ii)}(3),num2str(minNodeLoc(ii)));hold on;
end

