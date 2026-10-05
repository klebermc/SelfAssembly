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
N=10;                % Nodes in the network, cardinallity of vertex set
n=2;                % Variables of the state of each node
Gamma=[1 0; 0 1];   % Inter state relationship matrix
A=zeros(N,N);       % Ajacency Matrix
for i=1:N-2;    for j=1:2;        A(i,i+j)=1;    end; end
A(N-1,N)=1;
A = A + A';
A_deg=A;       % Ajacency Matrix version with degree
for i=1:size(A,1); A_deg(i,i) = -sum(A(i,:)); end
x=zeros(4,N);
% for i=1:N x(:,i)=[i/2;(-1)^i;0;0]+[0;0.5;0;0]; end
x(:,1)=[0;0;0;0];
for i=2:N 
    [newx,newy]= pol2cart(rand*2*pi,rand*0.2+0.5);
    x(:,i)=[newx+x(1,i-1);newy+x(2,i-1);0;0];  
end
G = graph(A);
hops_graph=distances(G);


%% WP navigation of the ensemble
WP = [0.5;0.5;0;0];
for j=2:5; WP(:,j) = WP(:,j-1)+[1;1;0;0]; end
nextwp=1;

%% Starting figure
close all
figure
hold on
grid on
axis ([min(x(1,:))-1 max(x(1,:))+1 min(x(2,:))-1 max(x(2,:))+1])

%% Flocking algorithm and misc. variables
epslon = 0.5; %flocking parameter
dt=0.1;  %time stpe of the simulation
d=0.5;   %desired distance between nodes
sigma_d = Auxiliar.sigma_norm(d); %used for flocking
int_range_r = 1; %range of my sensors 
sigma_int_range = Auxiliar.sigma_norm(int_range_r); %used for flocking
kp=1; %gain
kv=1;   %gain
pin_node=1; %the only node that is aware of the group objective (pinning control technique)
now=1;  %used to mark time

%% Flocking simulation
for t=dt:dt:200
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
                    if t<0.5
                        [ A, hops_graph ] = Auxiliar_DynNet.change_net_topology_add(A,i,j);
                    end
                    %end
                end
                if norm(x(1:n,i,k)-x(1:n,j,k),2)>int_range_r ... %node is not close
                   && A(i,j)==1 %node is connected
                    [ A, hops_graph ] = Auxiliar_DynNet.change_net_topology_remove(A,i,j);
                end
            end
        end
    end
    
    
    %simulating each node
    for i=1:N
        % Figure plot
        % --------------- 
%          plot(x(1,i,k), 0.5, 'xr'); %1D
%          text(x(1,i,k)+0.01, 0.5+0.01, num2str(i)); %1D
        objects_in_fig=[objects_in_fig,plot(x(1,i,k),x(2,i,k), 'xr')];
        objects_in_fig=[objects_in_fig,text(x(1,i,k)+0.01,x(2,i,k)+0.01, num2str(i))];
        posi = x(1:n,i,k);
        veli = x(n+1:n+n,i,k);
        u = x(n+1:n+n,1,1)*0;
        
        for j=1:N
%             if A(i,j)~=0; disp([i,j]);end
            if i~=j && A(i,j)~=0
                posj = x(1:n,j,k);
                velj = x(n+1:n+n,j,k);

                diff = posj-posi;
                sigma_diff = Auxiliar.sigma_norm(diff);
                
                phi_alpha = Auxiliar.rho_h(sigma_diff/sigma_int_range)*Auxiliar.sigma_1(sigma_diff-sigma_d);
                nij= diff/sqrt(1+epslon*norm(diff,2)^2);

                u = u + kp*phi_alpha*nij + kv*Auxiliar.rho_h(sigma_diff/sigma_int_range)*A(i,j)*(velj-veli);
                %disp([i,j,phi_alpha,nij', (phi_alpha*nij)', (Auxiliar.rho_h(sigma_diff/sigma_int_range)*A(i,j)*(velj-veli))'])
                if i>j
                    objects_in_fig=[objects_in_fig,plot([x(1,i,k) x(1,j,k)],[x(2,i,k) x(2,j,k)], 'k','linewidth',0.5)]; 
                    %uncomment below to see the desired actual distance between nodes
                    %objects_in_fig=[objects_in_fig,text(mean([x(1,i,k) x(1,j,k)]),mean([x(2,i,k) x(2,j,k)]), strcat('d=',num2str(norm((x(1:n,i,k)-x(1:n,j,k)),2),3)))];
                end
            end
        end
        
        %Pinning controller, only one node is aware of the group object
        if i==pin_node
            states_with_delay=zeros(n*2,N);
            for j=1:N
                k_with_delay=k-hops_graph(i,j);
                if k_with_delay<1;k_with_delay=1;end
%                 [k,hops_graph(i,j),k_with_delay]
                states_with_delay(:,j) = x(:,j,k_with_delay);
            end
            %there are two ways to simulate, the more realistic one, the pin node will access the
            %information about the states of the other nodes given a certain delay (time for this
            %information to be transmitted over the network)
            %the second, the pin node instantaneously knows the states of all nodes (even though
            %they are not directly connected)
            u = u + 1e-1*(WP(1:2,nextwp)-mean(states_with_delay(1:n,:),2)) + 1e-0*(WP(3:4,nextwp)-mean(states_with_delay(n+1:n+n,:),2));
            %u = u + 1e0*(WP(1:2,nextwp)-mean(x(1:n,:,k),2)) + 1e1*(WP(3:4,nextwp)-mean(x(n+1:n+n,:,k),2));
        end
        
        %u is the acceleration control signal

        %First order Euler integration for node dynamics
        x(1:n,i,k+1)     = posi + dt*veli + ((dt^2)/2)*u;
        x(n+1:n+n,i,k+1) =           veli +         dt*u;
        
%       This is a second method for doing the integration, more complex and not needed (same result)
%         x(:,i,k+1)
%         tspan = [0 dt];
%         y0 = x(:,i,k);
%         [t,y] = ode45(@(t,y) node_model(t,y,[0 1; 0 0],[0;1],u,n), tspan, y0)
    end
    
    objects_in_fig=[objects_in_fig,plot(mean(x(1,:,k),2),mean(x(2,:,k)), 'og')];
    objects_in_fig=[objects_in_fig,text(mean(x(1,:,k))+0.01,mean(x(2,:,k))+0.01, 'CM')];
    objects_in_fig=[objects_in_fig,plot(WP(1,nextwp),WP(2,nextwp), 'vr')];
    objects_in_fig=[objects_in_fig,text(WP(1,nextwp)+0.02,WP(2,nextwp)+0.02, 'goal')];
    title(strcat('t = ',num2str(t),' s'));
    
    %Once the group has reached the waypoint, I will move to the next
    if norm(WP(1:2,nextwp)-mean(x(1:n,:,k),2),2) < 0.05
        % + norm(WP(3:4,nextwp)-mean(x(n+1:n+n,:,k),2),2)
        nextwp=mod(nextwp+1,size(WP,2));
        if nextwp==0;nextwp=1;end
    end
    % ---------------

   proc_time=toc
   if t>=now
        now=t+1;
        %uncomment below to save multiple pictures of the process
        drawnow
        pause(0.05)
        print(strcat(num2str(now),'s'),'-dpng')
        axis ([min(x(1,:,k))-1 max(x(1,:,k))+1 min(x(2,:,k))-1 max(x(2,:,k))+1 0 2])
    end
   drawnow
   %    pause(abs(dt-proc_time));
   pause(0.02);
   delete(objects_in_fig)
end

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
