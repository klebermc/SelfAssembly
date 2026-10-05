% Description
% This simulation aims to study network control strategies applied to
% assembly.
% Here, different subgroups of the network will apply different assembly
% rules to create compound parts.
% Simulating state of nodes 

%clear

%% 3D - N nodes
N=98;                % Nodes in the network, cardinallity of vertex set
n=3;                % Variables of the state of each node
Gamma=[1 0; 0 1];   % Inter state relationship matrix
A=ones(N,N)-eye(N);

A_deg=A;       % Ajacency Matrix version with degree
for i=1:size(A,1); A_deg(i,i) = -sum(A(i,:)); end
x=zeros(n*2,N);
x(:,1)=[0;0;1;0;0;0];
for i=2:N 
%     [newx,newy]= pol2cart(rand*2*pi,abs(rand*0.2+0.05));
%     newx=min(max(newx,-1),-0.2);
%     newy=min(max(newy,-1),-0.2);
%     x(:,i)=[newx+x(1,i-1);newy+x(2,i-1);1;0;0;0];
    [newx,newy]= pol2cart(rand*2*pi,1.5);
x(:,i)=[newx;newy;1;0;0;0];  
end
G = graph(A);
hops_graph=distances(G);

%% WP50 navigation of the ensemble
WP = [1;1;0;0];
for j=2:5; WP(:,j) = WP(:,j-1)+[1;1;0;0]; end
nextwp=1;

%% Gain matrix
kp=0.1; kv=sqrt(2*kp);
C=[ kp kv; 3 2*sqrt(3); 1 2*sqrt(1); 1 2*sqrt(1)];

%% Compound part description
block_size=0.13;
compound_part=[0,0;0,1;0,2;]';
compound_part=compound_part*block_size;
is_compound_part=zeros(N);


%% Initializing figure
close all
% figure('units','normalized','outerposition',[0 0 0.3750 0.75])
figure('units','normalized','outerposition',[0.43 0.25 0.28 0.98])
% figure('units','normalized','outerposition',[1.0 0.25 0.65 1.4])
% figure('units','normalized','outerposition',[1.0 0.25 1 1])
record_video=0;
% view(135,30);
view(-30,30);

grid on;
axis([-0.5 1.5 -.9 1.5 0 2])
%axis equal
% axis ([min(x(1,:))-1 max(x(1,:))+1 min(x(2,:))-1 max(x(2,:))+1 0 2])
hold on
xlabel('X [m]')
ylabel('Y [m]')
zlabel('Z [m]')
drawnow
pause(0.5)


%% Structure
%ground level rectangle
% S=[ 0,0,0.5;    1,0,0.5;   0,1,0.5;    1,1,0.5;    0,2,0.5;    1,2,0.5;     0,3,0.5;    1,3,0.5; ]*block_size;

%ground level with one up side
% S=[ 0,0,0.5;    1,0,0.5;   0,1,0.5;    1,1,0.5;    0,2,0.5;    1,2,0.5;     0,0,1.5;    1,0,1.5; ]*block_size;

%ground level with one up side
% S=[ 0,0,0.5;    1,0,0.5;   0,1,0.5;    1,1,0.5;    0,2,0.5;    1,2,0.5;     0,1,1.5;    1,1,1.5; ]*block_size;

%two up
%S=[ 0,0,0.5;    1,0,0.5;   0,1,0.5;    1,1,0.5;    0,0,1.5;    1,0,1.5;     0,0,2.5;    1,0,2.5; ]*block_size;

% Stairs
% S=[ 	0,0,0.5;    	1,0,0.5;	2,0,0.5;	3,0,0.5;	0,0,1.5;	1,0,1.5;	2,0,1.5;   	0,0,2.5;    	1,0,2.5;	0,0,3.5;    ]*block_size;

% %big pyramid
% S=[ 	
% 0,0,0.5;	1,0,0.5;	2,0,0.5;	3,0,0.5;	4,0,0.5;
% 0,1,0.5;	1,1,0.5;	2,1,0.5;	3,1,0.5;	4,1,0.5;
% 0,2,0.5;    1,2,0.5;	2,2,0.5;	3,2,0.5;	4,2,0.5;
% 0,3,0.5;	1,3,0.5;	2,3,0.5;	3,3,0.5;	4,3,0.5;
% 0,4,0.5;	1,4,0.5;	2,4,0.5;	3,4,0.5;	4,4,0.5;
% 1,1,1.5;	2,1,1.5;	3,1,1.5;
% 1,2,1.5;	2,2,1.5;	3,2,1.5;
% 1,3,1.5;	2,3,1.5;	3,3,1.5;
% 0,2,1.5;
% 0,2,2.5;    1,2,2.5;    2,2,2.5;    ]*block_size;

% S=[ 	
% 0,0,0.5;	1,0,0.5;	2,0,0.5;	3,0,0.5;	4,0,0.5;
% 0,1,0.5;	1,1,0.5;	2,1,0.5;	3,1,0.5;	4,1,0.5;
% 0,2,0.5;    1,2,0.5;	2,2,0.5;	3,2,0.5;	4,2,0.5;
% 0,3,0.5;	1,3,0.5;	2,3,0.5;	3,3,0.5;	4,3,0.5;
% 0,4,0.5;	1,4,0.5;	2,4,0.5;	3,4,0.5;	4,4,0.5;
% 
% 1,1,1.5;	2,1,1.5;	3,1,1.5;
% 1,2,1.5;	2,2,1.5;	3,2,1.5;
% 1,3,1.5;	2,3,1.5;	3,3,1.5;
% 
% 0,2,1.5;                            4,2,1.5;
% 
% 0,2,2.5;    1,2,2.5;    2,2,2.5;    3,2,2.5;    4,2,2.5;]*block_size;


% a bench
S=[ 	
0,0,0.5;	1,0,0.5;	2,0,0.5;	3,0,0.5;	4,0,0.5;
0,1,0.5;	1,1,0.5;	2,1,0.5;	3,1,0.5;	4,1,0.5;
0,2,0.5;    1,2,0.5;	2,2,0.5;	3,2,0.5;	4,2,0.5;
0,3,0.5;	1,3,0.5;	2,3,0.5;	3,3,0.5;	4,3,0.5;
0,4,0.5;	1,4,0.5;	2,4,0.5;	3,4,0.5;	4,4,0.5;

0,0,1.5;	1,0,1.5;	2,0,1.5;	3,0,1.5;    4,0,1.5;	
0,1,1.5;	1,1,1.5;	2,1,1.5;	3,1,1.5;	4,1,1.5;
0,2,1.5;    1,2,1.5;	2,2,1.5;	3,2,1.5;	4,2,1.5;
0,3,1.5;	1,3,1.5;	2,3,1.5;	3,3,1.5;	4,3,1.5;
	

0,0,2.5;	1,0,2.5;	2,0,2.5;	3,0,2.5;	4,0,2.5;
0,1,2.5;	1,1,2.5;	2,1,2.5;	3,1,2.5;	4,1,2.5;
0,2,2.5;    1,2,2.5;	2,2,2.5;	3,2,2.5;	4,2,2.5;
0,3,2.5;	1,3,2.5;	2,3,2.5;	3,3,2.5;	4,3,2.5;

0,0,3.5;	1,0,3.5;	2,0,3.5;    3,0,3.5;    4,0,3.5;	
0,1,3.5;                                        4,1,3.5;	
0,2,3.5;                                        4,2,3.5;	
0,3,3.5;                                        4,3,3.5;	
	

0,0,4.5;	1,0,4.5;	2,0,4.5;    3,0,4.5;    4,0,4.5;	
0,1,4.5;                                        4,1,4.5;	
0,2,4.5;                                        4,2,4.5;	
0,3,4.5;                                        4,3,4.5;	


0,0,5.5;	1,0,5.5;	2,0,5.5;    3,0,5.5;    4,0,5.5;	
0,1,5.5;                                        4,1,5.5;	
0,2,5.5;                                        4,2,5.5;	
0,3,5.5;                                        4,3,5.5;	

]*block_size;

