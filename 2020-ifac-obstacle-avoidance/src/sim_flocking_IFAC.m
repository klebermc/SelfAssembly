% Simulating state of nodes 
clear

%% 2D - N nodes
N=10;                % Nodes in the network, cardinallity of vertex set
n=2;                % Variables of the state of each node
A=ones(N,N)-eye(N);       % Ajacency Matrix
x=zeros(4,N);
for i=1:N; x(:,i)=[rand;rand;0;0]+[1.5;4.5;0;0]; end %x(:,i)=[rand*N/10;rand*N/10;0;0]+[1;4;0;0]; end
% x(:,1)=[1.2;1.2;0;0]; x(:,2)=[2;1;0;0]; x(:,3)=[2;1.9;0;0]; x(:,4)=[2;2.9;0;0]; x(:,5)=[3;1;0;0]; x(:,6)=[3;0.25;0;0];
% x=[12.9237    4.4030    5.0000   12.2490    4.6238   12.1654    5.0352    4.3789    2.9898    3.7966;
%     3.3493    5.4540    4.8247    2.8232    4.7535    3.5165    5.9570    6.4331    5.4481    4.9429;
%     0.4247    0.0681    0.3795    0.4907    0.1302    0.4841   -0.0111    0.0744   -0.0350   -0.0152;
%     0.2655   -0.0521   -0.1772    0.2181   -0.0921    0.2168   -0.0266   -0.0663    0.0495    0.0338].*[1;1;0;0];
% 
% A=[  0     0     0     1     0     1     0     0     0     0;
%      0     0     0     0     0     0     1     1     0     1;
%      0     0     0     0     0     0     1     0     0     0;                                                                                     
%      1     0     0     0     0     1     0     0     0     0;
%      0     0     0     0     0     0     1     0     0     1;
%      1     0     0     1     0     0     0     0     0     0;
%      0     1     1     0     1     0     0     1     0     0;
%      0     1     0     0     0     0     1     0     0     0;
%      0     0     0     0     0     0     0     0     0     1;
%      0     1     0     0     1     0     0     0     1     0];
 
%% Obstacles
OBS =       [ 5; 8; 0.25];
OBS = [OBS, [ 5; 2; 0.25]];
OBS = [OBS, [ 4.5; 4; 0.25]];
OBS = [OBS, [ 6; 6; 0.25]];
OBS = [OBS, [ 6; 3; 0.25]];
OBS = [OBS, [ 8; 9; 0.25]];
OBS = [OBS, [ 8; 5; 0.25]];
OBS = [OBS, [ 8; 2; 0.25]];
OBS = [OBS, [10; 7; 0.25]];
OBS = [OBS, [10; 3; 0.25]];
OBS = [OBS, [12; 7; 0.25]];
OBS = [OBS, [12; 5; 0.25]];
OBS = [OBS, [14; 5; 0.25]];
OBS = [OBS, [14; 1; 0.25]];

%Wall, not interesting for formation
% OBS =       [4; 5; 0.5];

hist_plot=[];

%% Gain matrix
%C=[ c1_alpha c2_alpha; c1_beta c2_beta; c1_gamma c2_gamma, c1_vn c2_vn];
%C=[ 2 2; 1 5; 2 10; 1 1];
C=[ 2 2*sqrt(2); 3 2*sqrt(3); 1 2*sqrt(1); 1 2*sqrt(1)];

%% Weight matrix
W=ones(N,N);

%% Graph
G = graph(A);
hops_graph=distances(G);
pins=1;

%% Virtual Nodes
A_vn=zeros(N,N);       % Ajacency Matrix
x_vn=zeros(4,N);

