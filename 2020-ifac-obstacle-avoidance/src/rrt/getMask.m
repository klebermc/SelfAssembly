function [ mask ] = getMask(node, qNear, safeRadius, M, N)
%GETMASK Summary of this function goes here
%   Detailed explanation goes here

mask = zeros(M,N);
v1= [node.x node.y];
v2 = qNear;
a = (v2-v1)/norm(v2-v1);
t = safeRadius;

p = v1;

dist2 = sqrt((v2-v1)*(v2-v1)');

[mask] = maskAtPoint(mask,v1(1),v1(2),safeRadius,M,N);
p = p + safeRadius*a;
dist1 = sqrt((p-v1)*(p-v1)');

while(dist1 <= dist2)

[mask] = maskAtPoint(mask,p(1),p(2),safeRadius,M,N);

p = p + safeRadius*a;
dist1 = sqrt((p-v1)*(p-v1)');
end


[mask] = maskAtPoint(mask,v2(1),v2(2),safeRadius,M,N);



end




function [mask] = maskAtPoint(mask,x,y,safeRadius,M,N)
for i = (x - safeRadius):(x + safeRadius)
    for j = (y - safeRadius):(y + safeRadius)
        
        if( i > N || i <= 0 || j > M || j <=0)
            continue;
        end 
        if(sqrt((i-x)^2 + (j-y)^2) <= safeRadius)
                mask(j, i) = 1;
        end
        
    end
    
end



end
