function [ mask ] = getMask(node, qNear, safeRadius, M, N)
%GETMASK Summary of this function goes here
%   Detailed explanation goes here

mask = zeros(M,N);
x = node.x;
y = node.y;
for i = (x - safeRadius):(x + safeRadius)
    for j = (y - safeRadius):(y + safeRadius)
        
        if( i > N || i <= 0 || j > M || j <=0)
            continue;
        end
        
        if(sqrt((i-x)^2 + (j-y)^2) <= safeRadius)
            try
                mask(j, i) = 1;
            catch
                disp('');
            end
        end
        
    end
    
end

x = qNear(1);
y = qNear(2);
for i = (x - safeRadius):(x + safeRadius)
    for j = (y - safeRadius):(y + safeRadius)
        if( i > N || i <= 0 || j > M || j <= 0)
            continue;
        end
        
        if(sqrt((i-x)^2 + (j-y)^2) <= safeRadius)
            mask(j, i) = 1;
        end
        
    end
    
end

end