%% Figure 
close all
%figure('units','normalized','outerposition',[0 0 1 1])
% figure('outerposition',[100 50 1312 738])
figure('outerposition',[100 50 1220 800])
title('t = 0 - pins = []')
% area_dimensions=[17.778 10];
area_dimensions=[18 10];
grid on
axis([0 area_dimensions(1) 0 area_dimensions(2)])
hold on
set(gca,'fontsize', 35);
ax = gca;
outerpos = ax.OuterPosition;
ti = ax.TightInset; 
left = outerpos(1) + ti(1);
bottom = outerpos(2) + ti(2);
ax_width = outerpos(3) - ti(1) - ti(3);
ax_height = outerpos(4) - ti(2) - ti(4);
ax.Position = [left bottom ax_width ax_height];
% for j=1:size(OBS,2) Auxiliar.circle(9,5,1); end
% for i=1:N
%     for j=1:N; if A(i,j)==1 && i>j; objects_in_fig=[objects_in_fig,plot([x(1,i,k) x(1,j,k)],[x(2,i,k) x(2,j,k)], 'g','linewidth',2)]; end; end
%     objects_in_fig=[objects_in_fig,plot(x(1,i,k),x(2,i,k), 'xr','markersize',15)];
%     objects_in_fig=[objects_in_fig,text(x(1,i,k)+0.05,x(2,i,k)+0.1, num2str(i),'fontsize',25)];
%     %quiver(x(1,i,k),x(2,i,k),5*x(3,i,k),5*x(4,i,k));
% end
% print('test_image','-dpng')

%% Formation simulation or Swarm simulation
d=1; %inter agent distance

%formation parameters
Formation_POS_original = [
    3.0   2.0  2.0  1.0  1.0  1.0  0.0  0.0  0.0  0.0;
    1.5   1.0  2.0  0.5  1.5  2.5  0.0  1.0  2.0  3.0];
Formation_POS=Formation_POS_original*1.5;
Formation_POS_original=Formation_POS_original*1.5;
formation=0; %0 to simulate swarm, 1 to simulate formation
if formation==1; d=norm(Formation_POS(:,1)-Formation_POS(:,2)); end %change inter-agent distance

%swarm parameters
int_range_r = d*1.3;
sigma_int_range = Auxiliar.sigma_norm(int_range_r);

%% WP navigation of the ensemble
% WP = [0;5;0;0];
% WP = [WP,[7;7;0;0]];
%for j=2:3; WP(:,j) = WP(:,j-1)+[15;0;0;0]; end
finish = [17 5];
int_range_r_obs = 1.3*0.6*d;%0.5;
for j=1:size(OBS,2) Auxiliar.circle(OBS(1,j),OBS(2,j),OBS(3,j)); end
cd rrt
    path_pin = rrt(OBS,area_dimensions,int_range_r_obs,[2;5],finish);
    WP.path_pin = [path_pin; zeros(2,size(path_pin,2))];
    WP.pin_number = pins(1);
    WP.nextwp=1;
    %plot(path_pin(1,:),path_pin(2,:),'k-')
cd ..

%% General variables
MinNodes=3;
epslon = 0.5;.
dt=0.1;
now=1;
kp=1;
kv=1;
pin_close_obstacle=zeros(1,N);
node_close_obstacle=zeros(1,N);
%equation to dynamically determine the quantity of pins
max_pins=round(N/MinNodes);
max_d=d;
min_d=d/2;
% min_d=0.5;
% max_d=1;
line_eq_pins2d=[1 1;1 max_pins] \ [max_d;min_d];
hist_metric=[];
acc= zeros(n,N);
colors=[ [0 0 1]; [0 1 0]; [0 1 1]; [1 0 0]; [1 0 1]; [1 1 0]; [1 1 1]];
split_network=0;
    
wait_next_it=0;
time_to_wait=0;
edges_to_cut=[];
    
record_video=0;
if record_video==1
%     v = VideoWriter(strcat('Swarm_',num2str(N),'nodes_',num2str(MinNodes),'group.avi'));
%     v.FrameRate=5;
%     open(v);
end

