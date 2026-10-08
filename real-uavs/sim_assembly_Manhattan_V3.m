% Description
% This simulation aims to study network control strategies applied to
% assembly.
% Here, different subgroups of the network will apply different assembly
% rules to create compound parts.
% Simulating state of nodes 

clear

date_now=string(datetime('now','Format','yy_MM_dd_HH_mm_ss'));
%% Structure

% Stairs
% S=[ 0,0,0; 1,0,0; ];                                                          Seed_S=[ 0,0,0;];                           % two blocks ground level
% S=[ 0,0,0; 1,0,0; 0,0,1; ];                                                   Seed_S=[ 0,0,0; 0,0,1;];                    % stair with  3 blocks 
% S=[ 0,0,0; 1,0,0; 2,0,0; 0,0,1; 1,0,1; 0,0,2; ];                              Seed_S=[ 0,0,0; 0,0,1;  0,0,2; ];           % stair with  6 blocks 
  S=[ 0,0,0; 1,0,0; 2,0,0; 0,1,0; 1,1,0; 2,1,0; 0,0,1; 1,0,1; 0,1,1; 1,1,1; 0,0,2; 0,1,2;]; Seed_S=[ 0,0,0; 0,0,1;  0,0,2; ]; % stair with  6 blocks 
% S=[ 0,0,0; 1,0,0; 2,0,0; 3,0,0; 0,0,1; 1,0,1; 2,0,1; 0,0,2; 1,0,2; 0,0,3; ];  Seed_S=[ 0,0,0; 0,0,1;  0,0,2; 0,0,3;  ];   % stair with 10 blocks 


% ground level rectangle
% S=[ 0,0,0; 1,0,0; 0,1,0; 1,1,0; 0,2,0; 1,2,0; 0,3,0; 1,3,0; ]; Seed_S=[ 0,0,0;];

%ground level square
% S=[ 	
% 0,0,0;	1,0,0;	2,0,0;	3,0,0;	4,0,0;
% 0,1,0;	1,1,0;	2,1,0;	3,1,0;	4,1,0;
% 0,2,0;    1,2,0;	2,2,0;	3,2,0;	4,2,0;
% 0,3,0;	1,3,0;	2,3,0;	3,3,0;	4,3,0;
% 0,4,0;	1,4,0;	2,4,0;	3,4,0;	4,4,0;    ];
% Seed_S=[ 0,0,0;];

%small pyramid
% S=[ 	
% 0,0,0;	1,0,0;	2,0,0;
% 0,1,0;	1,1,0;	2,1,0;
% 0,2,0;  1,2,0;	2,2,0;
% 
% 0,1,1;	1,1,1;	2,1,1;
% 
% 1,1,2;
% ];
% Seed_S=[0,0,0;0,1,1;1,1,2;];


block_size=0.13;

L=max(S(:,3))+1; %L is the max layer number, 1<=l<=L

for j=1:size(S,1)
    S(j,3)=S(j,3)+0.5;
end
S=S*block_size;



%% 3D - N nodes
N=size(S,1);            % Nodes in the network, cardinallity of vertex set
n=3;                    % Variables of the state of each node
A=ones(N,N)-eye(N);
Adif=zeros(N,N);
x=zeros(n*2,N);
x(:,1)=[0;0;block_size/2;0;0;0];
for i=2:N 
%     [newx,newy]= pol2cart(rand*2*pi,abs(rand*0.2+0.05));
%     newx=min(max(newx,-1),-0.2);
%     newy=min(max(newy,-1),-0.2);
%     x(:,i)=[newx+x(1,i-1);newy+x(2,i-1);1;0;0;0];
    [newx,newy]= pol2cart(rand*2*pi,1.5);%[newx,newy]= pol2cart(rand*2*pi,1.5);
x(:,i)=[-block_size*2;-block_size*2;block_size/2;0;0;0];  
end
G = graph(A);
hops_graph=distances(G);

%% WP navigation of the ensemble
WP = [1;1;0;0];
for j=2:5; WP(:,j) = WP(:,j-1)+[1;1;0;0]; end
nextwp=1;

%% Gain matrix
kp=0.1; kv=sqrt(2*kp);
C=[ kp kv; 3 2*sqrt(3); 1 2*sqrt(1); 1 2*sqrt(1)];


%% Initializing figure
close all
record_video=1;
% figure('units','normalized','outerposition',[0.43 0.25 0.28 0.98]); record_video=0;
% figure('units','normalized','outerposition',[1.00 0.25 0.65 1.40]); record_video=1;
% figure('units','normalized','outerposition',[0.43 0.50 0.28 0.50]);
% figure('units','normalized','outerposition',[1.00 0.1638 0.6666 0.8361]); %figure linux laptop
% figure('units','normalized','outerposition',[0.01 0.50 0.20 0.50]);
figure('units','normalized','outerposition',[1.50 0.20 0.30 0.50]); %FIGURE MAC
                                               
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

%% Finite State Machine - variable used by each robot.
for i=1:N
    nodeVars(i).id=i;
    nodeVars(i).state=1;
    nodeVars(i).gradient=1;
    nodeVars(i).neighGrad=[];
    nodeVars(i).neighState=[];
    nodeVars(i).neighId=[];
    nodeVars(i).CEFRcirclingPos=1;
    nodeVars(i).CEFRid=0;
    nodeVars(i).CEFRposition=[];
    nodeVars(i).CEFRgradient=0;
    nodeVars(i).goalPos=[];
    nodeVars(i).displacement=[0;0;3]*block_size;
    nodeVars(i).initialAngle=0;
    nodeVars(i).vel=[0;0];
    nodeVars(i).val=0;
    nodeVars(i).neighVal=[];
    nodeVars(i).amIseed=false;
    nodeVars(i).counterNodesThisLayer=0;
    nodeVars(i).seedPos=[];
    nodeVars(i).axis_to_move=0;
    if i==1
        nodeVars(i).amIseed=true;
        nodeVars(i).state=6;
        nodeVars(i).goalPos=[0;0;block_size/2];
        nodeVars(i).gradient=0;
        nodeVars(i).counterNodesThisLayer=1;
    end
    nodeVars(i).MOVE_count=0;
    nodeVars(i).started=0;
    nodeVars(i).landingPos=[];
    nodeVars(i).relativeHeight=1;
end

%% momentum gains
mu=0.9;
eps=0.1;

%% Flocking simulation
epslon = 0.5;
inter_agent_d=1;
sigma_d = Auxiliar.sigma_norm(inter_agent_d);
int_range_r = 15;
sigma_int_range = Auxiliar.sigma_norm(int_range_r);

%% Generic simulation variables
dt=1;
objects_in_fig=[];
now=2.4;
szframe=[];
pin=4;                      
circling=[[ block_size; 0;0],[ 0;-block_size;0],[-block_size; 0;0],[ 0; block_size;0],[ 0; 0; block_size]];
simulate_dynamics=true;
sim_end=9999;
seeking_lowenergy=false;
hist_state=[];

bitdrones_server = Auxiliar_comm_bitdrones;
bitdrones_server=bitdrones_server.connect('DRONE_SERVER_IP',1520); % set to the address of the drone server

