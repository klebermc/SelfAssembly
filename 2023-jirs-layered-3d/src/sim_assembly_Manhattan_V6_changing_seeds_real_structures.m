% Description
% This simulation aims to study network control strategies applied to
% assembly.
% Here, different subgroups of the network will apply different assembly
% rules to create compound parts.
% Simulating state of nodes 
% 
% clear
% close all
% tr=[];
% 
% opts = delimitedTextImportOptions("NumVariables", 12);
% % Specify range and delimiter
% opts.DataLines = [2, Inf];    
% opts.Delimiter = " ";
% 
% % Specify column names and types
% opts.VariableNames = ["m_bar", "m_std", "m_max",...
%                     "tr1", "tr2", "mineig1", "mineig2", "pgrank1", "eigenvector1", "closeness1", "betweenness1",...
%                     "tr3", "tr4", "mineig3", "mineig4", "pgrank2", "eigenvector2", "closeness2", "betweenness2",...
%                     "Seedl1", "Seedl2", "Seedl3", "Seedl4"];
% opts.VariableTypes = ["double", "double", "double",...
%                     "double", "double", "double", "double", "double","double", "double", "double",...
%                     "double", "double", "double", "double", "double","double", "double", "double",...
%                     "double", "double", "double", "double"];
%  
% % Specify file level properties
% opts.ExtraColumnsRule = "ignore";
% opts.EmptyLineRule = "read";
% opts.ConsecutiveDelimitersRule = "join";
% opts.LeadingDelimitersRule = "ignore";
% 
% path_to_file="./";
% filename='save_now_assembly_asym.txt';
% file_path=strcat(path_to_file,filename);
% 
% % Import the data
% metricsIMPORTED = readtable(file_path, opts);

% clear opts


% % 3layers
possibilities=[];
for a=1:6 %3
    for b=1:4 %2
        for c=1:2%1
                possibilities=[possibilities; [a b c] ] ;
        end
    end
end

file_to_save='stairs_metrics_trace_of_gramian_closeness_weighted_s1.txt';
fileID = fopen(file_to_save, 'a');

%2551
for iterations=1:size(possibilities,1)
    one_possibility_time=tic;
    TOSAVE=[];
    
for direction=[-1,1]
    
    metrics.seedPOS=[];
    metrics.tr=[];
    metrics.mineig=[];
    metrics.pgrank=[];
    metrics.closeness=[];
    metrics.betweenness=[];
    metrics.eigenvector=[];
    
%% Structure


%stairs
% S=[ 	
% 0,0,0;    1,0,0;  2,0,0;
% 0,0,1;    1,0,1;
% 0,0,2;
% ];
% 
% Seed_S_label=[
%     1,2,3;
%     4,5,0;
%     6,0,0];
% 
% Seed_S = [
%     S(Seed_S_label(1,possibilities(iterations,1)),:);
%     S(Seed_S_label(2,possibilities(iterations,2)),:);
%     S(Seed_S_label(3,possibilities(iterations,3)),:);
%     ];
% 
% Selected_labels=  [Seed_S_label(1,possibilities(iterations,1));
%     Seed_S_label(2,possibilities(iterations,2));
%     Seed_S_label(3,possibilities(iterations,3));
%     ];



% 
% %stairs
S=[ 0,0,0; 1,0,0; 2,0,0; 
    0,1,0; 1,1,0; 2,1,0; 
    0,0,1; 1,0,1; 
    0,1,1; 1,1,1; 
    0,0,2; 
    0,1,2;];


Seed_S_label=[
    1,2,3,4,5,6;
    7,8,9,10,0,0;
    11,12,0,0,0,0;];

Seed_S = [
    S(Seed_S_label(1,possibilities(iterations,1)),:);
    S(Seed_S_label(2,possibilities(iterations,2)),:);
    S(Seed_S_label(3,possibilities(iterations,3)),:);
    ];

Selected_labels=  [Seed_S_label(1,possibilities(iterations,1));
    Seed_S_label(2,possibilities(iterations,2));
    Seed_S_label(3,possibilities(iterations,3));
    ];


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


% Creating Sprime
valuesX=[min(S(:,1))-1, max(S(:,1))+1];
valuesY=[min(S(:,2))-1, max(S(:,2))+1];
valuesZ=[min(S(:,3)), max(S(:,3))];
Sprime=[];
size_side=20;
size_side=size_side-1;
for i=valuesX(1):valuesX(2)
    for j=valuesY(1):valuesY(2)
        for k=valuesZ(1):valuesZ(2)
            is_in_S=false; for iter_vect_S=1:size(S,1); if norm([i,j,k] - S(iter_vect_S,:),2) < 0.1 ; is_in_S=true; end; end
            if ~is_in_S
                Sprime=[Sprime; i,j,k];
            end
        end
    end