%% Flocking simulation
for t=dt:dt:400
    tic
    k=round(t/dt);
    %cla
    objects_in_fig=[];
    hold on
    clc;
    
    % --------------- 
    % Figure plot
    for i=1:N
        objects_in_fig=[objects_in_fig,plot(x(1,i,k),x(2,i,k), 'xr','markersize',15,'linewidth',1.5)];
        objects_in_fig=[objects_in_fig,text(x(1,i,k)+0.05,x(2,i,k)+0.1, num2str(i),'fontsize',25)];
        %quiver(x(1,i,k),x(2,i,k),5*x(3,i,k),5*x(4,i,k));
        %for j=1:N; if A(i,j)==1 && i>j; edges=[edges,plot([x(1,i,k) x(1,j,k)],[x(2,i,k) x(2,j,k)], 'g')]; end; end
    end
    
    %First the node will check its connections
    for i=1:N
        %who is close (therefore, connected)
        for j=1:N
            %In a real scenario, I would not iterate through all vehicles, 
            %but through all sensors to see "who" am I seeing
            if i~=j 
                if norm(x(1:n,i,k)-x(1:n,j,k),2)<=d*0.7 ... %node is close
                   && A(i,j)==0 %node is not connected
                    if size(edges_to_cut,1)>0 %&& split_network==1
                        if ~(any(sum(abs([edges_to_cut(:,1)-i,edges_to_cut(:,2)-j]),2)<=1e-10))...
                        || ~(any(sum(abs([edges_to_cut(:,1)-j,edges_to_cut(:,2)-i]),2)<=1e-10))%...
                        %|| norm(x(1:n,i,k)-x(1:n,j,k),2)<=d 
                            %make sure that this connection is not a previously cutted connection
                            [ A, hops_graph ] = Auxiliar_DynNet.change_net_topology_add(A,i,j);
                        end
                    else%if split_network==0
                        [ A, hops_graph ] = Auxiliar_DynNet.change_net_topology_add(A,i,j);
                    end
                end
                if norm(x(1:n,i,k)-x(1:n,j,k),2)>int_range_r ... %node is not close
                   && A(i,j)==1 %node is connected
                    [ A, hops_graph ] = Auxiliar_DynNet.change_net_topology_remove(A,i,j);
                end
                if A(i,j)==1 && i>j; objects_in_fig=[objects_in_fig,plot([x(1,i,k) x(1,j,k)],[x(2,i,k) x(2,j,k)], 'g','linewidth',2)]; end
            end
            if W(i,j)==0;W(i,j)=1; W(j,i)=1;end
        end
    end
    
    edges_to_cut=[];
    split_network=0;
    %Now, lets break the network in case any node is out of the metric
    for i=1:N
        [metric,NetSize]=Auxiliar_DynNet.cohesion_metric (A,hops_graph,x(:,:,k),i,MinNodes);
        %if metric>int_range_r*0.9; objects_in_fig=[objects_in_fig,text(x(1,i,k)+0.05,x(2,i,k)-0.1, num2str(metric,3),'Color','red')]; end
        if wait_next_it~=1 && metric>int_range_r*0.95
            %then I have to care, to few nodes and the connections are getting weaker
            %split the network equally, using the distance to pin
            split_network=1; %I wanted to split the network, but probably cant because of net size
            if NetSize>MinNodes 
                [ cut , A , hops_graph, subnet ] = Auxiliar_DynNet.split_network( A , hops_graph , x , k, i, MinNodes);
                edges_to_cut=[edges_to_cut;cut];
                %i,subnet
                if length(subnet)>=MinNodes %I have to garantee that I will only split if the new net is greater than the min nodes allowed
                    for a=1:size(edges_to_cut,1); 
                        [ A, hops_graph ] = Auxiliar_DynNet.change_net_topology_remove( A, edges_to_cut(a,1), edges_to_cut(a,2) );
