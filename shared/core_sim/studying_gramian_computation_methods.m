A=[ 0 0 0 0 0 0;
    0 0 1 0 0 1;
    0 1 0 1 0 1;
    0 0 1 0 1 0;
    0 0 0 1 0 1;
    0 1 1 0 1 0;
];
G = graph(A);
hops_graph=distances(G);
plot(G)
j=2;

nodes_sg=[];
nodes_exc=[];
for node=1:size(hops_graph,1)
    if isinf(hops_graph(node,j))
        %this node is unreachable by j
        nodes_exc=[nodes_exc,node];
    else
        nodes_sg=[nodes_sg,node];
    end
end

A_sg=A;
A_sg(nodes_exc,:)=[];
A_sg(:,nodes_exc)=[];
    
unreachable_node=2;
gram=ones(1,size(nodes_sg,2))*0;
for p=1:size(nodes_sg,2)
    %propose a pin
    proposed_pin=nodes_sg(p);

    %compute controllability matrix t steps
    identM=eye(size(A,1));
    B=identM(:,proposed_pin);
    B(nodes_exc,:)=[];
    
    time=1;
    dt=0.1;
    T_steps = time/dt;

    C=[];
    for t=0:T_steps-1
        C = [C, (A_sg^t)*B];
    end

    %compute gramian matrix t steps
    W=C*C';
%     
%     W2=zeros(size(A_sg,1));
%     for t=0:T_steps-1
%         W2 = W2 + (A_sg^t)*B*(B')*((A_sg')^t);
%     end
%     
%     W-W2
    trace(W)
%     trace(W2)
    gram(proposed_pin)=trace(W);
    %gram(proposed_pin)=trace(inv(W));
end
pin = find(abs(max(gram)-gram)<1e-10);
pin = pin(1)
