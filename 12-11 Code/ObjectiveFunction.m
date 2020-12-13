
function [ ObjVal,GroupIndex1 ] = ObjectiveFunction (x,param,numberofNodes)

ObjVal= sum ( abs(x) ) + prod( abs(x) );
NodeX=param.NX;
NodeY=param.NY;
for ii=1:numberofNodes
    GroupIndex1{ii}=[NodeX(ii) NodeY(ii)];
end
% GroupIndex1=GroupIndex(:);
ii=1;
valIdx=500:50:700;
while length(GroupIndex1)>=ii
    for jj=1:length(valIdx)
        GroupIndex1{ii}(1,3)=valIdx(jj);
        ii=ii+1;
    end
end
end