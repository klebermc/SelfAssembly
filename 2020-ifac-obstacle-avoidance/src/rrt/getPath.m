function [ path,indexV ] = getPath( tree )
%GETPATH Summary of this function goes here
%   Detailed explanation goes here
treeSize = length(tree);
path = zeros(2,1);

i = 0;
index = treeSize;
indexV(i+1) = index;
while(index ~= -1)
    i = i+1;
    path(1,i) = tree(index).x;
    path(2,i) = tree(index).y;
    indexV(i+1) = index;
    index = tree(index).parent;
end



end

