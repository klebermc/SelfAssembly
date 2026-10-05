% Simulating state of nodes 

%% 1D
% 2 nodes
Gamma=1;   % Inter state relationship matrix
A=[0 1; 1 0];       % Ajacency Matrix
A_deg=A;       % Ajacency Matrix version with degree
for i=1:size(A,1); A_deg(i,i) = -sum(A(i,:)); end
N=2;                % Nodes in the network, cardinallity of vertex set
n=1;                % Variables of the state of each node
x=[0.1;0.4];
u=[0;0.1]*0;

%% 2D
%2 nodes
% Gamma=[1 0; 0 1];   % Inter state relationship matrix
% A=[0 1; 1 0];       % Ajacency Matrix
% A_deg=A;       % Ajacency Matrix version with degree
% for i=1:size(A,1); A_deg(i,i) = -sum(A(i,:)); end
% N=2;                % Nodes in the network, cardinallity of vertex set
% n=2;                % Variables of the state of each node
% x=[0.1;0.2;0.3;0.4];
% u=[0;0;0.1;0.1]*0;


% 3 nodes
% Gamma=[1 0; 0 1];   % Inter state relationship matrix
% A=[0 1 0; 1 0 1; 0 1 0];       % Ajacency Matrix
% A_deg=A;       % Ajacency Matrix version with degree
% for i=1:size(A,1); A_deg(i,i) = -sum(A(i,:)); end
% N=3;                % Nodes in the network, cardinallity of vertex set
% n=2;                % Variables of the state of each node
% x=[0.1;0.1;0.2;0.2;0.3;0.3];
% u=[0;0;0.01;0;0;0];

close all
figure

%% Approach 1
% for t=1:1:10
%     for i=1:N
%         plot(x((i-1)*n+1,t),x((i-1)*n+n,t), 'xr');
%         grid on
%         hold on
%         axis([0 1 0 1])
%         text(x((i-1)*n+1,t),x((i-1)*n+n,t), num2str(i));
%         %iterating the nodes
%         sum=zeros(n,1);
%         for j=1:N
%             %iterating neighbour
%             if j~=i
% %                 [(j-1)*n+1,(j-1)*n+n,(i-1)*n+1,(i-1)*n+n]
%                 sum=sum + A(i,j)*Gamma*((x((j-1)*n+1:(j-1)*n+n,t)-x((i-1)*n+1:(i-1)*n+n,t)));
%             end
%         end
%         x((i-1)*n+1:(i-1)*n+n,t+1) = x((i-1)*n+1:(i-1)*n+n,t) + u((i-1)*n+1:(i-1)*n+n) + sum
%     end
%     hold off
%     pause(0.5)
% end

%% Approach 2
dt=0.1

% Discretizing the adjacency matrix to simulate the network behaviour
Ad = ssdata(c2d(ss(A_deg,zeros(N*n,1),zeros(1,N*n),[0]),dt))
grid on
axis([0 1 0 1])
for t=dt:dt:5
    k=round(t/dt);
    cla
    hold on
    for i=1:N
        % Figure plot
        % --------------- 
         plot(x((i-1)*n+1,k),0.5, 'xr');
         text(x((i-1)*n+1,k)+0.01,0.5+0.01, num2str(i));
%             plot(x((i-1)*n+1,k),x((i-1)*n+2,k), 'xr');
%             text(x((i-1)*n+1,k)+0.01,x((i-1)*n+2,k)+0.01, num2str(i));
        posi = x((i-1)*n+1 : (i-1)*n+n,k);
        if k>1; veli = (x((i-1)*n+1 : (i-1)*n+n,k) - x((i-1)*n+1 : (i-1)*n+n,k-1))*(1/dt);
        else    veli = x((i-1)*n+1 : (i-1)*n+n,k)*0; end
        Phi=0;
        for j=1:N
            if i~=j
                posj = x((j-1)*n+1 : (j-1)*n+n,k);
                if k>1; velj = (x((j-1)*n+1 : (j-1)*n+n,k) - x((j-1)*n+1 : (j-1)*n+n,k-1))*(1/dt);
                else    velj = x((j-1)*n+1 : (j-1)*n+n,k)*0; end
                posji = posj-posi;
                d=0.5;
                alpha_norm=sqrt(1+norm(posji,2)^2)-1;
                phi_function=(alpha_norm^2 -2*d*alpha_norm + d^2);
                u(i,1)=-phi_function + A_deg(i,j)*(velj-veli);
            end
        end
    end
    hold off
    % ---------------
    
    %next state
    x(:,k+1) = kron(Ad,Gamma)*x(:,k) + u;
    pause(dt);
end