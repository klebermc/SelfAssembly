%cooperative transportation controller from Vijay kumar

%part position
x_1 = -0.135;%distance from center of compound part
y_1 = 0;%distance from center of compound part

%part position
x_2 = 0;%distance from center of compound part
y_2 = 0;%distance from center of compound part

x_2 = 0.135;%distance from center of compound part
y_2 = 0;%distance from center of compound part

psi_1=0;

A_1 =[ 1 0 0 0;
       y_1 cos(psi_1) -sin(psi_1) 0;
       -x_1 sin(psi_1)  cos(psi_1) 0;
       0 0 0 1];
   
A_2 =[ 1 0 0 0;
   y_2 cos(0) -sin(0) 0;
   -x_2 sin(0)  cos(0) 0;
   0 0 0 1];
   
A_3 =[ 1 0 0 0;
   y_3 cos(0) -sin(0) 0;
   -x_3 sin(0)  cos(0) 0;
   0 0 0 1];

arm_length=0.042;
l=(sqrt(2)/2) * arm_length;
c=0.001;% force to torque relationship in the propeller
P=[1,1,1,1; l,-l,-l,l; -l,-l,l,-l; c,-c,c,-c];

K=[A_1*P A_2*P A_3*P];

e3=[0;0;1]; %inertial z vector

J=[0.001*2;0.001;0.01]; %Inertia matrix

W = eye(8); %importance of each motor in the control

%Gains
kx=1;
kv=1;
kR=1;
kO=1;
m=0.050;
g=9.82;

% computed attitude Rc(t) ? SO(3) and 
% computed angular velocity Oc ? R3

R=eye(3);
xd=[0.5;0.5;0.5];
Xd=[];
Xd_dot=[];
xd_dot=[0.1;0.1;0.1];
for time=0.025:0.025:30
    Xd=[Xd,xd];
    if time<5
        Xd_dot=[Xd_dot,xd_dot];
    else
        Xd_dot=[Xd_dot,[0;0;0]];
    end
end


% omega angular velocity comes from sensors vrep
% R = [b1,b2,b3] attitude from body vectors

%computing errors

ex= x - Xd(:,round(t/0.025));
ev= v - Xd_dot(:,round(t/0.025));
omega_hat=skew_sym_3(omega);
xd_ddot=[0;0;0];

% xd_ddot=

% Compound part control, position and attitude
%Find the desired moments and thrust

%compute the desired force first
Fdes=(-kx*ex - kv*ev + m*g*e3 + m*xd_ddot);
T = Fdes * (R*e3) ;

%use the desired force vector to find the desired rotation
zbdes= Fdes/abs(Fdes);
xcdes=[1;0;0];
ybdes=cross(zbdes,xcdes)/abs(cross(zbdes,xcdes));
xbdes=cross(ybdes,zbdes);
Rdes=[xbdes,ybdes,zbdes];

Rdes_dot=Rdes*skew_sym_3(omega);
omegades_dot = (vee_map(Rdes'*Rdes_dot)-omegades)/ dt;
omegades = vee_map(Rdes'*Rdes_dot);

%compute the errors in rotation
eO= omega - R' * Rdes * omegades;
eR= 0.5*vee_map(Rdes' * R - R' * Rdes);
M = - kR*eR - kO*eO + cross(omega,J*omega) - J*(omega_hat*R'*Rdes*omegades - R'*Rdes*omegades_dot);

u=[T;M];

%given desired control inputs, find motor speeds
Kcross=inv(W) * K' * inv( K * inv(W) * K');
f=Kcross*u;