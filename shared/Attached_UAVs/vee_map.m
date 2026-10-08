function t = vee_map(A)
% Inverse of the hat map: the vector t such that hat(t) = A, for a 3x3
% skew-symmetric A. The diagonal is ignored, so a matrix that is only
% approximately skew-symmetric (numerical error in R'*Rdot) is accepted.
t = [A(3,2); A(1,3); A(2,1)];
end