[Xs,Ys,Zs] = sphere(4);
r = 0.03; Xs = Xs * r; Ys = Ys * r; Zs = Zs * r;

% x(:,1,1)=[S(1,1);S(1,2);block_size/2;0;0;0];
% Auxiliar.block3d(x(1,1,1),x(2,1,1),x(3,1,1),'grey');

for j=1:L
    comm_channel_seed(j).IN=0;
    comm_channel_seed(j).OUT=0;
end

working_agents=1:N;
timeout=0;

% clear
% load state_assembly.mat
% t=t-dt;

if record_video==1
%     v = VideoWriter(strcat('SelfAssembly_',num2str(N),'nodes.avi'));
%     v.FrameRate=5;
%     open(v);
end
count=0;

t=dt;

%load('current_state_21_11_03_16_57_47.mat') % resumes from a full-workspace snapshot saved during a flight (line ~968); the snapshot is not included in the repo, so the run starts from the beginning


%% Simulation Loop
% for t=dt:dt:2000

while t<6000
t=t+dt;
    
    if timeout>5
        break;
    end
    
    tic
    k=round(t/dt);

    objects_in_fig=[];
%     clc;
    %view(mod(round(k*4),360),30);
  
    
    % Communicate with other agents
    des_pos_bitdrones=zeros(N,n);
    for i=1:N
        if isempty(nodeVars(i).goalPos)
            des_pos_bitdrones(working_agents(i),:)=[0,0,0];
        else
           if nodeVars(i).state>=2 && nodeVars(i).state<=4
                des_pos_bitdrones(working_agents(i),:)=(nodeVars(i).goalPos+nodeVars(i).displacement)';
                if nodeVars(i).started ==0 
                    % This vehicle show be going to seed, circling or moving internally, but has not started yet in state 
                    nodeVars(i).started=1;
                    des_pos_bitdrones(working_agents(i),3)=-2; %starting on the C++ side
                end
                if nodeVars(i).started==1 && nodeVars(i).state==6
                    nodeVars(i).started=0;
                    des_pos_bitdrones(working_agents(i),3)=-1; %land command on the C++ side
                end
           else
                des_pos_bitdrones(working_agents(i),:)=nodeVars(i).goalPos';
           end
        end
    end
    
    disp('Sending messages:')
    bitdrones_server.send_message(des_pos_bitdrones);
    disp('-------------------')
    pause(0.2)
    disp('Receiving messages:')
    [pos_bitdrones,states]= bitdrones_server.receive_message();
    disp('-------------------')

    if isempty(pos_bitdrones)
        timeout=timeout+1;
    else
        timeout=0;
    end
    
    if ~isempty(states)
        w_a=1:length(states);
        i=length(states);
        while i>0
            if ~(states(i)==1 || states(i)==4 || states(i)>=10) 
                w_a(i)=[];
                pos_bitdrones(i,:)=[];
            end
            i=i-1;
        end
        working_agents=w_a;
    end
    
%     w_a=find(~all(pos_bitdrones == 0,2));
%     if ~isempty(w_a)
%         working_agents=w_a';
%     end
        
%     nonworking_agents=find(all(pos_bitdrones == 0,2));
%     while ~isempty(nonworking_agents)
%          row=nonworking_agents(1); 
%          pos_bitdrones(row,:)=[]; 
%          nonworking_agents=find(all(pos_bitdrones == 0,2));
%     end
             
             
    if size(pos_bitdrones,1) == N && size(pos_bitdrones,2)==n
       for i=1:N
           if nodeVars(i).state>=2 && nodeVars(i).state<=4
                x(1:n,i,k) = pos_bitdrones(i,:)'-nodeVars(i).displacement;
           else
               if k>1 && nodeVars(i).state == 6 && des_pos_bitdrones(working_agents(i),3)~=-1 
                   %if it is not the first time in the state 6, i will store my previous value
                   x(1:n,i,k)=x(1:n,i,k-1);
               else
                   x(1:n,i,k) = pos_bitdrones(i,:)';
               end
           end
       end
        
    elseif k>1
        x(1:n,:,k) = x(1:n,:,k-1); %didnt receive anything, replicating old position
    end
   % ---------------
    
    % Figure plot
    % ---------------
    for i=1:N
        switch nodeVars(i).state
%             case 1
%                 objects_in_fig=[objects_in_fig,Auxiliar.block3d(x(1,i,k),x(2,i,k),x(3,i,k),'yellow')];
%             case 2
%                 objects_in_fig=[objects_in_fig,Auxiliar.block3d(x(1,i,k),x(2,i,k),x(3,i,k),'red')];
%             case 3
%                 objects_in_fig=[objects_in_fig,Auxiliar.block3d(x(1,i,k),x(2,i,k),x(3,i,k),'magenta')];
%             case 4
%                 objects_in_fig=[objects_in_fig,Auxiliar.block3d(x(1,i,k),x(2,i,k),x(3,i,k),'blue')];
            case 5
                objects_in_fig=[objects_in_fig,Auxiliar.block3d(x(1,i,k),x(2,i,k),x(3,i,k),'green')];
            case 6
                objects_in_fig=[objects_in_fig,Auxiliar.block3d(x(1,i,k),x(2,i,k),x(3,i,k),'grey')];
        end
%         if nodeVars(i).state~=1; objects_in_fig=[objects_in_fig,text(x(1,i,k),x(2,i,k),x(3,i,k)+block_size/2+0.02, ...
%                                     sprintf('%.0f',nodeVars(i).gradient),'FontSize',8,'HorizontalAlignment','center')]; end
    end


    
    title(strcat('t=',num2str(k)), 'FontSize',15)
%     title(strcat('t=',num2str(t),'s'))
    actual_x=x(:,:,k);
    new_x=actual_x;
    states_with_delay=zeros(n*2,N);
    
    % ---- State Machine Simulation ------
    %this is parallelized
    all_u=actual_x(1:n,:)*0;
  
    for i=1:N
        posi = actual_x(1:n,i);
        veli = actual_x(n+1:n+n,i);
        u = veli*0;
        if nodeVars(i).state>=2 && nodeVars(i).state<=5 && ~isempty(states)
            if states(working_agents(i))<10 && des_pos_bitdrones(working_agents(i),3) ~= -2
                %I have an issue, should be flying but I am not (and I avoid entering here if I have just sent a command to fly)
                pause(1)
                nodeVars(i).state=1; %comming back to the deployment state
                nodeVars(i).started=0;
            end
        end
