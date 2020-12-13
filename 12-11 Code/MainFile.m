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


% Node Location  optimization based on PSO
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

