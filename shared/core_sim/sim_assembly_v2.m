% Description
% This simulation aims to study network control strategies applied to
% assembly.
% Here, different subgroups of the network will apply different assembly
% rules to create compound parts.
% Simulating state of nodes 

clear
 
%% 1D - 2 nodes
% Gamma=1;   % Inter state relationship matrix
% A=[0 1; 1 0];       % Ajacency Matrix
% A_deg=A;       % Ajacency Matrix version with degree
% for i=1:size(A,1); A_deg(i,i) = -sum(A(i,:)); end
% N=2;                % Nodes in the network, cardinallity of vertex set
% n=1;                % Variables of the state of each node dimensions to consider
% x=[0.25,0.75;-0.5,0.5];
% %u=[0;0.1]*0;

%% 2D - 2 nodes
% Gamma=[1 0; 0 1];   % Inter state relationship matrix
% A=[0 1; 1 0];       % Ajacency Matrix
% A_deg=A;       % Ajacency Matrix version with degree
% for i=1:size(A,1); A_deg(i,i) = -sum(A(i,:)); end
% N=2;                % Nodes in the network, cardinallity of vertex set
% n=2;                % Variables of the state of each node
% x=[ [0.4;0.5;0;0] , [0.6;0.5;0;0] ] ;


%% 2D - 3 nodes
% Gamma=[1 0; 0 1];   % Inter state relationship matrix
% A=[0 1 1; 1 0 1; 1 1 0];       % Ajacency Matrix
% A_deg=A;       % Ajacency Matrix version with degree
% for i=1:size(A,1); A_deg(i,i) = -sum(A(i,:)); end
% N=3;                % Nodes in the network, cardinallity of vertex set
% n=2;                % Variables of the state of each node
% x=[ [0.1;0.2;0;0] , [0.5;0.7;0;0] , [0.25;0.25;0;0] ] ;

%% 2D - 9 nodes
% N=9;                % Nodes in the network, cardinallity of vertex set
% n=2;                % Variables of the state of each node
% Gamma=[1 0; 0 1];   % Inter state relationship matrix
% % A=zeros(N,N);       % Ajacency Matrix
% A=ones(N,N)-eye(N);
% 
% % for i=1:N-2;    for j=1:2;        A(i,i+j)=1;    end; end
% % A(N-1,N)=1;
% % A = A + A';
% A_deg=A;       % Ajacency Matrix version with degree
% for i=1:size(A,1); A_deg(i,i) = -sum(A(i,:)); end
% x=zeros(4,N);
% x(:,1)=[0;0;0;0];
% for i=2:N 
%     [newx,newy]= pol2cart(rand*2*pi,rand*0.2+0.5);
%     x(:,i)=[newx+x(1,i-1);newy+x(2,i-1);0;0];  
% end
% G = graph(A);
% hops_graph=distances(G);

%% 2D - 10 nodes
% N=10;                % Nodes in the network, cardinallity of vertex set
% n=2;                % Variables of the state of each node
% Gamma=[1 0; 0 1];   % Inter state relationship matrix
% % A=zeros(N,N);       % Ajacency Matrix
% A=ones(N,N)-eye(N);
% 
% % for i=1:N-2;    for j=1:2;        A(i,i+j)=1;    end; end
% % A(N-1,N)=1;
% % A = A + A';
% A_deg=A;       % Ajacency Matrix version with degree
% for i=1:size(A,1); A_deg(i,i) = -sum(A(i,:)); end
% x=zeros(4,N);
% x(:,1)=[0;0;0;0];
% for i=2:N 
%     [newx,newy]= pol2cart(rand*2*pi,rand*0.2+0.5);
%     x(:,i)=[newx+x(1,i-1);newy+x(2,i-1);0;0];  
% end
% G = graph(A);
% hops_graph=distances(G);

%% 3D - 8 nodes
N=5;                % Nodes in the network, cardinallity of vertex set
n=3;                % Variables of the state of each node
Gamma=[1 0; 0 1];   % Inter state relationship matrix
A=ones(N,N)-eye(N);