%Plotting structure
for j=1:size(S,1)
    sx=S(j,1);sy=S(j,2);sz=S(j,3)-block_size/2;
    plot3([sx-block_size/2 sx+block_size/2],[sy-block_size/2 sy-block_size/2],[sz sz],'r', 'linewidth',1);
    plot3([sx-block_size/2 sx+block_size/2],[sy+block_size/2 sy+block_size/2],[sz sz],'r', 'linewidth',1);
    plot3([sx-block_size/2 sx-block_size/2],[sy-block_size/2 sy+block_size/2],[sz sz],'r', 'linewidth',1);
    plot3([sx+block_size/2 sx+block_size/2],[sy-block_size/2 sy+block_size/2],[sz sz],'r', 'linewidth',1);
end

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
    if i==1
        nodeVars(i).state=3;
        nodeVars(i).goalPos=[0;0;block_size/2];
        nodeVars(i).gradient=0;
    end
    nodeVars(i).displacement=[0;0;0];
    nodeVars(i).layer=0;
    nodeVars(i).possible_upper_CEFR.pos=[];
    nodeVars(i).possible_upper_CEFR.grad=999;
    nodeVars(i).possible_upper_CEFR.id=0;
    nodeVars(i).possible_upper_CEFR.circling=0;
    nodeVars(i).initialAngle=0;
    nodeVars(i).vel=0;
    nodeVars(i).past_grad=0;
end

%% momentum gains
mu=0.5;
eps=0.5;

%% Flocking simulation
epslon = 0.5;
inter_agent_d=1;
sigma_d = Auxiliar.sigma_norm(inter_agent_d);
int_range_r = 15;
sigma_int_range = Auxiliar.sigma_norm(int_range_r);

%% Generic simulation variables
dt=0.1;
objects_in_fig=[];
variables=[];
now=0;
pin=4;                      
circling=[[ block_size; 0;0],[ 0;-block_size;0],[-block_size; 0;0],[ 0; block_size;0],[ 0; 0; block_size]];
simulate_dynamics=false;
y_t=0;
y_tp1=0;

[Xs,Ys,Zs] = sphere(4);
r = 0.03; Xs = Xs * r; Ys = Ys * r; Zs = Zs * r;

x(:,1,1)=[S(1,1);S(1,2);block_size/2;0;0;0];
nodeVars(1).state=6;
Auxiliar.block3d(x(1,1,1),x(2,1,1),x(3,1,1),'grey');

clear
load state_assembly1.mat
t=t-dt;
mu=0.5;
eps=0.5;

if record_video==1
    v = VideoWriter(strcat('SelfAssembly_',num2str(N),'nodes.avi'));
    v.FrameRate=5;
    open(v);
end
sim_end=9999;

% for t=dt:dt:2000
while t<6000
t=t+dt;
    tic
    k=round(t/dt);
    %cla
    objects_in_fig=[];
    clc;

    % ---- Sensing stage ----
    %hard to paralelize this part
    %First the node will check its connections
%     for i=1:N
%         %who is close (therefore, connected)
%         for j=1:N
%             %In a real scenario, I would not iterate through all vehicles, 
%             %but through all sensors to see "who" am I seeing
%             if i~=j 
%                 if norm(x(1:n-1,i,k)-x(1:n-1,j,k),2)<=int_range_r ... %node is close
%                    && A(i,j)==0 %node is not connected
%                     [ A, hops_graph ] = Auxiliar_DynNet.change_net_topology_add(A,i,j);
%                 end
%                 if norm(x(1:n,i,k)-x(1:n,j,k),2)>int_range_r ... %node is not close
%                    && A(i,j)==1 %node is connected
%                     [ A, hops_graph ] = Auxiliar_DynNet.change_net_topology_remove(A,i,j);
%                 end
%                 if A(i,j)==1 && i>j && abs(x(n,i,k)-x(n,j,k))<0.5
%                     %uncomment for black line
%                     %objects_in_fig=[objects_in_fig,plot3([x(1,i,k) x(1,j,k)],[x(2,i,k) x(2,j,k)], [x(3,i,k) x(3,j,k)], 'k:','linewidth',1)]; 
%                     % if norm(x(1:n,i,k)-x(1:n,j,k),2)>d  objects_in_fig=[objects_in_fig,text((x(1,i,k)+x(1,j,k))/2,(x(2,i,k)+x(2,j,k))/2,num2str(norm(x(1:n,i,k)-x(1:n,j,k),2)))];end
%                 end
%             end
%         end
%     end
  
%creating the neighbours vector for each node
    for i=1:N
        nodeVars(i).neighGrad=[];
        nodeVars(i).neighState=[];
        nodeVars(i).neighId=[];
        for j=1:N
            if i~=j && A(i,j)~=0
%                 disp([i j nodeVars(j).gradient])
                nodeVars(i).neighGrad=[nodeVars(i).neighGrad,nodeVars(j).gradient];
                nodeVars(i).neighState=[nodeVars(i).neighState,nodeVars(j).state];
                nodeVars(i).neighId=[nodeVars(i).neighId,nodeVars(j).id];
                if j==nodeVars(i).CEFRid
                    nodeVars(i).CEFRgradient = nodeVars(j).gradient;
                end
            end
        end
    end
    % ----- Sensing END ------
    
   
% % show which rule is each group performed, this was removed because i thought that only with network rules I would solve it
% % I was missing self-assembly logic
    for i=1:N
    % Figure plot
    % ---------------
        switch nodeVars(i).state
            case 1
%                 objects_in_fig=[objects_in_fig,Auxiliar.block3d(x(1,i,k),x(2,i,k),x(3,i,k),'grey')];
%                 objects_in_fig=[objects_in_fig,text(x(1,i,k)-0.01,x(2,i,k),x(3,i,k)+block_size/2+0.01,num2str(i))];
            case 2