%                         objects_in_fig=[objects_in_fig,plot([x(1,edges_to_cut(a,1),k) x(1,edges_to_cut(a,2),k)],[x(2,edges_to_cut(a,1),k) x(2,edges_to_cut(a,2),k)], 'm','linewidth',1.5)]; 

    %                     delete(edges); edges=[]; edges=[edges,plot([x(1,edges_to_cut(a,1),k) x(1,edges_to_cut(a,2),k)],[x(2,edges_to_cut(a,1),k) x(2,edges_to_cut(a,2),k)], 'm')]; 
    %                     for i=1:N; for j=1:N; if A(i,j)==1 && i>j; edges=[edges,plot([x(1,i,k) x(1,j,k)],[x(2,i,k) x(2,j,k)], 'g')]; end; end; end

    %                     if sum(A(edges_to_cut(a,1),:))<2 || sum(A(edges_to_cut(a,2),:))<2 
    %                        [ A, hops_graph ] = Auxiliar_DynNet.change_net_topology_add( A, edges_to_cut(a,1), edges_to_cut(a,2) ); %nobody is staying alone
    %                     end
                    end
                else
                    disp(strcat( 'node [', num2str(i), '] wants to break the net, but I only have [',num2str(length(subnet)),'] nodes' ))
                end
            end
        end
    end

    %checking groups with size smaller than allowed
    for temp=1:2*N %as a security measure, there is an end in this loop
        problematicNodes=[];
        for i=1:N; if length(hops_graph(i,:))-sum(isinf(hops_graph(i,:))) < MinNodes; problematicNodes=[problematicNodes,i]; end ; end
        if length(problematicNodes)<1; break; end %end when I have no problematic nodes anymore
        
        i=problematicNodes(1); %solve the first problematic node and reevaluate
        closest_node=0;
        closest_dist=inf;
        for j=1:N
            distance=norm(x(1:n,i,k)-x(1:n,j,k),2);
            if distance<closest_dist && isinf(hops_graph(i,j))
                closest_dist=distance;
                closest_node=j;
            end
        end
        [ A, hops_graph ] = Auxiliar_DynNet.change_net_topology_add(A,i,closest_node);
        objects_in_fig=[objects_in_fig,plot([x(1,i,k) x(1,closest_node,k)],[x(2,i,k) x(2,closest_node,k)], 'g','linewidth',2)];
    end
    
    W=ones(N,N);
    W = W.*A;
    
    %Now check if it is needed to find new pins
    newpins = Auxiliar_DynNet.update_pins ( hops_graph, pins, A );
    if length(newpins) > length(pins)
        %Just gained a pin, lets compute the path
        cd rrt
        %WP=struct('path_pin',{},'pin_number',{},'nextwp',{});
        for idxpin=1:length(newpins)
            if ~any(newpins(idxpin)-pins==0) %I will not recompute the path for a pin that I already have
                path_pin = rrt(OBS,area_dimensions,int_range_r_obs,x(1:n,newpins(idxpin),k),finish);
                path_pin = [path_pin; zeros(2,size(path_pin,2))];
                WP(idxpin).path_pin = path_pin; %add a new path to a pin
                WP(idxpin).pin_number = newpins(idxpin); %say who is the pin that have this path
                WP(idxpin).nextwp=1;
            end
        end
        cd ..
    end
    if length(newpins) < length(pins)
        for excluded_pin=pins
            if ~any(excluded_pin-newpins==0)
                for idxpin=1:length(WP)
                    if WP(idxpin).pin_number==excluded_pin
                        WP(idxpin)=[];
                        break;
                    end
                end
            end
        end
        edges_to_cut=[]; 
    end
    %d=line_eq_pins2d(1)+line_eq_pins2d(2)*length(newpins); % if I am using more pins, get the nodes closer
    %d=min(max(d,min_d),max_d);
    %Formation_POS=Formation_POS_original*(d/max_d);
    pins=newpins;
    
    %now that every node checked everything, I will run the simulation of the nodes
    for i=1:N 
        %starts with every node computing its metrics and the states of other agents considering network delay
        [metric(i),NetSize(i)]=Auxiliar_DynNet.cohesion_metric (A,hops_graph,x(:,:,k),i,MinNodes);
        states_with_delay=[];%zeros(n*2,1);
        %get the delayed states from other nodes
        for j=1:N
            if ~isinf(hops_graph(i,j)) %if it is infinity, that means that this pin does not have access to the state of j
                k_with_delay=k-hops_graph(i,j);
                if k_with_delay<1;k_with_delay=1;end
                %disp([i,j,k,hops_graph(i,j),k_with_delay])
                states_with_delay = [states_with_delay, x(:,j,k_with_delay)];
            end
        end
        
        posi = x(1:n,i,k);
        veli = x(n+1:n+n,i,k);
        u = x(n+1:n+n,1,1)*0;
        
        % -------- Obstacle avoidance -------- 
        %considering the obstacle as another agent
        pin_close_obstacle(1,i)=0;
        for j=1:size(OBS,2)
            sigma_d_obs = Auxiliar.sigma_norm(d*0.6);%d/4);
            int_range_r_obs=1.3*0.6*d;
            sigma_int_range_obs = Auxiliar.sigma_norm(int_range_r_obs);
            %if i==1; Auxiliar.circle(OBS(1,j),OBS(2,j),OBS(3,j)); end %drawing the circles
            
            %To run simulation faster,
            %avoid the calculations if the target is out of range
            if norm(posi - OBS(1:n,j))<int_range_r_obs+OBS(3,j)
                %disp([i,j,norm(posi - OBS(1:n,j)), int_range_r_obs, int_range_r_obs+OBS(3,j)])
               
                mu = OBS(3,j)/norm(posi - OBS(1:n,j));      % obtain the vector from agent to object
                a_k = (posi - OBS(1:n,j))/norm(posi - OBS(1:n,j));
                P=eye(n) - a_k * (a_k');
                pos_beta=mu*posi+(1-mu)*OBS(1:n,j);         %position of beta agent (%olfati-saber modeling)
                vel_beta=mu*P*veli;                         %velocity of beta agent (%olfati-saber modeling)

                diff=pos_beta-posi;
                sigma_diff = Auxiliar.sigma_norm(diff);
                phi_beta = Auxiliar.rho_h(sigma_diff/sigma_int_range_obs)*(Auxiliar.sigma_1(sigma_diff-sigma_d_obs)-1);
                nij = diff/sqrt(1+epslon*norm(diff,2)^2);
                b_ik = Auxiliar.rho_h(sigma_diff/sigma_int_range_obs);
                %u = u + (1/sigma_diff)*phi_alpha*nij;
                
                gain=1;
                if mu>0.98
                    %plot(pos_beta(1), pos_beta(2), 'or');
                    %x(1:n,i,k) = x(1:n,i,k-1);
                    %x(n+1:n+n,i,k) = vel_beta;
                    %temp=OBS(1:n,j) + OBS(3,j)* ((posi - OBS(1:n,j))/norm(posi - OBS(1:n,j)));
                    %plot( x(1,i,k),  x(2,i,k), 'vm');
                    node_close_obstacle(1,i)=1;
%                 elseif norm(diff)<0.05; 
%                     gain=(0.01/sigma_diff); 
                end %this just avoids the node getting inside the obstacle
                %disp([mu,gain]); 
                u = u + C(2,1)*gain*phi_beta*nij + C(2,2)*b_ik*(vel_beta-veli);
            
                %plot(pos_beta(1), pos_beta(2), 'xb');
                objects_in_fig=[objects_in_fig,plot([posi(1) pos_beta(1)],[posi(2) pos_beta(2)], 'b','linewidth',1.5)];
                %text(mean([posi(1) pos_beta(1)]),mean([posi(2) pos_beta(2)]),...
                %    strcat('d=',num2str(norm(diff,2),2)));
                %    strcat('phi_alpha=',num2str(phi_alpha,3 ),', d=',num2str( norm(diff,2),3 ),', sig-d=',num2str( sigma_diff,3 ), ', exp=',num2str( exp(1/norm(diff,2)),3 ),', sig-d-1=',num2str( (1/sigma_diff)),3 ));             
                if norm(diff,2)<int_range_r_obs
                    if any(abs(pins-i)<=1e-10)
                        %disp('Pin close to obstacle')
                        %disp([norm(diff,2),pins,i,j])
                        pin_close_obstacle(1,i)=1;
                    end
                end
            end
        end
        
        % -------- Pinning controller -------- 
        if any(abs(pins-i)==0)
            if t>30
                %if i is a pin, I will find a path for it here
                idxWP=1;
                for pn = WP; if pn.pin_number == i ; break; end; idxWP=idxWP+1; end
                x_vn(:,i)=mean(states_with_delay(1:2*n,:),2);
                
                if NetSize(i)<2*MinNodes; dist=norm(pn.path_pin(1:2,pn.nextwp)-x_vn(1:2,i),2); %follow CM, node is taking the virtual node (center) to goal
                else;                     dist=norm(pn.path_pin(1:2,pn.nextwp)-x(1:n,i,k),2); %the node is taking itself there
                end
                
                dist2cm=1;
                if NetSize(i)<2*MinNodes; dist2cm=2; end
                    
                if dist < 0.2*dist2cm
                    WP(idxWP).nextwp=max(min(pn.nextwp+1,size(pn.path_pin,2)), 1);
                    pn.nextwp=max(min(pn.nextwp+1,size(pn.path_pin,2)), 1);
                    acc(1:n,i)=zeros(n,1);
                end

                %delayed states
                if NetSize(i)<2*MinNodes
                    u = u + C(3,1)*(pn.path_pin(1:2,pn.nextwp)-x_vn(1:2,i)) + C(3,2)*(pn.path_pin(3:4,pn.nextwp)-x_vn(3:4,i)); %center of mass
                else
                    acc(1:n,i)=min(max(acc(1:n,i)+(pn.path_pin(1:2,pn.nextwp)-x(1:n,i,k)),-50),50);
                    u = u + formation*0.001*acc(1:n,i) + C(3,1)*(pn.path_pin(1:2,pn.nextwp)-x(1:n,i,k)) + C(3,2)*(pn.path_pin(3:4,pn.nextwp)-x(n+1:n+n,i,k)); %own position
                end
                %ideal states (no delay)
                %u = u + 1e0*(WP(1:2,nextwp)-mean(x(1:n,:,k),2)) + 1e1*(WP(3:4,nextwp)-mean(x(n+1:n+n,:,k),2));
                
                %plots related to this pin (path, nextwaypoint center of mass of this graph)
                objects_in_fig=[objects_in_fig,plot(pn.path_pin(1,:),pn.path_pin(2,:),'k--','linewidth',1)];
                objects_in_fig=[objects_in_fig,plot(pn.path_pin(1,pn.nextwp),pn.path_pin(2,pn.nextwp), 'vk','markersize',15, 'linewidth',1.5)];
                %objects_in_fig=[objects_in_fig,text(pn.path_pin(1,pn.nextwp)+0.02,pn.path_pin(2,pn.nextwp)+0.02, strcat('GOAL-',num2str(i)))];
                objects_in_fig=[objects_in_fig,plot(x(1,i,k),x(2,i,k), 'ob','markersize',15,'linewidth',1.5)];