A_deg=A;       % Ajacency Matrix version with degree
for i=1:size(A,1); A_deg(i,i) = -sum(A(i,:)); end
x=zeros(n*2,N);
x(:,1)=[0;0;1;0;0;0];
for i=2:N 
    [newx,newy]= pol2cart(rand*2*pi,rand*0.2+0.5);
    x(:,i)=[newx+x(1,i-1);newy+x(2,i-1);1;0;0;0];  
end
G = graph(A);
hops_graph=distances(G);
des_pos_group=[0;0;1];

%% WP navigation of the ensemble
WP = [1;1;0;0];
for j=2:5; WP(:,j) = WP(:,j-1)+[1;1;0;0]; end
nextwp=1;

close all

%% Gain matrix
kp=1; kv=sqrt(2);
C=[ kp kv; 3 2*sqrt(3); 1 2*sqrt(1); 1 2*sqrt(1)];

%% Compound part description
block_size=0.13;
compound_part=[0,0;0,1;0,2;]';
compound_part=compound_part*block_size;
is_compound_part=zeros(N);


%% Defining the subgroup and the assembly rule that will be applied
for i=1:N
    assembly_group{i}.rule='flocking';
    assembly_group{i}.neighbours=1:N;
end

%% Initializing figure
figure('units','normalized','outerposition',[0 0 0.2 0.4])
view(45,30);
grid on;
%axis([0-1 3.67-1 0-1 2-1]*2)
%axis equal
axis ([min(x(1,:))-1 max(x(1,:))+1 min(x(2,:))-1 max(x(2,:))+1 0 2])
hold on
drawnow
pause(0.5)

%% Structure
structure=zeros(3,1,2);
structure(1,1,1)=1;
structure(1,1,2)=1;
structure(2,1,2)=1;
structure(3,1,1)=1;
structure(3,1,2)=1;
group=zeros(3,1,2);

%% Flocking simulation

% Discretizing the adjacency matrix to simulate the network behaviour
%Ad = ssdata(c2d(ss(A_deg,zeros(N*n,1),zeros(1,N*n),zeros(N*n,1)),dt))
epslon = 0.9;
dt=0.1;
inter_agent_d=1;
sigma_d = Auxiliar.sigma_norm(inter_agent_d);
int_range_r = 1.5;
sigma_int_range = Auxiliar.sigma_norm(int_range_r);
objects_in_fig=[];
time_to_assemble_cp=500;
variables=[];
now=1;
meandiff_rendez=0;
assemble_compound_part=0;
time_for_structure=0;
original_node=1;
pin=4;
des_pos=[1;1;1]*block_size;
landing_node=1;
landed_nodes=[];

record_video=1;
if record_video==1
    v = VideoWriter(strcat('SelfAssembly_',num2str(N),'nodes.avi'));
    v.FrameRate=5;
    open(v);
end

for t=dt:dt:1000
        
    tic
    k=round(t/dt);
    %cla
    objects_in_fig=[];
    clc;

    
    %First the node will check its connections
    for i=1:N
        %who is close (therefore, connected)
        for j=1:N
            %In a real scenario, I would not iterate through all vehicles, 
            %but through all sensors to see "who" am I seeing
            if i~=j 
                if norm(x(1:n,i,k)-x(1:n,j,k),2)<=int_range_r ... %node is close
                   && A(i,j)==0 %node is not connected
                    %make sure that this connection is not a previously cutted connection
                    %if ismember(j,assembly_group{i}.neighbours)
                        [ A, hops_graph ] = Auxiliar_DynNet.change_net_topology_add(A,i,j);
                    %end
                end
                if norm(x(1:n,i,k)-x(1:n,j,k),2)>int_range_r ... %node is not close
                   && A(i,j)==1 %node is connected
                    [ A, hops_graph ] = Auxiliar_DynNet.change_net_topology_remove(A,i,j);
                end
                if A(i,j)==1 && i>j
