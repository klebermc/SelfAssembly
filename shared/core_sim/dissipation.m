clear

%% General variables
objects_in_fig=[];
dt=0.1;

%% 3D - N nodes
block_size=0.13;
N=15;                % Nodes in the network, cardinallity of vertex set
n=3;                % Variables of the state of each node
Gamma=[1 0; 0 1];   % Inter state relationship matrix
A=zeros(N,N);

A_deg=A;       % Ajacency Matrix version with degree
for i=1:size(A,1); A_deg(i,i) = -sum(A(i,:)); end
x=zeros(n*2,N);
val=zeros(N,1);
val(3,1)=1;
for i=1:N 
    x(:,i)=[(i-1)*block_size;0;0.5*block_size;0;0;0];
end

x(1:3,6)=[0.0;0.0;1];
x(1:3,7)=[0.3;0.0;1];
x(1:3,8)=[0.0;0.3;1];
x(1:3,9)=[0.3;0.3;1];

x(1:3,10)=[0.6;0.0;1];
x(1:3,11)=[0.9;0.0;1];
x(1:3,12)=[0.6;0.3;1];
x(1:3,13)=[0.9;0.3;1];

x(1:3,14)=[1.2;0.0;1];
x(1:3,15)=[1.2;0.3;1];

val(6)=1;
val(7)=1;
val(8)=1;
val(9)=1;
val(10)=1;
val(11)=1;
val(12)=1;
val(13)=1;
val(14)=1;
val(15)=1;

G = graph(A);
hops_graph=distances(G);
k=1;

for i=1:N
    for j=1:N
        if i~=j 
            if norm(x(1:n,i,k)-x(1:n,j,k),2)<2*block_size ... %node is close
               && A(i,j)==0 %node is not connected
                [ A, hops_graph ] = Auxiliar_DynNet.change_net_topology_add(A,i,j);
            end
        end
    end
end
  
descending=[6,7,8,9,10,11,12,13,14,15];
desINDX=1;
state=1;
CEFR=3;
count=0;

%% Initializing figure
close all
figure('units','normalized','outerposition',[0.43 0.25 0.28 0.98]);%[0,0,1,1]);
grid on;
hold on;
xlabel('X [m]')
ylabel('Y [m]')
zlabel('Z [m]')
view(135,30);
axis([-1 1.5 -1.5 1.5 0 2]);
% for i=1:N
%     for j=1:N
%         if A(i,j)==1 && i>j
%             objects_in_fig=[objects_in_fig,plot3([x(1,i) x(1,j)],[x(2,i) x(2,j)], [x(3,i)+0.2 x(3,j)+0.2], 'k','linewidth',1)]; 
%         end
%     end
% end
drawnow
record_video=0
if record_video==1
    v = VideoWriter(strcat('difusion_',num2str(N),'nodes.avi'));
    v.FrameRate=10;
    open(v);
end


% %big pyramid
S=[
0,0,0.5;	1,0,0.5;	2,0,0.5;	3,0,0.5;	4,0,0.5;
0,1,0.5;	1,1,0.5;	2,1,0.5;	3,1,0.5;	4,1,0.5;
0,2,0.5;    1,2,0.5;	2,2,0.5;	3,2,0.5;	4,2,0.5;
0,3,0.5;	1,3,0.5;	2,3,0.5;	3,3,0.5;	4,3,0.5;
0,4,0.5;	1,4,0.5;	2,4,0.5;	3,4,0.5;	4,4,0.5;
% 1,1,1.5;	2,1,1.5;	3,1,1.5;
% 1,2,1.5;	2,2,1.5;	3,2,1.5;
% 1,3,1.5;	2,3,1.5;	3,3,1.5;
% 0,2,1.5;
% 0,2,2.5;    1,2,2.5;    2,2,2.5;    
]*block_size;
%Plotting structure
% for j=1:size(S,1)
%     sx=S(j,1);sy=S(j,2);sz=S(j,3)-block_size/2;
%     plot3([sx-block_size/2 sx+block_size/2],[sy-block_size/2 sy-block_size/2],[sz sz],'r', 'linewidth',1);
%     plot3([sx-block_size/2 sx+block_size/2],[sy+block_size/2 sy+block_size/2],[sz sz],'r', 'linewidth',1);
%     plot3([sx-block_size/2 sx-block_size/2],[sy-block_size/2 sy+block_size/2],[sz sz],'r', 'linewidth',1);
%     plot3([sx+block_size/2 sx+block_size/2],[sy-block_size/2 sy+block_size/2],[sz sz],'r', 'linewidth',1);
% end


%% Simulation loop
for t=dt:dt:100
    tic
    k=round(t/dt);
    objects_in_fig=[];
    clc;
    
