% Description
% This simulation aims to study network control strategies applied to
% assembly.
% Here, different subgroups of the network will apply different assembly
% rules to create compound parts.
% Simulating state of nodes 

clear
close all
block_size=0.1;
steps=1;

%% Initializing figure
close all
record_video=false;
export_figures=true;
plot_landed_definitively=true;
% figure('units','normalized','outerposition',[0.43 0.25 0.28 0.98]); record_video=0;
% figure('units','normalized','outerposition',[1.00 0.25 0.65 1.40]); record_video=1;
% figure('units','normalized','outerposition',[0.43 0.50 0.28 0.50]); %dell monitor, home, top left 
% figure('units','normalized','outerposition',[0.047767857142857,0.048125,0.277678571428571,0.535625]); ft_size=20; %figure_to_export lab vertical monitor
figure('units','normalized','outerposition',[0.049107142857143,0.00125,0.224107142857143,0.631875]); ft_size=40; %figure_to_export laptop + screen home
% figure('units','normalized','outerposition',[1.50 0.20 0.30 0.50]); %FIGURE MAC
                                               
% view(135,30);
view(-135,30);

grid on;
% axis([-0.2 0.6 -0.2 0.6 0 0.8]*4)
axis([-1 14 -5 10 0 15]*block_size)
hold on
% xlabel('X_B', 'fontsize', 20)
% ylabel('Y_B', 'fontsize', 20)
% zlabel('Z_B', 'fontsize', 20 )
xlabel('X_I', 'fontsize', 20)
ylabel('Y_I', 'fontsize', 20)
zlabel('Z_I', 'fontsize', 20)
drawnow
pause(0.5)

for sub_structure = 1:3
%% Structure
if sub_structure == 1 || sub_structure == 2
    %pole
    S=[ 	
    0,0,0;	1,0,0;	2,0,0;	3,0,0;	4,0,0;
    0,1,0;	1,1,0;	2,1,0;	3,1,0;	4,1,0;
    0,2,0;  1,2,0;	2,2,0;	3,2,0;	4,2,0;
    0,3,0;	1,3,0;	2,3,0;	3,3,0;	4,3,0;
    0,4,0;	1,4,0;	2,4,0;	3,4,0;	4,4,0;

    1,1,1;	2,1,1;	3,1,1;
    1,2,1;	2,2,1;  3,2,1;
    1,3,1;	2,3,1;	3,3,1;

    1,1,2;	2,1,2;	3,1,2;
    1,2,2;	2,2,2;  3,2,2;
    1,3,2;	2,3,2;	3,3,2;

    1,1,3;	2,1,3;	3,1,3;
    1,2,3;	2,2,3;  3,2,3;
    1,3,3;	2,3,3;	3,3,3;

    1,1,4;	2,1,4;	3,1,4;
    1,2,4;	2,2,4;  3,2,4;
    1,3,4;	2,3,4;	3,3,4;

    1,1,5;	2,1,5;	3,1,5;
    1,2,5;	2,2,5;  3,2,5;
    1,3,5;	2,3,5;	3,3,5;
    ];
else
    %pavement
    S=[ 	
    0,0,0;	1,0,0;	2,0,0;	3,0,0;	4,0,0;  5,0,0;	6,0,0;	7,0,0;	8,0,0;	9,0,0;	10,0,0;
    0,1,0;	1,1,0;	2,1,0;	3,1,0;	4,1,0;  5,1,0;	6,1,0;	7,1,0;	8,1,0;	9,1,0;	10,1,0;
    0,2,0;	1,2,0;	2,2,0;	3,2,0;	4,2,0;  5,2,0;	6,2,0;	7,2,0;	8,2,0;	9,2,0;	10,2,0;
    ];
end

%Seeds for chair
Seed_S=[ 0,0,0; 1,1,1;  1,1,2;  1,1,3;  1,1,4;  1,1,5;]; %aligned one over the other
% Seed_S=[ 0,0,0; 4,0,1;  0,0,2;  4,0,3;  0,0,4;  4,0,5;]; %each one on a side

Seed_S_global=[[0;0;0;0;0;0],[8;0;0;0;0;0],[1;1;7;0;0;0]]*block_size;
%Seeds for pyramid
% Seed_S=[0,0,0;0,1,1;1,1,2;];
% Seed_S=[0,0,0;2,1,1;1,1,2;];

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
x(:,1)=[0;0;block_size/2;0;0;0] + Seed_S_global(:,sub_structure);
for i=2:N 
%     [newx,newy]= pol2cart(rand*2*pi,abs(rand*0.2+0.05));
%     newx=min(max(newx,-1),-0.2);
%     newy=min(max(newy,-1),-0.2);
%     x(:,i)=[newx+x(1,i-1);newy+x(2,i-1);1;0;0;0];
    [newx,newy]= pol2cart(rand*2*pi,1.5);%[newx,newy]= pol2cart(rand*2*pi,1.5);
