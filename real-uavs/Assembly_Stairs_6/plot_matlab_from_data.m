close all
record_video=1;
% figure('units','normalized','outerposition',[0.43 0.25 0.28 0.98]); record_video=0;
% figure('units','normalized','outerposition',[1.00 0.25 0.65 1.40]); record_video=1;
% figure('units','normalized','outerposition',[0.43 0.50 0.28 0.50]);
% figure('units','normalized','outerposition',[1.00 0.1638 0.6666 0.8361]); %figure linux laptop
% figure('units','normalized','outerposition',[0.01 0.50 0.20 0.50]);
% figure('units','normalized','outerposition',[1.50 0.20 0.30 0.50]); %FIGURE MAC
                                               
figure('units','normalized','outerposition',[0.428571428571429,0.105625,0.308035714285714,0.77875]);

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

for i=2:N
    nodeVars(i).state=1;
end

time_t=dt;
while time_t<t
time_t=time_t+dt;
    
    switch time_t
        
        case 5
            nodeVars(2).state=2;
        case 24
            nodeVars(2).state=3;
        case 55
            nodeVars(2).state=4;
        case 56
            nodeVars(2).state=5;
        case 115
            nodeVars(2).state=5;
    end
    

    tic
    k=round(time_t/dt);

    objects_in_fig=[];               
             
    
    % Figure plot
    % ---------------
    for i=1:N
        switch nodeVars(i).state
%             case 1
%                 objects_in_fig=[objects_in_fig,block3d(x(1,i,k),x(2,i,k),x(3,i,k),'yellow')];
%             case 2
%                 objects_in_fig=[objects_in_fig,block3d(x(1,i,k),x(2,i,k),x(3,i,k),'red')];
%             case 3
%                 objects_in_fig=[objects_in_fig,block3d(x(1,i,k),x(2,i,k),x(3,i,k),'magenta')];
%             case 4
%                 objects_in_fig=[objects_in_fig,block3d(x(1,i,k),x(2,i,k),x(3,i,k),'blue')];
            case 5
                objects_in_fig=[objects_in_fig,block3d(x(1,i,k),x(2,i,k),x(3,i,k),'green')];
            case 6
                objects_in_fig=[objects_in_fig,block3d(x(1,i,k),x(2,i,k),x(3,i,k),'grey')];
        end