%         if nodeVars(i).state==3 || nodeVars(i).state==4 || nodeVars(i).state==5
%             fprintf("id[%d] - st[%d] - g[%d] - |Vi|[%d]",...
%                 nodeVars(i).id,...
%                 nodeVars(i).state,...
%                 nodeVars(i).gradient,...
%                 length(nodeVars(i).neighId));
%             if ~isempty(nodeVars(i).CEFRposition)
%                 fprintf("- CEFR { id[%d] - cP[%d] - pos[%.2f,%.2f,%.2f] - grad[%d] }",...
%                     nodeVars(i).CEFRid,...
%                     nodeVars(i).CEFRcirclingPos,...
%                     nodeVars(i).CEFRposition(1),nodeVars(i).CEFRposition(2),nodeVars(i).CEFRposition(3),...
%                     nodeVars(i).CEFRgradient);
%             end
%             fprintf("\n");
%             %hist_state=[hist_state,nodeVars(i).state];
%         end

        if nodeVars(i).state>=2 && nodeVars(i).state<=4
            fprintf("id[%d] - st[%d] - pos[%.2f,%.2f,%.2f] - seed[%.2f,%.2f,%.2f] - goal[%.2f,%.2f,%.2f]",...
                nodeVars(i).id,...
                nodeVars(i).state,...
                posi(1),posi(2),posi(3),...
                nodeVars(i).seedPos(1),nodeVars(i).seedPos(2),nodeVars(i).seedPos(3),...
                nodeVars(i).goalPos(1),nodeVars(i).goalPos(2),nodeVars(i).goalPos(3));
            fprintf("\n");
            %hist_state=[hist_state,nodeVars(i).state];
            objects_in_fig=[objects_in_fig,text(posi(1),posi(2),posi(3)+nodeVars(i).displacement(3)+block_size, ...
                    sprintf('dist=%.2fcm',norm(nodeVars(i).goalPos - posi,2)),'FontSize',10,'HorizontalAlignment','center')];
        end
        switch nodeVars(i).state
            case 1
                % ---- WAITING ---
                %this is where a node start looking for its neighbours
%                 for j=1:N
%                     %if A(i,j)~=0; disp([i,j]);end            
%                     if i~=j && A(i,j)~=0
%                         posj = actual_x(1:n,j);
%                         velj = actual_x(n+1:n+n,j);
%                         diff = posj-posi;
% 
%                         sigma_d = Auxiliar.sigma_norm(inter_agent_d);
%                         sigma_diff = Auxiliar.sigma_norm(diff);
%                         phi_alpha = Auxiliar.rho_h(sigma_diff/sigma_int_range)*Auxiliar.sigma_1(sigma_diff-sigma_d);
%                         nij= diff/sqrt(1+epslon*norm(diff,2)^2);
% 
%                         gain=1; 
%                         if norm(diff)<block_size*2
%                            gain=(0.05/sigma_diff); 
%                            disp([i,j,norm(diff,2),gain,phi_alpha,1/sqrt(1+epslon*norm(diff,2)^2)]); %this just avoids the node getting inside the obstacle
%                            gain=min(gain,10);
%                         end
% 
%                         u = u + gain*kp*phi_alpha*nij + kv*Auxiliar.rho_h(sigma_diff/sigma_int_range)*A(i,j)*(velj-veli);
%                         u(3)=0;
%                     end
%                 end
                