%                 if NetSize(i)<=MinNodes
%                     plot(x_vn(1,i),x_vn(2,i), 'or');
%                     text(x_vn(1,i)+0.05,x_vn(2,i)+0.01, 'VN-CM','Color','red');
%                 end
            end
%             plot(mean(states_with_delay(1,:),2),mean(states_with_delay(2,:)), 'or');
%             text(mean(states_with_delay(1,:))+0.01,mean(states_with_delay(2,:))+0.01, num2str(metric,2),'Color','red');
        end
        
        % -------- Inter-agent distance -------- 
        for j=1:N
%             if A(i,j)~=0; disp([i,j]);end
            if i~=j && A(i,j)~=0
%                 posj = states_with_delay(1:n,j);
%                 velj = states_with_delay(n+1:n+n,j);
                posj = x(1:n,j,k);
                velj = x(n+1:n+n,j,k);
                diff = posj-posi;
                if formation==1
                    posi_s = Formation_POS(1:n,i);
                    posj_s = Formation_POS(1:n,j);
                    u = u + W(i,j)*(kp*(-posi + posj + posi_s - posj_s) + kv*(-veli+velj));
                else
                    sigma_d = Auxiliar.sigma_norm(d);
                    sigma_diff = Auxiliar.sigma_norm(diff);
                    phi_alpha = Auxiliar.rho_h(sigma_diff/sigma_int_range)*Auxiliar.sigma_1(sigma_diff-sigma_d);
                    nij= diff/sqrt(1+epslon*norm(diff,2)^2);