%         if nodeVars(i).state~=1; objects_in_fig=[objects_in_fig,text(x(1,i,k),x(2,i,k),x(3,i,k)+block_size/2+0.02, ...
%                                     sprintf('%.0f',nodeVars(i).gradient),'FontSize',8,'HorizontalAlignment','center')]; end
    end

    for i=1:N
        switch nodeVars(i).state                
            case 2
                % ---- DESCEND ---- 
                %at this point, the goal position should be the s1 position
                %plot line
                to=[nodeVars(i).goalPos(1);nodeVars(i).goalPos(2);nodeVars(i).goalPos(3)+nodeVars(i).displacement(3)];
                objects_in_fig = Auxiliar_SelfAssembly.plot_line_3d(objects_in_fig, to, nodeVars(i).goalPos, 'k', 1.5);
                objects_in_fig=[objects_in_fig,surf(Xs+nodeVars(i).goalPos(1),Ys+nodeVars(i).goalPos(2),Zs+nodeVars(i).goalPos(3))];
                objects_in_fig=[objects_in_fig,block3d(x(1,i,k),x(2,i,k),x(3,i,k)+nodeVars(i).displacement(3),'red')];

                vect=(nodeVars(i).goalPos-posi);
                objects_in_fig = [objects_in_fig,quiver3(posi(1),posi(2),posi(3)+nodeVars(i).displacement(3)+block_size*0.6,vect(1),vect(2),vect(3), 'LineWidth',1.5,'MaxHeadSize',0.9, 'Color', 'b')];

            case 3
                % --- Edge following algorithm outside                
                %Plot the position to where I am going
                objects_in_fig=[objects_in_fig,surf(Xs+nodeVars(i).goalPos(1),Ys+nodeVars(i).goalPos(2),Zs+nodeVars(i).goalPos(3))];
                to=[nodeVars(i).goalPos(1);nodeVars(i).goalPos(2);nodeVars(i).goalPos(3)+nodeVars(i).displacement(3)];
                objects_in_fig = Auxiliar_SelfAssembly.plot_line_3d(objects_in_fig, nodeVars(i).goalPos, to, 'b', 1.5);
                %objects_in_fig = Auxiliar_SelfAssembly.plot_line_3d(objects_in_fig, nodeVars(i).goalPos, nodeVars(i).CEFRposition, 'b', 1.5);
                objects_in_fig=[objects_in_fig,block3d(x(1,i,k),x(2,i,k),x(3,i,k)+nodeVars(i).displacement(3),'magenta')];

                vect=(nodeVars(i).goalPos-posi);
                objects_in_fig = [objects_in_fig,quiver3(posi(1),posi(2),posi(3)+nodeVars(i).displacement(3)+block_size*0.6,vect(1),vect(2),vect(3), 'LineWidth',1.5,'MaxHeadSize',0.9, 'Color', 'b')];

            case 4
                % --- Edge following inside
                %Plot the position to where I am going  
                objects_in_fig=[objects_in_fig,surf(Xs+nodeVars(i).goalPos(1),Ys+nodeVars(i).goalPos(2),Zs+nodeVars(i).goalPos(3))];
                to=[nodeVars(i).goalPos(1);nodeVars(i).goalPos(2);nodeVars(i).goalPos(3)+nodeVars(i).displacement(3)];
                objects_in_fig = Auxiliar_SelfAssembly.plot_line_3d(objects_in_fig, nodeVars(i).goalPos, to, 'b', 1.5);
                %objects_in_fig = Auxiliar_SelfAssembly.plot_line_3d(objects_in_fig, nodeVars(i).goalPos, nodeVars(i).CEFRposition, 'b', 1.5);
                objects_in_fig=[objects_in_fig,block3d(x(1,i,k),x(2,i,k),x(3,i,k)+nodeVars(i).displacement(3),'blue')];

                vect=(nodeVars(i).goalPos-posi);
                objects_in_fig = [objects_in_fig,quiver3(posi(1),posi(2),posi(3)+nodeVars(i).displacement(3)+block_size*0.6,vect(1),vect(2),vect(3), 'LineWidth',1.5,'MaxHeadSize',0.9, 'Color', 'b')];

            case 5

                vect=(nodeVars(i).goalPos-posi);
                objects_in_fig = [objects_in_fig,quiver3(posi(1),posi(2),posi(3)+block_size*0.6,vect(1),vect(2),vect(3), 'LineWidth',1.5,'MaxHeadSize',0.9, 'Color', 'b')];
                objects_in_fig=Auxiliar_SelfAssembly.plot_line_3d(objects_in_fig,approaching_pos,nodeVars(i).landingPos,'k',1.5);
                objects_in_fig=[objects_in_fig,text(posi(1),posi(2),posi(3)+block_size, ...
                    sprintf('dist=%.2fcm',norm(nodeVars(i).goalPos - posi,2)),'FontSize',10,'HorizontalAlignment','center')];

                midline = (approaching_pos+nodeVars(i).landingPos)/2;
                objects_in_fig=[objects_in_fig,text(midline(1),midline(2),midline(3), ...
                    sprintf('land=%d%%',nodeVars(i).relativeHeight*100),'FontSize',10,'HorizontalAlignment','center')];


            case 6
                % --- Placed 

        end
    end
    %stop simulation condition
    number_of_placed=0;
    for i=1:N
        if nodeVars(i).state==6
            number_of_placed=number_of_placed+1;
        end
    end

    if number_of_placed==N
        if sim_end>t
            sim_end=t;
        else
            if record_video==1
                %view(mod(round((t-sim_end)/dt)+135,360),30);
                if t-sim_end>5
                   break;   
                end
            else
                break;
            end
        end
    end

    delete(objects_in_fig)
end        

   
    if record_video==1 && t>=now
        drawnow
        pause(0.05);
        frame=getframe;
        if isempty(szframe)
            szframe=size(frame.cdata)-2;
        end
%             frame.cdata=frame.cdata(1:szframe(1),1:szframe(2),1:3);
%             writeVideo(v,frame);
%             now=t+0.1;
        z=''; if t<10; z='00'; elseif t<100; z='0'; elseif t>=100; z=''; end
%         ax = gca;
        % Requires R2020a or later
%         exportgraphics(ax,strcat('real_assembly_',z,num2str(k),'.png'),'Resolution',300) 
        print(strcat('figures/real_assembly_',num2str(N),'_',z,num2str(k),'.png'),'-dpng')
        now=t+1;
    end
    
   drawnow;
   proc_time=toc;
   fprintf("processing time = %.3f | actual t = %.1f\n",proc_time,t); 
   pause(min(abs(dt-proc_time),dt))
   
   
   
    
   
   function h = block3d(x,y,z,colour)
            switch colour
                case 'grey'
                    colour=[0.8 0.8 0.8];
                case 'blue'
                    colour=[0.0 0.0 0.8];
                case 'red'
                    colour=[0.8 0.0 0.0];
                case 'green'
                    colour=[0.0 0.8 0.0];
                case 'magenta'
                    colour=[0.8 0.0 0.8];
                case 'yellow'
                    colour=[0.8 0.8 0.0];
            end
            d=0.13;
            a = -pi : pi/2 : pi;                                % Define Corners
            ph = pi/4;                                          % Define Angular Orientation (‘Phase’)
            X = [cos(a+ph); cos(a+ph)]/cos(ph); X = X*d/2 + x;
            Y = [sin(a+ph); sin(a+ph)]/sin(ph); Y = Y*d/2 + y;
            Z = [-ones(size(a)); ones(size(a))];Z = Z*d/2 + z;
            h=surf(X, Y, Z, 'FaceColor',colour,'EdgeColor','k'); % Plot Cube
            h=[h,patch(X', Y', Z', colour)]; % Make Cube Appear Solid
        end