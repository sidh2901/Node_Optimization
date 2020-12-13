
function [ ObjVal,GroupIndex1 ] = ObjectiveFunction (x,Network_Dim,numberofNodes)

ObjVal= sum ( abs(x) ) + prod( abs(x) );
indexPrediction=linspace(0,Network_Dim(1),sqrt(numberofNodes));
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
end