%                 objects_in_fig=[objects_in_fig,Auxiliar.block3d(x(1,i,k),x(2,i,k),x(3,i,k),'red')];
            case 3
                objects_in_fig=[objects_in_fig,Auxiliar.block3d(x(1,i,k),x(2,i,k),x(3,i,k),'magenta')];
            case 4
                objects_in_fig=[objects_in_fig,Auxiliar.block3d(x(1,i,k),x(2,i,k),x(3,i,k),'blue')];
            case 5
                objects_in_fig=[objects_in_fig,Auxiliar.block3d(x(1,i,k),x(2,i,k),x(3,i,k),'green')];
            case 6
                objects_in_fig=[objects_in_fig,Auxiliar.block3d(x(1,i,k),x(2,i,k),x(3,i,k),'grey')];
        end
        %objects_in_fig=[objects_in_fig,text(x(1,i,k),x(2,i,k), num2str(i))];
    end
    % % % colors of blocks

    
    title(strcat('t=',num2str(t),'s'))
    %I am going to simulate each agent in a parallel manner
    %this is good because it forces me to treat each one of them as an
    %individual that do not share information.
    actual_x=x(:,:,k);
    new_x=actual_x;
    states_with_delay=zeros(n*2,N);
    for j=1:N
        k_with_delay=k-hops_graph(pin,j);
        if k_with_delay<1;k_with_delay=1;end
        states_with_delay(:,j) = x(:,j,k_with_delay);
    end
    fprintf("t=%.2f\n",t);
    % ---- State Machine Simulation ------
    %this is parallelized
    all_u=actual_x(1:n,:)*0;
    for i=1:N
        posi = actual_x(1:n,i);
        veli = actual_x(n+1:n+n,i);
        u = veli*0;
        
