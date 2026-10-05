function [ colision ] = checkColision(mask,I)
%CHECKCOLISION Summary of this function goes here
%   Detailed explanation goes here
result = mask.*-(double(I)-255);
colision = 0;
if(sum(sum(result)) > 0)
    colision = 1;
end

end

