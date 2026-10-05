classdef Auxiliar_DynNet
    methods(Static)
        function [ A, hops_graph ] = change_net_topology_add( A, i, j )
            A(i,j)=1;
            A(j,i)=1;
            G = graph(A);
            hops_graph=distances(G);
        end
        
        function [ A, hops_graph ] = change_net_topology_remove( A, i, j )
            A(i,j)=0;
            A(j,i)=0;
            G = graph(A);
            hops_graph=distances(G);
        end
        
        function [A_dist] = distance_between_nodes(A, x, n)
            for i=1:size(A,1)
                for j=1:size(A,1)
                    A_dist(i,j) = norm(x(1:n,i)-x(1:n,j),2);
                end
            end
        end

        function  [ pins ] = update_pins( hops_graph, pins, A )
            new_pins=pins;
            %removing unecessary pins
            for pin=pins
                for node=1:size(hops_graph,2)
                    if pin~=node
                        if hops_graph(pin,node) < size(hops_graph,2)
                            %the pin can reach the node
                            idx=find(abs(new_pins-node)<=1e-10, 1);
                            if ~isempty(idx) && pin~=node
                                disp(strcat('node [', num2str(node), '] can be reached by pin [', num2str(pin),']'))
                                new_pins(idx)=[];
                            end
                        end
                    end
                end
                if length(new_pins)~=length(pins); break; end
            end
            pins=new_pins;
            %finding new pins
            for i=1:length(pins)
                for j=1:size(hops_graph,2)
                    if hops_graph(pins(i),j) > size(hops_graph,2)
                    %The maximum number of hops between two nodes is the number of nodes in the network
                    %This means that these two nodes (pins(i), j) are not connected
                        %is the node j already a pin?
                         if ~any(abs(pins-j)<=1e-10)
                             %any other pin can reach j?
                             canBereached=0;
                             for k=1:length(pins)
                                 if hops_graph(pins(k),j) <= size(hops_graph,2)
                                    %disp(strcat('node [', num2str(j), '] can be reached by pin [', num2str(pins(k)),']'))
                                    canBereached=1;
                                 end
                             end
                             %if j is not a pin and cannot be reached by a pin
                             if canBereached==0;
                                %add it as pin
                                %pins(length(pins)+1)=j; %the classical method, get the node+1 to be pin
                                %find a pin in the subnetwork of j
                                pins(length(pins)+1)= Auxiliar_DynNet.newpin_using_gramian( hops_graph, j, A );
                             end 
                             %break;
                         end
                    end
                end
            end
        end
        
        function [pin] = newpin_using_gramian( hops_graph, j, A )
            nodes_sg=[];
            nodes_exc=[];
            for node=1:size(hops_graph,1)
                if isinf(hops_graph(node,j))
                    nodes_exc=[nodes_exc,node]; %this node is unreachable by j
                else
                    nodes_sg=[nodes_sg,node]; %this node is reachable by j
                end
            end
            
            A = Auxiliar_DynNet.compute_system_dynamics_A(A);
            
            A_sg=A;
            A_sg(nodes_exc,:)=[];
            A_sg(:,nodes_exc)=[];

            gram=ones(1,size(nodes_sg,2))*0;
            for p=1:size(nodes_sg,2)
                %propose a pin
                proposed_pin=nodes_sg(p);

                %compute controllability matrix t steps
                identM=eye(size(A,1));
                B=identM(:,proposed_pin);
                B(nodes_exc,:)=[];
                
                W=Auxiliar_DynNet.compute_gramian ( A_sg , B );
%                 gram(proposed_pin)=trace(inv(W));
                gram(proposed_pin)=trace(W);
            end