%                     objects_in_fig=[objects_in_fig,plot([x(1,i,k) x(1,j,k)],[x(2,i,k) x(2,j,k)], 'k','linewidth',2)]; 
                    objects_in_fig=[objects_in_fig,plot3([x(1,i,k) x(1,j,k)],[x(2,i,k) x(2,j,k)], [x(3,i,k) x(3,j,k)], 'k','linewidth',1)]; 
                    % if norm(x(1:n,i,k)-x(1:n,j,k),2)>d  objects_in_fig=[objects_in_fig,text((x(1,i,k)+x(1,j,k))/2,(x(2,i,k)+x(2,j,k))/2,num2str(norm(x(1:n,i,k)-x(1:n,j,k),2)))];end
                end
            end
        end
    end
    
    
    if ismembertol(t,time_to_assemble_cp,0.1*dt/max(abs([t;time_to_assemble_cp])))
        for i=1:N
            if strcmp(assembly_group{i}.rule,'flocking')
                original_node=i;
                time_to_assemble_cp=10+time_to_assemble_cp;
                assemble_compound_part=1;
                break;
            end
        end 
        for i=1:N
            if strcmp(assembly_group{i}.rule,'formation')
                time_for_structure=time_for_structure+1;
            end
        end
        if time_for_structure==N
            time_for_structure=1;
        else
            time_for_structure=0;
        end
    end
    
    %a master mind will know what to do, so it will request for a specific
    %group to perform assemble
%     if ismembertol(t,time_to_assemble_cp,0.1*dt/max(abs([t;time_to_assemble_cp])))
    if assemble_compound_part==1
        nodes_in_cp=size(compound_part,2);
        closest_nodes=original_node;
        A_dist=Auxiliar_DynNet.distance_between_nodes(A,x(:,:,k),n);
        while length(closest_nodes)<nodes_in_cp
            closest_node=original_node;
            closest_dist=inf;
            for j=1:N
                if A_dist(original_node,j) < closest_dist && A_dist(original_node,j)~=0 && ~ismember(j,closest_nodes) && strcmp(assembly_group{j}.rule,'flocking')
                    closest_dist=A_dist(original_node,j);
                    closest_node=j;
                end
            end
            closest_nodes=[closest_nodes,closest_node];
        end
        sg=closest_nodes;
        for sg_i=1:length(sg)
            assembly_group{sg(sg_i)}.rule='rendezvous';
            assembly_group{sg(sg_i)}.neighbours=sg;
            for l=1:N
                if (l~=sg) 
                    assembly_group{l}.neighbours = assembly_group{l}.neighbours(assembly_group{l}.neighbours~=sg(sg_i)); %removing node from the neighbours
                end
%                  disp([l,assembly_group{l}.neighbours])
            end
        end
    end
    assemble_compound_part=0;

