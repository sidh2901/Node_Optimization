function [ globalBets ,  indxParti,minNodeLoc ] = PSO ( noP, maxIter,  param, dataVis )

nVar = param.nVar;
ub = param.ub;
lb = param.lb;
fobj = param.fobj;
Nodes_X=param.NX;
Nodes_Y=param.NY;
Nodes_Z=param.NY;
Network_Dim=param.NetD;
numberofNodes=param.NoNodes;
meanObjective = zeros(1, maxIter);
convergenceCurve = zeros(1, maxIter);

wMax = 0.9;
wMin = 0.2;
c1 = 2;
c2 = 2;
vMax = (ub - lb) .* 0.2;
vMin  = -vMax;

for k = 1 : noP
    particleSwarm.Particles(k).X = (ub-lb) .* rand(1,nVar) + lb;
    particleSwarm.Particles(k).V = zeros(1, nVar);
    particleSwarm.Particles(k).PBEST.X = zeros(1,nVar);
    particleSwarm.Particles(k).PBEST.O = inf;
    
    particleSwarm.globalBets.X = zeros(1,nVar);
    particleSwarm.globalBets.O = inf;
end


for t = 1 : maxIter
    
    for k = 1 : noP
        
        currentX = particleSwarm.Particles(k).X;
        
        
         [ObjectRes,indxParti]= fobj(currentX,Network_Dim,numberofNodes);
         particleSwarm.Particles(k).O=ObjectRes(1);
        meanObjective(t) =  meanObjective(t)  + particleSwarm.Particles(k).O;
        if particleSwarm.Particles(k).O < particleSwarm.Particles(k).PBEST.O
            particleSwarm.Particles(k).PBEST.X = currentX;
            particleSwarm.Particles(k).PBEST.O = particleSwarm.Particles(k).O;
        end
        
        if particleSwarm.Particles(k).O < particleSwarm.globalBets.O
            particleSwarm.globalBets.X = currentX;
            particleSwarm.globalBets.O = particleSwarm.Particles(k).O;
        end
    end
    
    w = wMax - t .* ((wMax - wMin) / maxIter);
    
%     FirstP_D1(t) = particleSwarm.Particles(1).X(1);
    
    for k = 1 : noP
        particleSwarm.Particles(k).V = w .* particleSwarm.Particles(k).V + c1 .* rand(1,nVar) .* (particleSwarm.Particles(k).PBEST.X - particleSwarm.Particles(k).X) ...
            + c2 .* rand(1,nVar) .* (particleSwarm.globalBets.X - particleSwarm.Particles(k).X);
        
        
        index1 = find(particleSwarm.Particles(k).V > vMax);
        index2 = find(particleSwarm.Particles(k).V < vMin);
        
        particleSwarm.Particles(k).V(index1) = vMax(index1);
        particleSwarm.Particles(k).V(index2) = vMin(index2);
        
        particleSwarm.Particles(k).X = particleSwarm.Particles(k).X + particleSwarm.Particles(k).V;
        
        index1 = find(particleSwarm.Particles(k).X > ub);
        index2 = find(particleSwarm.Particles(k).X < lb);
        
        particleSwarm.Particles(k).X(index1) = ub(index1);
        particleSwarm.Particles(k).X(index2) = lb(index2);
        
    end
    
    if dataVis == 1
        dispMsg = ['Iteration# ', num2str(t) , ' particleSwarm.globalBets.O = ' , num2str(particleSwarm.globalBets.O)];
        disp(dispMsg);
    end
    
    convergenceCurve(t) = particleSwarm.globalBets.O;
    meanObjective(t) = meanObjective(t) / noP;
end

globalBets = particleSwarm.globalBets;
minNodeLoc=[];
for jj=1:length(indxParti)
    aa=1;
    for ii=1:length(Nodes_X)
        %3D-Distance Formula
        dist(ii)=sqrt(((Nodes_X(ii)-indxParti{jj}(1))^2)+((Nodes_Y(ii)-indxParti{jj}(2))^2)+((Nodes_Z(ii)-indxParti{jj}(2))^2));
    end
    [min_val min_id]=sort(dist,'ascend');
    temp=find(minNodeLoc==min_id(aa));
    while ~isempty(temp)
        aa=aa+1;
        temp=find(minNodeLoc==min_id(aa));
    end
    minNodeLoc=[minNodeLoc min_id(aa)];
end

if dataVis == 1
    iterations = 1: maxIter;
    
    figure,
    semilogy(iterations , convergenceCurve, 'r');
    title('Convergence curve')
    xlabel('Iteration#')
    ylabel('Weight')
    
    figure,
    semilogy(iterations , meanObjective , 'g')
    title('Average objecitves of all particles')
    xlabel('Iteration#')
    ylabel('Average objective')  
end