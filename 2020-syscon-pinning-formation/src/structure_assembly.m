function [sys,x0,str,ts] = structure_assembly(t,x,u,flag)
% Dispatch the flag. The switch function controls the calls to
% S-function routines at each simulation stage.
switch flag,
	case 0
		[sys,x0,str,ts] = mdlInitializeSizes; % Initialization
		
	case 3
		sys = mdlOutputs(t,x,u); % Calculate outputs
	
	case 9
		sys = mdlTerminate(t,x,u);
	
	case { 1, 2, 4 }
		sys = []; % Unused flags
	
	otherwise
	error(['Unhandled flag = ',num2str(flag)]); % Error handling
end;
% End of function vrep_comm.


%
%=============================================================================
% mdlInitializeSizes
% Return the sizes, initial conditions, and sample times for the S-function.
%=============================================================================
%
function [sys,x0,str,ts,simStateCompliance] = mdlInitializeSizes()

sizes = simsizes;
sizes.NumContStates  = 0;
sizes.NumDiscStates  = 0;
sizes.NumOutputs     = 3*9;
sizes.NumInputs      = 3*9;
sizes.DirFeedthrough = 1;
sizes.NumSampleTimes = 1;

sys = simsizes(sizes);
x0 = []; % No continuous states
str = []; % No state ordering
ts = [-1 0]; % Inherited sample time - sample time: [period, offset]

% speicfy that the simState for this s-function is same as the default
simStateCompliance = 'DefaultSimState';

global End_POS_pyramid
global A
global WP
global kp
global kv
global N
global n
global assembling

assembling=0;

End_POS_pyramid = [
    0.0125    0.2325    0.2325    0.0125    0.1350    0.2700    0.1350         0    0.1350;
    0.2200    0.2200         0         0    0.2400    0.1225         0    0.1225    0.1225;
         0         0         0         0    0.1350    0.1350    0.1350    0.1350    0.2700];
% End_POS_column = [
%     0              0         0         0         0          0        0         0          0 ;
%     0              0         0         0         0          0        0         0          0 ;
%  1.0800    0.9450      0.8100     0.6750   0.5400     0.4050   0.27    0.1350    0];
% End_POS_pyramid=End_POS_column;
End_POS_pyramid(3,:)=End_POS_pyramid(3,:)+0.01;
End_POS_pyramid=End_POS_pyramid*10;

kp=0.25;
kv=1;

N=9;                % Nodes in the network, cardinallity of vertex set
n=3;                % Variables of the state of each node
A=zeros(N,N);       % Ajacency Matrix
A(1,2)=1; A(1,3)=1; A(1,4)=1; A(1,5)=1;                      A(1,8)=1;
          A(2,3)=1; A(2,4)=1; A(2,5)=1; A(2,6)=1;
                    A(3,4)=1;           A(3,6)=1;  A(3,7)=1;
                                                   A(4,7)=1; A(4,8)=1; 
                                        A(5,6)=1;  A(5,7)=0; A(5,8)=1; A(5,9)=1; 
                                                   A(6,7)=1; A(6,8)=0; A(6,9)=1; 
                                                             A(7,8)=1; A(7,9)=1;
                                                                       A(8,9)=1;
%A(1,2)=1; A(2,3)=1; A(3,4)=1; A(4,5)=1; A(5,6)=1; A(6,7)=1; A(7,8)=1; A(8,9)=1; %this is to assemble a column
A = A + A';

WP = [1;2;0;0;0;0];
% for j=2:5; WP(:,j) = WP(:,j-1)+[1;1;0;0;0;0]; end
nextwp=1;
WP(3,nextwp)=End_POS_pyramid(3,9);
% end mdlInitializeSizes

%
%=============================================================================
% mdlOutputs
% Return the output vector for the S-function
%=============================================================================
%
function sys = mdlOutputs(t,x,u)

global End_POS_pyramid
global A
global WP
global kp
global kv
global N
global n
global assembling

%gain pinning control
c = 1e0;

temp=zeros(n,N);
for i=0:(N-1)
    temp(:,i+1) = u(i*n+1:i*n+n);
end
x=temp;