%     fprintf("\nFlocking: ")
%     for l=1:N
%         if strcmp(assembly_group{l}.rule,'flocking')
%             for m=1:length(assembly_group{l}.neighbours)
%                 fprintf("%d ",assembly_group{l}.neighbours(m))
%             end
%             break;
%         end
%     end
%     fprintf("\n")
%     fprintf("Formation: ")
%     for l=1:N
%         if strcmp(assembly_group{l}.rule,'formation')
%             
%             for m=1:length(assembly_group{l}.neighbours)
%                 fprintf("%d ",assembly_group{l}.neighbours(m))
%             end
%             fprintf(" - ")
%         end
%     end
%     fprintf("\n")
%     fprintf("Rendz: ")
%     for l=1:N
%         if strcmp(assembly_group{l}.rule,'rendezvous')
%             for m=1:length(assembly_group{l}.neighbours)
%                 fprintf("%d ",assembly_group{l}.neighbours(m))
%             end
%             fprintf(" - ")
%         end
%     end
%     fprintf("\n")
   
    for i=1:N
        % Figure plot
        % --------------- 
        if strcmp(assembly_group{i}.rule,'flocking')
                objects_in_fig=[objects_in_fig,Auxiliar.block3d(x(1,i,k),x(2,i,k),x(3,i,k),'grey')];
        elseif strcmp(assembly_group{i}.rule,'formation')
                objects_in_fig=[objects_in_fig,Auxiliar.block3d(x(1,i,k),x(2,i,k),x(3,i,k),'red')];
        elseif strcmp(assembly_group{i}.rule,'rendezvous')
                objects_in_fig=[objects_in_fig,Auxiliar.block3d(x(1,i,k),x(2,i,k),x(3,i,k),'blue')];
        end
        objects_in_fig=[objects_in_fig,text(x(1,i,k),x(2,i,k), num2str(i))];
    end

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
    
    % decide who will land
    if landing_node>N
        break;
    end
    
    if norm(des_pos-actual_x(1:n,landing_node),2)<0.01
        % I actually need 3 fors to check of all pos
        landed_nodes=[landed_nodes,landing_node];
        landing_node=landing_node+1;
        indexes_landed=round(des_pos/block_size);
        group(indexes_landed(1),indexes_landed(2),indexes_landed(3))=1;
        for si1=1:size(structure,1)
            for si2=1:size(structure,2)
                for si3=1:size(structure,3)
                    disp([si1,si2,si3,structure(si1,si2,si3)])
                    if  Auxiliar_SelfAssembly.row_rule([0],group,[si1,si2,si3],structure,1) == 1 && ...
                        Auxiliar_SelfAssembly.plane_rule([0],group,[si1,si2,si3],structure,1) == 1 && ...
                        structure(si1,si2,si3) == 1 && ...
                        group(si1,si2,si3) == 0
                        des_pos=[si1;si2;si3]*block_size;
                    end
                end
            end
        end
    else
        disp(norm(des_pos-actual_x(1:n,landing_node),2))
    end
        
    all_u=actual_x(1:n,:)*0;
    parfor i=1:N
        posi = actual_x(1:n,i);
        veli = actual_x(n+1:n+n,i);
        u = veli*0;
                            
        %define subgroups,
        %check if node is part of the subgroup
        %select pin inside subgroup
        
        %this is where a node start looking for its neighbours
        for j=1:N
            %if A(i,j)~=0; disp([i,j]);end
            if i~=j && A(i,j)~=0
                posj = actual_x(1:n,j);
                velj = actual_x(n+1:n+n,j);
                diff = posj-posi;
                if strcmp(assembly_group{i}.rule,'formation') && strcmp(assembly_group{j}.rule,'formation')
                    if ismember(j,assembly_group{i}.neighbours)
                        idx_i=find(abs(assembly_group{i}.neighbours-i) < 0.001);
                        idx_j=find(abs(assembly_group{i}.neighbours-j) < 0.001);
                        posi_cp = compound_part(1:n,idx_i);
                        posj_cp = compound_part(1:n,idx_j);                          
                        u = u - ( kp*(posi - posj - posi_cp + posj_cp) + kv*(veli-velj) );
                        if norm(diff,2)<block_size
                            sigma_d = Auxiliar.sigma_norm(inter_agent_d);sigma_diff = Auxiliar.sigma_norm(diff);
                            phi_alpha = Auxiliar.rho_h(sigma_diff/sigma_int_range)*Auxiliar.sigma_1(sigma_diff-sigma_d);
                            nij= diff/sqrt(1+epslon*norm(diff,2)^2);
                            gain=(0.1/sigma_diff); 
                            u = u + kp*gain*phi_alpha*nij + kv*Auxiliar.rho_h(sigma_diff/sigma_int_range)*A(i,j)*(velj-veli);    
                        end
                    else
                        if time_for_structure==1
                            %assemblying final structure                            
                        end
                   end
                else %if strcmp(assembly_group{i}.rule,'flocking') && strcmp(assembly_group{j}.rule,'flocking') 
                    sigma_d = Auxiliar.sigma_norm(inter_agent_d);
                    sigma_diff = Auxiliar.sigma_norm(diff);
                    phi_alpha = Auxiliar.rho_h(sigma_diff/sigma_int_range)*Auxiliar.sigma_1(sigma_diff-sigma_d);
                    nij= diff/sqrt(1+epslon*norm(diff,2)^2);
                    gain=1; 
                    if norm(diff)<0.5
                        gain=(0.1/sigma_diff); 
                        %variables=[variables;i,j,norm(diff),gain,1/sqrt(1+epslon*norm(diff,2)^2)]; %it does not work with the parfor
                        %disp([i,j,norm(diff),gain,1/sqrt(1+epslon*norm(diff,2)^2)]); %this just avoids the node getting inside the obstacle
                    end
                    u = u + kp*gain*phi_alpha*nij + kv*Auxiliar.rho_h(sigma_diff/sigma_int_range)*A(i,j)*(velj-veli);    
%                 else
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
                end
                
            end
        end
        
        %Pinning controller - know the general objective
        if i==pin
            u = u + 1e-1*(des_pos_group-mean(states_with_delay(1:n,:),2)) + 1e0*(zeros(n,1)-mean(states_with_delay(n+1:n+n,:),2));
