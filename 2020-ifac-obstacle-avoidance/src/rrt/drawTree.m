function drawTree( tree, h)
%DRAWTREE Summary of this function goes here
%   Detailed explanation goes here
for i= 2:length(tree)
    x = [tree(i).x tree(tree(i).parent).x];
    y = [tree(i).y tree(tree(i).parent).y];
    h = line(x,y,'Marker','.','LineStyle','-');
    
end
drawnow

end

