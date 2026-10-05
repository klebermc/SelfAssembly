function [sys,x0,str,ts] = receive_message_drones(t,x,u,flag)
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

numdrones=3;
sizes = simsizes;
sizes.NumContStates  = 0;
sizes.NumDiscStates  = 0;
sizes.NumOutputs     = (numdrones+1)*3;
sizes.NumInputs      = 0;
sizes.DirFeedthrough = 0;
sizes.NumSampleTimes = 1;

sys = simsizes(sizes);
x0 = []; % No continuous states
str = []; % No state ordering
ts = [-1 0]; % Inherited sample time - sample time: [period, offset]

% speicfy that the simState for this s-function is same as the default
simStateCompliance = 'DefaultSimState';
global previous_msg_from_server;
previous_msg_from_server=zeros((numdrones+1)*3,1);
% end mdlInitializeSizes

%
%=============================================================================
% mdlOutputs
% Return the output vector for the S-function
%=============================================================================
%
function sys = mdlOutputs(t,x,u)
global bitdrones_server;
global information_sent;
global previous_msg_from_server;
global information_sent;
if (information_sent==1)
    try
        actual_states=bitdrones_server.receive_message();
        information_sent=0;
%         if size(actual_states,1)>0; previous_msg_from_server(1:3)=actual_states(1,:)'; end
%         if size(actual_states,1)>1; previous_msg_from_server(4:6)=actual_states(2,:)'; end
%         if size(actual_states,1)>2; previous_msg_from_server(7:9)=actual_states(3,:)'; end
%         if size(actual_states,1)>3; previous_msg_from_server(10:12)=actual_states(4,:)'; end
        previous_msg_from_server=[];
        for i=1:size(actual_states,1)
            previous_msg_from_server = [ previous_msg_from_server; actual_states(i,:)' ]; 
        end
    catch ME
        disp(ME.identifier) %usually it is a timeout, so move on udp
        disp(ME.message) 
        %disp(t)
    end
end
sys=previous_msg_from_server;
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