end


block_size=0.1;

%create the topology of G
A_topology=zeros(size(S,1),size(S,1));
for label=1:size(S,1)
    for possibleNeigh = label:size(S,1)
        if possibleNeigh ~= label && norm(S(label,:)-S(possibleNeigh,:),2) < 1.4 && S(label,3)==S(possibleNeigh,3)
            A_topology(possibleNeigh, label)=1;
            A_topology(label, possibleNeigh)=1;
        end
    end
end

%connect seeds in the topology
for i=1:size(Seed_S,1)-1
    seed_pos1=Seed_S(i,:);
    seed_pos2=Seed_S(i+1,:);
    
    %Now I need to find their labels
    for j=1:size(S,1); if norm(S(j,:)-seed_pos1,2)<0.1; seed_label1=j; break; end; end
    for j=1:size(S,1); if norm(S(j,:)-seed_pos2,2)<0.1; seed_label2=j; break; end; end
    
    Manhattan_dist=sum(abs(round(seed_pos1-seed_pos2)));
    
    if seed_label1 ~= seed_label2
        if direction==1
%             fprintf('A-> doing 1/MD: ')
            A_topology(seed_label1, seed_label2)=1/Manhattan_dist;
            A_topology(seed_label2, seed_label1)=1/Manhattan_dist;
        else
%             fprintf('A-> doing MD: ')
            A_topology(seed_label1, seed_label2)=Manhattan_dist;
            A_topology(seed_label2, seed_label1)=Manhattan_dist;
        end
    end
end


%create the topology of G
A_topologyPrime=zeros(size(Sprime,1),size(Sprime,1));
for label=1:size(Sprime,1)
    for possibleNeigh = label:size(Sprime,1)
        if possibleNeigh ~= label && norm(Sprime(label,:)-Sprime(possibleNeigh,:),2) < 1.4 %&& Sprime(label,3)==Sprime(possibleNeigh,3)
            A_topologyPrime(possibleNeigh, label)=1;
            A_topologyPrime(label, possibleNeigh)=1;
        end
    end
end


Gprime=graph(A_topologyPrime);
H=distances(Gprime);

G=graph(A_topology);

% subplot(1,2,1)
% plot(G, 'XData',S(:,1),'YData',S(:,2), 'ZData',S(:,3), 'LineWidth', 1.5, 'NodeFontSize',8, 'EdgeLabel',G.Edges.Weight)
% grid on
% 
% subplot(1,2,2)
% plot(Gprime, 'XData',Sprime(:,1),'YData',Sprime(:,2), 'ZData',Sprime(:,3), 'LineWidth', 0.5, 'NodeFontSize',8)
% grid on

L=max(S(:,3))+1;

% THIS STEP IS CRITICAL
for j=1:size(S,1)
    S(j,3)=S(j,3)+0.5;
end
S=S*block_size;

% % Plotting structure
% for j=1:size(S,1)
%     sx=S(j,1);sy=S(j,2);sz=S(j,3)-block_size/2;
%     plot3([sx-block_size/2 sx+block_size/2],[sy-block_size/2 sy-block_size/2],[sz sz],'r', 'linewidth',1); hold on;
%     plot3([sx-block_size/2 sx+block_size/2],[sy+block_size/2 sy+block_size/2],[sz sz],'r', 'linewidth',1);
%     plot3([sx-block_size/2 sx-block_size/2],[sy-block_size/2 sy+block_size/2],[sz sz],'r', 'linewidth',1);
%     plot3([sx+block_size/2 sx+block_size/2],[sy-block_size/2 sy+block_size/2],[sz sz],'r', 'linewidth',1);
% end


%% Gramian computation
metrics.pgrank=[];
metrics.closeness=[];
metrics.betweenness=[];
metrics.eigenvector=[];

%CONSIDERING WEIGHTS FOR CENTRALITY 
pg_ranks = centrality(G,'pagerank');
closeness = centrality(G,'closeness','Cost',G.Edges.Weight);
betweenness = centrality(G,'betweenness','Cost',G.Edges.Weight);
eigenvector = centrality(G,'eigenvector');

selected_seed=Seed_S_label(1,possibilities(iterations,1));

%IF I AM DOING THE MEAN OF ALL CENTRALITIES - not really useful
% metrics.pgrank=[metrics.pgrank,mean(pg_ranks)];
% metrics.closeness=[metrics.closeness,mean(closeness)];
% metrics.betweenness=[metrics.betweenness,mean(betweenness)];
% metrics.eigenvector=[metrics.eigenvector,mean(eigenvector)];

