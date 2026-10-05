function [ node ] = generateNode(max_x,max_y)
%GENERATE Summary of this function goes here
%   Detailed explanation goes here
min=0;
x = min + (max_x-min).*rand;
y = min + (max_y-min).*rand;

node = [x y];
end

