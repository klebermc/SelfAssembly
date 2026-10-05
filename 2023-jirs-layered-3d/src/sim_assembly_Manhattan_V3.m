% Description
% This simulation aims to study network control strategies applied to
% assembly.
% Here, different subgroups of the network will apply different assembly
% rules to create compound parts.
% Simulating state of nodes 

clear
close all

%% Structure
% Stairs
% S=[0,0,0;    	1,0,0;	2,0,0;	3,0,0;	0,0,1;	1,0,1;	2,0,1;   0,0,2;    1,0,2;   0,0,3;    ];

%ground level square
% S=[
% 0,0,0;	1,0,0;	
% 0,1,0;	1,1,0;	];
% S=[
% 0,0,0;	1,0,0;	2,0,0;	
% 0,1,0;	1,1,0;	2,1,0;	
% 0,2,0;    1,2,0;	2,2,0;	];
% S=[
% 0,0,0;	1,0,0;	2,0,0;	3,0,0;	
% 0,1,0;	1,1,0;	2,1,0;	3,1,0;	
% 0,2,0;  1,2,0;	2,2,0;	3,2,0;	
% 0,3,0;	1,3,0;	2,3,0;	3,3,0;	];
% S=[
% 0,0,0;	1,0,0;	2,0,0;	3,0,0;	4,0,0;
% 0,1,0;	1,1,0;	2,1,0;	3,1,0;	4,1,0;
% 0,2,0;    1,2,0;	2,2,0;	3,2,0;	4,2,0;
% 0,3,0;	1,3,0;	2,3,0;	3,3,0;	4,3,0;
% 0,4,0;	1,4,0;	2,4,0;	3,4,0;	4,4,0;    ];

%big pyramid
% S=[ 	
% 0,0,0;	1,0,0;	2,0,0;	3,0,0;	4,0,0;
% 0,1,0;	1,1,0;	2,1,0;	3,1,0;	4,1,0;
% 0,2,0;    1,2,0;	2,2,0;	3,2,0;	4,2,0;
% 0,3,0;	1,3,0;	2,3,0;	3,3,0;	4,3,0;
% 0,4,0;	1,4,0;	2,4,0;	3,4,0;	4,4,0;
% 
% 1,1,1;	2,1,1;	3,1,1;
% 1,2,1;	2,2,1;	3,2,1;
% 1,3,1;	2,3,1;	3,3,1;
% 
% 2,2,2;
% ];

%small pyramid
% S=[ 	
% 0,0,0;	1,0,0;	2,0,0;
% 0,1,0;    1,1,0;	2,1,0;
% 0,2,0;    1,2,0;	2,2,0;
% 
% 0,1,1;	1,1,1;	2,1,1;
% 
% 1,1,2;
% ];

%letter G
% S=[ 	
% 0,0,0;  1,0,0;  2,0,0;	3,0,0;	4,0,0;
% 0,1,0;	      	    	    	4,1,0;
% 0,2,0;	     	2,2,0;	    	4,2,0;
% 0,3,0;	    	2,3,0;	3,3,0;	4,3,0;
% 0,4,0;
% 0,5,0;	     	
% 0,6,0;	1,6,0;	2,6,0;	3,6,0;	4,6,0;
% ];

%a bench
S=[ 	
0,0,0;  1,0,0;  2,0,0;	3,0,0;	4,0,0;
0,1,0;	1,1,0;	2,1,0;	3,1,0;	4,1,0;
0,2,0;	1,2,0;	2,2,0;	3,2,0;	4,2,0;
0,3,0;	1,3,0;	2,3,0;	3,3,0;	4,3,0;
0,4,0;	1,4,0;	2,4,0;	3,4,0;	4,4,0;

0,0,1;  1,0,1;	2,0,1;	3,0,1;  4,0,1;	
0,1,1;	1,1,1;	2,1,1;	3,1,1;	4,1,1;
0,2,1;  1,2,1;	2,2,1;	3,2,1;	4,2,1;
0,3,1;	1,3,1;	2,3,1;	3,3,1;	4,3,1;
	
0,0,2;	1,0,2;	2,0,2;	3,0,2;	4,0,2;
0,1,2;	1,1,2;	2,1,2;	3,1,2;	4,1,2;
0,2,2;	1,2,2;	2,2,2;	3,2,2;	4,2,2;
0,3,2;	1,3,2;	2,3,2;	3,3,2;	4,3,2;

0,0,3;	1,0,3;	2,0,3;  3,0,3;  4,0,3;	
0,1,3;                          4,1,3;	
0,2,3;                          4,2,3;	
0,3,3;                          4,3,3;	
	
0,0,4;	1,0,4;	2,0,4;  3,0,4;  4,0,4;	
0,1,4;                          4,1,4;	
0,2,4;                          4,2,4;	
0,3,4;                          4,3,4;	

0,0,5;	1,0,5;	2,0,5;  3,0,5;  4,0,5;	
0,1,5;                          4,1,5;	
0,2,5;                          4,2,5;	
0,3,5;                          4,3,5;
];

%pole
% S=[ 	
% 0,0,0;	1,0,0;	2,0,0;	3,0,0;	4,0,0;
% 0,1,0;	1,1,0;	2,1,0;	3,1,0;	4,1,0;
% 0,2,0;    1,2,0;	2,2,0;	3,2,0;	4,2,0;
% 0,3,0;	1,3,0;	2,3,0;	3,3,0;	4,3,0;
% 0,4,0;	1,4,0;	2,4,0;	3,4,0;	4,4,0;
% 
% 1,1,1;	2,1,1;	3,1,1;
% 1,2,1;	2,2,1;  3,2,1;
% 1,3,1;	2,3,1;	3,3,1;
% 
% 1,1,2;	2,1,2;	3,1,2;
% 1,2,2;	2,2,2;  3,2,2;
% 1,3,2;	2,3,2;	3,3,2;
% 
% 1,1,3;	2,1,3;	3,1,3;
% 1,2,3;	2,2,3;  3,2,3;
% 1,3,3;	2,3,3;	3,3,3;
% 
% 1,1,4;	2,1,4;	3,1,4;
% 1,2,4;	2,2,4;  3,2,4;
% 1,3,4;	2,3,4;	3,3,4;
% 
% 1,1,5;	2,1,5;	3,1,5;
% 1,2,5;	2,2,5;  3,2,5;
% 1,3,5;	2,3,5;	3,3,5;
% 
% 1,1,6;	2,1,6;	3,1,6;
% 1,2,6;	2,2,6;  3,2,6;
% 1,3,6;	2,3,6;	3,3,6;
% 
% 1,1,7;	2,1,7;	3,1,7;
% 1,2,7;	2,2,7;  3,2,7;
% 1,3,7;	2,3,7;	3,3,7;
% ];

%Seeds for chair
Seed_S=[ 0,0,0; 0,0,1;  0,0,2;  0,0,3;  0,0,4;  0,0,5;]; %aligned one over the other
% Seed_S=[ 0,0,0; 4,0,1;  0,0,2;  4,0,3;  0,0,4;  4,0,5;]; %each one on a side

%Seeds for pyramid
% Seed_S=[0,0,0;0,1,1;1,1,2;];
% Seed_S=[0,0,0;2,1,1;1,1,2;];

block_size=0.1;
L=max(S(:,3))+1;

for j=1:size(S,1)
    S(j,3)=S(j,3)+0.5;
end
S=S*block_size;

%Plotting structure
% for j=1:size(S,1)
%     sx=S(j,1);sy=S(j,2);sz=S(j,3)-block_size/2;
%     plot3([sx-block_size/2 sx+block_size/2],[sy-block_size/2 sy-block_size/2],[sz sz],'r', 'linewidth',1); hold on;
%     plot3([sx-block_size/2 sx+block_size/2],[sy+block_size/2 sy+block_size/2],[sz sz],'r', 'linewidth',1);
%     plot3([sx-block_size/2 sx-block_size/2],[sy-block_size/2 sy+block_size/2],[sz sz],'r', 'linewidth',1);
%     plot3([sx+block_size/2 sx+block_size/2],[sy-block_size/2 sy+block_size/2],[sz sz],'r', 'linewidth',1);
% end
% 

%% 3D - N nodes
N=size(S,1);       % Nodes in the network, cardinallity of vertex set
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
x(:,i)=[ block_size*2; -block_size*2; block_size/2; 0;0;0];  
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
record_video=false;
export_figures=true;
plot_landed_definitively=true;
% figure('units','normalized','outerposition',[0.43 0.25 0.28 0.98]); record_video=0;
% figure('units','normalized','outerposition',[1.00 0.25 0.65 1.40]); record_video=1;
% figure('units','normalized','outerposition',[0.43 0.50 0.28 0.50]); %dell monitor, home, top left 
% figure('units','normalized','outerposition',[0.047767857142857,0.048125,0.277678571428571,0.535625])% ft_size=40; %figure_to_export lab with vertical monitor
figure('units','normalized','outerposition',[0.049107142857143,0.00125,0.224107142857143,0.631875]); ft_size=40; %figure_to_export laptop + screen home
% figure('units','normalized','outerposition',[1.50 0.20 0.30 0.50]); %FIGURE MAC
                                               
% view(135,30);
view(-135,30);

grid on;
% axis([-0.2 0.6 -0.2 0.6 0 0.8])
axis([-2 7 -2 7 0 9]*block_size)
hold on
xlabel('X_B', 'fontsize', 20)
ylabel('Y_B', 'fontsize', 20)
zlabel('Z_B', 'fontsize', 20 )
drawnow
pause(0.5)

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
    nodeVars(i).displacement=[0;0;0];
    nodeVars(i).initial=[0 0 0];
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
dt=0.1;
objects_in_fig=[];
now=2.4;
szframe=[];
pin=4;                      
circling=[[ block_size; 0;0],[ 0;-block_size;0],[-block_size; 0;0],[ 0; block_size;0],[ 0; 0; block_size]];
simulate_dynamics=false;
sim_end=9999;
seeking_lowenergy=false;
hist_state=[];hist_selected_grad=[];


[Xs,Ys,Zs] = sphere(4);
r = 0.03; Xs = Xs * r; Ys = Ys * r; Zs = Zs * r;

% x(:,1,1)=[S(13,1);S(13,2);block_size/2;0;0;0];
x(:,1,1)=[Seed_S(1,1)*block_size;Seed_S(1,2)*block_size;block_size/2;0;0;0];
if plot_landed_definitively; Auxiliar.block3d(x(1,1,1),x(2,1,1),x(3,1,1),'grey'); end

% surf(Xs+x(1,1,1),Ys+x(2,1,1),Zs+x(3,1,1)+0.75);

for j=1:L
    comm_channel_seed(j).IN=0;
    comm_channel_seed(j).OUT=0;
end
% clear
% load state_assembly.mat
% t=t-dt;


if record_video
    v = VideoWriter(strcat('SelfAssembly_',num2str(N),'nodes.avi'));
    v.FrameRate=5;
    open(v);
end
count=0;


%% Simulation Loop
for t=dt:dt:2000
% while t<6000
% t=t+dt;
    tic
    k=round(t/dt);

    objects_in_fig=[];
    clc;
    %view(mod(round(k*4),360),30);
    
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

%     test1=tic;
%     %checking connections of already landed nodes
%     for i=1:N
%         %who is close (therefore, connected)
%         for j=1:N
%             %In a real scenario, I would not iterate through all vehicles, 
%             %but through all sensors to see "who" am I seeing
%             if i~=j &&  nodeVars(i).state == 6 &&  nodeVars(j).state == 6
%                 if norm(x(1:n-1,i,k)-x(1:n-1,j,k),2)<=1.4*block_size ... %node is close
%                    && Adif(i,j)==0 %node is not connected
%                     [ Adif, hops_graph ] = Auxiliar_DynNet.change_net_topology_add(Adif,i,j);
%                 end
%                 if norm(x(1:n,i,k)-x(1:n,j,k),2)>1.4*block_size ... %node is not close
%                    && Adif(i,j)==1 %node is connected
%                     [ Adif, hops_graph ] = Auxiliar_DynNet.change_net_topology_remove(Adif,i,j);
%                 end
%                 if Adif(i,j)==1 && i>j 
%                     %uncomment for black line
%                     objects_in_fig=[objects_in_fig,plot3([x(1,i,k) x(1,j,k)],[x(2,i,k) x(2,j,k)], [x(3,i,k) x(3,j,k)]+0.75, 'k','linewidth',1)]; 
%                     % if norm(x(1:n,i,k)-x(1:n,j,k),2)>d  objects_in_fig=[objects_in_fig,text((x(1,i,k)+x(1,j,k))/2,(x(2,i,k)+x(2,j,k))/2,num2str(norm(x(1:n,i,k)-x(1:n,j,k),2)))];end
%                 end
%             end
%         end
%     end
%     toc(test1)

    %creating the neighbours vector for each node
