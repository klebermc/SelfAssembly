function [ colision ] = checkColision2(obstacles,qNear,safeRadius)
%CHECKCOLISION Summary of this function goes here
%   Detailed explanation goes here
    qNear=qNear';
    colision = 0;
    for j=1:size(obstacles,2)
        %disp([qNear, obstacles(1:n,j)])
        %disp([safeRadius, obstacles(3,j), norm(qNear - obstacles(1:2,j)), safeRadius+obstacles(3,j)])
        if norm(qNear - obstacles(1:2,j))<safeRadius+obstacles(3,j)
%             plot(qNear(1),qNear(2),'*m');
            colision = 1;
        end
    end
end

