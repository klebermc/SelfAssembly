function dXdt  = propagation(t, R_t, skew_sym_omega)
% t
R_t = reshape(R_t, size(skew_sym_omega)); %Convert from "n^2"-by-1 to "n"-by-"n"
dXdt = R_t * skew_sym_omega; %Determine derivative
dXdt = dXdt(:); %Convert from "n"-by-"n" to "n^2"-by-1
end