%     val(3,k)=1;
    
    for i=1:N
        for j=1:N
            %In a real scenario, I would not iterate through all vehicles, 
            %but through all sensors to see "who" am I seeing
            if i~=j 
                if norm(x(1:n-1,i,k)-x(1:n-1,j,k),2)<2*block_size ... %node is close
                   && A(i,j)==0 %node is not connected
                    [ A, hops_graph ] = Auxiliar_DynNet.change_net_topology_add(A,i,j);
                end
                if norm(x(1:n,i,k)-x(1:n,j,k),2)>=2*block_size ... %node is not close
                   && A(i,j)==1 %node is connected
                    [ A, hops_graph ] = Auxiliar_DynNet.change_net_topology_remove(A,i,j);
                end
            end
%             if A(i,j)==1 && i>j
%                 objects_in_fig=[objects_in_fig,plot3([x(1,i,k) x(1,j,k)],[x(2,i,k) x(2,j,k)], [x(3,i,k)+0.2 x(3,j,k)+0.2], 'k','linewidth',1)]; 
%             end
        end
        objects_in_fig=[objects_in_fig,Auxiliar.block3d(x(1,i,k),x(2,i,k),x(3,i,k),'grey')];
        objects_in_fig=[objects_in_fig,text(x(1,i,k),x(2,i,k),x(3,i,k)+block_size/2+0.01, sprintf('%.0f',val(i,k)*100),'color',[val(i,k),0,(1-val(i,k))])];
    end
    
    if desINDX>length(descending)
        break;
    end
    
    for i=1:N
        if i==descending(desINDX)
            if state == 1
                count=0;
%                 pos_N =x(1:n,CEFR,k)+[0;block_size;0];
%                 pos_S =x(1:n,CEFR,k)-[0;block_size;0];
                pos_E =x(1:n,CEFR,k)+[block_size;0;0];
                pos_W =x(1:n,CEFR,k)-[block_size;0;0];
%                 [pos_N_free,id_N]=Auxiliar_SelfAssembly.check_position_free(pos_N, x(:,:,k));
%                 [pos_S_free,id_S]=Auxiliar_SelfAssembly.check_position_free(pos_S, x(:,:,k));
                [pos_E_free,id_E]=Auxiliar_SelfAssembly.check_position_free(pos_E, x(:,:,k));
                [pos_W_free,id_W]=Auxiliar_SelfAssembly.check_position_free(pos_W, x(:,:,k));
%                 objects_in_fig = Auxiliar_SelfAssembly.plot_line_3d(objects_in_fig,pos_N, x(1:3,i), 'k', 1);
%                 objects_in_fig = Auxiliar_SelfAssembly.plot_line_3d(objects_in_fig,pos_S, x(1:3,i), 'k', 1);
                objects_in_fig = Auxiliar_SelfAssembly.plot_line_3d(objects_in_fig,pos_E, x(1:3,i), 'k', 1);
                objects_in_fig = Auxiliar_SelfAssembly.plot_line_3d(objects_in_fig,pos_W, x(1:3,i), 'k', 1);
                
                if ~pos_E_free && ~pos_W_free
                    if val(id_E,k)> val(id_W,k)
                        CEFR=id_E;
                    else
                        CEFR=id_W;
                    end
                else
                    state=2;
                end
                
            elseif state ==2
                pos_E=x(1:n,CEFR,k)+[block_size;0;0];
                pos_W=x(1:n,CEFR,k)-[block_size;0;0];
                [pos_E_free,id_N]=Auxiliar_SelfAssembly.check_position_free(pos_E,   x(:,:,k));
                [pos_W_free,id_S]=Auxiliar_SelfAssembly.check_position_free(pos_W, x(:,:,k));
                
                if pos_E_free
                   x(1:n,i,k)=pos_E;
                end
                if pos_W_free
                   x(1:n,i,k)=pos_W;
                end
                
                objects_in_fig = Auxiliar_SelfAssembly.plot_line_3d(objects_in_fig,x(1:n,i,k),   x(1:3,i), 'b', 1.5);
                state = 3;
            elseif state ==3
                count = count + 1;
                if count > 10
                    desINDX=desINDX+1;
                    state =1;
                    CEFR=3;
                end
            end
        end
      
        sum=0;
        for j=1:N
            if i~=j && A(i,j)~=0
                sum = sum + (val(j,k)-val(i,k));
            end
        end
        
        val(i,k+1) = val(i,k) + dt*sum;
        val(i,k+1) = max(val(i,k+1),0);
        x(:,i,k+1)=x(:,i,k);
    end

       
    if record_video==1
        drawnow
        pause(0.05);
        frame=getframe;
        if t==dt
            szframe=size(frame.cdata)-2;
        end
        frame.cdata=frame.cdata(1:szframe(1),1:szframe(2),1:3);
        writeVideo(v,frame);
    end
        
    proc_time=toc;
    fprintf("processing time = %.3f | actual t = %.1f\n",proc_time,t); 
    pause(dt);
    delete(objects_in_fig)
end

if record_video==1
    close(v);
    pause(1);
    command = sprintf('ffmpeg -i %s -vf "pad=ceil(iw/2)*2:ceil(ih/2)*2" -vcodec libx264 -acodec aac %s && rm %s ', v.Filename,strcat('difusion_',num2str(N),'nodes.mp4') ,v.Filename);
    system(command);
end

