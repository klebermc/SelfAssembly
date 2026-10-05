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
Gamma=[1 0; 0 1];   % Inter state relationship matrix
A=[0 1; 1 0];       % Ajacency Matrix
A_deg=A;       % Ajacency Matrix version with degree
for i=1:size(A,1); A_deg(i,i) = -sum(A(i,:)); end
N=2;                % Nodes in the network, cardinallity of vertex set
n=2;                % Variables of the state of each node
x=[ [0.1;0.55;0;0] , [0.7;0.8;0;0] ] ;


%% 2D - 3 nodes
% Gamma=[1 0; 0 1];   % Inter state relationship matrix
% A=[0 1 1; 1 0 1; 1 1 0];       % Ajacency Matrix
% A_deg=A;       % Ajacency Matrix version with degree
% for i=1:size(A,1); A_deg(i,i) = -sum(A(i,:)); end
% N=3;                % Nodes in the network, cardinallity of vertex set
% n=2;                % Variables of the state of each node
% x=[ [0.1;0.2;0;0] , [0.5;0.7;0;0] , [0.25;0.25;0;0] ] ;

%% 2D - 10 nodes
% N=10;                % Nodes in the network, cardinallity of vertex set
% n=2;                % Variables of the state of each node
% Gamma=[1 0; 0 1];   % Inter state relationship matrix
% A=zeros(N,N);       % Ajacency Matrix
% for i=1:N-2;    for j=1:2;        A(i,i+j)=1;    end; end
% A(N-1,N)=1;
% A = A + A';
% A_deg=A;       % Ajacency Matrix version with degree
% for i=1:size(A,1); A_deg(i,i) = -sum(A(i,:)); end
% x=zeros(4,N);
% %for i=1:N x(:,i)=[i/10;(((-1)^i)/10)+0.5;0;0];  end
% for i=1:N x(:,i)=[i/2;(-1)^i;0;0]+[0;0.5;0;0]; end

%% Virtual Tree
As=[0,0,0;1,0,0;1,0,0];
s=[ [1;0.1;0;0] , [0.5;0.1;0;0] , [1.5;0.1;0;0] ] ;

%% WP navigation of the ensemble
% Constraints and goals
x_lim=[0 5; 0 5; -100 100; -100 100];
WP = [1.5;1.5;0;0];
% WP = [0.5;0.5;0;0];
% for j=2:5; WP(:,j) = WP(:,j-1)+[1;1;0;0]; end
nextwp=1;

close all
figure

%% Flocking simulation

% Discretizing the adjacency matrix to simulate the network behaviour
%Ad = ssdata(c2d(ss(A_deg,zeros(N*n,1),zeros(1,N*n),zeros(N*n,1)),dt))
grid on
axis([-1 5 -1 5])
hold on
epslon = 1;
dt=0.1;
d=0.5;
sigma_d = Auxiliar.sigma_norm(d);
int_range_r = 10;
sigma_int_range = Auxiliar.sigma_norm(int_range_r);
now=1
for t=dt:dt:1000
    tic
    k=round(t/dt);
    cla
    hold on
    for i=1:N
        % Figure plot
        % --------------- 
%          plot(x(1,i,k), 0.5, 'xr'); %1D
%          text(x(1,i,k)+0.01, 0.5+0.01, num2str(i)); %1D
        plot(x(1,i,k),x(2,i,k), 'xr');
        text(x(1,i,k)+0.01,x(2,i,k)+0.01, num2str(i));
        posi = x(1:n,i,k);
        veli = x(n+1:n+n,i,k);
        u = x(n+1:n+n,1,1)*0;
        
        clc;
        for j=1:N
%             if A(i,j)~=0; disp([i,j]);end
            if i~=j && A(i,j)~=0
                posj = x(1:n,j,k);
                velj = x(n+1:n+n,j,k);

                diff = posj-posi;
                sigma_diff = Auxiliar.sigma_norm(diff);
                
                phi_alpha = Auxiliar.rho_h(sigma_diff/sigma_int_range)*Auxiliar.sigma_1(sigma_diff-sigma_d);
                nij= diff/sqrt(1+epslon*norm(diff,2)^2);

                u = u + phi_alpha*nij + Auxiliar.rho_h(sigma_diff/sigma_int_range)*A(i,j)*(velj-veli);

                if i>j
                    plot([x(1,i,k) x(1,j,k)],[x(2,i,k) x(2,j,k)], 'k');
                    %text(mean([x(1,i,k) x(1,j,k)]),mean([x(2,i,k) x(2,j,k)]), strcat('d=',num2str(sqrt((x(1,i,k)-x(1,j,k))^2+(x(2,i,k)-x(2,j,k))^2))));
                end
            end
        end
        
        
%         %Pinning controller
%         if i==1
%             u = u + 1e0*(WP(1:2,nextwp)-mean(x(1:n,:,k),2)) + 1e1*(WP(3:4,nextwp)-mean(x(n+1:n+n,:,k),2));
%         end
        
        %Pinning controller
        if i==1
            u = u + 1e0*(s(1:n,2,k)-x(1:n,1,k)) + 1e1*(s(n+1:n+n,2,k)-x(n+1:n+n,1,k));
            plot([s(1,2,k) x(1,1,k)],[s(2,2,k) x(2,1,k)], 'r--');
        end
        if i==2
            u = u + 1e0*(s(1:n,3,k)-x(1:n,2,k)) + 1e1*(s(n+1:n+n,3,k)-x(n+1:n+n,2,k));
            plot([s(1,3,k) x(1,2,k)],[s(2,3,k) x(2,2,k)], 'r--');
        end
        %u=u*0;
        x(1:n,i,k+1)     = posi + dt*veli + ((dt^2)/2)*u;
        x(n+1:n+n,i,k+1) =           veli +         dt*u;
