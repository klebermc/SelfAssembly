function dXdt  = RiccatiCov(t, X, A_t, Q)
% t
X = reshape(X, size(A_t)); %Convert from "n^2"-by-1 to "n"-by-"n"
dXdt = A_t * X + X * (A_t') + Q; %Determine derivative
dXdt = dXdt(:); %Convert from "n"-by-"n" to "n^2"-by-1
end