%         fprintf("id[%d] - st[%d] - g[%d] - |Vi|[%d]",...
%             nodeVars(i).id,...
%             nodeVars(i).state,...
%             nodeVars(i).gradient,...
%             length(nodeVars(i).neighId));
%         if ~isempty(nodeVars(i).CEFRposition)
%             fprintf("- CEFR { id[%d] - cP[%d] - pos[%.2f,%.2f,%.2f] - grad[%d] }",...
%                 nodeVars(i).CEFRid,...
%                 nodeVars(i).CEFRcirclingPos,...
%                 nodeVars(i).CEFRposition(1),nodeVars(i).CEFRposition(2),nodeVars(i).CEFRposition(3),...
%                 nodeVars(i).CEFRgradient);
%         end
%         fprintf("\n");
        
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
%                            %variables=[variables;i,j,norm(diff),gain,1/sqrt(1+epslon*norm(diff,2)^2)]; %it does not work with the parfor
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

                %State transition
                is_neigh_desc_or_ef=0;
                for j=1:length(nodeVars(i).neighState)
                    if     nodeVars(i).neighState(j)==2 ... %a neighbour is descending
                        || nodeVars(i).neighState(j)==3 ... %or edge-following
                        || nodeVars(i).neighState(j)==4 ... %or edge-following
                        || nodeVars(i).neighState(j)==5     %or landing
                        is_neigh_desc_or_ef=1;
                    end
                end
                
                % neighbour placed - if $\exists j \in V^i $ such that $j$ state is placed.
                % get the highest height visible
                for idx_neigh_vect=1:length(nodeVars(i).neighState)
                    if nodeVars(i).neighState(idx_neigh_vect)==6 && is_neigh_desc_or_ef==0 %a neighbour has landed
                        landedNodeID=nodeVars(i).neighId(idx_neigh_vect);
                        %objects_in_fig = Auxiliar_SelfAssembly.plot_line_3d(objects_in_fig, posi, actual_x(1:3,landedNodeID), 'k', 1);

                        if nodeVars(i).state==2 
                            % I've passed this if already
                            %disp([i landedNodeID norm(actual_x(1:n,landedNodeID)-posi,2) norm(nodeVars(i).CEFRposition-posi,2) round(actual_x(3,landedNodeID)/block_size-0.5) round(nodeVars(i).CEFRposition(3)/block_size-0.5)])
                            if norm(actual_x(1:n,landedNodeID)-posi,2)<norm(nodeVars(i).CEFRposition-posi,2) && ...
                                    round(actual_x(3,landedNodeID)/block_size-0.5)<=round(nodeVars(i).CEFRposition(3)/block_size-0.5)
                                %This neighbouris actually closer and lower height                      
                                nodeVars(i).state=2; %goes to descent stage
                                nodeVars(i).goalPos= actual_x(1:n,landedNodeID); %position of the landed node
                                nodeVars(i).CEFRposition=actual_x(1:n,landedNodeID); %position of the landed node
                                nodeVars(i).CEFRid=landedNodeID;
                                nodeVars(i).CEFRcirclingPos=1;
                                nodeVars(i).CEFRgradient=nodeVars(i).neighGrad(idx_neigh_vect);
                            end
                        else
                            %first time in this if
                            nodeVars(i).state=2; %goes to descent stage
                            nodeVars(i).goalPos= actual_x(1:n,landedNodeID); %position of the landed node
                            nodeVars(i).CEFRposition=actual_x(1:n,landedNodeID); %position of the landed node
                            nodeVars(i).CEFRid=landedNodeID;
                            nodeVars(i).CEFRcirclingPos=1;
                            nodeVars(i).CEFRgradient=nodeVars(i).neighGrad(idx_neigh_vect);
                        end
                        actual_x(n+1:n+n,i)=actual_x(n+1:n+n,i)*0;
                        u=u*0;
                    end
                end
                
                u(3)= u(3) + kp*(1 - posi(3)) + kv*(-veli(3));
                
            case 2
                % ---- DESCEND ---- 
                %at this point, the goal position should be the landed node position
                
                %first, let us decide if I am the correct node to keep moving
                for j=1:length(nodeVars(i).neighState)
                    if nodeVars(i).neighState(j)>=2 && nodeVars(i).neighState(j)<=5
                        id_desceding_neigh=nodeVars(i).neighId(j);
                                                    
                        if ~simulate_dynamics
                            %just told myself to continue descending (to trust this I have to have
                            %really large sensor range
                            if id_desceding_neigh < i %id of neighbour smaller than mine
                                nodeVars(i).state=1; % back to flocking
                                nodeVars(i).CEFRposition=[];
                                break;
                            end
                        else
                            if nodeVars(i).neighState(j)>nodeVars(i).state %neigh in further state
                                %this guy is already doing edge following, I will retract
                                nodeVars(i).state=1; % back to flocking
                                nodeVars(i).CEFRposition=[];
                                break;
                            else
                                %the neighbour is also descending
                                if actual_x(n,id_desceding_neigh) < actual_x(n,i) %height of neighbour smaller than mine
                                    nodeVars(i).state=1; % back to flocking
                                    nodeVars(i).CEFRposition=[];
                                    break;
                                end
                            end                            
                        end
                    end
                end    
                
                if nodeVars(i).state==2
                    %plot line
                    objects_in_fig = Auxiliar_SelfAssembly.plot_line_3d(objects_in_fig, posi, nodeVars(i).CEFRposition, 'g', 1.5);
                    
                    %compute control
                    u= kp*(nodeVars(i).CEFRposition - posi) + kv*(-veli); 
                    u=(0.01*randn+1)*u;% a little noise in the control just to avoid having ideal values in this stage. 

                    %State Transition
                    %approached placed block - if $|p_t(i) - p_t(j*)|<d*$. That means that the arriving block is close enough of a placed block. 
                    %$d*>\sqrt{3}d$ avoids blocks colliding with each other. Note that a node will always transition from descent
                    min_d=100*block_size; %sqrt(3)*block_size*1.1;
                    if norm((posi - nodeVars(i).CEFRposition),2) <= min_d %Too close of the landed node
                        nodeVars(i).state=3; %goes to edge following stage                  
                        %the closest circling pos is not free
                        %let me check if all are busy
                        nodeVars(i).goalPos=nodeVars(i).CEFRposition+circling(:,1);
                        nodeVars(i).CEFRcirclingPos=1;
                        number_of_free=0;
                        for l=1:4
                            candidate_goal=nodeVars(i).CEFRposition+circling(:,l);
                            [is_candidate_free,id]=Auxiliar_SelfAssembly.check_position_free(candidate_goal,actual_x);
                            %objects_in_fig = Auxiliar_SelfAssembly.plot_line_3d(objects_in_fig, posi, candidate_goal, 'k', 1);
                            if is_candidate_free
                                if norm(posi-candidate_goal,2)<=norm(posi-nodeVars(i).goalPos,2)
                                    nodeVars(i).CEFRcirclingPos=l;
                                    nodeVars(i).goalPos=candidate_goal;
                                end
                                number_of_free=number_of_free+1;
                            end
                        end
                        if number_of_free==0
                            %no available positions here, go from the top                       
                            nodeVars(i).goalPos=nodeVars(i).CEFRposition+circling(:,1);
                            nodeVars(i).CEFRcirclingPos=1;    
                            [is_candidate_free,id]=Auxiliar_SelfAssembly.check_position_free(nodeVars(i).CEFRposition+circling(:,1),actual_x);
                            while is_candidate_free==false
                                nodeVars(i).CEFRposition=nodeVars(i).goalPos;
                                nodeVars(i).CEFRid=id;
                                idx_neighV=find(nodeVars(i).neighId==id);
                                nodeVars(i).CEFRgradient=nodeVars(i).neighGrad(idx_neighV);
                                nodeVars(i).goalPos=nodeVars(i).CEFRposition+circling(:,1);
                                nodeVars(i).CEFRcirclingPos=1;    
                                [is_candidate_free,id]=Auxiliar_SelfAssembly.check_position_free(nodeVars(i).CEFRposition+circling(:,1),actual_x);
                            end
                        end

                        [theta,rho] = cart2pol(nodeVars(i).goalPos(1),nodeVars(i).goalPos(2));
                        nodeVars(i).initialAngle=rad2deg(wrapTo2Pi(theta));
                        nodeVars(i).displacement(3)=3*block_size+nodeVars(i).CEFRposition(3);
                        is_first=1;
%                         direction=1;
                        direction=rand;
                        if direction <0.5
                            direction =-1;
                        else
                            direction =1;
                        end

                        %find the highest displacement to not hit any block
                        for j=1:length(nodeVars(i).neighState)
                            if nodeVars(i).neighState(j)== 6 %a neighbour landed
                                id_landed=nodeVars(i).neighId(j);
                                if actual_x(n,id_landed) >= nodeVars(i).displacement(3)-3*block_size %height of neighbour smaller than mine
                                    nodeVars(i).displacement(3)=3*block_size+actual_x(n,id_landed);
                                end
                            end
                        end  
                    end
                end
                
            case 3
                % --- Edge following algorithm outside                
                %Plot the position to where I am going
                objects_in_fig=[objects_in_fig,surf(Xs+nodeVars(i).goalPos(1),Ys+nodeVars(i).goalPos(2),Zs+nodeVars(i).goalPos(3))];
                to=[nodeVars(i).goalPos(1);nodeVars(i).goalPos(2);nodeVars(i).goalPos(3)+nodeVars(i).displacement(3)];
                objects_in_fig = Auxiliar_SelfAssembly.plot_line_3d(objects_in_fig, nodeVars(i).goalPos, to, 'b', 1.5);
                objects_in_fig = Auxiliar_SelfAssembly.plot_line_3d(objects_in_fig, nodeVars(i).goalPos, nodeVars(i).CEFRposition, 'b', 1.5);
                
                u = 0.5*kp*(nodeVars(i).goalPos+nodeVars(i).displacement - posi) + kv*(-veli);
                                
                i_am_inside_S=Auxiliar_SelfAssembly.check_position_inside_structure(posi-nodeVars(i).displacement,S);
                if norm((nodeVars(i).goalPos+nodeVars(i).displacement - posi),2) <= 0.01 
                    [theta,rho] = cart2pol(posi(1),posi(2));
                    theta=rad2deg(wrapTo2Pi(theta));
                    disp([ theta, nodeVars(i).initialAngle, abs(theta-nodeVars(i).initialAngle), round(theta/5)]);
                    %disp(round(rad2deg(wrapTo2Pi(theta))/5));
                    
                    %Checking positions below me (THIS MAY HAVE TO CHANGE)
                    maxlevel=round((nodeVars(i).goalPos(3)/block_size)-0.5);
                    pos_to_go=nodeVars(i).goalPos;
                    level=0;
                    below_is_inside=false;
                    while level<=maxlevel
                        pos_to_go(3)=(level+0.5)*block_size;
                        [is_down_free,id]=Auxiliar_SelfAssembly.check_position_free(pos_to_go,actual_x);
                        is_down_inside=Auxiliar_SelfAssembly.check_position_inside_structure(pos_to_go,S);                                    
                        if is_down_free && is_down_inside
                            below_is_inside=true;
                            break;
                        else
                            level=level+1;
                        end
                    end
                    
                    %entered a valid position
                    if i==1
                        nodeVars(i).state=4;
                    elseif i_am_inside_S
                        nodeVars(i).state=4;
                    elseif below_is_inside
                        grad_side=9999;
                        lowgradid=1;
                        for l=1:4
                            [is_side_free,id_side]=Auxiliar_SelfAssembly.check_position_free(pos_to_go+circling(:,l),actual_x);
                            objects_in_fig = Auxiliar_SelfAssembly.plot_line_3d(objects_in_fig, posi, pos_to_go+circling(:,l), 'k', 1.5);
                            if ~is_side_free
                                idx_neighV=find(nodeVars(i).neighId==id_side);
                                if grad_side>nodeVars(i).neighGrad(idx_neighV)
                                    grad_side=nodeVars(i).neighGrad(idx_neighV);
                                    lowgradid=id_side;
                                end
                            end
                        end
                        nodeVars(i).CEFRposition=actual_x(1:n,lowgradid);
                        nodeVars(i).CEFRgradient=grad_side;
                        nodeVars(i).CEFRid=lowgradid;
                        nodeVars(i).goalPos=pos_to_go;
                        
                        nodeVars(i).state=4;
                    elseif abs(theta-nodeVars(i).initialAngle)<2 && is_first==0 %&& nodeVars(i).possible_upper_CEFR.circling~=0
                            %the circling is to guarantee that I have a node to go to.
                            %just spin around        
                            %go to closest node
                            min_distance=9999;
                            for idx_neigh_vect=1:length(nodeVars(i).neighState)
                                if nodeVars(i).neighState(idx_neigh_vect)==6
                                    %first filter, check only landed nodes
                                    landedNodeID=nodeVars(i).neighId(idx_neigh_vect);
                                    level_landed=round(actual_x(n,landedNodeID)/block_size-0.5);
                                    if level_landed == round(nodeVars(i).goalPos(n)/block_size-0.5)+1
                                        %block is exactly one level up
                                        objects_in_fig = Auxiliar_SelfAssembly.plot_line_3d(objects_in_fig, posi, actual_x(1:3,landedNodeID), 'k', 1.5);
                                        distance_to_this_node=norm(actual_x(1:n,landedNodeID)-posi,2);
                                        if distance_to_this_node<min_distance
                                            min_distance=distance_to_this_node;
                                            nodeVars(i).CEFRid=landedNodeID;
                                            nodeVars(i).CEFRgradient=nodeVars(i).neighGrad(idx_neigh_vect);
                                        end
                                    end
                                end
                            end
                            
                            nodeVars(i).CEFRposition=actual_x(1:n,nodeVars(i).CEFRid);
                            [goal_pos, circling_pos] = Auxiliar_SelfAssembly.get_closest_circling_pos(nodeVars(i).CEFRposition, posi, circling);
                            
                            [theta,rho] = cart2pol(goal_pos(1),goal_pos(2));
                            nodeVars(i).initialAngle=rad2deg(wrapTo2Pi(theta));
                            nodeVars(i).goalPos=goal_pos;
                            nodeVars(i).CEFRcirclingPos=circling_pos;
                            is_first=1;
                    else
                        is_first=0;

                        %default is circling on the same layer
                        nextCirclingPos = Auxiliar_SelfAssembly.next_circling (nodeVars(i).CEFRcirclingPos,direction*1);
                        nextGoalPosition=nodeVars(i).CEFRposition+circling(:,nextCirclingPos);
                        objects_in_fig = Auxiliar_SelfAssembly.plot_line_3d(objects_in_fig, posi, nextGoalPosition, 'k', 1.5);
                        
                        changed_circled_node=0; 

                        [is_next_free, id_side]=Auxiliar_SelfAssembly.check_position_free(nextGoalPosition,actual_x);
                        
                        while ~is_next_free 
                            %there is a node here already, j

                            %The way I am implementing, I am sensing again
                            idx_neighV=find(nodeVars(i).neighId==id_side); %found the position in the neigh vector that shows this ID
                            grad_side_node = nodeVars(i).neighGrad(idx_neighV);
                            
                            y_tp1=grad_side_node+mu*(grad_side_node-nodeVars(i).CEFRgradient);
                            delta_function=(y_tp1-y_t);
                            nodeVars(i).vel=y_t - eps*delta_function; %actualy, my f() I call grad, but I need deltaf() grad of the grad
                            disp([grad_side_node, nodeVars(i).CEFRgradient , nodeVars(i).vel ])
                            
                            if  grad_side_node > nodeVars(i).CEFRgradient
                                %the gradient of the next is bigger than the actual gradient.
                                nextGoalPosition=nodeVars(i).CEFRposition++circling(:,5); %UP in the actual block                                   
                                objects_in_fig = Auxiliar_SelfAssembly.plot_line_3d(objects_in_fig, posi, nextGoalPosition, 'k', 1.5);

                                [is_up_free,id_up]=Auxiliar_SelfAssembly.check_position_free(nextGoalPosition,actual_x);
                                grad_up=9999;
                                if ~is_up_free
                                        idx_neighV=find(nodeVars(i).neighId==id_up); %found the position in the neigh vector that shows this ID
                                        grad_up=nodeVars(i).neighGrad(idx_neighV);
                                end   
                                is_up_inside=Auxiliar_SelfAssembly.check_position_inside_structure(nextGoalPosition,S);                                    

                                %here, side is already taken, considering up
                                if is_up_free
                                    if is_up_inside
                                        nextCirclingPos=5; 
                                    else
                                        %continue with the side edge follow
                                        nodeVars(i).CEFRposition=actual_x(1:n,id_side);
                                        nodeVars(i).CEFRgradient=grad_side_node;
                                        nodeVars(i).CEFRid=id_side;
                                        nextCirclingPos = Auxiliar_SelfAssembly.next_circling(nextCirclingPos,-1*direction);
                                    end
                                else
                                    %just saving uppper node
                                    nodeVars(i).possible_upper_CEFR.pos=actual_x(1:n,id_up);
                                    nodeVars(i).possible_upper_CEFR.grad=grad_up;
                                    nodeVars(i).possible_upper_CEFR.id=id_up;
                                    
                                    %gets the closest goal position
                                    [candidate_goal, nodeVars(i).possible_upper_CEFR.circling] = Auxiliar_SelfAssembly.get_closest_circling_pos(actual_x(1:n,id_up), posi, circling);

                                    %in this case, I should move to the side
                                    %Change the robot that I am edge-following
                                    %now I will need to find the new node to edge follow
                                    nodeVars(i).CEFRposition=actual_x(1:n,id_side);
                                    nodeVars(i).CEFRgradient=grad_side_node;
                                    nodeVars(i).CEFRid=id_side;
                                    nextCirclingPos = Auxiliar_SelfAssembly.next_circling(nextCirclingPos,-1*direction);
                                    changed_circled_node=1;
                                end
                            else
                                %Change the robot that I am edge-following
                                %now I will need to find the new node to edge follow
                                nodeVars(i).CEFRposition=actual_x(1:n,id_side);
                                nodeVars(i).CEFRgradient=grad_side_node;
                                nodeVars(i).CEFRid=id_side;
                                nextCirclingPos = Auxiliar_SelfAssembly.next_circling(nextCirclingPos,-1*direction);

                                changed_circled_node=1;
                            end
                            %nodeVars(i).CEFRcirclingPos %stay the same
                            nextGoalPosition=nodeVars(i).CEFRposition+circling(:,nextCirclingPos);
                            if nextCirclingPos==5
                                %I am chaniging layers
                                [theta,rho] = cart2pol(nextGoalPosition(1),nextGoalPosition(2));
                                nodeVars(i).initialAngle=rad2deg(theta);
                                nodeVars(i).possible_upper_CEFR.pos=[];
                            end

                            objects_in_fig = Auxiliar_SelfAssembly.plot_line_3d(objects_in_fig, posi, nextGoalPosition, 'k', 1.5);
                            [is_next_free, id_side]=Auxiliar_SelfAssembly.check_position_free(nextGoalPosition,actual_x);
                        end
                        
                        nodeVars(i).goalPos=nextGoalPosition;
                        nodeVars(i).CEFRcirclingPos=nextCirclingPos;
                    end
                end
                
                nodeVars(i).past_grad
                if ~simulate_dynamics
                    actual_x(1:n,i)=nodeVars(i).goalPos+nodeVars(i).displacement;
                    actual_x(n+1:n+n,i)=[0;0;0];
                    u=u*0;
                end
                
                for j=1:length(nodeVars(i).neighState)
                    if nodeVars(i).neighState(j)>=2 && nodeVars(i).neighState(j)<=5 %if this block seems somebody else doing it, reevaluates
                        id_desceding_neigh=nodeVars(i).neighId(j);
                        if actual_x(n,id_desceding_neigh) < actual_x(n,i) %height of neighbour smaller than mine
                        	nodeVars(i).state=1; % back to flocking
                            nodeVars(i).CEFRposition=[];
                            break;
                        end
                    end
                end    
                y_t=y_tp1;
            case 4
                % --- Edge following inside
                %Am I going to exit the structure
                %I have not decided how S looks like yet, I will suppose it
                %is a list

                %Plot the position to where I am going  
                objects_in_fig=[objects_in_fig,surf(Xs+nodeVars(i).goalPos(1),Ys+nodeVars(i).goalPos(2),Zs+nodeVars(i).goalPos(3))];
                to=[nodeVars(i).goalPos(1);nodeVars(i).goalPos(2);nodeVars(i).goalPos(3)+nodeVars(i).displacement(3)];
                objects_in_fig = Auxiliar_SelfAssembly.plot_line_3d(objects_in_fig, nodeVars(i).goalPos, to, 'b', 1.5);
                objects_in_fig = Auxiliar_SelfAssembly.plot_line_3d(objects_in_fig, nodeVars(i).goalPos, nodeVars(i).CEFRposition, 'b', 1.5);
                
                u = 0.5*kp*(nodeVars(i).goalPos+nodeVars(i).displacement - posi) + kv*(-veli);
                
                if i==1
                    nodeVars(i).state=5;
                elseif norm((nodeVars(i).goalPos+nodeVars(i).displacement - posi),2) <= 0.01 %entered a valid position
                    
                    %nodeVars(i).circlingPos is the position the clock that I am right now                
                    %now I have to compute if the next position is available
                    % actualGoalPosition=nodeVars(i).goalPos; %should be the same as posi
                    % disp(norm(posi-actualGoalPosition,2));
                    
                    if nodeVars(i).CEFRcirclingPos ~= 5

                        nextCirclingPos = Auxiliar_SelfAssembly.next_circling(nodeVars(i).CEFRcirclingPos,1*direction);
                        nextGoalPosition=nodeVars(i).CEFRposition+circling(:,nextCirclingPos);
                    
                        bigger_CEFR_gradient=false;
                        changed_circled_node=0;

                        objects_in_fig = Auxiliar_SelfAssembly.plot_line_3d(objects_in_fig, posi, nextGoalPosition, 'k', 1.5);

                        next_is_inside_S=Auxiliar_SelfAssembly.check_position_inside_structure(nextGoalPosition,S);
                        [is_side_free,id_side]=Auxiliar_SelfAssembly.check_position_free(nextGoalPosition,actual_x);
                            
                        while next_is_inside_S && ~is_side_free && ~bigger_CEFR_gradient
                            %there is a node here already, j
                            idx_neighV=find(nodeVars(i).neighId==id_side); %found the position in the neigh vector that shows this ID
                            grad_side=nodeVars(i).neighGrad(idx_neighV);
                            
                            is_up_inside=Auxiliar_SelfAssembly.check_position_inside_structure(nodeVars(i).CEFRposition+circling(:,5),S);

                            if grad_side > nodeVars(i).CEFRgradient && changed_circled_node==0
                                %the gradient of the next is bigger than the actual gradient.
                                bigger_CEFR_gradient=true;
                                [is_up_free,id_up]=Auxiliar_SelfAssembly.check_position_free(nodeVars(i).CEFRposition+circling(:,5),actual_x);
                                grad_up=9999;
                                if ~is_up_free
                                        idx_neighV=find(nodeVars(i).neighId==id_up); %found the position in the neigh vector that shows this ID
                                        grad_up=nodeVars(i).neighGrad(idx_neighV);
                                        %just saving uppper node
                                        nodeVars(i).possible_upper_CEFR.pos=actual_x(1:n,id_up);
                                        nodeVars(i).possible_upper_CEFR.grad=grad_up;
                                        nodeVars(i).possible_upper_CEFR.id=id_up;
                                end   
                            else

                                %Change the robot that I am edge-following
                                %now I will need to find the new node to edge follow
                                nodeVars(i).CEFRposition=actual_x(1:n,id_side);
                                nodeVars(i).CEFRgradient=nodeVars(i).neighGrad(idx_neighV);
                                nodeVars(i).CEFRid=id_side;
                                nextCirclingPos = Auxiliar_SelfAssembly.next_circling(nextCirclingPos,-1*direction);

                                changed_circled_node=1;
                                nextGoalPosition=nodeVars(i).CEFRposition+circling(:,nextCirclingPos);
                                
                                objects_in_fig = Auxiliar_SelfAssembly.plot_line_3d(objects_in_fig, posi, nextGoalPosition, 'k', 1.5);

                                [is_side_free,id_side]=Auxiliar_SelfAssembly.check_position_free(nextGoalPosition,actual_x);
                                next_is_inside_S=Auxiliar_SelfAssembly.check_position_inside_structure(nextGoalPosition,S);
                            end                          
                        end
                        
%                         eu preciso comparar de novo se eu trocar de nó
%                         isso precisa de ser comparado tambem no outside

                        if changed_circled_node==1
                            next_is_inside_S=Auxiliar_SelfAssembly.check_position_inside_structure(nextGoalPosition,S);
                        end


                        if ~next_is_inside_S || bigger_CEFR_gradient
                            % I am inside, but I am about to leave the structure
                            % I am about to edge-follow a robot with a bigger gradient
                            nodeVars(i).state=5;
                        else
                            nodeVars(i).goalPos=nextGoalPosition;
                            nodeVars(i).CEFRcirclingPos=nextCirclingPos;
                        end
%                         if ~next_is_inside_S
%                             % I am inside, but I am about to leave the structure
%                             % I am about to edge-follow a robot with a bigger gradient
%                             nodeVars(i).state=5;
%                         elseif bigger_CEFR_gradient
%                              if is_up_free && is_up_inside
%                                  nodeVars(i).goalPos=nodeVars(i).CEFRposition+circling(:,5);
%                                  nodeVars(i).CEFRcirclingPos=5;
%                              else  
%                                 nodeVars(i).state=5;
%                              end
%                         else
%                             nodeVars(i).goalPos=nextGoalPosition;
%                             nodeVars(i).CEFRcirclingPos=nextCirclingPos;
%                         end
                    else
                        % I am already on top of a node, find a neighbouring position that is inside
                        % and has has the lower grad
                        lowestgradID=nodeVars(i).CEFRid;
                        lowestgradVal=nodeVars(i).CEFRgradient;
                        for l=1:4
                            nextGoalPosition=nodeVars(i).CEFRposition+circling(:,l);
                            [is_pos_free,id_node]=Auxiliar_SelfAssembly.check_position_free(nextGoalPosition,actual_x);
                            if ~is_pos_free
                                %Somebody at this location
                                indexNV=find(nodeVars(i).neighId-id_node==0);
                                next_is_inside_S=Auxiliar_SelfAssembly.check_position_inside_structure(nextGoalPosition+circling(:,5) ,S);
                                if nodeVars(i).neighGrad(indexNV)<lowestgradVal && next_is_inside_S
                                    lowestgradID=id_node;
                                    lowestgradVal=nodeVars(i).neighGrad(indexNV);
                                    objects_in_fig = Auxiliar_SelfAssembly.plot_line_3d(objects_in_fig, posi, actual_x(1:3,lowestgradID), 'k', 1.5);
                                end
                                
                            end
                        end
                        
                        objects_in_fig = Auxiliar_SelfAssembly.plot_line_3d(objects_in_fig, posi, actual_x(1:3,lowestgradID), 'k', 1.5);
                        
                        [is_pos_free,id_node]=Auxiliar_SelfAssembly.check_position_free((actual_x(1:n,lowestgradID)+circling(:,5)),actual_x);

                        if norm(nodeVars(i).CEFRposition-actual_x(1:n,lowestgradID),2)<0.02
                            %there is no other node with a lower grad to follow
                            nodeVars(i).state=5;
                        elseif ~is_pos_free
                            %there is a node here already, i am on a higher layer, so I will start
                            %edge following him
                            idx_neighV=find(nodeVars(i).neighId==id_node);
                            nodeVars(i).CEFRposition=actual_x(1:n,id_node);
                            nodeVars(i).CEFRid=id_node;
                            nodeVars(i).CEFRgradient=nodeVars(i).neighGrad(idx_neighV);
                            nodeVars(i).goalPos=nodeVars(i).CEFRposition+circling(:,1);
                            nodeVars(i).CEFRcirclingPos=1;
                            for m=1:4
                                prospecting_pos=nodeVars(i).CEFRposition+circling(:,m);
                                objects_in_fig = Auxiliar_SelfAssembly.plot_line_3d(objects_in_fig, posi, prospecting_pos, 'k', 1.5);
                                %find the closest position to start the edge follow
                                if norm(posi-nodeVars(i).goalPos,2)>norm(posi-prospecting_pos,2)
                                    nodeVars(i).goalPos=prospecting_pos;
                                    nodeVars(i).CEFRcirclingPos=m;
                                end
                            end
                        else
                            idx_neighV=find(nodeVars(i).neighId==lowestgradID);
                            nodeVars(i).CEFRposition=actual_x(1:n,lowestgradID);
                            nodeVars(i).CEFRid=lowestgradID;
                            nodeVars(i).CEFRgradient=nodeVars(i).neighGrad(idx_neighV);
                            nodeVars(i).CEFRcirclingPos=5;
                            nodeVars(i).goalPos=nodeVars(i).CEFRposition+circling(:,5);
                        end
                    end
                end
                if ~simulate_dynamics    
                    actual_x(1:n,i)=nodeVars(i).goalPos+nodeVars(i).displacement;
                    actual_x(n+1:n+n,i)=[0;0;0];
                    u=u*0;
                end
                
            case 5
                %lading state
                from=nodeVars(i).goalPos.*[1;1;0];
                objects_in_fig = Auxiliar_SelfAssembly.plot_line_3d(objects_in_fig, from, nodeVars(i).goalPos, 'g', 1.5); 
                %check if I can land in a lower height
                
                level=round((nodeVars(i).goalPos(3)/block_size)-0.5);
                nodeVars(i).goalPos(3)=(level+0.5)*block_size;
                
                %rouding to block height
                %nodeVars(i).goalPos(3)=(round((nodeVars(i).goalPos(3)/block_size)-0.5)+0.5)*block_size;
                u = 0.5*kp*(nodeVars(i).goalPos - posi) + kv*(-veli);

                if norm((nodeVars(i).goalPos - posi),2) <= 0.01 %arrived at the destination
                    nodeVars(i).state=6;
                    nodeVars(i).layer=round((nodeVars(i).goalPos(3)/block_size)-0.5);
%                     Auxiliar.block3d(actual_x(1,i),actual_x(2,i),actual_x(3,i),'grey');
                end
                if ~simulate_dynamics    
                    actual_x(1:n,i)=nodeVars(i).goalPos;
                    actual_x(n+1:n+n,i)=[0;0;0];
                    u=u*0;
                end
                
            case 6
                % --- Placed 
                %update your own gradient
%                 nodeVars(i).gradient=min(nodeVars(i).neighGrad)+1;
                if i~=1
                    nodeVars(i).gradient=sum(round((actual_x(1:n,i)-[0;0;block_size/2])/block_size)) + nodeVars(i).layer;
                end
                u = 0.9*([0;0;0]-veli);
                if i==1
                    nodeVars(i).gradient=0;
                end
                objects_in_fig=[objects_in_fig,text(x(1,i,k)-0.01,x(2,i,k),x(3,i,k)+block_size/2+0.01,  strcat('(',num2str(nodeVars(i).gradient),')'))];
        end
        all_u(:,i)=u;
    end        
    
     for i=1:N
%         new_x(:,i) = [posi + dt*veli + ((dt^2)/2)*u; veli + dt*u];
        new_x(:,i) = [actual_x(1:n,i) + dt*actual_x(n+1:n+n,i) + ((dt^2)/2)*all_u(:,i); actual_x(n+1:n+n,i) + dt*all_u(:,i);];
        if norm(new_x(n+1:n+n,i),2) > 1
            %saturate the vel
            new_x(n+1:n+n,i) = new_x(n+1:n+n,i)/norm(new_x(n+1:n+n,i),2);
        end
    end
    
    x(:,:,k+1)=new_x;

    %rescale axes
    if mod(round(t*100),100)==0
        %axis ([min(x(1,:,k))-1 max(x(1,:,k))+1 min(x(2,:,k))-1 max(x(2,:,k))+1 0 max(x(1,:))-min(x(1,:))]);    
        axis ([-0.5 1.5 -0.5 1.5 0 2]);
    end
    
   proc_time=toc;
   fprintf("processing time = %.3f | actual t = %.1f\n",proc_time,t); 

   
    if record_video==1
        if t>=now
            drawnow
            pause(0.05);
            frame=getframe;
            if t==dt
                szframe=size(frame.cdata)-2;
            end
            frame.cdata=frame.cdata(1:szframe(1),1:szframe(2),1:3);
            writeVideo(v,frame);
            now=t+0.1;
%             z=''; if t<10; z='00'; elseif t<100; z='0'; elseif t>=100; z=''; end
%             print(strcat('Images/',num2str(N),'N_',num2str(MinNodes),'G/',z,num2str(now)),'-dpng')
        end
    else
%            if t>=now
%                 now=t+0.2;
                drawnow
                pause(0.1);
%            end
    end
    
    %stop simulation condition
    number_of_placed=0;
    for i=1:N
        if nodeVars(i).state==6
            number_of_placed=number_of_placed+1;
        end
        if isempty(nodeVars(i).neighId)
            %a node has no neighbours
            number_of_placed=N;
        end
    end
    
    if number_of_placed==N
%         if sim_end>t
%             sim_end=t;
%         else
%             if t-sim_end>5
               break;   
%             end
%         end
    end
    
    delete(objects_in_fig)
end

if record_video==1
    close(v);
    pause(1);
    command = sprintf('ffmpeg -i %s -vf "pad=ceil(iw/2)*2:ceil(ih/2)*2" -vcodec libx264 -acodec aac %s && rm %s ', v.Filename,strcat('SelfAssembly_',num2str(N),'nodes.mp4') ,v.Filename);
    system(command);
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


%% Not used

    
%     objects_in_fig=[objects_in_fig,plot(mean(x(1,:,k),2),mean(x(2,:,k)), 'ok')];
%     objects_in_fig=[objects_in_fig,text(mean(x(1,:,k))+0.01,mean(x(2,:,k))+0.01, 'CM')];
%     objects_in_fig=[objects_in_fig,plot(WP(1,nextwp),WP(2,nextwp), 'vk')];
%     objects_in_fig=[objects_in_fig,text(WP(1,nextwp)+0.02,WP(2,nextwp)+0.02, 'goal')];
%     objects_in_fig=[objects_in_fig,title(strcat('t = ',num2str(t),' s'))];
    
%     if abs(WP(1:2,nextwp)-mean(x(1:n,:,k),2)) + abs(WP(3:4,nextwp)-mean(x(n+1:n+n,:,k),2)) < 0.2
%         nextwp=mod(nextwp+1,size(WP,2));
%         if nextwp==0;nextwp=1;end
%     end
%     hold off
%     % ---------------
%     if t>=now
%         now=t+0.5;
%         drawnow
%         axis ([min(x(1,:,k))-1 max(x(1,:,k))+1 min(x(2,:,k))-1 max(x(2,:,k))+1 0 2])
%         pause(0.05);
%     end

%                 zed = posj-posi;
%                 sigma_norm_zed = Auxiliar.sigma_norm(zed);
%                 delta_sigma = zed / (1+epslon*sigma_norm_zed);
                %d_sig_norm=sqrt(1+norm(d,2)^2)-1;
                %phi_function_minus=(sigma_norm^2 -2*d_sig_norm*sigma_norm + d_sig_norm^2);
                %delta = (phi_function_plus-phi_function_minus)/0.001;
                %posji = posj-posi;
                %sigma_norm=sqrt(1+norm(posji,2)^2)-1;
                %phi_function=(sigma_norm^2 -2*d_sig_norm*sigma_norm + d_sig_norm^2);
                
                
                
%                 strcmp(assembly_group{i}.rule,'formation') && strcmp(assembly_group{j}.rule,'formation')
%                     if ismember(j,assembly_group{i}.neighbours)
%                         idx_i=find(abs(assembly_group{i}.neighbours-i) < 0.001);
%                         idx_j=find(abs(assembly_group{i}.neighbours-j) < 0.001);
%                         posi_cp = compound_part(1:n,idx_i);
%                         posj_cp = compound_part(1:n,idx_j);                          
%                         u = u - ( kp*(posi - posj - posi_cp + posj_cp) + kv*(veli-velj) );
%                         if norm(diff,2)<block_size
%                             sigma_d = Auxiliar.sigma_norm(inter_agent_d);sigma_diff = Auxiliar.sigma_norm(diff);
%                             phi_alpha = Auxiliar.rho_h(sigma_diff/sigma_int_range)*Auxiliar.sigma_1(sigma_diff-sigma_d);
%                             nij= diff/sqrt(1+epslon*norm(diff,2)^2);
%                             gain=(0.1/sigma_diff); 
%                             u = u + kp*gain*phi_alpha*nij + kv*Auxiliar.rho_h(sigma_diff/sigma_int_range)*A(i,j)*(velj-veli);    
%                         end
%                     else
%                         if time_for_structure==1
%                             %assemblying final structure                            
%                         end
%                     end
                   
                
%                     %special cases - obstacle avoidance
%                     sigma_d_obs = Auxiliar.sigma_norm(0.5);
%                     int_range_r_obs=0.5;
%                     sigma_int_range_obs = Auxiliar.sigma_norm(int_range_r_obs);
% 
%                     %To run simulation faster,
%                     %avoid the calculations if the target is out of range
%                     if norm(posi - posj)<int_range_r_obs+block_size
%                         %disp([i,j,norm(posi - posj), int_range_r_obs, int_range_r_obs+OBS(3,j)])
% 
%                         mu = block_size/norm(posi - posj);      % obtain the vector from agent to object
%                         a_k = (posi - posj)/norm(posi - posj);
%                         P=eye(n) - a_k * (a_k');
%                         pos_beta=mu*posi+(1-mu)*posj;         %position of beta agent (%olfati-saber modeling)
%                         vel_beta=mu*P*veli;                         %velocity of beta agent (%olfati-saber modeling)
% 
%                         diff=pos_beta-posi;
%                         sigma_diff = Auxiliar.sigma_norm(diff);
%                         phi_beta = Auxiliar.rho_h(sigma_diff/sigma_int_range_obs)*(Auxiliar.sigma_1(sigma_diff-sigma_d_obs)-1);
%                         nij = diff/sqrt(1+epslon*norm(diff,2)^2);
%                         b_ik = Auxiliar.rho_h(sigma_diff/sigma_int_range_obs);
%                         u = u + C(2,1)*phi_beta*nij + C(2,2)*b_ik*(vel_beta-veli);
% 
%                         objects_in_fig=[objects_in_fig,plot(pos_beta(1), pos_beta(2), 'xb')];
%                         objects_in_fig=[objects_in_fig,plot([posi(1) pos_beta(1)],[posi(2) pos_beta(2)], 'b','linewidth',1.5)];
%                         %text(mean([posi(1) pos_beta(1)]),mean([posi(2) pos_beta(2)]),...
%                         %    strcat('d=',num2str(norm(diff,2),2)));
%                         %    strcat('phi_alpha=',num2str(phi_alpha,3 ),', d=',num2str( norm(diff,2),3 ),', sig-d=',num2str( sigma_diff,3 ), ', exp=',num2str( exp(1/norm(diff,2)),3 ),', sig-d-1=',num2str( (1/sigma_diff)),3 ));
%                     end