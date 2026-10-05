function dydt = node_model(t,y,A,B,u,n)
dydt = zeros(n*2,1);
t
dydt = kron(A,eye(n))*y + kron(B,eye(n))*u
