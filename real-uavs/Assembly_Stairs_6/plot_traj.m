S=[ 0,0,0; 1,0,0; 2,0,0; 0,1,0; 1,1,0; 2,1,0; 0,0,1; 1,0,1; 0,1,1; 1,1,1; 0,0,2; 0,1,2;]; Seed_S=[ 0,0,0; 0,0,1;  0,0,2; ]; % stair with  6 blocks 

block_size=0.13;

L=max(S(:,3))+1; %L is the max layer number, 1<=l<=L

for j=1:size(S,1)
    S(j,3)=S(j,3)+0.5;
end
S=S*block_size;

%% Initializing figure
close all
figure('units','pixels','outerposition',[1960,544,1160,1046])
% figure('units','normalized','outerposition',[0.428571428571429,0.105625,0.308035714285714,0.77875]);
                                               
% view(-135,30);
view(-135,30);

grid on;

% axis([-0.5 0.5 -0.5 0.5 0 1]);
%axis equal
% axis ([min(x(1,:))-1 max(x(1,:))+1 min(x(2,:))-1 max(x(2,:))+1 0 2])
hold on
xlabel('X', 'FontSize',15)
ylabel('Y', 'FontSize',15)
zlabel('Z', 'FontSize',15)


%Plotting structure
for j=1:size(S,1)
    sx=S(j,1);sy=S(j,2);sz=S(j,3)-block_size/2;
    plot3([sx-block_size/2 sx+block_size/2],[sy-block_size/2 sy-block_size/2],[sz sz],'r', 'linewidth',1);
    plot3([sx-block_size/2 sx+block_size/2],[sy+block_size/2 sy+block_size/2],[sz sz],'r', 'linewidth',1);
    plot3([sx-block_size/2 sx-block_size/2],[sy-block_size/2 sy+block_size/2],[sz sz],'r', 'linewidth',1);
    plot3([sx+block_size/2 sx+block_size/2],[sy-block_size/2 sy+block_size/2],[sz sz],'r', 'linewidth',1);
end
drawnow
pause(0.5)
ax=gca;
ax.FontSize=15;

htick=-5:5;
htick=htick*block_size;
vtick=0:10;
vtick=vtick*block_size;
ax.XTick=htick;
ax.YTick=htick;
ax.ZTick=vtick;
axis ([min(htick) max(htick) min(htick) max(htick)  min(vtick) max(vtick)])

t=1;
for i=1:size(saved_x,2)
    traj(i)=plot3([saved_x(1,i,t) saved_x(1,i,t)],[saved_x(2,i,t) saved_x(2,i,t)],[saved_x(3,i,t) saved_x(3,i,t)],'-','LineWidth', 2);
    pos(i)=plot3(saved_x(1,i,1),saved_x(2,i,1),saved_x(3,i,1),'ko', 'MarkerFaceColor', 'k', 'MarkerSize', 4);
    txt(i)=text(saved_x(1,i,1),saved_x(1,i,1),saved_x(1,i,1)+0.01,num2str(i));
end

hold on
grid on

for i=5:size(saved_x,2)
    for t=450:size(saved_x,3)
        title(sprintf('t=%d',t))
        set(traj(i), 'XData', reshape(saved_x(1,i,1:t),1,[]),'YData', reshape(saved_x(2,i,1:t),1,[]),'ZData', reshape(saved_x(3,i,1:t),1,[]));
        set(pos(i) , 'XData', saved_x(1,i,t),'YData', saved_x(2,i,t),'ZData', saved_x(3,i,t));
        set(txt(i) , 'Position', saved_x(1:3,i,t)'+[0,0,0.01]);
        drawnow
        pause(0.1);
    end
    pause(0.1);
end