sys = [];
int_range_r = 0.45;
sigma_int_range = Auxiliar.sigma_norm(int_range_r);
k=1; 
epslon=1;
nextwp=1;

for i=1:N
        posi = x(1:n,i,k);
        %veli = x(n+1:n+n,i,k);
        u = x(1:n,1,1)*0;
        posi_s = End_POS_pyramid(1:n,i);
        
        for j=1:N
            posj = x(1:n,j,k);
            if i~=j && A(i,j)~=0
%                 posj = x(1:n,j,k);
                %velj = x(n+1:n+n,j,k);
                posj_s = End_POS_pyramid(1:n,j);
                u = u + kp*(posi - posj - posi_s + posj_s); %+ kv*(veli-velj);
            end
            if i~=j
                %trying to avoid colisions
                diff = posj-posi;
                sigma_diff = Auxiliar.sigma_norm(diff);
                sigma_d = Auxiliar.sigma_norm(1);
                phi_alpha = Auxiliar.rho_h(sigma_diff/sigma_int_range)*Auxiliar.sigma_1(sigma_diff-sigma_d);
                nij= diff/sqrt(1+epslon*norm(diff,2)^2);
                %do not avoid colisions if it is an assembly stage
                if assembling==0
                    u = u - (10/(norm(diff)+1e-10))*phi_alpha*nij; 
                    if norm(phi_alpha*nij,2)>0.001 || (norm(diff) < 0.45 && norm(diff) > 0.01 )
                        %just for debug
                        fprintf('i=%d | j=%d | norm(phi_alpha*nij,2)=%.3f | norm(diff)=%.3f | (10/(norm(diff)+1e-10))=%.3f\n', i,j, norm(phi_alpha*nij,2), norm(diff), (10/(norm(diff)+1e-10)))
                    end
                end
            end
        end
        
        u=-1*u;
        
        %Pinning controller
        if i==N
%             u = u + 1e0*(WP(1:n,nextwp)-mean(x(1:n,:,k),2)) + 1e1*(WP(n+1:n+n,nextwp)-mean(x(n+1:n+n,:,k),2));
            u = u + c*(WP(1:n,nextwp)-x(1:n,i,k)); %+ 1e1*(WP(n+1:n+n,nextwp)-x(n+1:n+n,i,k));
        end
        
        %overwriting u because I want to go the waiting position
        if t<7
            u = 5e-1*([0;(i-1)*0.5;3]-x(1:3,i,k));
            %if i~=N u=u*0; end
        end
        sys = [sys;u];
end

if mod(t,2)<0.05
    disp([norm(WP(1:n,nextwp)-x(1:n,9,k),2), norm((End_POS_pyramid(:,1)-End_POS_pyramid(:,2)), 2), WP(3,nextwp)])
end

%shirink the structure, assembly stage
%if norm((WP(1:n,nextwp)-mean(x(1:n,:,k),2)), 2) < 0.2 &&...
if norm(WP(1:n,nextwp)-x(1:n,9,k),2)  < 0.05 &&...
   norm((End_POS_pyramid(:,1)-End_POS_pyramid(:,2)), 2) > 0.22  %column 0.1350
    disp([norm(WP(1:n,nextwp)-x(1:n,9,k),2), norm((End_POS_pyramid(:,1)-End_POS_pyramid(:,2)), 2), WP(3,nextwp)])
    End_POS_pyramid=End_POS_pyramid*0.995;
    WP(3,nextwp)=End_POS_pyramid(3,9);%WP(3,nextwp)*0.999;
    assembling=1;
end
if mean(mean(x))==0 && max(max(x))==0 
    sys=sys*0; 
end

% if norm((End_POS_pyramid(:,1)-End_POS_pyramid(:,2)), 2) <= 0.23
%     pause(0.1)
% end


    
% end mdlOutputs

%
%=============================================================================
% mdlTerminate
% Perform any end of simulation tasks.
%=============================================================================
%
function sys=mdlTerminate(t,x,u)
sys = [];
% end mdlTerminate


%controller Section V-B
%A survey of multi-agent formation control: Position-, displacement-, and distance-based approaches
%Kwang-Kyo Oh, Myoung-Chul Park, and Hyo-Sung Ahn