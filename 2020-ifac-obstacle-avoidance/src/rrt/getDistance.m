function [ dist ] = getDistance(node, point )
%GETDISTANCE Summary of this function goes here
%   Detailed explanation goes here
dist = sqrt((node.x-point(1))^2+(node.y-point(2))^2);

end

