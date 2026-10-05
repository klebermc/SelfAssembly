function [ pathF ] = filterPath( path,a, b )
%FILTERPATH Summary of this function goes here
%   Detailed explanation goes here
[M, N] = size(path);
pathF = zeros(M,N);
pathF(:,1) = path(:,1);

for i = 2:N
    
    pathF(:,i) = a*pathF(:,i-1) + b*path(:,i);
    
end

pathF(:,N) = path(:,N);
end