%         x(:,i,k+1)
%         tspan = [0 dt];
%         y0 = x(:,i,k);
%         [t,y] = ode45(@(t,y) node_model(t,y,[0 1; 0 0],[0;1],u,n), tspan, y0)
    end
    
    %Computing virtual nodes
    for i=1:3
        % Figure plot
        % --------------- 
        plot(s(1,i,k),s(2,i,k), '*m');
        text(s(1,i,k)+0.01,s(2,i,k)+0.01, num2str(i));
        posi = s(1:n,i,k);
        veli = s(n+1:n+n,i,k);
        u = s(n+1:n+n,1,1)*0;
        
        for j=1:3
            %if As(i,j)~=0; disp([i,j]);end
            if i~=j && As(i,j)~=0
                posj = s(1:n,j,k);
                velj = s(n+1:n+n,j,k);
                u = u + 0.1*(posj-posi) + 1*(velj-veli);
                
                %diff = posj-posi;
                %sigma_diff = Auxiliar.sigma_norm(diff); 
                %phi_alpha = Auxiliar.rho_h(sigma_diff/sigma_int_range)*Auxiliar.sigma_1(sigma_diff-sigma_d);
                %nij= diff/sqrt(1+epslon*norm(diff,2)^2);
                %u = u + phi_alpha*nij + Auxiliar.rho_h(sigma_diff/sigma_int_range)*As(i,j)*(velj-veli);
                plot([s(1,i,k) s(1,j,k)],[s(2,i,k) s(2,j,k)], 'r--');
                %text(mean([x(1,i,k) x(1,j,k)]),mean([x(2,i,k) x(2,j,k)]), strcat('d=',num2str(sqrt((x(1,i,k)-x(1,j,k))^2+(x(2,i,k)-x(2,j,k))^2))));
            end
        end
        
        if i==1
            u = 1e0*(WP(1:2,nextwp)-mean(x(1:n,:,k),2)) + 1e1*(WP(3:4,nextwp)-mean(x(n+1:n+n,:,k),2)) + ...
             1e0*(mean(x(1:n,:,k),2)-s(1:n,1,k)) + 1e1*(mean(x(n+1:n+n,:,k),2)-s(n+1:n+n,1,k));
        end
        if i==2
            d_constrain = min(x(1:n,:,k),[],2)-x_lim(1:n,1);
            %sigma_d_constrain = Auxiliar.sigma_norm(d_constrain);
            %u = (1e-10)*exp(1/sigma_d_constrain)
            u = u + (1e-10)*exp(1./d_constrain);
            
        end
        if i==3
            d_constrain = x_lim(1:n,2)-max(x(1:n,:,k),[],2);
            %sigma_d_constrain = Auxiliar.sigma_norm(d_constrain);
            %u = (1e-10)*exp(1/sigma_d_constrain)
            u = u -(1e-10)*exp(1./d_constrain);
        end
        %u=u*0;
        s(1:n,i,k+1)     = posi + dt*veli + ((dt^2)/2)*u;
        s(n+1:n+n,i,k+1) =           veli +         dt*u;
    end
    
    
    plot(mean(x(1,:,k),2),mean(x(2,:,k)), 'ok');
    text(mean(x(1,:,k))+0.01,mean(x(2,:,k))+0.01, 'CM');
    plot(WP(1,nextwp),WP(2,nextwp), 'vk');
    text(WP(1,nextwp)+0.02,WP(2,nextwp)+0.02, 'Goal');
    title(strcat('t = ',num2str(t),' s'));
    
    if abs(WP(1:2,nextwp)-mean(x(1:n,:,k),2)) + abs(WP(3:4,nextwp)-mean(x(n+1:n+n,:,k),2)) < 0.05
        nextwp=mod(nextwp+1,size(WP,2));
        if nextwp==0;nextwp=1;end
    end
%     axis tight
    hold off
    % ---------------

   proc_time=toc
%    pause(abs(dt-proc_time));
    if t>=now
        print(strcat(num2str(now),'s'),'-dpng')
        now=t+2;
        pause(1);
    end
   pause(0.02);
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
                
                
%     switch t
%         case 1
%             print('0001s','-dpng')
%         case 10
%             print('0010s','-dpng')
%         case 100
%             print('0100s','-dpng')
%         case 200
%             print('0200s','-dpng')
%         case 400
%             print('0400s','-dpng')
%         case 800
%             print('0800s','-dpng')
%         case 1000
%             print('1000s','-dpng')
%         case 2000
%             print('2000s','-dpng')
%         case 3000
%             print('3000s','-dpng')
%         case 4000
%             print('4000s','-dpng')
%         case 5000
%             print('5000s','-dpng')
%         case 10000
%             print('10000s','-dpng')            
%     end