%                     N_i=0; for m=1:size(hops_graph,2); if ~isinf(hops_graph(i,m)); N_i=N_i+1; end; end
                    gain=1; if norm(diff)<0.1; gain=(0.02/sigma_diff); end %disp([norm(diff),gain]); this just avoids the node getting inside the obstacle
                    u = u + W(i,j)*( C(1,1)*gain*phi_alpha*nij + C(1,2)*Auxiliar.rho_h(sigma_diff/sigma_int_range)*A(i,j)*(velj-veli) );
                end
                if i<j
                    if norm(diff,2)<=d; objects_in_fig=[objects_in_fig,plot([x(1,i,k) x(1,j,k)],[x(2,i,k) x(2,j,k)], 'g','linewidth',1.5)]; 
                    else; color=max(min([(norm(diff,2)-d)/(int_range_r-d),1-((norm(diff,2)-d)/(int_range_r-d)),0.0],1),0);
                        objects_in_fig=[objects_in_fig,plot([x(1,i,k) x(1,j,k)],[x(2,i,k) x(2,j,k)], 'Color',color,'linewidth',1.5)]; end
                end
%                 if W(i,j)~=1
%                     if i>j
%                         text(mean([x(1,i,k) x(1,j,k)]),mean([x(2,i,k) x(2,j,k)]), ...
%                             strcat('W(',num2str(i),',',num2str(j),')=',num2str(W(i,j))));
%                             %strcat('d=',num2str(sqrt((x(1,i,k)-x(1,j,k))^2+(x(2,i,k)-x(2,j,k))^2))));
%                     end
%                     disp([i,j,W(i,j)])
%                     W(i,j)=1; %reseting the weight matrix that will be altered on pin section
%                 end
            end
        end