%IF I AM DOING CENTRALITY ONLY OF seed 1  $p_{s_1}$
metrics.pgrank=[metrics.pgrank,pg_ranks(selected_seed)];
metrics.closeness=[metrics.closeness,closeness(selected_seed)];
metrics.betweenness=[metrics.betweenness,betweenness(selected_seed)];
metrics.eigenvector=[metrics.eigenvector,eigenvector(selected_seed)];

%Just plotting if I want to see the graph
close all
figure('units','pixels','outerposition',[1995,990,1200,500])
subplot(1,2,1);
%plot(graph(A_topology), 'XData',S(:,1),'YData',S(:,2), 'LineWidth', 1.5, 'NodeFontSize',15)
plot(graph(A_topology), 'XData',S(:,1),'YData',S(:,2), 'ZData',S(:,3), 'LineWidth', 1.5, 'NodeFontSize',15)
grid on
subplot(1,2,2)
% plot(graph(A_topology), 'XData',S(:,1),'YData',S(:,2), 'LineWidth', 1.5, 'NodeFontSize',8, 'NodeLabel', pg_ranks)
plot(graph(A_topology), 'XData',S(:,1),'YData',S(:,2), 'ZData',S(:,3), 'LineWidth', 1.5, 'NodeFontSize',8, 'NodeLabel', round(closeness*10000))
grid on

ts=1;
alpha=0.1:0.1:100;

Con = A_topology;

 %   To compute the gramian I have to have an stable dynamics, thus I use noazary to compute A given the connectivity