%     test2=tic;
%     for i=1:N
%         nodeVars(i).neighGrad=[];
%         nodeVars(i).neighState=[];
%         nodeVars(i).neighId=[];
%         nodeVars(i).neighVal=[];
%         for j=1:N
%             if i~=j && A(i,j)~=0
% %                 disp([i j nodeVars(j).gradient])
%                 nodeVars(i).neighGrad=[nodeVars(i).neighGrad,nodeVars(j).gradient];
%                 nodeVars(i).neighState=[nodeVars(i).neighState,nodeVars(j).state];
%                 nodeVars(i).neighId=[nodeVars(i).neighId,nodeVars(j).id];
%                 if j==nodeVars(i).CEFRid
%                     nodeVars(i).CEFRgradient = nodeVars(j).gradient;
%                 end
%             end
%             if Adif(i,j)==1
%                 nodeVars(i).neighVal=[nodeVars(i).neighVal,nodeVars(j).val];
%             end
%         end
%     end
%     toc(test2)
    % ----- Sensing END ------
    
   
    for i=1:N
    % Figure plot
    % ---------------
        switch nodeVars(i).state
            case 1
%                 objects_in_fig=[objects_in_fig,Auxiliar.block3d(x(1,i,k),x(2,i,k),x(3,i,k),'grey')];
%                 objects_in_fig=[objects_in_fig,text(x(1,i,k)-0.01,x(2,i,k),x(3,i,k)+block_size/2+0.01,num2str(i))];
            case 2
                objects_in_fig=[objects_in_fig,Auxiliar.block3d(x(1,i,k),x(2,i,k),x(3,i,k),'red')];
            case 3
                objects_in_fig=[objects_in_fig,Auxiliar.block3d(x(1,i,k),x(2,i,k),x(3,i,k),'magenta')];
            case 4
                objects_in_fig=[objects_in_fig,Auxiliar.block3d(x(1,i,k),x(2,i,k),x(3,i,k),'blue')];
            case 5
                objects_in_fig=[objects_in_fig,Auxiliar.block3d(x(1,i,k),x(2,i,k),x(3,i,k),'grey')];
            case 6
                if ~plot_landed_definitively; objects_in_fig=[objects_in_fig,Auxiliar.block3d(x(1,i,k),x(2,i,k),x(3,i,k),'grey')]; end
        end
%         if nodeVars(i).state~=1; objects_in_fig=[objects_in_fig,text(x(1,i,k),x(2,i,k),x(3,i,k)+block_size/2+0.02, ...
%                                     sprintf('%.0f',nodeVars(i).gradient),'FontSize',8,'HorizontalAlignment','center')]; end
    end
    % % % colors of blocks

    
    title(strcat('t=',num2str(k)))
