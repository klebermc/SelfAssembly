function [ qNear ] = limitDistance( node, qRand, edgeLength)
%LIMITDISTANCE Summary of this function goes here
%   Detailed explanation goes here

pos = [node.x node.y];

v = qRand - pos;

if(norm(v) < edgeLength)
    qNear = qRand;
    return;
end

v = v/norm(v);

%qNear = round(edgeLength*v+pos);
qNear = edgeLength*v+pos;

end