x(:,i)=[ block_size*2; -block_size*2; block_size/2; 0;0;0] + Seed_S_global(:,sub_structure);
end
G = graph(A);
hops_graph=distances(G);

%% Gain matrix
kp=0.1; kv=sqrt(2*kp);
C=[ kp kv; 3 2*sqrt(3); 1 2*sqrt(1); 1 2*sqrt(1)];


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
x(:,1,1)=[Seed_S(1,1)*block_size;Seed_S(1,2)*block_size;block_size/2;0;0;0] + Seed_S_global(:,sub_structure);
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
   
    for i=1:N
    % Figure plot
    % ---------------
        switch nodeVars(i).state
            case 1
%                 objects_in_fig=[objects_in_fig,Auxiliar.block3d(x(1,i,k),x(2,i,k),x(3,i,k),'darkGrey')];
%                 objects_in_fig=[objects_in_fig,text(x(1,i,k)-0.01,x(2,i,k),x(3,i,k)+block_size/2+0.01,num2str(i))];
%             case 2
%                 objects_in_fig=[objects_in_fig,Auxiliar.block3d(x(1,i,k),x(2,i,k),x(3,i,k),'red')];
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


    title(strcat('t=',num2str(steps)))
    disp([t,steps,k])
%     title(strcat('t=',num2str(k)))
%     title(strcat('t=',num2str(t),'s'))
    actual_x=x(:,:,k) - Seed_S_global(:,sub_structure);
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
                objects_in_fig = [objects_in_fig,quiver3(   posi(1) + Seed_S_global(1,sub_structure),...
                                                            posi(2) + Seed_S_global(2,sub_structure),...
                                                            posi(3) + Seed_S_global(3,sub_structure)+block_size*0.6,...
                                                            vect(1),vect(2),vect(3), 'LineWidth',1.5,'MaxHeadSize',0.9, 'Color', 'b')];
                        
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
                    if plot_landed_definitively; Auxiliar.block3d(actual_x(1,i)+ Seed_S_global(1,sub_structure),actual_x(2,i)+ Seed_S_global(2,sub_structure),actual_x(3,i)+ Seed_S_global(3,sub_structure),'grey'); end
%                     surf(Xs+nodeVars(i).goalPos(1),Ys+nodeVars(i).goalPos(2),Zs+nodeVars(i).goalPos(3)+0.75);
                    count=0;
                    now=t;
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
    
    x(:,:,k+1)=new_x + Seed_S_global(:,sub_structure);
    
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
                ax.XTickLabel=[{0},{5},{10},{15}];
                ax.YTickLabel=[{-5},{0},{5},{10}];
                ax.ZTickLabel=[{0},{5},{10},{15}];
                ax.FontSize=ft_size;
                %%print(strcat('chair_',z,num2str(k)),'-dpng')
                                
                % Requires R2020a or later

%                 av_x=[1;0;0];
%                 av_y=[0;1;0];
%                 av_z=[0;0;1];
%                 objects_in_fig=[objects_in_fig,quiver3(x(1,1,1), x(2,1,1), x(3,1,1), av_x(1)*0.2,av_x(2)*0.2,av_x(3)*0.2, 'LineWidth',2, 'color', 'blue', 'MaxHeadSize', 1/0.2)]
%                 objects_in_fig=[objects_in_fig,quiver3(x(1,1,1), x(2,1,1), x(3,1,1), av_y(1)*0.2,av_y(2)*0.2,av_y(3)*0.2, 'LineWidth',2, 'color', 'blue', 'MaxHeadSize', 1/0.2)]
%                 objects_in_fig=[objects_in_fig,quiver3(x(1,1,1), x(2,1,1), x(3,1,1), av_z(1)*0.2,av_z(2)*0.2,av_z(3)*0.2, 'LineWidth',2, 'color', 'blue', 'MaxHeadSize', 1/0.2)]
                
                exportgraphics(ax,strcat('bridge_',num2str(sub_structure),'_',padding,num2str(round(k)), '.png'),'Resolution',300) %this removes empty spaces around the figure
                now=t+10;
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
    steps=steps+1;
end
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
%     objects_in_fig=[objects_in_fig,title(strcat('t = ',num2str(t),' s'))];