%     title(strcat('t=',num2str(t),'s'))
    %I am going to simulate each agent in a parallel manner
    %this is good because it forces me to treat each one of them as an
    %individual that do not share information.
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
                if k ==10*i %is it my turn to move to the seed?
                    %objects_in_fig = Auxiliar_SelfAssembly.plot_line_3d(objects_in_fig, posi, actual_x(1:3,landedNodeID), 'k', 1);
                    nodeVars(i).state=2; %goes to descent stage
                    nodeVars(i).goalPos=block_size*(Seed_S(1,:)'+[0;0;0.5]);%= actual_x(1:n,1)+[-1;-1;0]*block_size; %position of the landed node
                    nodeVars(i).seedPos=block_size*(Seed_S(1,:)'+[0;0;0.5]);%=actual_x(1:n,1);
                    nodeVars(i).CEFRposition=block_size*(Seed_S(1,:)'+[0;0;0.5]);%actual_x(1:n,1); %position of the landed node
                    nodeVars(i).CEFRid=1;
                    nodeVars(i).CEFRcirclingPos=1;
                    nodeVars(i).displacement=[0;0;0];%[-1;-1;2]*block_size;
                end
                
                %u(3)= u(3) + kp*(1 - posi(3)) + kv*(-veli(3));
                
            case 2
                % ---- DESCEND ---- 
                %at this point, the goal position should be the s1 position
                %plot line
% % %                     objects_in_fig = Auxiliar_SelfAssembly.plot_line_3d(objects_in_fig, posi, nodeVars(i).CEFRposition, 'g', 1.5);
                hist_selected_grad=[];

                %compute control
                u= kp*(nodeVars(i).goalPos - posi) + kv*(-veli); 
                u=(0.01*randn+1)*u;% a little noise in the control just to avoid having ideal values in this stage. 

                %State Transition
                %approached placed block - if $|p_t(i) - p_t(j*)|<d*$. That means that the arriving block is close enough of a placed block. 
                count=count+1;
                min_d=1.4*block_size; %sqrt(3)*block_size*1.1;
                if norm((posi-(nodeVars(i).goalPos+nodeVars(i).displacement)),2) <= min_d
                    %I am close to the seed, 
                    layer=round((posi(3)/block_size)+0.5);
                    if comm_channel_seed(layer).OUT==0
                        %no message to me
                        if comm_channel_seed(layer).IN==0
                            comm_channel_seed(layer).IN=1;
                        else
                            %but I already sent something, no one in this channel, I am the seed.
                            nodeVars(i).goalPos=nodeVars(i).seedPos;
                            nodeVars(i).counterNodesThisLayer=nodeVars(i).counterNodesThisLayer+1;
                            nodeVars(i).amIseed=true;
                            nodeVars(i).state=5; %goes to landing
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
                        
                        [theta,rho] = cart2pol(posi(1)-nodeVars(i).seedPos(1),posi(2)-nodeVars(i).seedPos(2));
                        nodeVars(i).initial=[theta,rho,1];
                        
                        nodeVars(i).state=3; %goes to edge following stage             
                        positions_aroundseed=[nodeVars(i).CEFRposition+circling(:,1),nodeVars(i).CEFRposition+circling(:,2),nodeVars(i).CEFRposition+circling(:,3),nodeVars(i).CEFRposition+circling(:,4)];
                        for iter=1:4
                            if sum(abs(positions_aroundseed(:,iter)-posi)) < block_size
                                break;
                            end
                        end
                        nodeVars(i).goalPos=nodeVars(i).CEFRposition+circling(:,iter);
                        nodeVars(i).CEFRcirclingPos=iter;
%                         number_of_free=0;
%                         for l=1:4
%                             candidate_goal=nodeVars(i).CEFRposition+circling(:,l);
%                             [is_candidate_free,id]=Auxiliar_SelfAssembly.check_position_free(candidate_goal,actual_x);
%                             %objects_in_fig = Auxiliar_SelfAssembly.plot_line_3d(objects_in_fig, posi, candidate_goal, 'k', 1);
%                             if is_candidate_free
%                                 if norm(posi-candidate_goal,2)<=norm(posi-nodeVars(i).goalPos,2)
%                                     nodeVars(i).CEFRcirclingPos=l;
%                                     nodeVars(i).goalPos=candidate_goal;
%                                 end
%                                 number_of_free=number_of_free+1;
%                             end
%                         end

%                         [theta,rho] = cart2pol(posi(1)-actual_x(1,1),posi(2)-actual_x(2,1));
%                         nodeVars(i).initialAngle=rad2deg(wrapTo2Pi(theta));
%                         nodeVars(i).displacement(3)=3*block_size+nodeVars(i).CEFRposition(3);

                        direction=1;
%                         if rand <0.5; direction=-1; else direction=1; end  
                    end
                end  
                
                if ~simulate_dynamics
%                     actual_x(1:n,i)=nodeVars(i).goalPos+nodeVars(i).displacement;
                    dist=round((posi-(nodeVars(i).goalPos+nodeVars(i).displacement))/block_size);
                    if  sum(abs(dist))>1 %1 means I am adjacent to a see %At least I need to go somewhere
                        if dist(3)==0
                            %MOVE.EXT() moving on external vertices
                            destination=nodeVars(i).goalPos+nodeVars(i).displacement;
                            vect=(destination-posi);% vector pointing to desitnation
                            vect=vect/block_size; %vect in the grid

                            nodeVars(i).axis_to_move=~nodeVars(i).axis_to_move;
                            if nodeVars(i).axis_to_move
                                %try X                        
                                my_pos_in_grid=(posi-nodeVars(i).displacement)/block_size - [0;0;0.5];
                                next_pos_in_grid=round(my_pos_in_grid+[sign(vect(1));0;0]);
                            else
                                %try Y
                                my_pos_in_grid=(posi-nodeVars(i).displacement)/block_size - [0;0;0.5];
                                next_pos_in_grid=round(my_pos_in_grid+[0;sign(vect(2));0]);
                            end
                            %is in the blueprint?
                            %is it the seed?
                            I = sum(Seed_S(:,1)==next_pos_in_grid(1) & Seed_S(:,2)==next_pos_in_grid(2) & Seed_S(:,3)==next_pos_in_grid(3) );
                            if I==1
                                %Awesome, found the seed.
                            else
                                %not the seed, is it in the grid at least
                                if Auxiliar_SelfAssembly.check_position_inside_structure(block_size*(next_pos_in_grid+[0;0;0.5]),S)
                                    %It is in the grid but not the seed, dont go there
                                else
                                    %not the seed, not in the grid, external, good, move here.
                                   actual_x(1:n,i)=(next_pos_in_grid+[0;0;0.5])*block_size+nodeVars(i).displacement;
                                   if norm(actual_x(1:n,i)-(posi+[0;0;block_size*vect(3)/abs(vect(3))]),2)>block_size/2; nodeVars(i).MOVE_count=nodeVars(i).MOVE_count+1;end
                                end
                            end
                        else
                            %move on height
                            destination=nodeVars(i).goalPos+nodeVars(i).displacement;
                            vect=(destination-posi);
                            if norm(actual_x(1:n,i)-(posi+[0;0;block_size*vect(3)/abs(vect(3))]),2)>block_size/2; nodeVars(i).MOVE_count=nodeVars(i).MOVE_count+1;end
                            actual_x(1:n,i)=posi+[0;0;block_size*vect(3)/abs(vect(3))];
                        end
                    end
                    actual_x(n+1:n+n,i)=[0;0;0];
                    u=u*0;
                end
                
            case 3
                % --- Edge following algorithm outside                
                %Plot the position to where I am going
%                 objects_in_fig=[objects_in_fig,surf(Xs+nodeVars(i).goalPos(1),Ys+nodeVars(i).goalPos(2),Zs+nodeVars(i).goalPos(3))];
%                 to=[nodeVars(i).goalPos(1);nodeVars(i).goalPos(2);nodeVars(i).goalPos(3)+nodeVars(i).displacement(3)];
%                 objects_in_fig = Auxiliar_SelfAssembly.plot_line_3d(objects_in_fig, nodeVars(i).goalPos, to, 'b', 1.5);
%                 objects_in_fig = Auxiliar_SelfAssembly.plot_line_3d(objects_in_fig, nodeVars(i).goalPos, nodeVars(i).CEFRposition, 'b', 1.5);
                
                u = 0.5*kp*(nodeVars(i).goalPos+nodeVars(i).displacement - posi) + kv*(-veli);
                
                i_am_inside_S=Auxiliar_SelfAssembly.check_position_inside_structure(posi-nodeVars(i).displacement,S);
                
                if norm(((nodeVars(i).goalPos+nodeVars(i).displacement) - posi),2) <= 0.01 
                    [theta,rho] = cart2pol(posi(1)-nodeVars(i).seedPos(1),posi(2)-nodeVars(i).seedPos(2));
                    
                    %entered a valid position
                    if i_am_inside_S
                        nodeVars(i).state=4;
                        nodeVars(i).vel=[0;0];
                    elseif abs(norm([theta,rho]-nodeVars(i).initial(1:2),2))<0.01 && nodeVars(i).initial(3)==0
                        %the circling is to guarantee that I have a node to go to.
                        %just spin around    
                        layer=round((posi(3)/block_size)+0.5);
                        nodeVars(i).goalPos=block_size*(Seed_S(layer+1,:)'+[0;0;0.5]);%=comm_channel_seed(layer).OUT+[-1;-1;0]*block_size;
                        nodeVars(i).seedPos=block_size*(Seed_S(layer+1,:)'+[0;0;0.5]);%=comm_channel_seed(layer).OUT;
                        nodeVars(i).CEFRposition=nodeVars(i).seedPos;    
                        nodeVars(i).state=2;
                    else
                        nodeVars(i).initial(3)=0;
                        
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
                                is_pos_inside(j)=Auxiliar_SelfAssembly.check_position_inside_structure(positions_to_test(:,j),S);
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
                                        if is_pos_free(j) && Auxiliar_SelfAssembly.check_position_inside_structure(nextGoalPosition,S) 
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
                        %hist_selected_grad=[hist_selected_grad,[nodeVars(i).state;I(j);gradssorted(j)]];
                    end
                end
                vect=(nodeVars(i).goalPos-posi);
                objects_in_fig = [objects_in_fig,quiver3(posi(1),posi(2),posi(3)+block_size*0.6,vect(1),vect(2),vect(3), 'LineWidth',1.5,'MaxHeadSize',0.9, 'Color', 'b')];
                        
                if ~simulate_dynamics && nodeVars(i).state ~=2
                    if norm(actual_x(1:n,i)-(nodeVars(i).goalPos+nodeVars(i).displacement),2)>block_size/2; nodeVars(i).MOVE_count=nodeVars(i).MOVE_count+1;end
                    actual_x(1:n,i)=nodeVars(i).goalPos+nodeVars(i).displacement;
                    actual_x(n+1:n+n,i)=[0;0;0];
                    u=u*0;
                end
                
            case 4
                % --- Edge following inside
                %Am I going to exit the structure
                %I have not decided how S looks like yet, I will suppose it
                %is a list

                %Plot the position to where I am going  
% %                 objects_in_fig=[objects_in_fig,surf(Xs+nodeVars(i).goalPos(1),Ys+nodeVars(i).goalPos(2),Zs+nodeVars(i).goalPos(3))];
% %                 to=[nodeVars(i).goalPos(1);nodeVars(i).goalPos(2);nodeVars(i).goalPos(3)+nodeVars(i).displacement(3)];
% %                 objects_in_fig = Auxiliar_SelfAssembly.plot_line_3d(objects_in_fig, nodeVars(i).goalPos, to, 'b', 1.5);
% %                 objects_in_fig = Auxiliar_SelfAssembly.plot_line_3d(objects_in_fig, nodeVars(i).goalPos, nodeVars(i).CEFRposition, 'b', 1.5);
                
                u = 0.5*kp*(nodeVars(i).goalPos+nodeVars(i).displacement - posi) + kv*(-veli);
                
                if i==1
                    nodeVars(i).state=5;
                elseif norm((nodeVars(i).goalPos+nodeVars(i).displacement - posi),2) <= 0.01 %entered a valid position
                    
                    %nodeVars(i).circlingPos is the position the clock that I am right now                
                    %now I have to compute if the next position is available
                    % actualGoalPosition=nodeVars(i).goalPos; %should be the same as posi
                    
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
                        
%                         % --- plotting in order ---
%                         objects_in_fig = Auxiliar_SelfAssembly.plot_line_3d(objects_in_fig, nodeVars(i).goalPos, my_actual_position_east, 'b', 1);
%                         objects_in_fig = Auxiliar_SelfAssembly.plot_line_3d(objects_in_fig, nodeVars(i).goalPos, my_actual_position_south, 'b', 1);
%                         objects_in_fig = Auxiliar_SelfAssembly.plot_line_3d(objects_in_fig, nodeVars(i).goalPos, my_actual_position_west, 'b', 1);
%                         objects_in_fig = Auxiliar_SelfAssembly.plot_line_3d(objects_in_fig, nodeVars(i).goalPos, my_actual_position_north, 'b', 1);
%                         % ----------------------
                        
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
                            is_pos_inside(j)=Auxiliar_SelfAssembly.check_position_inside_structure(positions_to_test(:,j),S);
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

%                         grads(1) = grads(1)-nodeVars(i).vel(2);
%                         grads(2) = grads(2)-nodeVars(i).vel(1)*0.7-nodeVars(i).vel(2)*0.7;
%                         grads(3) = grads(3)-nodeVars(i).vel(1);
%                         grads(4) = grads(4)-nodeVars(i).vel(1)*0.7-nodeVars(i).vel(2)*0.7;
%                         grads(5) = grads(5)-nodeVars(i).vel(2);
%                         grads(6) = grads(6)-nodeVars(i).vel(1)*0.7-nodeVars(i).vel(2)*0.7;
%                         grads(7) = grads(7)-nodeVars(i).vel(1);
%                         grads(8) = grads(8)-nodeVars(i).vel(1)*0.7-nodeVars(i).vel(2)*0.7;
%                         grads(9) = grads(9)-nodeVars(i).vel(2);

                        [gradssorted,I] = sort(grads);
                        % -------------------------
                        if gradssorted(1)<=CEG && gradssorted(1)<1000
                            for j=1:length(I)
                                if gradssorted(j)>1000
                                    %I am already searching things that I should not, stop.
                                    nodeVars(i).state=5;
                                    break;
                                end
                                nextGoalPosition=positions_to_test(:,I(j));
                                nodeVars(i).goalPos=nextGoalPosition;
%                                 objects_in_fig = Auxiliar_SelfAssembly.plot_line_3d(objects_in_fig, posi, nextGoalPosition, 'b', 1.5);
                                nodeVars(i).vel(2)=mu*nodeVars(i).vel(2) - eps*delta_function(1);
                                break;
                            end
                            if  nodeVars(i).state~=5
                                    %I am already searching things that I should not, stop.
                                nodeVars(i).goalPos=nextGoalPosition;
                                nodeVars(i).CEFRcirclingPos=nextCirclingPos;
                            end
                        else
                            nodeVars(i).state=5;
                        end 
                        hist_selected_grad=[hist_selected_grad,[nodeVars(i).state;I(j);gradssorted(j)]];
                end
                if ~simulate_dynamics    
                    if norm(actual_x(1:n,i)-(nodeVars(i).goalPos+nodeVars(i).displacement),2)>block_size/2; nodeVars(i).MOVE_count=nodeVars(i).MOVE_count+1; end
                
                    actual_x(1:n,i)=nodeVars(i).goalPos+nodeVars(i).displacement;
                    actual_x(n+1:n+n,i)=[0;0;0];
                    u=u*0;
                end
                
            case 5
                %lading state
                from=nodeVars(i).goalPos.*[1;1;0];
% % %                 objects_in_fig = Auxiliar_SelfAssembly.plot_line_3d(objects_in_fig, from, nodeVars(i).goalPos, 'g', 1.5); 
                [free, id]=Auxiliar_SelfAssembly.check_position_free(nodeVars(i).goalPos,actual_x);
                if ~free
                    %first occurence
                    actual_x2=actual_x;
                    actual_x2(:,id)=[];
                    [free, id]=Auxiliar_SelfAssembly.check_position_free(nodeVars(i).goalPos,actual_x2);
                    if ~free
                        %second block on the same position, something wrong
                        pause(0.1)
                    end
                end
                
%                 %check if I can land in a lower height
%                 [is_down_free, id_down]=Auxiliar_SelfAssembly.check_position_free(nodeVars(i).goalPos-[0;0;block_size],actual_x);
%                 if is_down_free
%                     %bad sign, below is empty
%                     if Auxiliar_SelfAssembly.check_position_inside_structure(nodeVars(i).goalPos-[0;0;block_size],S)
%                         nodeVars(i).goalPos=nodeVars(i).goalPos-[0;0;block_size];
%                     end
%                 end
                
                level=round((nodeVars(i).goalPos(3)/block_size)-0.5);
                nodeVars(i).goalPos(3)=(level+0.5)*block_size;
                
                %rouding to block height
                %nodeVars(i).goalPos(3)=(round((nodeVars(i).goalPos(3)/block_size)-0.5)+0.5)*block_size;
                u = 0.5*kp*(nodeVars(i).goalPos - posi) + kv*(-veli);

                if norm((nodeVars(i).goalPos - posi),2) <= 0.01 %arrived at the destination
                    nodeVars(i).state=6;
                    if plot_landed_definitively; Auxiliar.block3d(actual_x(1,i),actual_x(2,i),actual_x(3,i),'grey'); end
%                     surf(Xs+nodeVars(i).goalPos(1),Ys+nodeVars(i).goalPos(2),Zs+nodeVars(i).goalPos(3)+0.75);
                    count=0;
                end
                
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
                        %give to it a rotation matrix
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
                    nodeVars(i).gradient=Auxiliar_SelfAssembly.compute_gradient_layer_MD(posi,block_size,nodeVars(i).seedPos) ;
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
    
    for i=1:N
%         new_x(:,i) = [posi + dt*veli + ((dt^2)/2)*u; veli + dt*u];
        new_x(:,i) = [actual_x(1:n,i) + dt*actual_x(n+1:n+n,i) + ((dt^2)/2)*all_u(:,i); actual_x(n+1:n+n,i) + dt*all_u(:,i);];
        if norm(new_x(n+1:n+n,i),2) > 1
            %saturate the vel
            new_x(n+1:n+n,i) = new_x(n+1:n+n,i)/norm(new_x(n+1:n+n,i),2);
        end
    end
    
    x(:,:,k+1)=new_x;
    
   proc_time=toc;
   fprintf("processing time = %.3f | actual t = %.1f\n",proc_time,t); 

   if record_video || export_figures
        if t>=now
            drawnow
            pause(0.05);
            if record_video
                frame=getframe;
                if isempty(szframe)
                    szframe=size(frame.cdata)-2;
                end
                frame.cdata=frame.cdata(1:szframe(1),1:szframe(2),1:3);
                writeVideo(v,frame);
                now=t+0.1;
            elseif export_figures
                padding=''; if k<10; padding='00'; elseif k<100; padding='0'; elseif k>=100; padding=''; end
                ax = gca;
                ax.XTickLabel=[{-2},{0},{2},{4},{6}];
                ax.YTickLabel=[{-2},{0},{2},{4},{6}];
                ax.ZTickLabel=[{0},{2},{4},{6},{8}];
                ax.FontSize=ft_size;
                %%print(strcat('chair_',z,num2str(k)),'-dpng')
                                
                % Requires R2020a or later

%                 av_x=[1;0;0];
%                 av_y=[0;1;0];
%                 av_z=[0;0;1];
%                 objects_in_fig=[objects_in_fig,quiver3(x(1,1,1), x(2,1,1), x(3,1,1), av_x(1)*0.2,av_x(2)*0.2,av_x(3)*0.2, 'LineWidth',2, 'color', 'blue', 'MaxHeadSize', 1/0.2)]
%                 objects_in_fig=[objects_in_fig,quiver3(x(1,1,1), x(2,1,1), x(3,1,1), av_y(1)*0.2,av_y(2)*0.2,av_y(3)*0.2, 'LineWidth',2, 'color', 'blue', 'MaxHeadSize', 1/0.2)]
%                 objects_in_fig=[objects_in_fig,quiver3(x(1,1,1), x(2,1,1), x(3,1,1), av_z(1)*0.2,av_z(2)*0.2,av_z(3)*0.2, 'LineWidth',2, 'color', 'blue', 'MaxHeadSize', 1/0.2)]
                
                exportgraphics(ax,strcat('chair_',padding,num2str(round(k)), '.png'),'Resolution',300) %this removes empty spaces around the figure
                now=t+2.1;
            end
        end
    else
       if t>=now
            now=t+10;
            drawnow
            pause(0.1);
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
            if record_video
                %view(mod(round((t-sim_end)/dt)+135,360),30);
%                 if t-sim_end>5
                   break;   
%                 end
            else
                break;
            end
        end
    end
    
    delete(objects_in_fig)
end

if record_video
    close(v);
    pause(1);
    command = sprintf('ffmpeg -i %s -vf "pad=ceil(iw/2)*2:ceil(ih/2)*2" -vcodec libx264 -acodec aac %s && rm %s ', v.Filename,strcat('SelfAssembly_',num2str(N),'nodes.mp4') ,v.Filename);
    system(command);
end

MOVECOUNT=[]; for i=1:N; MOVECOUNT(i)=nodeVars(i).MOVE_count; end
% figure, plot(MOVECOUNT)
moves=[mean(MOVECOUNT), std(MOVECOUNT), max(MOVECOUNT)];
%  fileID = fopen('textfile.txt', 'a');
%  fprintf(fileID, '%f %f %f \n', moves);
%  fclose(fileID);
 

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
    

%% edge following outside considering 9 positions
%                 % --- Edge following algorithm outside                
%                 %Plot the position to where I am going
%                 objects_in_fig=[objects_in_fig,surf(Xs+nodeVars(i).goalPos(1),Ys+nodeVars(i).goalPos(2),Zs+nodeVars(i).goalPos(3))];
%                 to=[nodeVars(i).goalPos(1);nodeVars(i).goalPos(2);nodeVars(i).goalPos(3)+nodeVars(i).displacement(3)];
%                 objects_in_fig = Auxiliar_SelfAssembly.plot_line_3d(objects_in_fig, nodeVars(i).goalPos, to, 'b', 1.5);
%                 objects_in_fig = Auxiliar_SelfAssembly.plot_line_3d(objects_in_fig, nodeVars(i).goalPos, nodeVars(i).CEFRposition, 'b', 1.5);
%                 
%                 u = 0.5*kp*(nodeVars(i).goalPos+nodeVars(i).displacement - posi) + kv*(-veli);
%                 
%                 i_am_inside_S=Auxiliar_SelfAssembly.check_position_inside_structure(posi-nodeVars(i).displacement,S);
%                 if norm(((nodeVars(i).goalPos+nodeVars(i).displacement) - posi),2) <= 0.01 
%                     [theta,rho] = cart2pol(posi(1)-actual_x(1,1),posi(2)-actual_x(2,1));
%                     theta=rad2deg(wrapTo2Pi(theta));
%                     %disp([ theta, nodeVars(i).initialAngle, abs(theta-nodeVars(i).initialAngle), round(theta/5)]);
%                     %disp(round(rad2deg(wrapTo2Pi(theta))/5));
%                     
%                     %entered a valid position
%                     if i_am_inside_S
%                         nodeVars(i).state=4;
%                         nodeVars(i).vel=[0;0];
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
%                             circling_pos=5;
%                             nodeVars(i).onTOP=true;
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
%                     else
%                         is_first=0;
%                         
%                         % --- computing the positions ---
%                         %bottom up positions
%                         %default is circling on the same layer
%                         nextCirclingPos = Auxiliar_SelfAssembly.next_circling(nodeVars(i).CEFRcirclingPos,direction*1);
%                         nextGoalPosition=nodeVars(i).CEFRposition+circling(:,nextCirclingPos); 
%                         my_actual_position=nodeVars(i).goalPos;
%                         
%                         %Checking 1 position below me
%                         straight_down=my_actual_position; %pos 1
%                         straight_down(3)=((round((my_actual_position(3)/block_size)-0.5)-1)+0.5)*block_size;
%                         front_pos=nextGoalPosition+circling(:,Auxiliar_SelfAssembly.next_circling(nextCirclingPos,-1*direction)); %pos 3
%                         diag_down= front_pos-[0;0;block_size]; % pos 2
%                         diag_up= front_pos+[0;0;block_size]; %pos 4
%                         straight_up=my_actual_position; %pos 5
%                         straight_up(3)=((round((my_actual_position(3)/block_size)-0.5)+1)+0.5)*block_size;
%                         
%                         nextdown=nextGoalPosition-[0;0;block_size]; % pos 6
%                         circling_same_layer=nextGoalPosition;%pos 7
%                         nextup=circling_same_layer+[0;0;block_size]; %pos 8
%                         CEFRup=nodeVars(i).CEFRposition+circling(:,5); %pos 9                
%                         % --------------------------------
%                         
%                         % --- plotting in order ---
% %                         objects_in_fig = Auxiliar_SelfAssembly.plot_line_3d(objects_in_fig, nodeVars(i).goalPos, straight_down, 'r', 1);
% %                         objects_in_fig = Auxiliar_SelfAssembly.plot_line_3d(objects_in_fig, nodeVars(i).goalPos, diag_down, 'r', 1);
%                         objects_in_fig = Auxiliar_SelfAssembly.plot_line_3d(objects_in_fig, nodeVars(i).goalPos, front_pos, 'r', 1);
% %                         objects_in_fig = Auxiliar_SelfAssembly.plot_line_3d(objects_in_fig, nodeVars(i).goalPos, diag_up, 'r', 1);
% %                         objects_in_fig = Auxiliar_SelfAssembly.plot_line_3d(objects_in_fig, nodeVars(i).goalPos, straight_up, 'r', 1);
% 
% %                         objects_in_fig = Auxiliar_SelfAssembly.plot_line_3d(objects_in_fig, nodeVars(i).goalPos, nextdown, 'k', 1);
%                         objects_in_fig = Auxiliar_SelfAssembly.plot_line_3d(objects_in_fig, nodeVars(i).goalPos, circling_same_layer, 'k', 1);
% %                         objects_in_fig = Auxiliar_SelfAssembly.plot_line_3d(objects_in_fig, nodeVars(i).goalPos, nextup, 'k', 1);
% %                         objects_in_fig = Auxiliar_SelfAssembly.plot_line_3d(objects_in_fig, nodeVars(i).goalPos, CEFRup, 'k', 1);
%                         % ----------------------
%                         
%                         positions_to_test=[straight_down,diag_down,front_pos,diag_up,straight_up,nextdown,circling_same_layer,nextup,CEFRup];
%                         is_pos_free=false(1,size(positions_to_test,2));
%                         id_node=ones(1,size(positions_to_test,2))*-1;
%                         is_pos_inside=false(1,size(positions_to_test,2));
%                         
%                         % --- finding positions free --- 
%                         for j=1:size(positions_to_test,2)
%                             [is_pos_free(j),id_node(j)]=Auxiliar_SelfAssembly.check_position_free(positions_to_test(:,j),actual_x);
%                         end
%                         % ------------------------------
%                         
%                         % --- looking where is inside --- 
%                         for j=1:size(positions_to_test,2)
%                             is_pos_inside(j)=Auxiliar_SelfAssembly.check_position_inside_structure(positions_to_test(:,j),S);
%                         end
%                         % ---------------------------
%                                                 
%                         
%                         % --- finding all grads --- 
%                         grads=ones(1,size(positions_to_test,2))*9999;
%                         for j=1:size(positions_to_test,2)
%                               grads(j)=Auxiliar_SelfAssembly.compute_gradient_MD(positions_to_test(:,j),block_size);
% %                            grads(j) = Auxiliar_SelfAssembly.compute_gradient_Energy(positions_to_test(:,j), block_size, actual_x, nodeVars(i).neighGrad, nodeVars(i).neighId);
%                         end
%                        
%                         %FORCING TO IGNORING UP AND DOWN POSITIONS, SEARCH ON THE SAME LAYER
%                         is_pos_free(1)=false;id_node(1)=-1;is_pos_inside(1)=false;grads(1)=9999;
%                         is_pos_free(2)=false;id_node(2)=-1;is_pos_inside(2)=false;grads(2)=9999;
%                         is_pos_free(4)=false;id_node(4)=-1;is_pos_inside(4)=false;grads(4)=9999;
%                         is_pos_free(5)=false;id_node(5)=-1;is_pos_inside(5)=false;grads(5)=9999;
%                         is_pos_free(6)=false;id_node(6)=-1;is_pos_inside(6)=false;grads(6)=9999;
%                         is_pos_free(8)=false;id_node(8)=-1;is_pos_inside(8)=false;grads(8)=9999;
%                         is_pos_free(9)=false;id_node(9)=-1;is_pos_inside(9)=false;grads(9)=9999;
%                         
%                         CEG=Auxiliar_SelfAssembly.compute_gradient_MD(my_actual_position,block_size);%current expcted grad
%                         delta_function=grads-CEG;
% 
%                         
%                         %this is the code for MOMENTUM                        
% %                         grads(1) = grads(1)-nodeVars(i).vel(2);
% %                         grads(2) = grads(2)-nodeVars(i).vel(1)*0.7-nodeVars(i).vel(2)*0.7;
% %                         grads(3) = grads(3)-nodeVars(i).vel(1);
% %                         grads(4) = grads(4)-nodeVars(i).vel(1)*0.7-nodeVars(i).vel(2)*0.7;
% %                         grads(5) = grads(5)-nodeVars(i).vel(2);
% %                         grads(6) = grads(6)-nodeVars(i).vel(1)*0.7-nodeVars(i).vel(2)*0.7;
% %                         grads(7) = grads(7)-nodeVars(i).vel(1);
% %                         grads(8) = grads(8)-nodeVars(i).vel(1)*0.7-nodeVars(i).vel(2)*0.7;
% %                         grads(9) = grads(9)-nodeVars(i).vel(2);
% 
%                         [gradssorted,I] = sort(grads);
%                         % -------------------------
%                         
%                         %NOTE THAT IAM ACTUALLY ONLY RUNNING POSITIONS 3 AND 7, SAME LAYER
%                         nodeVars(i).onTOP=false;
%                         for j=1:length(I)
%                             switch I(j)
%                                 case 1
%                                     if is_pos_free(1) && is_pos_inside(1) && straight_down(3)>0 %%is_down_free && is_down_inside && straight_down(3)>0 %this is clearly the lowest gradient possible
%                                         node_from_down=nodeVars(i).CEFRposition-[0;0;block_size];
%                                         [free, id_down]=Auxiliar_SelfAssembly.check_position_free(node_from_down,actual_x);%I know it is not free, I just want the ID
%                                         idx_neighV=find(nodeVars(i).neighId==id_down); 
%                                         nodeVars(i).CEFRposition=node_from_down;
%                                         nodeVars(i).CEFRgradient=nodeVars(i).neighGrad(idx_neighV);
%                                         nodeVars(i).CEFRid=id_down;
%                                         nextGoalPosition=nodeVars(i).CEFRposition+circling(:,nextCirclingPos);
%                                         nodeVars(i).goalPos=nextGoalPosition;
% % % %                                         objects_in_fig = Auxiliar_SelfAssembly.plot_line_3d(objects_in_fig, posi, nextGoalPosition, 'b', 1.5);
%                                         
%                                         nodeVars(i).vel(2)=mu*nodeVars(i).vel(2) - eps*delta_function(1);
%                                         break;
%                                     end
%                                 case 2
%                                     if is_pos_free(2) && is_pos_inside(2) && diag_down(3)>0 
%                                         node_from_down=nodeVars(i).CEFRposition-[0;0;block_size];
%                                         node_from_diag_down = node_from_down+circling(:,Auxiliar_SelfAssembly.next_circling(nextCirclingPos,-1*direction));
%                                         [free, id_down]=Auxiliar_SelfAssembly.check_position_free(node_from_diag_down,actual_x);
%                                         objects_in_fig = Auxiliar_SelfAssembly.plot_line_3d(objects_in_fig, posi, node_from_down, 'b', 1.5);
%                                         objects_in_fig = Auxiliar_SelfAssembly.plot_line_3d(objects_in_fig, posi, node_from_diag_down, 'b', 1.5);
% 
%                                         if ~free
%                                             idx_neighV=find(nodeVars(i).neighId==id_down); 
%                                             nodeVars(i).CEFRposition=node_from_diag_down;
%                                             nodeVars(i).CEFRgradient=nodeVars(i).neighGrad(idx_neighV);
%                                             nodeVars(i).CEFRid=id_down;
%                                             nextGoalPosition=positions_to_test(:,2);
%                                             nodeVars(i).goalPos=nextGoalPosition;
%                                             objects_in_fig = Auxiliar_SelfAssembly.plot_line_3d(objects_in_fig, posi, nextGoalPosition, 'b', 1.5);
%                                             
%                                             nodeVars(i).vel(1)=mu*nodeVars(i).vel(1) - eps*delta_function(2);
%                                             nodeVars(i).vel(2)=mu*nodeVars(i).vel(2) - eps*delta_function(2);
%                                             break;
%                                         end
%                                     end
%                                 case 3
%                                     if is_pos_free(3) 
%                                         if id_node(7)~=-1
%                                             idx_neighV=find(nodeVars(i).neighId==id_node(7)); %found the position in the neigh vector that shows this ID
%                                             grad_side_node = nodeVars(i).neighGrad(idx_neighV);
%                                             nodeVars(i).CEFRposition=actual_x(1:n,id_node(7));
%                                             nodeVars(i).CEFRgradient=grad_side_node;
%                                             nodeVars(i).CEFRid=id_node(7);
%                                             %edge follow side node
%                                             nextCirclingPos = Auxiliar_SelfAssembly.next_circling(nextCirclingPos,-1*direction);
%                                             nextGoalPosition=nodeVars(i).CEFRposition+circling(:,nextCirclingPos);
% % % %                                             objects_in_fig = Auxiliar_SelfAssembly.plot_line_3d(objects_in_fig, posi, nextGoalPosition, 'b', 1.5);
%                                             nodeVars(i).vel(1)=mu*nodeVars(i).vel(1) - eps*delta_function(3);
%                                             break;
%                                         end
%                                     else
%                                         %this is a corner
%                                         idx_neighV=find(nodeVars(i).neighId==id_node(3)); %found the position in the neigh vector that shows this ID
%                                         grad_front_node = nodeVars(i).neighGrad(idx_neighV);
%                                         nextCirclingPos = Auxiliar_SelfAssembly.next_circling(nextCirclingPos,-1*direction);
%                                         nextCirclingPos = Auxiliar_SelfAssembly.next_circling(nextCirclingPos,-1*direction);
%                                         nextGoalPosition=nodeVars(i).goalPos; % stay in the same place
%                                         nodeVars(i).CEFRposition=actual_x(1:n,id_node(3));
%                                         nodeVars(i).CEFRgradient=grad_front_node;
%                                         nodeVars(i).CEFRid=id_node(3);
%                                         %nodeVars(i).vel(1)=mu*nodeVars(i).vel(1) - eps*delta_function(3);
%                                         break;
%                                     end
%                                 case 4
%                                     if is_pos_free(4) && round(diag_up(n)/block_size-0.5)+1<=max(S(:,3)/block_size-0.5)
%                                         node_from_up=nodeVars(i).CEFRposition+[0;0;block_size];
%                                         node_from_diag_up = node_from_up+circling(:,Auxiliar_SelfAssembly.next_circling(nextCirclingPos,-1*direction));
%                                         [free, id_Dup]=Auxiliar_SelfAssembly.check_position_free(node_from_diag_up,actual_x);
%                                         objects_in_fig = Auxiliar_SelfAssembly.plot_line_3d(objects_in_fig, posi, node_from_up, 'b', 1.5);
%                                         objects_in_fig = Auxiliar_SelfAssembly.plot_line_3d(objects_in_fig, posi, node_from_diag_up, 'b', 1.5);
% 
%                                         if ~free
%                                             idx_neighV=find(nodeVars(i).neighId==id_Dup); 
%                                             nodeVars(i).CEFRposition=node_from_diag_up;
%                                             nodeVars(i).CEFRgradient=nodeVars(i).neighGrad(idx_neighV);
%                                             nodeVars(i).CEFRid=id_Dup;
%                                             nextGoalPosition=positions_to_test(:,4);
%                                             nodeVars(i).goalPos=nextGoalPosition;
%                                             objects_in_fig = Auxiliar_SelfAssembly.plot_line_3d(objects_in_fig, posi, nextGoalPosition, 'b', 1.5);
%                                             [theta,rho] = cart2pol(nextGoalPosition(1)-actual_x(1,1),nextGoalPosition(2)-actual_x(2,1));
%                                             nodeVars(i).initialAngle=rad2deg(wrapTo2Pi(theta));
%                                             nodeVars(i).vel(1)=mu*nodeVars(i).vel(1) - eps*delta_function(4);
%                                             nodeVars(i).vel(2)=mu*nodeVars(i).vel(2) - eps*delta_function(4);
%                                             break;
%                                         end
%                                     end
%                                 case 5
%                                     if is_pos_free(5) && round(straight_up(n)/block_size-0.5)+1<=max(S(:,3)/block_size-0.5)
%                                         node_from_up=nodeVars(i).CEFRposition+[0;0;block_size];
%                                         [free, id_up]=Auxiliar_SelfAssembly.check_position_free(node_from_up,actual_x);%I know it is not free, I just want the ID
%                                         if ~free
%                                             idx_neighV=find(nodeVars(i).neighId==id_up); 
%                                             nodeVars(i).CEFRposition=node_from_up;
%                                             nodeVars(i).CEFRgradient=nodeVars(i).neighGrad(idx_neighV);
%                                             nodeVars(i).CEFRid=id_up;
%                                             nextGoalPosition=nodeVars(i).CEFRposition+circling(:,nextCirclingPos);
%                                             nodeVars(i).goalPos=nextGoalPosition;
%     % % %                                         objects_in_fig = Auxiliar_SelfAssembly.plot_line_3d(objects_in_fig, posi, nextGoalPosition, 'b', 1.5);
%                                             [theta,rho] = cart2pol(nextGoalPosition(1)-actual_x(1,1),nextGoalPosition(2)-actual_x(2,1));
%                                             nodeVars(i).initialAngle=rad2deg(wrapTo2Pi(theta));
%                                             nodeVars(i).vel(2)=mu*nodeVars(i).vel(2) - eps*delta_function(5);
%                                             break;
%                                         end
%                                     end
%                                 case 6
%                                     if  is_pos_inside(6) && is_pos_free(6) && nextdown(3)>0 %(above ground)
%                                         %the next down position is free and inside the structure
%                                         node_from_down=nodeVars(i).CEFRposition-[0;0;block_size];
%                                         %I know it is not free, I just want the ID
%                                         [free, id_down]=Auxiliar_SelfAssembly.check_position_free(node_from_down,actual_x);
%                                         if ~free
%                                             idx_neighV=find(nodeVars(i).neighId==id_down);
%                                             nodeVars(i).CEFRposition=node_from_down;
%                                             nodeVars(i).CEFRgradient=nodeVars(i).neighGrad(idx_neighV);
%                                             nodeVars(i).CEFRid=id_down;
%                                             nextGoalPosition=nodeVars(i).CEFRposition+circling(:,nextCirclingPos);
%     % % %                                         objects_in_fig = Auxiliar_SelfAssembly.plot_line_3d(objects_in_fig, posi, nextGoalPosition, 'b', 1.5);
%                                             
%                                             nodeVars(i).vel(1)=mu*nodeVars(i).vel(1) - eps*delta_function(6);
%                                             nodeVars(i).vel(2)=mu*nodeVars(i).vel(2) - eps*delta_function(6);
%                                             break;
%                                         end
%                                     end
%                                 case 7
%                                     if  is_pos_free(7) 
%                                         nodeVars(i).vel(1)=mu*nodeVars(i).vel(1) - eps*delta_function(7);
% % % %                                         objects_in_fig = Auxiliar_SelfAssembly.plot_line_3d(objects_in_fig, posi, nextGoalPosition, 'b', 1.5);
%                                         break;
%                                     end
%                                 case 8
%                                     if  is_pos_free(8) && round(nextup(n)/block_size-0.5)+1<=max(S(:,3)/block_size-0.5)
%                                         node_from_up=nodeVars(i).CEFRposition+[0;0;block_size];
%                                         [free, id_up]=Auxiliar_SelfAssembly.check_position_free(node_from_up,actual_x);%I know it is not free, I just want the ID
%                                         if ~free
%                                             idx_neighV=find(nodeVars(i).neighId==id_up);
%                                             nodeVars(i).CEFRposition=actual_x(1:n,id_up);
%                                             nodeVars(i).CEFRid=id_up;
%                                             nodeVars(i).CEFRgradient=nodeVars(i).neighGrad(idx_neighV);
%                                             nextGoalPosition=nextup; %UP of the next block    
%                                             objects_in_fig = Auxiliar_SelfAssembly.plot_line_3d(objects_in_fig, posi, nextGoalPosition, 'b', 1.5);
%                                             [theta,rho] = cart2pol(nextGoalPosition(1)-actual_x(1,1),nextGoalPosition(2)-actual_x(2,1));
%                                             nodeVars(i).initialAngle=rad2deg(wrapTo2Pi(theta));
%                                             nodeVars(i).vel(1)=mu*nodeVars(i).vel(1) - eps*delta_function(8);
%                                             nodeVars(i).vel(2)=mu*nodeVars(i).vel(2) - eps*delta_function(8);
%                                             break;
%                                         else
%                                             if is_pos_inside(8)
%                                                 idx_neighV=find(nodeVars(i).neighId==id_node(7));
%                                                 %nextCirclingPos=5;
%                                                 nodeVars(i).onTOP=true;
%                                                 nodeVars(i).CEFRid=id_node(7);
%                                                 nextGoalPosition=nextup; %UP of the next block     
%                                                 objects_in_fig = Auxiliar_SelfAssembly.plot_line_3d(objects_in_fig, posi, nextGoalPosition, 'b', 1.5);
%                                                 [theta,rho] = cart2pol(nextGoalPosition(1)-actual_x(1,1),nextGoalPosition(2)-actual_x(2,1));
%                                                 nodeVars(i).initialAngle=rad2deg(wrapTo2Pi(theta));
%                                                 nodeVars(i).vel(1)=mu*nodeVars(i).vel(1) - eps*delta_function(8);
%                                                 nodeVars(i).vel(2)=mu*nodeVars(i).vel(2) - eps*delta_function(8);
%                                                 break;
%                                             end
%                                         end                                 
%                                     end
%                                 case 9
%                                     if is_pos_free(9) && round(CEFRup(n)/block_size-0.5)+1<=max(S(:,3)/block_size-0.5) && is_pos_inside(j)
% % % %                                         objects_in_fig = Auxiliar_SelfAssembly.plot_line_3d(objects_in_fig, posi, nextGoalPosition, 'b', 1.5);
%                                         %nextCirclingPos=5;    
%                                         neighID = Auxiliar_SelfAssembly.position_has_a_neighbour(perpend,actual_x, circling, direction);
%                                         if neighID~=-1
%                                             nodeVars(i).CEFRid=neighID;     
%                                             idx_neighV=find(nodeVars(i).neighId==id_node(3)); 
%                                             nodeVars(i).CEFRgradient=nodeVars(i).neighGrad(idx_neighV);
%                                             nodeVars(i).CEFRposition=actual_x(1:n,neighID);
% 
%                                             [goal_pos, circling_pos] = Auxiliar_SelfAssembly.get_closest_circling_pos(nodeVars(i).CEFRposition, positions_to_test(:,9), circling);
%                                                 
%                                             objects_in_fig = Auxiliar_SelfAssembly.plot_line_3d(objects_in_fig, posi, actual_x(1:3,nodeVars(i).CEFRid), 'k', 1.5);
%                                             nextGoalPosition=goal_pos;
%                                             %nodeVars(i).CEFRcirclingPos=circling_pos;
%                                             
%                                             [theta,rho] = cart2pol(goal_pos(1)-actual_x(1,1),goal_pos(2)-actual_x(2,1));
%                                             nodeVars(i).initialAngle=rad2deg(wrapTo2Pi(theta));
%                                             nodeVars(i).vel(2)=mu*nodeVars(i).vel(2) - eps*delta_function(9);
%                                             break;
%                                        elseif is_pos_inside(9) 
%                                             nodeVars(i).onTOP=true;    
% 
%                                             objects_in_fig = Auxiliar_SelfAssembly.plot_line_3d(objects_in_fig, posi, actual_x(1:3,nodeVars(i).CEFRid), 'k', 1.5);
%                                             nextGoalPosition=positions_to_test(:,9);
%                                             %nodeVars(i).CEFRcirclingPos=circling_pos;
%                                             
%                                             [theta,rho] = cart2pol(goal_pos(1)-actual_x(1,1),goal_pos(2)-actual_x(2,1));
%                                             nodeVars(i).initialAngle=rad2deg(wrapTo2Pi(theta));
%                                             nodeVars(i).vel(2)=mu*nodeVars(i).vel(2) - eps*delta_function(9);
%                                             break;
%                                         end
%                                     end
%                             end
%                         end
%                         
%                         changed_circled_node=0;
% 
%                         nodeVars(i).goalPos=nextGoalPosition;
%                         nodeVars(i).CEFRcirclingPos=nextCirclingPos;
%                         hist_selected_grad=[hist_selected_grad,[nodeVars(i).state;I(j);gradssorted(j)]];
%                     end
%                     
%                 end
%                 
%                 if ~simulate_dynamics
%                     actual_x(1:n,i)=nodeVars(i).goalPos+nodeVars(i).displacement;
%                     actual_x(n+1:n+n,i)=[0;0;0];
%                     u=u*0;
%                 end
%                 

                
%% previous edge follow outside               
%                         while ~is_next_free 
%                             %there is a node here already, j
% 
%                             %The way I am implementing, I am sensing again
%                             idx_neighV=find(nodeVars(i).neighId==id_side); %found the position in the neigh vector that shows this ID
%                             grad_side_node = nodeVars(i).neighGrad(idx_neighV);
%                             delta_function=grad_side_node-nodeVars(i).CEFRgradient;
%                             nodeVars(i).vel=mu*nodeVars(i).vel - eps*delta_function; %actualy, my f() I call grad, but I need deltaf() grad of the grad
%                             disp([grad_side_node, nodeVars(i).CEFRgradient , nodeVars(i).vel ])
%                             
%                             if  grad_side_node > nodeVars(i).CEFRgradient 
%                                 %the gradient of the next is bigger than the actual gradient.
%                                 nextGoalPosition=nodeVars(i).CEFRposition+circling(:,5); %UP in the actual block                                   
%                                 objects_in_fig = Auxiliar_SelfAssembly.plot_line_3d(objects_in_fig, posi, nextGoalPosition, 'k', 1.5);
% 
%                                 [is_up_free,id_up]=Auxiliar_SelfAssembly.check_position_free(nextGoalPosition,actual_x);
%                                 
%                                 grad_up=9999;
%                                 if ~is_up_free
%                                         idx_neighV=find(nodeVars(i).neighId==id_up); %found the position in the neigh vector that shows this ID
%                                         grad_up=nodeVars(i).neighGrad(idx_neighV);
%                                 end   
%                                 is_up_inside=Auxiliar_SelfAssembly.check_position_inside_structure(nextGoalPosition,S);
% 
%                                 %here, side is already taken, considering up
%                                 if is_up_free
%                                     if is_up_inside
%                                         nextCirclingPos=5; 
%                                     else
%                                         %continue with the side edge follow
%                                         nodeVars(i).CEFRposition=actual_x(1:n,id_side);
%                                         nodeVars(i).CEFRgradient=grad_side_node;
%                                         nodeVars(i).CEFRid=id_side;
%                                         nextCirclingPos = Auxiliar_SelfAssembly.next_circling(nextCirclingPos,-1*direction);
%                                     end
%                                 else
%                                     %just saving uppper node
%                                     nodeVars(i).possible_upper_CEFR.pos=actual_x(1:n,id_up);
%                                     nodeVars(i).possible_upper_CEFR.grad=grad_up;
%                                     nodeVars(i).possible_upper_CEFR.id=id_up;
%                                     
%                                     %gets the closest goal position
%                                     [candidate_goal, nodeVars(i).possible_upper_CEFR.circling] = Auxiliar_SelfAssembly.get_closest_circling_pos(actual_x(1:n,id_up), posi, circling);
% 
%                                     %in this case, I should move to the side
%                                     %Change the robot that I am edge-following
%                                     %now I will need to find the new node to edge follow
%                                     nodeVars(i).CEFRposition=actual_x(1:n,id_side);
%                                     nodeVars(i).CEFRgradient=grad_side_node;
%                                     nodeVars(i).CEFRid=id_side;
%                                     nextCirclingPos = Auxiliar_SelfAssembly.next_circling(nextCirclingPos,-1*direction);
%                                     changed_circled_node=1;
%                                 end
%                             else
%                                 %Change the robot that I am edge-following
%                                 %now I will need to find the new node to edge follow
%                                 nodeVars(i).CEFRposition=actual_x(1:n,id_side);
%                                 nodeVars(i).CEFRgradient=grad_side_node;
%                                 nodeVars(i).CEFRid=id_side;
%                                 nextCirclingPos = Auxiliar_SelfAssembly.next_circling(nextCirclingPos,-1*direction);
% 
%                                 changed_circled_node=1;
%                             end
%                             %nodeVars(i).CEFRcirclingPos %stay the same
%                             nextGoalPosition=nodeVars(i).CEFRposition+circling(:,nextCirclingPos);
%                             if nextCirclingPos==5
%                                 %I am chaniging layers
%                                 [theta,rho] = cart2pol(nextGoalPosition(1),nextGoalPosition(2));
%                                 nodeVars(i).initialAngle=rad2deg(theta);
%                                 nodeVars(i).possible_upper_CEFR.pos=[];
%                             end
% 
%                             objects_in_fig = Auxiliar_SelfAssembly.plot_line_3d(objects_in_fig, posi, nextGoalPosition, 'k', 1.5);
%                             [is_next_free, id_side]=Auxiliar_SelfAssembly.check_position_free(nextGoalPosition,actual_x);
%                         end


%% previous edge follow inside
%                         %Checking 1 position below me
%                         straight_down=nodeVars(i).goalPos;
%                         straight_down(3)=((round((nodeVars(i).goalPos(3)/block_size)-0.5)-1)+0.5)*block_size;
%                         [is_down_free,id]=Auxiliar_SelfAssembly.check_position_free(straight_down,actual_x);
%                         is_down_inside=Auxiliar_SelfAssembly.check_position_inside_structure(straight_down,S);
%                         
%                         if is_down_free && is_down_inside %this is clearly the lowest gradient possible
%                             node_from_down=nodeVars(i).CEFRposition-[0;0;block_size];
%                             [free, id_down]=Auxiliar_SelfAssembly.check_position_free(node_from_down,actual_x); %I know it is not free, I just want the ID
%                             idx_neighV=find(nodeVars(i).neighId==id_down); %found the position in the neigh vector that shows this ID
%                             nodeVars(i).CEFRposition=node_from_down;
%                             nodeVars(i).CEFRgradient=nodeVars(i).neighGrad(idx_neighV);
%                             nodeVars(i).CEFRid=id_down;
%                             nextCirclingPos = nodeVars(i).CEFRcirclingPos;
%                             nextGoalPosition=nodeVars(i).CEFRposition+circling(:,nodeVars(i).CEFRcirclingPos);
% % % %                             objects_in_fig = Auxiliar_SelfAssembly.plot_line_3d(objects_in_fig, posi, nextGoalPosition, 'b', 1.5);
%                             next_is_inside_S=true;
%                             bigger_CEFR_gradient=false;
%                         else
%                             
%                             nextCirclingPos = Auxiliar_SelfAssembly.next_circling(nodeVars(i).CEFRcirclingPos,1*direction);
%                             nextGoalPosition=nodeVars(i).CEFRposition+circling(:,nextCirclingPos);
% 
%                             bigger_CEFR_gradient=false;
%                             changed_circled_node=0;
% 
% % % %                             objects_in_fig = Auxiliar_SelfAssembly.plot_line_3d(objects_in_fig, posi, nextGoalPosition, 'k', 1.5);
% 
%                             next_is_inside_S=Auxiliar_SelfAssembly.check_position_inside_structure(nextGoalPosition,S);
%                             [is_side_free,id_side]=Auxiliar_SelfAssembly.check_position_free(nextGoalPosition,actual_x);
%                             while_counter=1;
%                             while next_is_inside_S && ~is_side_free && ~bigger_CEFR_gradient && while_counter<10
%                                 while_counter=while_counter+1;
%                                 %there is a node here already, j
%                                 idx_neighV=find(nodeVars(i).neighId==id_side); %found the position in the neigh vector that shows this ID
%                                 grad_side=nodeVars(i).neighGrad(idx_neighV);
% 
%                                 is_up_inside=Auxiliar_SelfAssembly.check_position_inside_structure(nodeVars(i).CEFRposition+circling(:,5),S);
% 
%                                 if grad_side > nodeVars(i).CEFRgradient && (changed_circled_node==0 || changed_circled_node==2)
%                                     %if I have not changed the node, or if I have changed it twice (I am in a corner)
%                                     %the gradient of the next is bigger than the actual gradient.
%                                     bigger_CEFR_gradient=true;
%     %                                 [is_up_free,id_up]=Auxiliar_SelfAssembly.check_position_free(nodeVars(i).CEFRposition+circling(:,5),actual_x);
%     %                                 grad_up=9999;
%     %                                 if ~is_up_free
%     %                                         idx_neighV=find(nodeVars(i).neighId==id_up); %found the position in the neigh vector that shows this ID
%     %                                         grad_up=nodeVars(i).neighGrad(idx_neighV);
%     %                                         %just saving uppper node
%     %                                         nodeVars(i).possible_upper_CEFR.pos=actual_x(1:n,id_up);
%     %                                         nodeVars(i).possible_upper_CEFR.grad=grad_up;
%     %                                         nodeVars(i).possible_upper_CEFR.id=id_up;
%     %                                 end   
%                                 else
% 
%                                     %Change the robot that I am edge-following
%                                     %now I will need to find the new node to edge follow
%                                     nodeVars(i).CEFRposition=actual_x(1:n,id_side);
%                                     nodeVars(i).CEFRgradient=nodeVars(i).neighGrad(idx_neighV);
%                                     nodeVars(i).CEFRid=id_side;
%                                     nextCirclingPos = Auxiliar_SelfAssembly.next_circling(nextCirclingPos,-1*direction);
% 
%                                     changed_circled_node=changed_circled_node+1;
%                                     nextGoalPosition=nodeVars(i).CEFRposition+circling(:,nextCirclingPos);
% 
% % % %                                     objects_in_fig = Auxiliar_SelfAssembly.plot_line_3d(objects_in_fig, posi, nextGoalPosition, 'k', 1.5);
% 
%                                     [is_side_free,id_side]=Auxiliar_SelfAssembly.check_position_free(nextGoalPosition,actual_x);
%                                     next_is_inside_S=Auxiliar_SelfAssembly.check_position_inside_structure(nextGoalPosition,S);
%                                 end                          
%                             end
%                         end
%                         if while_counter>=10
%                             break;
%                         end
% %                         eu preciso comparar de novo se eu trocar de nó
% %                         isso precisa de ser comparado tambem no outside
%                         if ~next_is_inside_S || bigger_CEFR_gradient
%                             % I am inside, but I am about to leave the structure
%                             % I am about to edge-follow a robot with a bigger gradient
%                             nodeVars(i).state=5;
%                         else
%                             nodeVars(i).goalPos=nextGoalPosition;
%                             nodeVars(i).CEFRcirclingPos=nextCirclingPos;
%                         end
% %                         if ~next_is_inside_S
% %                             % I am inside, but I am about to leave the structure
% %                             % I am about to edge-follow a robot with a bigger gradient
% %                             nodeVars(i).state=5;
% %                         elseif bigger_CEFR_gradient
% %                              if is_up_free && is_up_inside
% %                                  nodeVars(i).goalPos=nodeVars(i).CEFRposition+circling(:,5);
% %                                  nodeVars(i).CEFRcirclingPos=5;
% %                              else  
% %                                 nodeVars(i).state=5;
% %                              end
% %                         else
% %                             nodeVars(i).goalPos=nextGoalPosition;
% %                             nodeVars(i).CEFRcirclingPos=nextCirclingPos;
% %                         end

%% OLD STATE 4
%                                 if nodeVars(i).onTOP
%                                     neighbour_ID = Auxiliar_SelfAssembly.position_has_a_neighbour(nodeVars(i).goalPos, actual_x, circling, direction);
%                                     if neighbour_ID >-1
%                                         %just found a node by my side
%                                         nodeVars(i).onTOP=false;
%                                         nodeVars(i).CEFRposition=actual_x(1:n,neighbour_ID);
%                                         idx_neighV=find(nodeVars(i).neighId==neighbour_ID); 
%                                         nodeVars(i).CEFRgradient=nodeVars(i).neighGrad(idx_neighV(1));
%                                         nodeVars(i).CEFRid=neighbour_ID;
%                                         [nextGoalPosition, nextCirclingPos] = Auxiliar_SelfAssembly.get_closest_circling_pos(nodeVars(i).CEFRposition, my_actual_position, circling);
%                                         break;
%                                     end
%                                 end
%                                     switch I(j)
%                                         case 1
%                                             if is_pos_free(1) && is_pos_inside(1) && straight_down(3)>0 %%is_down_free && is_down_inside && straight_down(3)>0 %this is clearly the lowest gradient possible
%                                                 node_from_down=nodeVars(i).CEFRposition-[0;0;block_size];
%                                                 [free, id_down]=Auxiliar_SelfAssembly.check_position_free(node_from_down,actual_x);%I know it is not free, I just want the ID
%                                                 idx_neighV=find(nodeVars(i).neighId==id_down); 
%                                                 nodeVars(i).CEFRposition=node_from_down;
%                                                 nodeVars(i).CEFRgradient=nodeVars(i).neighGrad(idx_neighV);
%                                                 nodeVars(i).CEFRid=id_down;
%                                                 nextGoalPosition=nodeVars(i).CEFRposition+circling(:,nextCirclingPos);
%                                                 nodeVars(i).goalPos=nextGoalPosition;
%         % % %                                         objects_in_fig = Auxiliar_SelfAssembly.plot_line_3d(objects_in_fig, posi, nextGoalPosition, 'b', 1.5);
%                                                 nodeVars(i).vel(2)=mu*nodeVars(i).vel(2) - eps*delta_function(1);
%                                                 break;
%                                             end
%                                         case 2
%                                             if is_pos_free(2) && is_pos_inside(2) && diag_down(3)>0 
%                                                 node_from_down=nodeVars(i).CEFRposition-[0;0;block_size];
%                                                 node_from_diag_down = node_from_down+circling(:,Auxiliar_SelfAssembly.next_circling(nextCirclingPos,-1*direction));
%                                                 [free, id_down]=Auxiliar_SelfAssembly.check_position_free(node_from_diag_down,actual_x);
% % % %                                                 objects_in_fig = Auxiliar_SelfAssembly.plot_line_3d(objects_in_fig, posi, node_from_down, 'b', 1.5);
% % % %                                                 objects_in_fig = Auxiliar_SelfAssembly.plot_line_3d(objects_in_fig, posi, node_from_diag_down, 'b', 1.5);
% 
%                                                 if ~free
%                                                     idx_neighV=find(nodeVars(i).neighId==id_down); 
%                                                     nodeVars(i).CEFRposition=node_from_diag_down;
%                                                     nodeVars(i).CEFRgradient=nodeVars(i).neighGrad(idx_neighV);
%                                                     nodeVars(i).CEFRid=id_down;
%                                                     nextGoalPosition=positions_to_test(:,2);
%                                                     nodeVars(i).goalPos=nextGoalPosition;
% % % %                                                     objects_in_fig = Auxiliar_SelfAssembly.plot_line_3d(objects_in_fig, posi, nextGoalPosition, 'b', 1.5);
% 
%                                                     nodeVars(i).vel(1)=mu*nodeVars(i).vel(1) - eps*delta_function(2);
%                                                     nodeVars(i).vel(2)=mu*nodeVars(i).vel(2) - eps*delta_function(2);
%                                                     break;
%                                                 end
%                                             end
%                                         case 3
%                                             if is_pos_free(3) 
%                                                 if id_node(7)~=-1
%                                                     idx_neighV=find(nodeVars(i).neighId==id_node(7)); %found the position in the neigh vector that shows this ID
%                                                     grad_side_node = nodeVars(i).neighGrad(idx_neighV);
%                                                     nodeVars(i).CEFRposition=actual_x(1:n,id_node(7));
%                                                     nodeVars(i).CEFRgradient=grad_side_node;
%                                                     nodeVars(i).CEFRid=id_node(7);
%                                                     %edge follow side node
%                                                     nextCirclingPos = nodeVars(i).CEFRcirclingPos;
%                                                     nextGoalPosition=nodeVars(i).CEFRposition+circling(:,nextCirclingPos);
%         % % %                                             objects_in_fig = Auxiliar_SelfAssembly.plot_line_3d(objects_in_fig, posi, nextGoalPosition, 'b', 1.5);
%                                                     nodeVars(i).vel(1)=mu*nodeVars(i).vel(1) - eps*delta_function(3);
%                                                     break;
%                                                 else
%                                                     if nodeVars(i).onTOP && id_node(2)~=-1
%                                                         idx_neighV=find(nodeVars(i).neighId==id_node(2)); %found the position in the neigh vector that shows this ID
%                                                         grad_down_node = nodeVars(i).neighGrad(idx_neighV);
%                                                         nodeVars(i).CEFRposition=actual_x(1:n,id_node(2));
%                                                         nodeVars(i).CEFRgradient=grad_down_node;
%                                                         nodeVars(i).CEFRid=id_node(2);
%                                                         %edge follow side node
%                                                         nextCirclingPos = nodeVars(i).CEFRcirclingPos;
%                                                         nextGoalPosition=positions_to_test(:,3);
%             % % %                                             objects_in_fig = Auxiliar_SelfAssembly.plot_line_3d(objects_in_fig, posi, nextGoalPosition, 'b', 1.5);
%                                                         nodeVars(i).vel(1)=mu*nodeVars(i).vel(1) - eps*delta_function(3);
%                                                         break;
%                                                     end
%                                                 end
%                                             else
%                                                 %this is a corner
%                                                 idx_neighV=find(nodeVars(i).neighId==id_node(3)); %found the position in the neigh vector that shows this ID
%                                                 grad_front_node = nodeVars(i).neighGrad(idx_neighV);
%                                                 if grad_front_node>nodeVars(i).CEFRgradient
%                                                     nodeVars(i).state=5;
%                                                     break;
%                                                 end
%                                                 nextCirclingPos = Auxiliar_SelfAssembly.next_circling(nextCirclingPos,-1*direction);
%                                                 nextCirclingPos = Auxiliar_SelfAssembly.next_circling(nextCirclingPos,-1*direction);
%                                                 nextGoalPosition=nodeVars(i).goalPos; % stay in the same place
%                                                 nodeVars(i).CEFRposition=actual_x(1:n,id_node(3));
%                                                 nodeVars(i).CEFRgradient=grad_front_node;
%                                                 nodeVars(i).CEFRid=id_node(3);
%                                                 %nodeVars(i).vel(1)=mu*nodeVars(i).vel(1) - eps*delta_function(3);
%                                                 break;
%                                             end
%                                         case 4
%                                             if is_pos_free(4) && round(diag_up(n)/block_size-0.5)+1<=max(S(:,3)/block_size-0.5)
%                                                 node_from_up=nodeVars(i).CEFRposition+[0;0;block_size];
%                                                 node_from_diag_up = node_from_up+circling(:,Auxiliar_SelfAssembly.next_circling(nextCirclingPos,-1*direction));
%                                                 [free, id_Dup]=Auxiliar_SelfAssembly.check_position_free(node_from_diag_up,actual_x);
% % % %                                                 objects_in_fig = Auxiliar_SelfAssembly.plot_line_3d(objects_in_fig, posi, node_from_up, 'b', 1.5);
% % % %                                                 objects_in_fig = Auxiliar_SelfAssembly.plot_line_3d(objects_in_fig, posi, node_from_diag_up, 'b', 1.5);
% 
%                                                 if ~free
%                                                     idx_neighV=find(nodeVars(i).neighId==id_Dup); 
%                                                     nodeVars(i).CEFRposition=node_from_diag_up;
%                                                     nodeVars(i).CEFRgradient=nodeVars(i).neighGrad(idx_neighV);
%                                                     nodeVars(i).CEFRid=id_Dup;
%                                                     nextGoalPosition=positions_to_test(:,4);
%                                                     nodeVars(i).goalPos=nextGoalPosition;
% % % %                                                     objects_in_fig = Auxiliar_SelfAssembly.plot_line_3d(objects_in_fig, posi, nextGoalPosition, 'b', 1.5);
% 
%                                                     nodeVars(i).vel(1)=mu*nodeVars(i).vel(1) - eps*delta_function(4);
%                                                     nodeVars(i).vel(2)=mu*nodeVars(i).vel(2) - eps*delta_function(4);
%                                                     break;
%                                                 end
%                                             end
%                                         case 5
%                                             if is_pos_free(5) && round(straight_up(n)/block_size-0.5)+1<=max(S(:,3)/block_size-0.5)
%                                                 node_from_up=nodeVars(i).CEFRposition+[0;0;block_size];
%                                                 [free, id_up]=Auxiliar_SelfAssembly.check_position_free(node_from_up,actual_x);%I know it is not free, I just want the ID
% % % %                                                 objects_in_fig = Auxiliar_SelfAssembly.plot_line_3d(objects_in_fig, posi, node_from_up, 'b', 1.5);
%                                                 if ~free
%                                                     idx_neighV=find(nodeVars(i).neighId==id_up); 
%                                                     nodeVars(i).CEFRposition=node_from_up;
%                                                     nodeVars(i).CEFRgradient=nodeVars(i).neighGrad(idx_neighV);
%                                                     nodeVars(i).CEFRid=id_up;
%                                                     nextCirclingPos = nodeVars(i).CEFRcirclingPos;
%                                                     nextGoalPosition=nodeVars(i).CEFRposition+circling(:,nextCirclingPos);
%                                                     nodeVars(i).goalPos=nextGoalPosition;
% % % %                                                     objects_in_fig = Auxiliar_SelfAssembly.plot_line_3d(objects_in_fig, posi, nextGoalPosition, 'b', 1.5);
%                                                     nodeVars(i).vel(2)=mu*nodeVars(i).vel(2) - eps*delta_function(5);
%                                                     break;
%                                                 end
%                                             end
%                                         case 6
%                                             if  is_pos_inside(6) && is_pos_free(6) && nextdown(3)>0 %(above ground)
%                                                 %the next down position is free and inside the structure
%                                                 node_from_down=nodeVars(i).CEFRposition-[0;0;block_size];
%                                                 %I know it is not free, I just want the ID
%                                                 [free, id_down]=Auxiliar_SelfAssembly.check_position_free(node_from_down,actual_x);
%                                                 if ~free
%                                                     idx_neighV=find(nodeVars(i).neighId==id_down);
%                                                     nodeVars(i).CEFRposition=node_from_down;
%                                                     nodeVars(i).CEFRgradient=nodeVars(i).neighGrad(idx_neighV);
%                                                     nodeVars(i).CEFRid=id_down;
%                                                     nextGoalPosition=nodeVars(i).CEFRposition+circling(:,nextCirclingPos);
%             % % %                                         objects_in_fig = Auxiliar_SelfAssembly.plot_line_3d(objects_in_fig, posi, nextGoalPosition, 'b', 1.5);
% 
%                                                     nodeVars(i).vel(1)=mu*nodeVars(i).vel(1) - eps*delta_function(6);
%                                                     nodeVars(i).vel(2)=mu*nodeVars(i).vel(2) - eps*delta_function(6);
%                                                     break;
%                                                 end
%                                             end
%                                         case 7
%                                             if  is_pos_free(7) 
%                                                 nextCirclingPos = Auxiliar_SelfAssembly.next_circling (nodeVars(i).CEFRcirclingPos,direction*1);
%                                                 nextGoalPosition=nodeVars(i).CEFRposition+circling(:,nextCirclingPos); 
%                                                 nodeVars(i).vel(1)=mu*nodeVars(i).vel(1) - eps*delta_function(7);
%         % % %                                         objects_in_fig = Auxiliar_SelfAssembly.plot_line_3d(objects_in_fig, posi, nextGoalPosition, 'b', 1.5);
%                                                 break;
%                                             end
%                                         case 8
%                                             if  is_pos_free(8) && round(nextup(n)/block_size-0.5)+1<=max(S(:,3)/block_size-0.5)
%                                                 node_from_up=nodeVars(i).CEFRposition+[0;0;block_size];
%                                                 [free, id_up]=Auxiliar_SelfAssembly.check_position_free(node_from_up,actual_x);%I know it is not free, I just want the ID
%                                                 if ~free
%                                                     idx_neighV=find(nodeVars(i).neighId==id_up);
%                                                     nodeVars(i).CEFRposition=actual_x(1:n,id_up);
%                                                     nodeVars(i).CEFRid=id_up;
%                                                     nodeVars(i).CEFRgradient=nodeVars(i).neighGrad(idx_neighV);
%                                                     nextGoalPosition=nextup; %UP of the next block    
% % % %                                                     objects_in_fig = Auxiliar_SelfAssembly.plot_line_3d(objects_in_fig, posi, nextGoalPosition, 'b', 1.5);
% 
%                                                     nodeVars(i).vel(1)=mu*nodeVars(i).vel(1) - eps*delta_function(8);
%                                                     nodeVars(i).vel(2)=mu*nodeVars(i).vel(2) - eps*delta_function(8);
%                                                     break;
%                                                 else
%                                                     if is_pos_inside(8)
%                                                         idx_neighV=find(nodeVars(i).neighId==id_node(7));
%                                                         %nextCirclingPos=5;
%                                                         nodeVars(i).onTOP=true;
%                                                         nodeVars(i).CEFRid=id_node(7);
%                                                         nextGoalPosition=nextup; %UP of the next block     
% % % %                                                         objects_in_fig = Auxiliar_SelfAssembly.plot_line_3d(objects_in_fig, posi, nextGoalPosition, 'b', 1.5);
% 
%                                                         nodeVars(i).vel(1)=mu*nodeVars(i).vel(1) - eps*delta_function(8);
%                                                         nodeVars(i).vel(2)=mu*nodeVars(i).vel(2) - eps*delta_function(8);
%                                                         break;
%                                                     end
%                                                 end                                 
%                                             end
%                                         case 9
%                                             if is_pos_free(9) && round(CEFRup(n)/block_size-0.5)+1<=max(S(:,3)/block_size-0.5) && is_pos_inside(j)
%     % % %                                         objects_in_fig = Auxiliar_SelfAssembly.plot_line_3d(objects_in_fig, posi, nextGoalPosition, 'b', 1.5);
%                                                 %nextCirclingPos=5;    
%                                                 neighID = Auxiliar_SelfAssembly.position_has_a_neighbour(perpend,actual_x, circling, direction);
%                                                 if neighID~=-1
%                                                     nodeVars(i).CEFRid=neighID;     
%                                                     idx_neighV=find(nodeVars(i).neighId==id_node(3)); 
%                                                     nodeVars(i).CEFRgradient=nodeVars(i).neighGrad(idx_neighV);
%                                                     nodeVars(i).CEFRposition=actual_x(1:n,neighID);
% 
%                                                     [goal_pos, circling_pos] = Auxiliar_SelfAssembly.get_closest_circling_pos(nodeVars(i).CEFRposition, positions_to_test(:,9), circling);
% 
%                                                     objects_in_fig = Auxiliar_SelfAssembly.plot_line_3d(objects_in_fig, posi, actual_x(1:3,nodeVars(i).CEFRid), 'k', 1.5);
%                                                     nextGoalPosition=goal_pos;
%                                                     %nodeVars(i).CEFRcirclingPos=circling_pos;
% 
%                                                     [theta,rho] = cart2pol(goal_pos(1)-actual_x(1,1),goal_pos(2)-actual_x(2,1));
%                                                     nodeVars(i).initialAngle=rad2deg(wrapTo2Pi(theta));
%                                                     nodeVars(i).vel(2)=mu*nodeVars(i).vel(2) - eps*delta_function(9);
%                                                     break;
%                                                elseif is_pos_inside(9) 
%                                                     nodeVars(i).onTOP=true;    
% 
%                                                     objects_in_fig = Auxiliar_SelfAssembly.plot_line_3d(objects_in_fig, posi, actual_x(1:3,nodeVars(i).CEFRid), 'k', 1.5);
%                                                     nextGoalPosition=positions_to_test(:,9);
%                                                     %nodeVars(i).CEFRcirclingPos=circling_pos;
% 
%                                                     [theta,rho] = cart2pol(goal_pos(1)-actual_x(1,1),goal_pos(2)-actual_x(2,1));
%                                                     nodeVars(i).initialAngle=rad2deg(wrapTo2Pi(theta));
%                                                     nodeVars(i).vel(2)=mu*nodeVars(i).vel(2) - eps*delta_function(9);
%                                                     break;
%                                                 end
%                                             end
%                                         case 10
%                                             if is_pos_free(10) 
%                                                 neighID = Auxiliar_SelfAssembly.position_has_a_neighbour(perpend,actual_x, circling, direction);
%                                                 if neighID>-1
%                                                     idx_neighV=find(nodeVars(i).neighId==neighID);
%                                                     grad_side_node = nodeVars(i).neighGrad(idx_neighV);
%                                                     nodeVars(i).CEFRposition=actual_x(1:n,neighID);
%                                                     nodeVars(i).CEFRgradient=grad_side_node;
%                                                     nodeVars(i).CEFRid=neighID;
%                                                     [goal_pos, circling_pos] = Auxiliar_SelfAssembly.get_closest_circling_pos(nodeVars(i).CEFRposition, positions_to_test(:,10), circling);
%                                                     nextCirclingPos = circling_pos;
%                                                     nextGoalPosition=positions_to_test(:,10);
%                                                     nodeVars(i).onTOP=false;
%                                                     nodeVars(i).vel(1)=mu*nodeVars(i).vel(1) - eps*delta_function(10);
%                                                     break;
%                                                 else
%                                                     if id_node(11)~=-1
%                                                         idx_neighV=find(nodeVars(i).neighId==id_node(11)); %found the position in the neigh vector that shows this ID
%                                                         grad_down_node = nodeVars(i).neighGrad(idx_neighV);
%                                                         nodeVars(i).CEFRposition=actual_x(1:n,id_node(11));
%                                                         nodeVars(i).CEFRgradient=grad_down_node;
%                                                         nodeVars(i).CEFRid=id_node(11);
%                                                         nodeVars(i).onTOP=true;
%                                                         nextCirclingPos = nodeVars(i).CEFRcirclingPos;
%                                                         nextGoalPosition=positions_to_test(:,10);
%                                                         nodeVars(i).vel(1)=mu*nodeVars(i).vel(1) - eps*delta_function(10);
%                                                         break;
%                                                     end
%                                                 end
%                                             end
%                                         case 11
%                                             if is_pos_free(11)  && is_pos_inside(11) && perpend_down(3)>0 
%                                                 neighID = Auxiliar_SelfAssembly.position_has_a_neighbour(perpend_down,actual_x, circling, direction);
%                                                 if neighID>-1
%                                                     idx_neighV=find(nodeVars(i).neighId==neighID);
%                                                     grad_side_node = nodeVars(i).neighGrad(idx_neighV);
%                                                     nodeVars(i).CEFRposition=actual_x(1:n,neighID);
%                                                     nodeVars(i).CEFRgradient=grad_side_node;
%                                                     nodeVars(i).CEFRid=neighID;
%                                                     nodeVars(i).onTOP=false;
%                                                     [goal_pos, circling_pos] = Auxiliar_SelfAssembly.get_closest_circling_pos(nodeVars(i).CEFRposition, positions_to_test(:,10), circling);
%                                                     nextCirclingPos = circling_pos;
%                                                     nextGoalPosition=positions_to_test(:,11);
%                                                     nodeVars(i).vel(1)=mu*nodeVars(i).vel(1) - eps*delta_function(11);
%                                                     nodeVars(i).vel(2)=mu*nodeVars(i).vel(2) - eps*delta_function(11);
%                                                     break;
%                                                 else
%                                                     [free,id]=Auxiliar_SelfAssembly.check_position_free(positions_to_test(:,11)-[0;0;block_size],actual_x);
%                                                     if id~=1
%                                                         idx_neighV=find(nodeVars(i).neighId==id); %found the position in the neigh vector that shows this ID
%                                                         grad_down_node = nodeVars(i).neighGrad(idx_neighV);
%                                                         nodeVars(i).CEFRposition=actual_x(1:n,id);
%                                                         nodeVars(i).CEFRgradient=grad_down_node;
%                                                         nodeVars(i).CEFRid=id;
%                                                         nodeVars(i).onTOP=true;
%                                                         nextCirclingPos = nodeVars(i).CEFRcirclingPos;
%                                                         nextGoalPosition=positions_to_test(:,11);
%                                                         nodeVars(i).vel(1)=mu*nodeVars(i).vel(1) - eps*delta_function(11);
%                                                         nodeVars(i).vel(2)=mu*nodeVars(i).vel(2) - eps*delta_function(11);
%                                                         break;
%                                                     end
%                                                 end
%                                             end
%                                     end

%old edge follow from the top
% % %                         % I am already on top of a node, find a neighbouring position that is inside
% % %                         % and has has the lower grad
% % %                         lowestgradID=nodeVars(i).CEFRid;
% % %                         lowestgradVal=nodeVars(i).CEFRgradient;
% % %                         for l=1:4
% % %                             nextGoalPosition=nodeVars(i).CEFRposition+circling(:,l);
% % %                             [is_pos_free,id_node]=Auxiliar_SelfAssembly.check_position_free(nextGoalPosition,actual_x);
% % %                             if ~is_pos_free
% % %                                 %Somebody at this location
% % %                                 indexNV=find(nodeVars(i).neighId-id_node==0);
% % %                                 next_is_inside_S=Auxiliar_SelfAssembly.check_position_inside_structure(nextGoalPosition+circling(:,5) ,S);
% % %                                 if nodeVars(i).neighGrad(indexNV)<lowestgradVal && next_is_inside_S
% % %                                     lowestgradID=id_node;
% % %                                     lowestgradVal=nodeVars(i).neighGrad(indexNV);
% % % % % %                                     objects_in_fig = Auxiliar_SelfAssembly.plot_line_3d(objects_in_fig, posi, actual_x(1:3,lowestgradID), 'k', 1.5);
% % %                                 end
% % %                             end
% % %                         end
% % %                         
% % % % % %                         objects_in_fig = Auxiliar_SelfAssembly.plot_line_3d(objects_in_fig, posi, actual_x(1:3,lowestgradID), 'k', 1.5);
% % %                         
% % %                         [is_pos_free,id_node]=Auxiliar_SelfAssembly.check_position_free((actual_x(1:n,lowestgradID)+circling(:,5)),actual_x);
% % % 
% % %                         if norm(nodeVars(i).CEFRposition-actual_x(1:n,lowestgradID),2)<0.02
% % %                             %there is no other node with a lower grad to follow
% % %                             nodeVars(i).state=5;
% % %                         elseif ~is_pos_free
% % %                             %there is a node here already, i am on a higher layer, so I will start
% % %                             %edge following him
% % %                             idx_neighV=find(nodeVars(i).neighId==id_node);
% % %                             nodeVars(i).CEFRposition=actual_x(1:n,id_node);
% % %                             nodeVars(i).CEFRid=id_node;
% % %                             nodeVars(i).CEFRgradient=nodeVars(i).neighGrad(idx_neighV);
% % %                             nodeVars(i).goalPos=nodeVars(i).CEFRposition+circling(:,1);
% % %                             nodeVars(i).CEFRcirclingPos=1;
% % %                             for m=1:4
% % %                                 prospecting_pos=nodeVars(i).CEFRposition+circling(:,m);
% % % % % %                                 objects_in_fig = Auxiliar_SelfAssembly.plot_line_3d(objects_in_fig, posi, prospecting_pos, 'k', 1.5);
% % %                                 %find the closest position to start the edge follow
% % %                                 if norm(posi-nodeVars(i).goalPos,2)>norm(posi-prospecting_pos,2)
% % %                                     nodeVars(i).goalPos=prospecting_pos;
% % %                                     nodeVars(i).CEFRcirclingPos=m;
% % %                                 end
% % %                             end
% % %                         else
% % %                             idx_neighV=find(nodeVars(i).neighId==lowestgradID);
% % %                             nodeVars(i).CEFRposition=actual_x(1:n,lowestgradID);
% % %                             nodeVars(i).CEFRid=lowestgradID;
% % %                             nodeVars(i).CEFRgradient=nodeVars(i).neighGrad(idx_neighV);
% % %                             nodeVars(i).CEFRcirclingPos=5;
% % %                             nodeVars(i).goalPos=nodeVars(i).CEFRposition+circling(:,5);
% % %                         end