%             pin = find(abs(min(gram)-gram)<1e-10); %trace inv
            pin = find(abs(max(gram)-gram)<1e-10); %trace
            pin = pin(1);
        end
        
        function A_sys = compute_system_dynamics_A(A)
            ts=1;
            alpha=0.1:0.1:100;
            Con = A;
             %   To compute the gramian I have to have an stable dynamics, thus I use noazary to compute A given the connectivity
            for alpha_iter=1:length(alpha)
                alp=alpha(alpha_iter);
                eigenvalues1=eig(-alp*eye(size(Con,1))+Con);
                %for j=1:length(eigenvalues1) plot(i,eigenvalues1(j),'rx');  end  
                if eigenvalues1<0          
                    break;
                end
            end
            A_sys=expm((-alp*eye(size(Con,1))+Con)*ts); %ts=dt
        end
        
        function [metric,NetSize] = cohesion_metric ( A , hops_graph , x , node , minNodes)
            
            minNodes=3;
            idxs_1hop=find(abs(hops_graph(node,:)-1)<=1e-10); %nodes within 1 hop of dist
            %idxs_2hop=find(abs(hops_graph(node,:)-2)<=1e-10); %nodes within 2 hop of dist
            idxs=[idxs_1hop];%,idxs_2hop];
            n=size(x,1)/2;
            %find the closer nodes
            dists=[];
            for idx = idxs; dists = [dists, norm(x(1:n,idx)-x(1:n,node),2)]; end
            idxs=[idxs;dists];
            dist_sorted=sort(dists); %sort the distances
            temp_idxs=[];
            for dist = dist_sorted
                for iter_hop = 1:length(dists)
                    if idxs(2,iter_hop) == dist
                        temp_idxs = [temp_idxs, idxs(1,iter_hop)];
                    end
                end
            end
            idxs=temp_idxs;
            %---
            %metric=(mean(dists)*minNodes)/(length(idxs)+1);
            if isempty(dists)   max_dist=100;
            else                max_dist=max(dists); end
            metric=(max_dist*minNodes)/(length(idxs)+1);
            NetSize=length(hops_graph(node,:))-sum(isinf(hops_graph(node,:)));%length(idxs)+1;
            %fprintf('%d- metric= [%.3f] net_size= [%d]\n',node,metric,NetSize)
        end
        
        function [ edges_to_cut , A , hops_graph, subnet ] = split_network( A , hops_graph , x , k, pin, MinNodes)
            states_with_delay=x(:,:,k)*0; 
            N=size(A,1);
            %get the delayed states from other nodes
            idxs=[];
            for j=1:N
                if ~isinf(hops_graph(pin,j)) %if it is infinity, that means that this pin does not have access to the state of j
                    k_with_delay=k-hops_graph(pin,j);
                    if k_with_delay<1;k_with_delay=1;end
                    %disp([pin,j,k,hops_graph(pin,j),k_with_delay])
                    states_with_delay(:,j) = x(:,j,k_with_delay);
                    if j~=pin; idxs=[idxs,j];end
                end
            end

            n=size(x,1)/2;
            %find the closer nodes
            dists=[];
            for idx = idxs; dists = [dists, norm(states_with_delay(1:n,idx)-x(1:n,pin,k),2)]; end
            idxs=[idxs;dists];
            dist_sorted=sort(dists); %sort the distances
            temp_idxs=[];
            for dist = dist_sorted
                for iter_hop = 1:length(dists)
                    if idxs(2,iter_hop) == dist && ~any(abs(temp_idxs-idxs(1,iter_hop))<1e-10)
                        temp_idxs = [temp_idxs, idxs(1,iter_hop)];
                        break;
                    end
                end
            end
            idxs=temp_idxs;
            if size(idxs,2)+1>=MinNodes*2
                %disp(max(MinNodes-1,round(size(idxs,2)/2)-1));
                %subnet_1=idxs(1,1:max(MinNodes-1,round(size(idxs,2)/2)-1));
                %subnet_2=idxs(1,max(MinNodes,round(size(idxs,2)/2)):size(idxs,2));
                subnet_1=idxs(1,1:MinNodes-1);
                subnet_2=idxs(1,MinNodes:size(idxs,2));
            else
                subnet_1=idxs;
                subnet_2=[];
            end

            edges_to_cut=[];
            for i=1:N
                for j=1:N
                    if A(i,j)==1
                        if( any(abs(subnet_1-i)<=1e-10) && any(abs(subnet_2-j)<=1e-10) )...
                                || ( any(abs(subnet_2-i)<=1e-10) && any(abs(subnet_1-j)<=1e-10) )
                            %disp([i j])
                            %break the connection just to see what will happen with the network
                            [ A, hops_graph ] = Auxiliar_DynNet.change_net_topology_remove( A, i, j );
                            if length(find(~isinf(hops_graph(:,i))))<MinNodes || length(find(~isinf(hops_graph(:,j))))<MinNodes
                                %disp([i j])
                                if( any(abs(subnet_1-i)<=1e-10) && any(abs(subnet_2-j)<=1e-10) )
                                     %disp(strcat('I cannot break [',num2str([i,j]),'] connection, the node [',num2str(j),'] will be alone'))
                                     %moving the node
                                     subnet_2(abs(subnet_2-j)<=1e-10)=[];
                                     subnet_1=[subnet_1,j];
                                 end
                            else
                                 edges_to_cut=[edges_to_cut; i j];
                            end
                            [ A, hops_graph ] = Auxiliar_DynNet.change_net_topology_add( A, i, j );
                        end
                    end
                end
            end
            if length(subnet_2)<MinNodes
                edges_to_cut=[];
            end
            subnet = [subnet_1 pin];
        end
        
        function [controllability] = controllability_diff_nodes_using_gramian( A )

            gram=ones(1,size(A,2))*0;
            for p=1:size(A,2)
                
                proposed_pin=p; %propose a pin

                %compute controllability matrix t steps
                identM=eye(size(A,1));
                B=identM(:,proposed_pin);
                
                W=Auxiliar_DynNet.compute_gramian ( A , B );
                gram(proposed_pin)=trace(W);
                %gram(proposed_pin)=trace(inv(W));
            end
            controllability=gram;
        end
        
        function [Wc] = compute_gramian ( A , B )
            
            N=size(A,1);

            %FIRST STEP, SEE IF IT IS STABLE OR UNSTABLE
            eigenvalues = eig(A);
            C=eye(size(A,1));
            C=C(1,:);
            dt=0.1; 
            sys_d=ss(A,B,C,0,dt); %I know that my matrices reprent discre systems
            
            isstable=1;
            for j=1:length(eigenvalues)
                if abs(eigenvalues(j))>=1 %unitary circle (works well with imaginary poles as well)
                    isstable=0; break;
                end
            end

            if isstable==1
                Wc = gram(sys_d,'c'); %this guy computes discreate, continuous, real and imag poles

%                 %This handles well imaginary poles
%                 time=dt*100*N; T_steps = time/dt;
%                 %this is OK for:
%                 %STABLE, discrete, T_steps >> (10x) N netsize (100x for imaginary poles)
%                 Contr=[]; for t=0:T_steps-1; Contr = [Contr,(A^t)*B]; end
%                 %compute gramian matrix t steps
%                 Wc=Contr*Contr';
            else
                % If it is unstable
                iscomplex=0;
                for j=1:length(eigenvalues)
                    if ~isreal(eigenvalues(j))
                        iscomplex=1; break;
                    end
                end
                if iscomplex==0
                    sys_c = d2c(sys_d,'matched');
                    Ac=sys_c.A;
                    Bc=sys_c.B;
                    %this function only works on continuous time
                    Wc = CtrGram(Ac,Bc); %/10 %I am not sure why, but for stable systems this function is returning the gramian multiplied by 10
                else
                    %NOTHING to do if the system has complex poles
                    Wc = inf(N,N);
                end
            end
        end
        
    end
end