%         %Second part of inter agent distances, virtual agents
        if NetSize(i)<2*MinNodes %|| split_network==1
            x_vn(:,i)=mean(states_with_delay(1:2*n,:),2);
            u = u + C(4,1)*(x_vn(1:2,i)-posi) + C(4,2)*(x_vn(3:4,i)-veli);
            %text(x_vn(1,i)+0.05,x_vn(2,i)+0.01, 'VN-CM','color', colors(mod(i,size(colors,1))+1,:));
            objects_in_fig=[objects_in_fig,plot(x_vn(1,i),x_vn(2,i), 'o','color', colors(mod(i,size(colors,1))+1,:) )];
        end
        
        % -------- Simulation of the dynamics of the node i -------- 
        %if max(abs(u))>1; disp(u); end
        u=min(max(u,-1),1); %saturation
        x(1:n,i,k+1)     = posi + dt*veli + ((dt^2)/2)*u;
        x(n+1:n+n,i,k+1) =           veli +         dt*u;
        
        while node_close_obstacle(i)==1
            node_moved=0;
            for j=1:size(OBS,2)
                mu = OBS(3,j)/norm(x(1:n,i,k+1) - OBS(1:n,j));
                if mu>1.001
                    %plot(x(1,i,k+1),x(2,i,k+1), 'ok');
                    x(1:n,i,k+1)=mu*x(1:n,i,k+1)+(1-mu)*OBS(1:n,j);
                    %plot(x(1,i,k+1),x(2,i,k+1), 'vm');
                    node_moved=1;
                    break;
                end
            end
            if node_moved==1; node_close_obstacle(i)=1;
            else;  node_close_obstacle(i)=0; end
        end
    end
    hist_metric=[hist_metric;metric,length(pins)];
    title(strcat('t = ',num2str(t),' sec - pins = [',num2str(pins),']'));
    hold off

    % ---------------
   proc_time=toc;
   disp(proc_time)

    if record_video==1
        if t>=now
            drawnow
            pause(0.05);
%             frame=getframe;
%             writeVideo(v,frame);
            z=''; if t<10; z='00'; elseif t<100; z='0'; elseif t>=100; z=''; end
            print(strcat('Images/',num2str(N),'N_',num2str(MinNodes),'G/',z,num2str(now)),'-dpng')
            now=t+2;
        end
    else
        pause(0.02);
    end
    delete(objects_in_fig)
end
% if record_video==1
%     close(v);
% end

figure
hold on
grid on


for node=1:N
    subplot(3,ceil(N/3),node); hold on; grid on;
    x_node=zeros(k,0);y_node=zeros(k,0);
    for i=1:k; x_node(i)=x(1,node,i); end; plot(x_node)
    for i=1:k; y_node(i)=x(2,node,i); end; plot(y_node)
    title(strcat('Node ',num2str(node)));
    axis tight
    hold off
end

