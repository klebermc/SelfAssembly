function [ index ] = getNearestNode( tree, qRand )
%GETNEARESTNODE Summary of this function goes here
%   Detailed explanation goes here
index = 1;
minDist = inf;
for i = 1:length(tree)
    d = sqrt((qRand(1)-tree(i).x)^2 + (qRand(2)-tree(i).y)^2);
    if(d < minDist)
        index = i;
        minDist = d;
    end
    
end