for alpha_iter=1:length(alpha)
    alp=alpha(alpha_iter);
    eigenvalues1=eig(-alp*eye(size(Con,1))+Con);
    %for j=1:length(eigenvalues1) plot(i,eigenvalues1(j),'rx');  end  
    disp(eig(expm((-alp*eye(size(Con,1))+Con)*ts))')
    disp(abs(eig(expm((-alp*eye(size(Con,1))+Con)*ts)))')
    disp(max(abs(eig(expm((-alp*eye(size(Con,1))+Con)*ts)))))
    if eigenvalues1<0 
        if max(abs(eig(expm((-alp*eye(size(Con,1))+Con)*ts))))<0.9
            break;
        end
    end
end
    
A=expm((-alp*eye(size(Con,1))+Con)*ts); %ts=dt
%     Din = diag(sum(Con,1));
%     A=Con*inv(Din);

for j=1:size(S,1); if norm(S(j,:)-Seed_S(1,:)*block_size,2)<0.1; seed_label1=j; break; end; end
number_vertices=size(A,1);       

% fprintf('\n')
for two_iters=1:2
    B=eye(number_vertices);
    if two_iters==1
        B=   B(:,Seed_S_label(1,possibilities(iterations,1))) ;
%         fprintf('B only s1 :')
        
        C=eye(size(A,1));
        C=C(seed_label1,:);
        sys_d=ss(A,B,C,0,ts);
        Wc_stable = gram(sys_d,'c'); %this guy computes discreate, continuous, real and imag poles

        %This handles well imaginary poles
    %     for i=1:10*number_vertices
    %         time=ts*i;
    %         dt=ts;% dt=0.1;
    %         T_steps = time/dt;
    %         %this is OK for
    %         %STABLE, discrete, T_steps >> (10x) number_vertices netsize (100x for imaginary poles)
    %         C=[];
    %         for t=0:T_steps-1
    %             C = [C, (A^t)*B];
    %         end
    %         %compute gramian matrix t steps
    %         W(:,:,i)=C*C';
    %     end
        Wc=Wc_stable;%W(:,:,i);
        metrics.tr=[metrics.tr, trace(Wc)];
        metrics.mineig=[metrics.mineig, min(eig(Wc))];
    %     disp( [alp, trace(Wc), trace(Wc_stable)] );
%         fprintf(' %f ',trace(Wc));
    %     
    %     subplot(2,2,3);
    %     hold on
    %     grid onmet
    %     time_vect=dt:dt:time;
    %     plot(time_vect,reshape(W(1,1,:),1,[]))
    %     plot(time_vect,reshape(W(1,2,:),1,[]))
    %     plot(time_vect,reshape(W(2,1,:),1,[]))
    %     plot(time_vect,reshape(W(2,2,:),1,[]))
    %     plot(time,Wc_stable(1,1),'bo')
    %     plot(time,Wc_stable(1,2),'bo')
    %     plot(time,Wc_stable(2,1),'bo')
    %     plot(time,Wc_stable(2,2),'bo')
    %     legend('W11','W12','W21','W22','Wc stable11','Wc stable12','Wc stable21','Wc stable22')
    %     hold off
    %     
    % 
    % subplot(2,2,4);
    % plot(tr);
    % grid on

    else
        tr_values=[];
        mineig_values=[];
%         fprintf('B average :')
        for i=1:number_vertices
            B_temp= B(:,i);
            C=eye(size(A,1));
            C=C(seed_label1,:);
            sys_d=ss(A,B_temp,C,0,ts);
            Wc_stable = gram(sys_d,'c'); %this guy computes discreate, continuous, real and imag poles
            Wc=Wc_stable;%W(:,:,i);
            tr_values=[tr_values, trace(Wc)];
            mineig_values=[mineig_values, min(eig(Wc))];
%             fprintf(' %f ',trace(Wc));
        end
        metrics.tr=[metrics.tr, mean(tr_values)];
        metrics.mineig=[metrics.mineig, mean(mineig_values)];
    %     disp( [alp, trace(Wc), trace(Wc_stable)] );
    end
%     fprintf('\n');
end 

%% 3D - N nodes
N=size(S,1);       % Nodes in the network, cardinallity of vertex set
n=3;                    % Variables of the state of each node
A=ones(N,N)-eye(N);
Adif=zeros(N,N);
x=zeros(n*2,N);
for i=1:N 
    x(:,i)=[ block_size; -block_size*3; block_size/2; 0;0;0];  
end

%% Gain matrix
kp=0.1; kv=sqrt(2*kp);
C=[ kp kv; 3 2*sqrt(3); 1 2*sqrt(1); 1 2*sqrt(1)];


%% Initializing figure
% % % close all
record_video=0;
visualoutput=false;
visualoutput2=false;
if visualoutput || visualoutput2
    close all
% figure('units','normalized','outerposition',[0.43 0.25 0.28 0.98]); record_video=0;
% figure('units','normalized','outerposition',[1.00 0.25 0.65 1.40]); record_video=1;
% % figure('units','normalized','outerposition',[0.43 0.50 0.28 0.50]); %dell monitor, home, top left 
% figure('units','normalized','outerposition',[1.00 0.1638 0.6666 0.8361]); %figure_to_export
figure('units','normalized','outerposition',[1.50 0.20 0.30 0.50]); %FIGURE MAC
pause(0.1)                              
view(-135,30);
axis([-0.5 1.5 -.9 1.5 0 2])

% axis ([min(x(1,:))-1 max(x(1,:))+1 min(x(2,:))-1 max(x(2,:))+1 0 2])

hold on
grid on;
xlabel('X')
ylabel('Y')
zlabel('Z')
drawnow
pause(0.5)
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
if visualoutput; Auxiliar.block3d(x(1,1,1),x(2,1,1),x(3,1,1),'grey'); end

% surf(Xs+x(1,1,1),Ys+x(2,1,1),Zs+x(3,1,1)+0.75);

for j=1:L
    comm_channel_seed(j).IN=0;
    comm_channel_seed(j).OUT=0;
end
% clear
% load state_assembly.mat
% t=t-dt;

% axis([min(S(:,1))-1 max(S(:,1))+1 min(S(:,2))-1 max(S(:,2))+1 0 1.5])

if record_video==1
    v = VideoWriter(strcat('SelfAssembly_',num2str(N),'nodes.avi'));
    v.FrameRate=5;
    open(v);
end
count=0;


%% Simulation Loop
for t=dt:dt:2000
% while t<6000
% t=t+dt;
    break;
    tic
    k=round(t/dt);
% 
%     objects_in_fig=[];
%     clc;
    %view(mod(round(k*4),360),30);
 
if visualoutput2
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
                objects_in_fig=[objects_in_fig,Auxiliar.block3d(x(1,i,k),x(2,i,k),x(3,i,k),'green')];
            case 6
                objects_in_fig=[objects_in_fig,Auxiliar.block3d(x(1,i,k),x(2,i,k),x(3,i,k),'grey')];
        end
%         if nodeVars(i).state~=1; objects_in_fig=[objects_in_fig,text(x(1,i,k),x(2,i,k),x(3,i,k)+block_size/2+0.02, ...
%                                     sprintf('%.0f',nodeVars(i).gradient),'FontSize',8,'HorizontalAlignment','center')]; end
    end
    % % % colors of blocks
end
    
%     title(strcat('t=',num2str(k)))
    
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
        
%         if nodeVars(i).state>=2 && nodeVars(i).state<=5
%             fprintf("id[%d] - st[%d] - MOVES[%d]",...
%                 nodeVars(i).id,...
%                 nodeVars(i).state,...
%                 nodeVars(i).MOVE_count);
%             fprintf("\n");
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
% %                     comm_channel_seed(layer).OUT=1; %forcing cirlcing this layer LONGEST PATH
                    
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

                        %direction=-1;
%                         if rand <0.5; direction=-1; else direction=1; end  
                    end
                end  
                
                if ~simulate_dynamics
%                     actual_x(1:n,i)=nodeVars(i).goalPos+nodeVars(i).displacement;
                    dist=round((posi-(nodeVars(i).goalPos+nodeVars(i).displacement))/block_size);
                    if  sum(abs(dist))>1 %1 means I am adjacent to a see %At least I need to go somewhere
                        
%                         if dist(3)==0
                            %MOVE.EXT() moving on external vertices
                            destination=nodeVars(i).goalPos+nodeVars(i).displacement;
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
                               if norm(candidate - my_pos_in_grid,2)< dist && ~Auxiliar_SelfAssembly.check_position_inside_structure(block_size*(candidate+[0;0;0.5]),S)
                                  dist=norm(candidate - my_pos_in_grid,2);
%                                   objects_in_fig = Auxiliar_SelfAssembly.plot_line_3d(objects_in_fig, candidate*block_size, my_pos_in_grid*block_size, 'b', 1.5);
                                  go_to=candidate;
                               end
                           end
                           
                           posSprime1=1; for iter_vect_S=1:size(Sprime,1); if norm(go_to' - Sprime(iter_vect_S,:),2) < 0.1 ; posSprime1=iter_vect_S; break;  end; end
                           posSprime2=1; for iter_vect_S=1:size(Sprime,1); if norm(my_pos_in_grid' - Sprime(iter_vect_S,:),2) < 0.1 ; posSprime2=iter_vect_S; break; end; end
                           vect=go_to-my_pos_in_grid;
                           actual_x(1:n,i)=(go_to+[0;0;0.5])*block_size+nodeVars(i).displacement;
                           if go_to(3)~=0
                            nodeVars(i).MOVE_count=nodeVars(i).MOVE_count+H(posSprime1, posSprime2);
%                             fprintf("%d , %d \n", H(posSprime1, posSprime2), sum(abs(vect)));               
                           end
%                            nodeVars(i).axis_to_move=~nodeVars(i).axis_to_move;
%                             if nodeVars(i).axis_to_move
%                                 %try X                        
%                                 my_pos_in_grid=(posi-nodeVars(i).displacement)/block_size - [0;0;0.5];
%                                 next_pos_in_grid=round(my_pos_in_grid+[sign(vect(1));0;0]);
%                             else
%                                 %try Y
%                                 my_pos_in_grid=(posi-nodeVars(i).displacement)/block_size - [0;0;0.5];
%                                 next_pos_in_grid=round(my_pos_in_grid+[0;sign(vect(2));0]);
%                             end
%                             %is in the blueprint?
%                             %is it the seed?
%                             I = sum(Seed_S(:,1)==next_pos_in_grid(1) & Seed_S(:,2)==next_pos_in_grid(2) & Seed_S(:,3)==next_pos_in_grid(3) );
%                             if I==1
%                                 %Awesome, found the seed.
%                             else
%                                 %not the seed, is it in the grid at least
%                                 if Auxiliar_SelfAssembly.check_position_inside_structure(block_size*(next_pos_in_grid+[0;0;0.5]),S)
%                                     %It is in the grid but not the seed, dont go there
%                                     while Auxiliar_SelfAssembly.check_position_inside_structure(block_size*(next_pos_in_grid+[0;0;0.5]),S)
%                                         vect(1:2)=[0.7,-0.7;0.7,0.7]*vect(1:2); %(rotate 90)
%                                         next_pos_in_grid=round(my_pos_in_grid+[sign(vect(1));sign(vect(2));0]); 
%                                     end
%                                     
%                                     nodeVars(i).axis_to_move=~nodeVars(i).axis_to_move;
%                                     actual_x(1:n,i)=(next_pos_in_grid+[0;0;0.5])*block_size+nodeVars(i).displacement;
%                                    if norm(actual_x(1:n,i)-(posi+[0;0;block_size*vect(3)/abs(vect(3))]),2)>block_size/2; nodeVars(i).MOVE_count=nodeVars(i).MOVE_count+1;end
%                                 else
%                                     %not the seed, not in the grid, external, good, move here.
%                                    actual_x(1:n,i)=(next_pos_in_grid+[0;0;0.5])*block_size+nodeVars(i).displacement;
%                                    if norm(actual_x(1:n,i)-(posi+[0;0;block_size*vect(3)/abs(vect(3))]),2)>block_size/2; nodeVars(i).MOVE_count=nodeVars(i).MOVE_count+1;end
%                                 end
%                             end
%                         else
%                             %move on height
%                             destination=nodeVars(i).goalPos+nodeVars(i).displacement;
%                             vect=(destination-posi);
%                             if norm(actual_x(1:n,i)-(posi+[0;0;block_size*vect(3)/abs(vect(3))]),2)>block_size/2; nodeVars(i).MOVE_count=nodeVars(i).MOVE_count+1;end
%                             actual_x(1:n,i)=posi+[0;0;block_size*vect(3)/abs(vect(3))];
%                         end
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
                    %disp([ theta, nodeVars(i).initialAngle, abs(theta-nodeVars(i).initialAngle), round(theta/5)]);
                    %disp(round(rad2deg(wrapTo2Pi(theta))/5));
%                     disp(norm([theta,rho]-nodeVars(i).initial(1:2),2));

                    %entered a valid position
                    if i_am_inside_S
                        nodeVars(i).state=4;
                        nodeVars(i).vel=[0;0];
%                     elseif abs(norm([theta,rho]-nodeVars(i).initial(1:2),2))<0.01 && nodeVars(i).initial(3)==0
%                         %the circling is to guarantee that I have a node to go to.
%                         %just spin around    
%                         layer=round((posi(3)/block_size)+0.5);
%                         nodeVars(i).goalPos=block_size*(Seed_S(layer+1,:)'+[0;0;0.5]);%=comm_channel_seed(layer).OUT+[-1;-1;0]*block_size;
%                         nodeVars(i).seedPos=block_size*(Seed_S(layer+1,:)'+[0;0;0.5]);%=comm_channel_seed(layer).OUT;
%                         nodeVars(i).CEFRposition=nodeVars(i).seedPos;    
%                         nodeVars(i).state=2;
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
                        vect=(nextGoalPosition-posi);
%                         objects_in_fig = [objects_in_fig,quiver3(posi(1),posi(2),posi(3)+block_size*0.6,vect(1),vect(2),vect(3), 'LineWidth',1.5,'MaxHeadSize',0.9, 'Color', 'b')];
                        nodeVars(i).goalPos=nextGoalPosition;
                        nodeVars(i).CEFRcirclingPos=nextCirclingPos;
                        %hist_selected_grad=[hist_selected_grad,[nodeVars(i).state;I(j);gradssorted(j)]];
                    end
                end
                
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
%                         disp(nodeVars(i).vel)
%                         disp(delta_function)

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
                    if visualoutput
                        Auxiliar.block3d(actual_x(1,i),actual_x(2,i),actual_x(3,i),'grey');
                        drawnow
                        pause(0.05);
                    end
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
%         all_u(:,i)=u;
    end        
    
    for i=1:N
%         new_x(:,i) = [posi + dt*veli + ((dt^2)/2)*u; veli + dt*u];
        new_x(:,i) = [actual_x(1:n,i) + dt*actual_x(n+1:n+n,i) + ((dt^2)/2)*all_u(:,i); actual_x(n+1:n+n,i) + dt*all_u(:,i);];
%         if norm(new_x(n+1:n+n,i),2) > 1
%             %saturate the vel
%             new_x(n+1:n+n,i) = new_x(n+1:n+n,i)/norm(new_x(n+1:n+n,i),2);
%         end
    end
    
    x(:,:,k+1)=new_x;

%     %rescale axes
%     if mod(round(t*100),100)==0
%         %axis ([min(x(1,:,k))-1 max(x(1,:,k))+1 min(x(2,:,k))-1 max(x(2,:,k))+1 0 max(x(1,:))-min(x(1,:))]);    
%         %axis ([-0.5 1.5 -0.5 1.5 0 2]);
%         axis([min(S(:,1))-0.2 max(S(:,1))+0.2 min(S(:,2))-0.2 max(S(:,2))+0.2 0 0.8])
%     end
    
   proc_time=toc;
%    fprintf("processing time = %.3f | actual t = %.1f\n",proc_time,t); 

   
%     if record_video==1
%         if t>=now
%             drawnow
%             pause(0.05);
%             frame=getframe;
%             if isempty(szframe)
%                 szframe=size(frame.cdata)-2;
%             end
%             frame.cdata=frame.cdata(1:szframe(1),1:szframe(2),1:3);
%             writeVideo(v,frame);
%             now=t+0.1;
% % %             z=''; if t<10; z='00'; elseif t<100; z='0'; elseif t>=100; z=''; end
% % %             ax = gca;
% % %             % Requires R2020a or later
% % %             exportgraphics(ax,strcat('chair_',z,num2str(k),'.png'),'Resolution',600) %this removes empty spaces around the figure
% % %             %%print(strcat('chair_',z,num2str(k)),'-dpng')
% % %             now=t+10;
%         end
%     else
% %            if t>=now
% %                 now=t+0.2;
%                 drawnow
%                 pause(0.1);
% %            end
%     end
    
    %stop simulation condition
    number_of_placed=0;
    for i=1:N
        if nodeVars(i).state==6
            number_of_placed=number_of_placed+1;
        end
%         if isempty(nodeVars(i).neighId)
%             %a node has no neighbours
%             number_of_placed=N;
%         end
    end
    
    if number_of_placed==N
        if sim_end>t
            sim_end=t;
        else
%             if record_video==1
                %view(mod(round((t-sim_end)/dt)+135,360),30);
%                 if t-sim_end>5
%                    break;   
%                 end
%             else
                break;
%             end
        end
    end
    if visualoutput2
    drawnow
    pause(0.1)
    delete(objects_in_fig)
    end
end

if record_video==1
    close(v);
    pause(1);
    command = sprintf('ffmpeg -i %s -vf "pad=ceil(iw/2)*2:ceil(ih/2)*2" -vcodec libx264 -acodec aac %s && rm %s ', v.Filename,strcat('SelfAssembly_',num2str(N),'nodes.mp4') ,v.Filename);
    system(command);
end

% for i=1:N
%     for j=i:N
%         if i~=j && norm(x(1:3,i,k)-x(1:3,j,k),2)/block_size < 0.8
%             fprintf('hold on, two blocks at the same place \n i | j = %d | %d \n dist = %.3f\n',i,j, norm(x(1:3,i,k)-x(1:3,j,k),2)/block_size)
%         end
%     end
% end


MOVECOUNT=[]; for i=1:N; MOVECOUNT(i)=nodeVars(i).MOVE_count; end
% figure, plot(MOVECOUNT)
moves=[mean(MOVECOUNT), std(MOVECOUNT), max(MOVECOUNT)];
%save('sim4b4.mat','moves','-append')
% TOSAVE = [TOSAVE, moves, tr];
TOSAVE = [TOSAVE, moves, metrics.tr,metrics.mineig*10^18,metrics.pgrank,metrics.eigenvector,metrics.closeness,metrics.betweenness];
end

% 
% (TOSAVE(1)+TOSAVE(6))/2
% (TOSAVE(2)+TOSAVE(7))/2
% (TOSAVE(3)+TOSAVE(8))/2
% TOSAVE
% SP = sum(round(x(1:n,:,k)/block_size - [0;0;0.5]),1);
% [mean(SP), std(SP), max(SP)]

moving_distances=[0,0,0]; 
%[metricsIMPORTED.m_bar(iterations) , metricsIMPORTED.m_std(iterations) , metricsIMPORTED.m_max(iterations) ];
% moving_distances=[(TOSAVE(1)+TOSAVE(12))/2, (TOSAVE(2)+TOSAVE(13))/2, (TOSAVE(3)+TOSAVE(14))/2];

% disp(metrics)
fprintf(fileID, '%.6f %.6f %.6f ',moving_distances);
fprintf(fileID, '%.6f %.6f %.6f %.6f %.6f %.6f %.6f %.6f ',TOSAVE(4:11));
fprintf(fileID, '%.6f %.6f %.6f %.6f %.6f %.6f %.6f %.6f ',TOSAVE(15:22));
switch length(Selected_labels)
    case 1
        fprintf(fileID, '%d\n', Selected_labels);
    case 2
        fprintf(fileID, '%d %d\n', Selected_labels);
    case 3
        fprintf(fileID, '%d %d %d\n', Selected_labels);
    case 4
        fprintf(fileID, '%d %d %d %d\n', Selected_labels);
    case 5
        fprintf(fileID, '%d %d %d %d %d\n', Selected_labels);
    case 6
        fprintf(fileID, '%d %d %d %d %d %d\n', Selected_labels);
end

%  fprintf(fileID, '%.6f %.6f %.6f %.6f %.6f %.6f %.6f %.6f %.6f %.6f\n', TOSAVE);
 
     if mod(iterations,100)==0
%         fclose(fileID);
%         fileID = fopen(file_to_save, 'a');
     end


    fprintf('time for 1 possibility =  %f | %d %% \n',toc(one_possibility_time), round(100*iterations/size(possibilities,1)));

end
 fclose(fileID);
 
 
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

% %-----
% A_2b2 = zeros(4,4);
% A_2b2(1,2)=1;A_2b2(2,1)=1;A_2b2(1,3)=1;A_2b2(3,1)=1;A_2b2(2,4)=1;A_2b2(4,2)=1;A_2b2(3,4)=1;A_2b2(4,3)=1;
% 
% %-----
% A_3b3 = zeros(9,9);
% A_3b3(1,2)=1;A_3b3(2,1)=1;A_3b3(1,4)=1;A_3b3(4,1)=1;A_3b3(2,3)=1;A_3b3(3,2)=1;A_3b3(2,5)=1;A_3b3(5,2)=1;
% A_3b3(3,6)=1;A_3b3(6,3)=1;
% A_3b3(4,5)=1;A_3b3(5,4)=1;A_3b3(4,7)=1;A_3b3(7,4)=1;A_3b3(5,6)=1;A_3b3(6,5)=1;A_3b3(5,8)=1;A_3b3(8,5)=1;
% A_3b3(6,9)=1;A_3b3(9,6)=1;
% A_3b3(7,8)=1;A_3b3(8,7)=1;A_3b3(8,9)=1;A_3b3(9,8)=1;
% 
% %-----
% A_4b4 = zeros(16,16);
% A_4b4(1,2)=1;A_4b4(2,1)=1;A_4b4(2,3)=1;A_4b4(3,2)=1;A_4b4(3,4)=1;A_4b4(4,3)=1;
% A_4b4(1,5)=1;A_4b4(5,1)=1;A_4b4(2,6)=1;A_4b4(6,2)=1;A_4b4(3,7)=1;A_4b4(7,3)=1;A_4b4(4,8)=1;A_4b4(8,4)=1;
% A_4b4(5,6)=1;A_4b4(6,5)=1;A_4b4(6,7)=1;A_4b4(7,6)=1;A_4b4(7,8)=1;A_4b4(8,7)=1;
% A_4b4(5,9)=1;A_4b4(9,5)=1;A_4b4(6,10)=1;A_4b4(10,6)=1;A_4b4(7,11)=1;A_4b4(11,7)=1;A_4b4(8,12)=1;A_4b4(12,8)=1;
% A_4b4(9,10)=1;A_4b4(10,9)=1;A_4b4(10,11)=1;A_4b4(11,10)=1;A_4b4(11,12)=1;A_4b4(12,11)=1;
% A_4b4(9,13)=1;A_4b4(13,9)=1;A_4b4(10,14)=1;A_4b4(14,10)=1;A_4b4(11,15)=1;A_4b4(15,11)=1;A_4b4(12,16)=1;A_4b4(16,12)=1;
% A_4b4(13,14)=1;A_4b4(14,13)=1;A_4b4(14,15)=1;A_4b4(15,14)=1;A_4b4(15,16)=1;A_4b4(16,15)=1;
% 
% %-----
% A_5b5 = zeros(25,25);
% A_5b5(1,2)=1;A_5b5(2,1)=1;A_5b5(2,3)=1;A_5b5(3,2)=1;A_5b5(3,4)=1;A_5b5(4,3)=1;A_5b5(4,5)=1;A_5b5(5,4)=1;
% A_5b5(6,7)=1;A_5b5(7,6)=1;A_5b5(7,8)=1;A_5b5(8,7)=1;A_5b5(8,9)=1;A_5b5(9,8)=1;A_5b5(9,10)=1;A_5b5(10,9)=1;
% A_5b5(11,12)=1;A_5b5(12,11)=1;A_5b5(12,13)=1;A_5b5(13,12)=1;A_5b5(13,14)=1;A_5b5(14,13)=1;A_5b5(14,15)=1;A_5b5(15,14)=1;
% A_5b5(16,17)=1;A_5b5(17,16)=1;A_5b5(17,18)=1;A_5b5(18,17)=1;A_5b5(18,19)=1;A_5b5(19,18)=1;A_5b5(19,20)=1;A_5b5(20,19)=1;
% A_5b5(21,22)=1;A_5b5(22,21)=1;A_5b5(22,23)=1;A_5b5(23,22)=1;A_5b5(23,24)=1;A_5b5(24,23)=1;A_5b5(24,25)=1;A_5b5(25,24)=1;
% for i=1:5:16;  for j=i:i+4;  disp(strcat('(',num2str(j),',',num2str(j+5),')'));  A_5b5(j,j+5)=1; A_5b5(j+5,j)=1;  end; end
    