figure
plot(hist_metric,'DisplayName','hist_metric')



%% Not used
%             pos_obj = OBS(1:n,j) - posi; % obtain the vector from agent to object
%             [a,r]=cart2pol(pos_obj(1),pos_obj(2)); %transfor to polar
%             r=r-OBS(3,j); %discount the object size
%             [diff(1,1),diff(2,1)]=pol2cart(a,r);
%             pos_beta(1,1)=diff(1)+posi(1); pos_beta(2,1)=diff(2)+posi(2); %position of beta agent (%olfati-saber modeling)

        
        %Getting the states with delay (the node i access the information
        %of node j delayed by number of hops)
%         states_with_delay=zeros(n*2,N);
%         for j=1:N
%             k_with_delay=k-hops_graph(i,j);
%             if k_with_delay<1;k_with_delay=1;end
%             %disp([i,j,k,hops_graph(i,j),k_with_delay])
%             states_with_delay(:,j) = x(:,j,k_with_delay);
%         end

%                 zed = posj-posi;
%                 sigma_norm_zed = Auxiliar.sigma_norm(zed);
%                 delta_sigma = zed / (1+epslon*sigma_norm_zed);
                %d_sig_norm=sqrt(1+norm(d,2)^2)-1;
                %phi_function_minus=(sigma_norm^2 -2*d_sig_norm*sigma_norm + d_sig_norm^2);
                %delta = (phi_function_plus-phi_function_minus)/0.001;
                %posji = posj-posi;
                %sigma_norm=sqrt(1+norm(posji,2)^2)-1;
                %phi_function=(sigma_norm^2 -2*d_sig_norm*sigma_norm + d_sig_norm^2);

%     for eachpin=pins
%         metric=Auxiliar_DynNet.cohesion_metric (A,hops_graph,x(:,:,k),eachpin,MinNodes);
%         if metric>int_range_r*0.8
%             %then I have to care, to few nodes and the connections are getting weaker
%             %split the network equally, using the distance to pin
%             Auxiliar_DynNet.split_network( A , hops_graph , x , k, eachpin);
%         end
%     end

    %plot(mean(x(1,:,k),2),mean(x(2,:,k)), 'ok');
    %text(mean(x(1,:,k))+0.01,mean(x(2,:,k))+0.01, 'CM','Color','black');
%making the pin increase the gains of the network nodes the network                
%             if pin_close_obstacle(1,i)==1
%                 idxs_1hop=find(abs(hops_graph(i,:)-1)<=1e-10);
%                 idxs_2hop=find(abs(hops_graph(i,:)-2)<=1e-10);
%                 idxs=[idxs_1hop,idxs_2hop];
%                 %find the closer nodes
%                 dists=[];
%                 for idx = idxs; dists = [dists, norm(x(1:n,idx,k)-x(1:n,i,k),2)]; end
%                 idxs=[idxs;dists];
%                 dist_sorted=sort(dists); %sort the distances
%                 temp_idxs=[];
%                 for dist = dist_sorted
%                     for iter_hop = 1:length(dists)
%                         if idxs(2,iter_hop) == dist
%                             temp_idxs = [temp_idxs, idxs(1,iter_hop)];
%                         end
%                     end
%                 end
%                 idxs=temp_idxs;
%                 count_nodes=1;  %counts the number of nodes in the new subgraph
%                 LM=3;           % max nodes in the new subgraph
%                 for idx = idxs
%                     %if norm(x(1:n,idx,k)-x(1:n,i,k),2) < int_range_r && norm(x(1:n,idx,k)-x(1:n,i,k),2) > d
%                         %W(i,idx)= 100*((norm(x(1:n,idx,k)-x(1:n,i,k),2)-d)/(int_range_r-d));
%                         W(i,idx)= 5*((norm(x(1:n,idx,k)-x(1:n,i,k),2))/(int_range_r))+1;
%                         W(idx,i)=W(i,idx);
%                         count_nodes=count_nodes+1;
%                         %disp([i,idx,count_nodes,norm(x(1:n,idx,k)-x(1:n,i,k),2), W(i,idx)])
%                         if count_nodes>=LM; break; end
%                     %end
%                 end
%             end