%                 %there is no pin for now, but there will be
%                 %Pinning controller - know the general objective
%                 if i==pin
%                     u = u + 1e-1*(des_pos_group-mean(states_with_delay(1:n,:),2)) + 1e0*(zeros(n,1)-mean(states_with_delay(n+1:n+n,:),2)); %Set group pos and take the realistic mean group there (with comm delay)
%         %             u = u + 1e-1*(WP(1:2,nextwp)-mean(states_with_delay(1:n,:),2)) + 1e0*(WP(3:4,nextwp)-mean(states_with_delay(n+1:n+n,:),2));%Iterate through waypoints and take the realistic mean group there (with comm delay)
%         %             u = u + 1e0*(WP(1:2,nextwp)-mean(x(1:n,:,k),2)) + 1e1*(WP(3:4,nextwp)-mean(x(n+1:n+n,:,k),2));%Iterate through waypoints and take the ideal mean group there (with comm delay)
%                 end


                % neighbour placed - if $\exists j \in V^i $ such that $j$ state is placed.
                if k >= 90*i-175 && nodeVars(i-1).state==6 %is it my turn to move to the seed?
                    %objects_in_fig = Auxiliar_SelfAssembly.plot_line_3d(objects_in_fig, posi, actual_x(1:3,landedNodeID), 'k', 1);
                    nodeVars(i).state=2; %goes to descent stage
                    nodeVars(i).goalPos=posi; %block_size*(Seed_S(1,:)'+[0;0;0.5]);%= actual_x(1:n,1)+[-1;-1;0]*block_size; %position of the landed node
                    nodeVars(i).seedPos=block_size*(Seed_S(1,:)'+[0;0;0.5]);%=actual_x(1:n,1);
                    nodeVars(i).CEFRposition=block_size*(Seed_S(1,:)'+[0;0;0.5]);%actual_x(1:n,1); %position of the landed node
                    nodeVars(i).CEFRid=1;
                    nodeVars(i).CEFRcirclingPos=1;
                else
                    nodeVars(i).goalPos=posi;
                end
                
                %u(3)= u(3) + kp*(1 - posi(3)) + kv*(-veli(3));
                
            case 2
                % ---- DESCEND ---- 
                %at this point, the goal position should be the s1 position
                %plot line
                to=[nodeVars(i).goalPos(1);nodeVars(i).goalPos(2);nodeVars(i).goalPos(3)+nodeVars(i).displacement(3)];
                objects_in_fig = Auxiliar_SelfAssembly.plot_line_3d(objects_in_fig, to, nodeVars(i).goalPos, 'k', 1.5);
                objects_in_fig=[objects_in_fig,surf(Xs+nodeVars(i).goalPos(1),Ys+nodeVars(i).goalPos(2),Zs+nodeVars(i).goalPos(3))];
                objects_in_fig=[objects_in_fig,Auxiliar.block3d(x(1,i,k),x(2,i,k),x(3,i,k)+nodeVars(i).displacement(3),'red')];

                % %compute control
                % u= kp*(nodeVars(i).goalPos - posi) + kv*(-veli); 
                % u=(0.01*randn+1)*u;% a little noise in the control just to avoid having ideal values in this stage. 
                
                %Communication
                %State Transition
                %approached placed block - if $|p_t(i) - p_t(j*)|<d*$. That means that the arriving block is close enough of a placed block. 
                count=count+1;
                min_d=1.4; %sqrt(3)*block_size*1.1;
                if norm((posi-nodeVars(i).seedPos),2)/block_size <= min_d
                    %I am close to the seed, 
                    layer=round((nodeVars(i).seedPos(3)/block_size)+0.5);
                    if comm_channel_seed(layer).OUT==0
                        %no message to me
                        if comm_channel_seed(layer).IN==0
                            comm_channel_seed(layer).IN=1;
                        else
                            %but I already sent something, no one in this channel, I am the seed.
                            nodeVars(i).counterNodesThisLayer=nodeVars(i).counterNodesThisLayer+1;
                            nodeVars(i).amIseed=true;
                            nodeVars(i).state=5; %goes to landing
                            nodeVars(i).goalPos=posi+nodeVars(i).displacement;
                            nodeVars(i).landingPos=nodeVars(i).seedPos;
                            comm_channel_seed(layer).IN=0;
                            comm_channel_seed(layer).OUT=0;
                        end
                    elseif comm_channel_seed(layer).OUT == -1 
                        %Comm from this seed just told me that this layer is done
                        nodeVars(i).goalPos=block_size*(Seed_S(layer+1,:)'+[0;0;0.5]);%=comm_channel_seed(layer).OUT+[-1;-1;0]*block_size;
                        nodeVars(i).seedPos=block_size*(Seed_S(layer+1,:)'+[0;0;0.5]);%=comm_channel_seed(layer).OUT;
                        nodeVars(i).CEFRposition=nodeVars(i).seedPos;
                        comm_channel_seed(layer).OUT=0; %emptying outcoming buffer
                    else
                        %There is something in the channel, circle here.
                        comm_channel_seed(layer).OUT=0; %emptying outcoming buffer
                        
                        nodeVars(i).state=3; %goes to edge following stage             
                        positions_aroundseed=[nodeVars(i).CEFRposition+circling(:,1),nodeVars(i).CEFRposition+circling(:,2),nodeVars(i).CEFRposition+circling(:,3),nodeVars(i).CEFRposition+circling(:,4)];
                        for iter=1:4
                            if sum(abs(positions_aroundseed(:,iter)-posi)) < block_size
                                break;
                            end
                        end
                        nodeVars(i).goalPos=nodeVars(i).CEFRposition+circling(:,iter);
                        nodeVars(i).CEFRcirclingPos=iter;
                        direction=1;
%                         if rand <0.5; direction=-1; else direction=1; end  
                    end
                end  
                
                %movement
                dist=round((posi-nodeVars(i).seedPos)/block_size);
                if  sum(abs(dist))>1 %1 means I am adjacent to a see %At least I need to go somewhere
                    if dist(3)==0
                        %MOVE.EXT() moving on external vertices
                        if norm(nodeVars(i).goalPos-posi)<block_size/2
                            %I can only do this if I have reached the
                            %last goal
                            destination=nodeVars(i).seedPos;
                            vect=(destination-posi);% vector pointing to desitnation
                            vect=vect/block_size; %vect in the grid

                            CIR =[
                                1    0   -1    0;
                                0   -1    0    1;
                                0    0    0    0 ];
                            seed_pos=round(destination/block_size-[0;0;0.5]);
                            my_pos_in_grid=(posi-nodeVars(i).displacement)/block_size - [0;0;0.5];
                            dist=9999;
                            go_to=[];
                            for iterator=1:4
                              candidate=seed_pos+CIR(:,iterator);
                               if norm(candidate - my_pos_in_grid,2)< dist && ~Auxiliar_SelfAssembly.check_position_inside_structure(block_size*(candidate+[0;0;0.5]),S,block_size)
                                  dist=norm(candidate - my_pos_in_grid,2);
                                  %objects_in_fig = Auxiliar_SelfAssembly.plot_line_3d(objects_in_fig, candidate*block_size, my_pos_in_grid*block_size, 'b', 1.5);
                                  go_to=candidate;
                               end
                            end

                            nodeVars(i).goalPos=(go_to+[0;0;0.5])*block_size;
                           
%                             nodeVars(i).axis_to_move=~nodeVars(i).axis_to_move;
%                             if nodeVars(i).axis_to_move
%                                 %try X                        
%                                 my_pos_in_grid=posi/block_size - [0;0;0.5];
%                                 next_pos_in_grid=round(my_pos_in_grid+[vect(1)/abs(vect(1));0;0]);
%                             else
%                                 %try Y
%                                 my_pos_in_grid=posi/block_size- [0;0;0.5];
%                                 next_pos_in_grid=round(my_pos_in_grid+[0;vect(2)/abs(vect(2));0]);
%                             end
%                             %is in the blueprint?
%                             %is it the seed?
%                             I = sum(Seed_S(:,1)==next_pos_in_grid(1) & Seed_S(:,2)==next_pos_in_grid(2) & Seed_S(:,3)==next_pos_in_grid(3) );
%                             if I==1
%                                 %Awesome, found the seed.
%                             else
%                                 %not the seed, is it in the grid at least
%                                 if Auxiliar_SelfAssembly.check_position_inside_structure(block_size*(next_pos_in_grid+[0;0;0.5]),S,block_size)
%                                     %It is in the grid but not the seed, dont go there
%                                 else
%                                     %not the seed, not in the grid, external, good, move here.
%                                    nodeVars(i).goalPos=(next_pos_in_grid+[0;0;0.5])*block_size;
%                                    if norm(nodeVars(i).goalPos-(posi+[0;0;block_size*vect(3)/abs(vect(3))]),2)>block_size/2; nodeVars(i).MOVE_count=nodeVars(i).MOVE_count+1;end
%                                 end
%                             end
                        end
                    else
                        %move on height
                        destination=nodeVars(i).seedPos;
                        vect=(destination-posi);
                        next_pos_in_grid=round([posi(1)/block_size; posi(2)/block_size; destination(3)/block_size-0.5]);

                        nodeVars(i).goalPos=(next_pos_in_grid+[0;0;0.5])*block_size;

                        if norm(actual_x(1:n,i)-nodeVars(i).goalPos,2)>block_size/2; nodeVars(i).MOVE_count=nodeVars(i).MOVE_count+1;end
                    end
                end
                
                vect=(nodeVars(i).goalPos-posi);
                objects_in_fig = [objects_in_fig,quiver3(posi(1),posi(2),posi(3)+nodeVars(i).displacement(3)+block_size*0.6,vect(1),vect(2),vect(3), 'LineWidth',1.5,'MaxHeadSize',0.9, 'Color', 'b')];
                        
                    
                if ~simulate_dynamics
                    actual_x(1:n,i)=nodeVars(i).goalPos;
                    actual_x(n+1:n+n,i)=[0;0;0];
                    u=u*0;
                end

            case 3
                % --- Edge following algorithm outside                
                %Plot the position to where I am going
                objects_in_fig=[objects_in_fig,surf(Xs+nodeVars(i).goalPos(1),Ys+nodeVars(i).goalPos(2),Zs+nodeVars(i).goalPos(3))];
                to=[nodeVars(i).goalPos(1);nodeVars(i).goalPos(2);nodeVars(i).goalPos(3)+nodeVars(i).displacement(3)];
                objects_in_fig = Auxiliar_SelfAssembly.plot_line_3d(objects_in_fig, nodeVars(i).goalPos, to, 'b', 1.5);
                %objects_in_fig = Auxiliar_SelfAssembly.plot_line_3d(objects_in_fig, nodeVars(i).goalPos, nodeVars(i).CEFRposition, 'b', 1.5);
                objects_in_fig=[objects_in_fig,Auxiliar.block3d(x(1,i,k),x(2,i,k),x(3,i,k)+nodeVars(i).displacement(3),'magenta')];

%                 u = 0.5*kp*(nodeVars(i).goalPos - posi) + kv*(-veli);
                
                i_am_inside_S=Auxiliar_SelfAssembly.check_position_inside_structure(posi,S,block_size);
                
                if norm((nodeVars(i).goalPos - posi),2)/block_size <= 0.25
                    [theta,rho] = cart2pol(posi(1)-actual_x(1,1),posi(2)-actual_x(2,1));
                    theta=rad2deg(wrapTo2Pi(theta));
                    %disp([ theta, nodeVars(i).initialAngle, abs(theta-nodeVars(i).initialAngle), round(theta/5)]);
                    %disp(round(rad2deg(wrapTo2Pi(theta))/5));
                    
                    %entered a valid position
                    if i_am_inside_S
                        nodeVars(i).state=4;
                        nodeVars(i).vel=[0;0];
%                     elseif abs(theta-nodeVars(i).initialAngle)<2 && is_first==0  && round(nodeVars(i).goalPos(n)/block_size-0.5)+1<=max(S(:,3)/block_size-0.5)
%                         %the circling is to guarantee that I have a node to go to.
%                         %just spin around    
%                             
%                         %get the closest position in the structure
%                         min_distance=9999;
%                         goal_pos=[0;0;0];
%                         for j=1:size(S,1)
%                             if round(S(j,3)/block_size-0.5)==round(nodeVars(i).goalPos(3)/block_size-0.5)+1
%                                 distance_to_this_pos=norm(S(j,:)'-nodeVars(i).goalPos,2);
%                                 if distance_to_this_pos<min_distance
%                                     min_distance=distance_to_this_pos;
%                                     goal_pos=S(j,:)';
%                                 end
%                             end
%                         end
%                         
%                         [free, id]=Auxiliar_SelfAssembly.check_position_free(goal_pos,actual_x);
%                         if ~free
%                             % There is a not here already
%                             nodeVars(i).onTOP=false;
%                             nodeVars(i).CEFRposition=goal_pos;
%                             idx_neighV=find(nodeVars(i).neighId==id); 
%                             nodeVars(i).CEFRgradient=nodeVars(i).neighGrad(idx_neighV(1));
%                             nodeVars(i).CEFRid=id;
%                             [goal_pos, circling_pos] = Auxiliar_SelfAssembly.get_closest_circling_pos(goal_pos, nodeVars(i).goalPos, circling);
%                         else
%                             %Empty position for me
%                             [~, id_down]=Auxiliar_SelfAssembly.check_position_free(goal_pos-[0;0;block_size],actual_x);
%                             nodeVars(i).CEFRposition=actual_x(1:n,id_down);
%                             nodeVars(i).CEFRid=id_down;
%                             idx_neighV=find(nodeVars(i).neighId==id_down); 
%                             nodeVars(i).CEFRgradient=nodeVars(i).neighGrad(idx_neighV(1));
%                         end
% 
%                         [theta,rho] = cart2pol(goal_pos(1)-actual_x(1,1),goal_pos(2)-actual_x(2,1));
%                         nodeVars(i).initialAngle=rad2deg(wrapTo2Pi(theta));
%                         nodeVars(i).goalPos=goal_pos;
%                         %nodeVars(i).CEFRcirclingPos=circling_pos;
%                                 
%                         is_first=1;
                    else
                        is_first=0;
                        
                        % --- computing the positions ---
                        %bottom up positions
                        %default is circling on the same layer
                        
                        surface_node=nodeVars(i).CEFRposition;
                        nextGoalPosition=nodeVars(i).CEFRposition+circling(:,Auxiliar_SelfAssembly.next_circling(nodeVars(i).CEFRcirclingPos,direction*1)); 
                                                
                        my_actual_position=nodeVars(i).goalPos;
                        nextCirclingPos=nodeVars(i).CEFRcirclingPos;
                            
                        [angle,~] = cart2pol(my_actual_position(1)-surface_node(1),my_actual_position(2)-surface_node(2));
                        %if I am not alligned with the position, keep moving
                        if abs(mod(angle,pi/2))<0.1
                            front_pos=nextGoalPosition+circling(:,nodeVars(i).CEFRcirclingPos); %pos 1
    %                         my_actual_position=nodeVars(i).goalPos;
    %                         nextCirclingPos = Auxiliar_SelfAssembly.next_circling(nodeVars(i).CEFRcirclingPos,direction*1);
    %                         circling_same_layer=my_actual_position+circling(:,nextCirclingPos);  %pos 2
    %                         front_pos=my_actual_position+circling(:,Auxiliar_SelfAssembly.next_circling(nextCirclingPos,direction*1)); %pos 1
                            % --------------------------------

%                             % --- plotting in order ---
%                             objects_in_fig = Auxiliar_SelfAssembly.plot_line_3d(objects_in_fig, my_actual_position+[0;0;block_size], nextGoalPosition, 'g', 1);
%                             objects_in_fig = Auxiliar_SelfAssembly.plot_line_3d(objects_in_fig, my_actual_position+[0;0;block_size], surface_node, 'r', 1);
%                             objects_in_fig = Auxiliar_SelfAssembly.plot_line_3d(objects_in_fig, my_actual_position+[0;0;block_size], front_pos, 'k', 1);
%                             % ----------------------

                            positions_to_test=[surface_node,front_pos];
                            is_pos_free=false(1,size(positions_to_test,2));
                            id_node=ones(1,size(positions_to_test,2))*-1;
                            is_pos_inside=false(1,size(positions_to_test,2));

                            % --- finding positions free --- 
                            for j=1:size(positions_to_test,2)
                                [is_pos_free(j),id_node(j)]=Auxiliar_SelfAssembly.check_position_free(positions_to_test(:,j),actual_x);
                            end
                            % ------------------------------

                            % --- looking where is inside --- 
                            for j=1:size(positions_to_test,2)
                                is_pos_inside(j)=Auxiliar_SelfAssembly.check_position_inside_structure(positions_to_test(:,j),S,block_size);
                            end
                            % ---------------------------

                            % --- finding all grads --- 
                            grads=ones(1,size(positions_to_test,2))*9999;
                            for j=1:size(positions_to_test,2)
                                  grads(j)=Auxiliar_SelfAssembly.compute_gradient_MD(positions_to_test(:,j),block_size);
    %                            grads(j) = Auxiliar_SelfAssembly.compute_gradient_Energy(positions_to_test(:,j), block_size, actual_x, nodeVars(i).neighGrad, nodeVars(i).neighId);
                            end

    %                         CEG=Auxiliar_SelfAssembly.compute_gradient_MD(my_actual_position,block_size);%current expcted grad
    %                         delta_function=grads-CEG;
    %                         %this is the code for MOMENTUM                        
    % %                         grads(1) = grads(1)-nodeVars(i).vel(2);
    % %                         grads(2) = grads(2)-nodeVars(i).vel(2);
    % % %                         grads(4) = grads(4)-nodeVars(i).vel(1)*0.7-nodeVars(i).vel(2)*0.7; %horizontal and vertical channel
    %                         [gradssorted,I] = sort(grads);
                            % -------------------------

                            for j=1:length(is_pos_free)
                                switch j
                                    case 1
                                        if is_pos_free(j) 
                                            %move here
                                            nextGoalPosition=surface_node;
                                            nextCirclingPos = Auxiliar_SelfAssembly.next_circling(nodeVars(i).CEFRcirclingPos,direction*1);
                                            break;
                                        end 
                                    case 2
                                        if is_pos_free(j) && Auxiliar_SelfAssembly.check_position_inside_structure(nextGoalPosition,S,block_size) 
                                            %move one to the side
                                            %nodeVars(i).CEFRgradient=grad_side_node;
                                            nodeVars(i).CEFRposition=nextGoalPosition;
                                            nextGoalPosition=front_pos;
                                            %nodeVars(i).vel(1)=mu*nodeVars(i).vel(1) - eps*delta_function(1);
                                            break;
                                        elseif is_pos_free(j) 
                                            % I have to to around a block
                                            nextGoalPosition=front_pos;
                                        else
                                            %this is a corner
                                            nextGoalPosition=nodeVars(i).goalPos; % stay in the same place
                                            nodeVars(i).CEFRposition=front_pos;
                                            nextCirclingPos = Auxiliar_SelfAssembly.next_circling(nodeVars(i).CEFRcirclingPos,direction*(-1));
                                            %objects_in_fig = Auxiliar_SelfAssembly.plot_line_3d(objects_in_fig, my_actual_position+[0;0;block_size], nodeVars(i).CEFRposition, 'b', 1);
                                            %objects_in_fig = Auxiliar_SelfAssembly.plot_line_3d(objects_in_fig, my_actual_position+[0;0;block_size], nodeVars(i).CEFRposition+circling(:,Auxiliar_SelfAssembly.next_circling(nextCirclingPos,direction*1)), 'm', 1);
                                            break;
                                        end
                                end
                            end
                        else
                            nextCirclingPos = Auxiliar_SelfAssembly.next_circling(nodeVars(i).CEFRcirclingPos,direction*1);
                        end
                        nodeVars(i).goalPos=nextGoalPosition;
                        nodeVars(i).CEFRcirclingPos=nextCirclingPos;
                    end
                end
                
                vect=(nodeVars(i).goalPos-posi);
                objects_in_fig = [objects_in_fig,quiver3(posi(1),posi(2),posi(3)+nodeVars(i).displacement(3)+block_size*0.6,vect(1),vect(2),vect(3), 'LineWidth',1.5,'MaxHeadSize',0.9, 'Color', 'b')];
                        
                if ~simulate_dynamics
                    if norm(actual_x(1:n,i)-nodeVars(i).goalPos,2)>block_size/2; nodeVars(i).MOVE_count=nodeVars(i).MOVE_count+1;end
                    actual_x(1:n,i)=nodeVars(i).goalPos;
                    actual_x(n+1:n+n,i)=[0;0;0];
                    u=u*0;
                end
                
            case 4
                % --- Edge following inside
                %Plot the position to where I am going  
                objects_in_fig=[objects_in_fig,surf(Xs+nodeVars(i).goalPos(1),Ys+nodeVars(i).goalPos(2),Zs+nodeVars(i).goalPos(3))];
                to=[nodeVars(i).goalPos(1);nodeVars(i).goalPos(2);nodeVars(i).goalPos(3)+nodeVars(i).displacement(3)];
                objects_in_fig = Auxiliar_SelfAssembly.plot_line_3d(objects_in_fig, nodeVars(i).goalPos, to, 'b', 1.5);
                %objects_in_fig = Auxiliar_SelfAssembly.plot_line_3d(objects_in_fig, nodeVars(i).goalPos, nodeVars(i).CEFRposition, 'b', 1.5);
                objects_in_fig=[objects_in_fig,Auxiliar.block3d(x(1,i,k),x(2,i,k),x(3,i,k)+nodeVars(i).displacement(3),'blue')];
                
%                 u = 0.5*kp*(nodeVars(i).goalPos - posi) + kv*(-veli);
                if norm((nodeVars(i).goalPos - posi),2)/block_size <= 0.25 %entered a valid position
                    
                    %nodeVars(i).circlingPos is the position the clock that I am right now                
                    %now I have to compute if the next position is available
                    % actualGoalPosition=nodeVars(i).goalPos; %should be the same as posi
                    % disp(norm(posi-actualGoalPosition,2));
                    
                        % --- computing the positions ---
                        %bottom up positions
                        %default is circling on the same layer
                    
                        %nextCirclingPos = Auxiliar_SelfAssembly.next_circling (nodeVars(i).CEFRcirclingPos,direction*1);
                        %nextGoalPosition=nodeVars(i).CEFRposition+circling(:,nextCirclingPos); 
                        my_actual_position=nodeVars(i).goalPos;
                        
                        my_actual_position_east =my_actual_position +circling(:,1);
                        my_actual_position_south =my_actual_position +circling(:,2);
                        my_actual_position_west =my_actual_position +circling(:,3);
                        my_actual_position_north =my_actual_position +circling(:,4);
                        
                        % --------------------------------
                        
                        % --- plotting in order ---
                        objects_in_fig = Auxiliar_SelfAssembly.plot_line_3d(objects_in_fig, nodeVars(i).goalPos, my_actual_position_east, 'b', 1);
                        objects_in_fig = Auxiliar_SelfAssembly.plot_line_3d(objects_in_fig, nodeVars(i).goalPos, my_actual_position_south, 'b', 1);
                        objects_in_fig = Auxiliar_SelfAssembly.plot_line_3d(objects_in_fig, nodeVars(i).goalPos, my_actual_position_west, 'b', 1);
                        objects_in_fig = Auxiliar_SelfAssembly.plot_line_3d(objects_in_fig, nodeVars(i).goalPos, my_actual_position_north, 'b', 1);
                        % ----------------------
                        
                        positions_to_test=[my_actual_position_east,my_actual_position_south,my_actual_position_west,my_actual_position_north];
                        
                        is_pos_free=false(1,size(positions_to_test,2));
                        id_node=ones(1,size(positions_to_test,2))*-1;
                        is_pos_inside=false(1,size(positions_to_test,2));
                        
                        % --- finding positions free --- 
                        for j=1:size(positions_to_test,2)
                            [is_pos_free(j),id_node(j)]=Auxiliar_SelfAssembly.check_position_free(positions_to_test(:,j),actual_x);
                        end
                        % ------------------------------
                        
                        % --- looking where is inside --- 
                        for j=1:size(positions_to_test,2)
                            is_pos_inside(j)=Auxiliar_SelfAssembly.check_position_inside_structure(positions_to_test(:,j),S,block_size);
                        end
                        % ---------------------------
                        
                        % --- finding all grads --- 
                        CEG=Auxiliar_SelfAssembly.compute_gradient_layer_MD(my_actual_position,block_size,nodeVars(i).seedPos);%current expcted grad
                        grads=ones(1,size(positions_to_test,2))*9999;
                        for j=1:size(positions_to_test,2)
                             grads(j)=Auxiliar_SelfAssembly.compute_gradient_layer_MD(positions_to_test(:,j),block_size,nodeVars(i).seedPos);
                             if  ~is_pos_inside(j) || ~is_pos_free(j) || grads(j)>=CEG %remove the last bit for momentum
                                 grads(j)=grads(j)+1001;% higher grad, should not want this guy
                             end
                        end

%                         CEG=nodeVars(i).CEFRgradient;
%                         grads=ones(1,size(positions_to_test,2))*9999;
%                         for j=1:size(positions_to_test,2)
%                             grads(j) = Auxiliar_SelfAssembly.compute_gradient_Energy(positions_to_test(:,j), block_size, actual_x, nodeVars(i).neighGrad, nodeVars(i).neighId);
%                              if  ~is_pos_inside(j) || grads(j)>CEG %remove the last bit for momentum
%                                  grads(j)=grads(j)+1000;% higher grad, should not want this guy
%                              end
%                         end

%                         if ~is_pos_free(3)
%                             %this is a corner
%                             idx_neighV=find(nodeVars(i).neighId==id_node(3)); 
%                             grads(3)=nodeVars(i).neighGrad(idx_neighV(1));
%                         end

                        delta_function=grads-CEG;
%                         disp(nodeVars(i).vel)
%                         disp(delta_function)

                        [gradssorted,I] = sort(grads);
                        % -------------------------
                        if gradssorted(1)<=CEG && gradssorted(1)<1000
                            for j=1:length(I)
                                if gradssorted(j)>1000
                                    %I am already searching things that I should not, stop.
                                    nodeVars(i).state=5;
                                    nodeVars(i).goalPos=posi+nodeVars(i).displacement;
                                    nodeVars(i).landingPos=(round((posi/block_size)-[0;0;0.5])+[0;0;0.5])*block_size;
                                    break;
                                end
                                nextGoalPosition=positions_to_test(:,I(j));
                                nodeVars(i).goalPos=nextGoalPosition;
                                objects_in_fig = Auxiliar_SelfAssembly.plot_line_3d(objects_in_fig, posi, nextGoalPosition, 'b', 1.5);
                                nodeVars(i).vel(2)=mu*nodeVars(i).vel(2) - eps*delta_function(1);
                                break;
                            end
                            if  nodeVars(i).state~=5
                                    %I am already searching things that I should not, stop.
                                nodeVars(i).goalPos=nextGoalPosition;
                                nodeVars(i).CEFRcirclingPos=nextCirclingPos;
                            end
                        else
                            nodeVars(i).state=5; %since I already changed the state I have to add the displacement
                            nodeVars(i).goalPos=posi+nodeVars(i).displacement;
                            nodeVars(i).landingPos=(round((posi/block_size)-[0;0;0.5])+[0;0;0.5])*block_size;
                        end 
                end
                
                                
                vect=(nodeVars(i).goalPos-posi);
                objects_in_fig = [objects_in_fig,quiver3(posi(1),posi(2),posi(3)+nodeVars(i).displacement(3)+block_size*0.6,vect(1),vect(2),vect(3), 'LineWidth',1.5,'MaxHeadSize',0.9, 'Color', 'b')];
                      
                
                if ~simulate_dynamics    
                    if norm(actual_x(1:n,i)-(nodeVars(i).goalPos),2)>block_size/2; nodeVars(i).MOVE_count=nodeVars(i).MOVE_count+1; end
                
                    actual_x(1:n,i)=nodeVars(i).goalPos;
                    actual_x(n+1:n+n,i)=[0;0;0];
                    u=u*0;
                end
                
            case 5
                %landing state
%                 from=nodeVars(i).goalPos.*[1;1;0];
% % % %                 objects_in_fig = Auxiliar_SelfAssembly.plot_line_3d(objects_in_fig, from, nodeVars(i).goalPos, 'g', 1.5); 
%                 [free, id]=Auxiliar_SelfAssembly.check_position_free(nodeVars(i).goalPos,actual_x);
%                 if ~free
%                     %first occurence
%                     actual_x2=actual_x;
%                     actual_x2(:,id)=[];
%                     [free, id]=Auxiliar_SelfAssembly.check_position_free(nodeVars(i).goalPos,actual_x2);
%                     if ~free
%                         %second block on the same position, something wrong
%                         pause(0.1)
%                     end
%                 end
%                 
                       
                        
%                 %check if I can land in a lower height
%                 [is_down_free, id_down]=Auxiliar_SelfAssembly.check_position_free(nodeVars(i).goalPos-[0;0;block_size],actual_x);
%                 if is_down_free
%                     %bad sign, below is empty
%                     if Auxiliar_SelfAssembly.check_position_inside_structure(nodeVars(i).goalPos-[0;0;block_size],S)
%                         nodeVars(i).goalPos=nodeVars(i).goalPos-[0;0;block_size];
%                     end
%                 end
                
                %here goal(3) has the height of the structure in real-world
                %+ displacement manually added
                %here posi(3) has the real height of the vehicle (i dont
                %discount the displacement)
%                 level=round((nodeVars(i).goalPos(3)/block_size)-0.5);
%                 nodeVars(i).goalPos(3)=(level+0.5)*block_size;
                
                
                my_goal_position=nodeVars(i).landingPos;
                position_east =my_goal_position +circling(:,1);
                position_south =my_goal_position +circling(:,2);
                position_west =my_goal_position +circling(:,3);
                position_north =my_goal_position +circling(:,4);
                positions_to_test=[position_east,position_south,position_west,position_north];
                is_pos_free=false(1,size(positions_to_test,2));
                id_node=ones(1,size(positions_to_test,2))*-1;
                % --- finding positions free --- 
                for j=1:size(positions_to_test,2)
                    [is_pos_free(j),id_node(j)]=Auxiliar_SelfAssembly.check_position_free(positions_to_test(:,j),actual_x);
                    positions_to_test(:,j)=positions_to_test(:,j)-my_goal_position;
                    if ~is_pos_free(j)
                        positions_to_test(:,j)=positions_to_test(:,j)*0;
                    end
                end
                % ------------------------------

%                 relative_height = abs(nodeVars(i).goalPos(3) - posi(3))/block_size; %difference in height
%                 if relative_height > 1; relative_height=1;end
%                 if relative_height<0.001; relative_height=0.001;end
                approaching_pos = my_goal_position + sum(positions_to_test,2)*2+ nodeVars(i).displacement;
                nodeVars(i).goalPos  =  approaching_pos * nodeVars(i).relativeHeight + my_goal_position * (1-nodeVars(i).relativeHeight);           
               
                dist_to_goal=norm((nodeVars(i).goalPos - posi),2)/block_size;
                
                if dist_to_goal <= 0.2 %arrived at the destination
                    nodeVars(i).relativeHeight=nodeVars(i).relativeHeight-0.25;
                    if nodeVars(i).relativeHeight > 1 ; nodeVars(i).relativeHeight = 1 ; end
                    if nodeVars(i).relativeHeight < 0 ; nodeVars(i).relativeHeight = 0 ; end
                end
                
                    
                %rouding to block height
                %nodeVars(i).goalPos(3)=(round((nodeVars(i).goalPos(3)/block_size)-0.5)+0.5)*block_size;
                u = 0.5*kp*(nodeVars(i).goalPos - posi) + kv*(-veli);

                if norm((nodeVars(i).landingPos - posi),2)/block_size <= 0.25 %arrived at the destination
                    nodeVars(i).state=6;
                    % Auxiliar.block3d(actual_x(1,i),actual_x(2,i),actual_x(3,i),'grey');
                    % surf(Xs+nodeVars(i).goalPos(1),Ys+nodeVars(i).goalPos(2),Zs+nodeVars(i).goalPos(3)+0.75);
                    count=0;
                    posi=nodeVars(i).landingPos;
                    actual_x(1:n,i)=nodeVars(i).landingPos;
                    save(strcat('current_state_',date_now,'.mat')) %every time a block is placed, I save
                end
                                                
                vect=(nodeVars(i).goalPos-posi);
                objects_in_fig = [objects_in_fig,quiver3(posi(1),posi(2),posi(3)+block_size*0.6,vect(1),vect(2),vect(3), 'LineWidth',1.5,'MaxHeadSize',0.9, 'Color', 'b')];
                objects_in_fig=Auxiliar_SelfAssembly.plot_line_3d(objects_in_fig,approaching_pos,nodeVars(i).landingPos,'k',1.5);
                objects_in_fig=[objects_in_fig,text(posi(1),posi(2),posi(3)+block_size, ...
                    sprintf('dist=%.2fcm',norm(nodeVars(i).goalPos - posi,2)),'FontSize',10,'HorizontalAlignment','center')];
                
                midline = (approaching_pos+nodeVars(i).landingPos)/2;
                objects_in_fig=[objects_in_fig,text(midline(1),midline(2),midline(3), ...
                    sprintf('land=%d%%',nodeVars(i).relativeHeight*100),'FontSize',10,'HorizontalAlignment','center')];
                
                if ~simulate_dynamics
                    if norm(actual_x(1:n,i)-nodeVars(i).goalPos,2)>block_size/2; nodeVars(i).MOVE_count=nodeVars(i).MOVE_count+1;end
                    actual_x(1:n,i)=nodeVars(i).goalPos;
                    actual_x(n+1:n+n,i)=[0;0;0];
                    u=u*0;
                end
                
            case 6
                % --- Placed 
                %update your own gradient
%                 nodeVars(i).gradient=min(nodeVars(i).neighGrad)+1;
%                 if nodeVars(i).val==1 && i~=1
%                     pause(0.1)
%                 end
                
                if nodeVars(i).amIseed
                    layer=round((posi(3)/block_size)+0.5);
                    if comm_channel_seed(layer).IN == 1
                        %new node arrive
                        layer_size=0;
                        for iter =1:size(S,1)
                            if abs(S(iter,3) - posi(3)) < block_size/2
                                layer_size=layer_size+1;
                            end
                        end
                        if nodeVars(i).counterNodesThisLayer >= layer_size
                            %this layer is done, you should go up
%                             closest_vertex_up=[];
%                             dist=999;
%                             for j=1:size(S,1)
%                                 if round(S(j,3)/block_size) == round(posi(3)/block_size)+1 %next layer
%                                     if norm (S(j,:)-[posi(1),posi(2),posi(3)]) < dist
%                                        dist=norm(S(j,:)-[posi(1),posi(2),posi(3)]);
%                                        closest_vertex_up=S(j,:)';
%                                     end
%                                 end
%                             end
%                             comm_channel_seed(layer).OUT=closest_vertex_up;
                            comm_channel_seed(layer).OUT=-1; % do not circle this layer
                        else  
%                             comm_channel_seed(layer).OUT=[1,0,0;0,1,0;0,0,1];
                            comm_channel_seed(layer).OUT=1;
                            nodeVars(i).counterNodesThisLayer=nodeVars(i).counterNodesThisLayer+1;
                        end
                        comm_channel_seed(layer).IN=0; %emptying incoming buffer
                    else
                        comm_channel_seed(layer).OUT=0; %Send 0 out, meaning that there is nothing
                    end
                else
                    nodeVars(i).goalPos=posi;
                    %nodeVars(i).gradient=Auxiliar_SelfAssembly.compute_gradient_layer_MD(posi,block_size,nodeVars(i).seedPos) ;
                end
                
                %this part is for using MD
%                 if i==1
%                     nodeVars(i).gradient=0;
                    %nodeVars(i).val=1;
%                 else
%                     nodeVars(i).gradient=Auxiliar_SelfAssembly.compute_gradient_layer_MD(posi,block_size,nodeVars(i).seedPos) ;
%                 end
                
                %using energy
%                 if seeking_lowenergy
%                     nodeVars(i).gradient=nodeVars(i).val;
%                 else
%                     nodeVars(i).gradient=1/nodeVars(i).val;
%                 end
%                 u = 0.9*([0;0;0]-veli);

                
%                 objects_in_fig=[objects_in_fig,text(...
%                     x(1,i,k)-0.01,x(2,i,k),x(3,i,k)+block_size/2+0.01, ...
%                     sprintf('%.0f',nodeVars(i).val*100),'color',[nodeVars(i).val,0,(1-nodeVars(i).val)],'FontSize',14,'HorizontalAlignment','center')];
%                 objects_in_fig=[objects_in_fig,text(...
%                     x(1,i,k)-0.01,x(2,i,k),x(3,i,k)+block_size/2+0.01, ...
%                     sprintf('%.0f',nodeVars(i).gradient*100),'color',[nodeVars(i).gradient,0,(1-nodeVars(i).gradient)],'HorizontalAlignment','center')];
%                 objects_in_fig=[objects_in_fig,text(...
%                     x(1,i,k),x(2,i,k),x(3,i,k)+block_size/2+0.02, ...
%                     sprintf('%.1f',nodeVars(i).gradient),'FontSize',8,'HorizontalAlignment','center')];
                
%                 nodeVars(i).val = nodeVars(i).val + dt*sum(nodeVars(i).neighVal-nodeVars(i).val); %vdot = sum aij (vj-vi)
%                 nodeVars(i).val = min(max(nodeVars(i).val,0),1);

        end
        all_u(:,i)=u;
    end        
    
%     for i=1:N
% %         new_x(:,i) = [posi + dt*veli + ((dt^2)/2)*u; veli + dt*u];
%         new_x(:,i) = [actual_x(1:n,i) + dt*actual_x(n+1:n+n,i) + ((dt^2)/2)*all_u(:,i); actual_x(n+1:n+n,i) + dt*all_u(:,i);];
%         if norm(new_x(n+1:n+n,i),2) > 1
%             %saturate the vel
%             new_x(n+1:n+n,i) = new_x(n+1:n+n,i)/norm(new_x(n+1:n+n,i),2);
%         end
%     end
%     x(:,:,k+1)=new_x;

   
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

if record_video==1
%     close(v);
%     pause(1);
%     command = sprintf('ffmpeg -i %s -vf "pad=ceil(iw/2)*2:ceil(ih/2)*2" -vcodec libx264 -acodec aac %s && rm %s ', v.Filename,strcat('SelfAssembly_',num2str(N),'nodes.mp4') ,v.Filename);
%     system(command);
end

% figure(2)
% hold on
% grid on
% for node=1:N
%     subplot(3,ceil(N/3),node); hold on; grid on;
%     x_node=zeros(k,0);y_node=zeros(k,0);
%     for i=1:k; x_node(i)=x(1,node,i); end; plot(x_node)
%     for i=1:k; y_node(i)=x(2,node,i); end; plot(y_node)
%     title(strcat('Node ',num2str(node)));
%     axis tight
%     hold off
% end

