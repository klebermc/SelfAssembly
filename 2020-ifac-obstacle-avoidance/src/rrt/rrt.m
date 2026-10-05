function [path] = rrt(obstacles,area_dimensions,range_obstacles,start,finish)
%start = [50,50];
%finish = [700,700];

%draw_tree
draw_tree=0; %0 - false
safeRadius = range_obstacles;
edgeLength = safeRadius/2; %%Smaller than 

% edgeLength = 0.2; %%Smaller than safeRadius/2
% safeRadius = 0.5; %range_obstacles

%%%%%%%%%%%%%%
max_x=floor(area_dimensions(1)); max_y = floor(area_dimensions(2));
temp=start;
while checkColision2(obstacles,start',safeRadius) == 1
    %the position of the node is already within the colision range
    %give the tree another start position
    for j=1:size(obstacles,2)
        if norm(temp - obstacles(1:2,j))<safeRadius+obstacles(3,j)
            break;
        end
    end
    temp=obstacles(1:2,j) + 1.01*(safeRadius+obstacles(3,j))* ((temp - obstacles(1:2,j))/norm(temp - obstacles(1:2,j)));
    %plot(temp(1), temp(2), 'vm');
    start=temp;
end

nNodes = 1;
tree(1).x = start(1);
tree(1).y = start(2);
tree(1).parent = -1;
h=figure(1);
if draw_tree==1; plot(start(1),start(2),'*r'); plot(finish(1),finish(2),'*b'); end
tic
while(1)
    qRand = generateNode(max_x,max_y); %random point in space
    index = getNearestNode(tree, qRand); %find closes point in tree
    qNear = limitDistance(tree(index),qRand,edgeLength); %create a probable new node connected to the closest one
    %check for colision
    colision = checkColision2(obstacles,qNear,safeRadius);
    %mask = getMask(tree(index), qNear,safeRadius,M,N);
    %colision = checkColision(mask,I);
    
    if(colision == 0)
        nNodes = nNodes + 1;
        tree(nNodes).x = qNear(1);
        tree(nNodes).y = qNear(2);
        tree(nNodes).parent = index;
        
        if draw_tree==1
        x_vec = [tree(nNodes).x tree(tree(nNodes).parent).x];
        y_vec = [tree(nNodes).y tree(tree(nNodes).parent).y];
        h = line(x_vec,y_vec,'Marker','.','LineStyle','-');
        end
        
        [ dist ] = getDistance(tree(nNodes), finish);
        if(dist < 0.5)%(edgeLength*2))
            nNodes = nNodes+1;
            index = getNearestNode(tree, finish);
            tree(nNodes).x = finish(1);
            tree(nNodes).y = finish(2);
            tree(nNodes).parent = index;
            disp('Finished');
            break;
        end
        
    end
    if(mod(nNodes,1000) == 0)
         disp(strcat('tree size = ', num2str(nNodes)))
         if draw_tree==1; drawnow; pause(0.05); end
    end
end
toc

[path, indexV] = getPath(tree);
path = fliplr(path);
pathF = path;
if draw_tree==1 
    indexV = fliplr(indexV);
    plot(path(1,:),path(2,:),'r');
    alfa = 0.9;
    %pathF = filterPath(path,alfa,1-alfa);
    plot(pathF(1,:),pathF(2,:),'m');
end
end