%             u = u + 1e-1*(WP(1:2,nextwp)-mean(states_with_delay(1:n,:),2)) + 1e0*(WP(3:4,nextwp)-mean(states_with_delay(n+1:n+n,:),2));
%             u = u + 1e0*(WP(1:2,nextwp)-mean(x(1:n,:,k),2)) + 1e1*(WP(3:4,nextwp)-mean(x(n+1:n+n,:,k),2));
        end
        
        if t>2 && i==landing_node
            u = 0.01*(des_pos-posi)+0.2*([0;0;0]-veli);
            disp(veli')
        end
        if t>2 && ~isempty(find(abs(landed_nodes-i)==0))
            u = 0.8*([0;0;0]-veli);
        end
        all_u(:,i) = u;
        %new_x(:,i) = [posi + dt*veli + ((dt^2)/2)*u; veli + dt*u;];

    end
    
    
    %Changing inputs to be a mean for a compound part
    for i=1:N
        posi = actual_x(1:n,i);
        veli = actual_x(n+1:n+n,i);
%         if is_compound_part(i)==1
%             mean_u=all_u(:,i)*0;
%             list_of_parts=Auxiliar.parts_in_cp(i,compound_parts);
%             for j=1:length(list_of_parts)
%                 mean_u=mean_u+all_u(:,list_of_parts(j))/length(list_of_parts);
%             end
%             for j=1:length(list_of_parts)
%                 all_u(:,list_of_parts(j))=mean_u;
%             end
%         end
        u=all_u(:,i);            
        new_x(:,i) = [posi + dt*veli + ((dt^2)/2)*u; veli + dt*u;];
    end

%     %check for compound parts
%     for i=1:N
%         for j=1:N
%             if norm((posi - posj - posi_cp + posj_cp),2)<0.01
%                 compound_parts=[i,j];
%             end
%         end
%     end
    
    x(:,:,k+1)=new_x;
    
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
    % ---------------
   drawnow
   proc_time=toc;
   fprintf("processing time = %.3f | actual t = %.1f\n",proc_time,t);
   if dt>proc_time
       pause(abs(dt-proc_time)/2);
   end
   
%    if t>=now
% %         print(strcat(num2str(now),'s'),'-dpng')
%         now=t+1;
% %         pause(0.5);
%    end
   
    if record_video==1
        if t>=now
            drawnow
            pause(0.05);
            frame=getframe;
            frame.cdata=frame.cdata(1:445,1:695,1:3);
            writeVideo(v,frame);
%             z=''; if t<10; z='00'; elseif t<100; z='0'; elseif t>=100; z=''; end
%             print(strcat('Images/',num2str(N),'N_',num2str(MinNodes),'G/',z,num2str(now)),'-dpng')
            now=t+2;
        end
        axis ([min(x(1,:,k))-1 max(x(1,:,k))+1 min(x(2,:,k))-1 max(x(2,:,k))+1 0 2])
    end
    
delete(objects_in_fig)
end

if record_video==1
    close(v);
end

figure(2)
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

    %                 if i>j
    %                     objects_in_fig=[objects_in_fig,plot([x(1,i,k) x(1,j,k)],[x(2,i,k) x(2,j,k)], 'k')];
    %                     %objects_in_fig=[objects_in_fig,text(mean([x(1,i,k) x(1,j,k)]),mean([x(2,i,k) x(2,j,k)]), strcat('d=',num2str(norm((x(1:n,i,k)-x(1:n,j,k)),2),3)))];
    %                 end
    

%% Not used
%                 zed = posj-posi;
%                 sigma_norm_zed = Auxiliar.sigma_norm(zed);
%                 delta_sigma = zed / (1+epslon*sigma_norm_zed);
                %d_sig_norm=sqrt(1+norm(d,2)^2)-1;
                %phi_function_minus=(sigma_norm^2 -2*d_sig_norm*sigma_norm + d_sig_norm^2);
                %delta = (phi_function_plus-phi_function_minus)/0.001;
                %posji = posj-posi;
                %sigma_norm=sqrt(1+norm(posji,2)^2)-1;
                %phi_function=(sigma_norm^2 -2*d_sig_norm*sigma_norm + d_sig_norm^2);