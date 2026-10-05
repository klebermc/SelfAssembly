function [sys,x0,str,ts] = send_message_drones(t,x,u,flag)
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

numdrones=1;
sizes = simsizes;
sizes.NumContStates  = 0;
sizes.NumDiscStates  = 0;
sizes.NumOutputs     = 0;
sizes.NumInputs      = numdrones*3;
sizes.DirFeedthrough = 1;
sizes.NumSampleTimes = 1;

sys = simsizes(sizes);
x0 = []; % No continuous states
str = []; % No state ordering
ts = [-1 0]; % Inherited sample time - sample time: [period, offset]

% speicfy that the simState for this s-function is same as the default
simStateCompliance = 'DefaultSimState';
tic
global bitdrones_server;
bitdrones_server = Auxiliar_comm_bitdrones;
bitdrones_server=bitdrones_server.connect('DRONE_SERVER_IP',1520); % set to the address of the drone server
global information_sent;
global previous_t;
previous_t=0;
information_sent=0;
% end mdlInitializeSizes

%
%=============================================================================
% mdlOutputs
% Return the output vector for the S-function
%=============================================================================
%
function sys = mdlOutputs(t,x,u)
global previous_t;
global bitdrones_server;
global information_sent;
%if (t-previous_t>=0.040)
processing_time=toc;
if processing_time>=0.045
    tic;
    previous_t=t;
    %fprintf('t=%d dt=%d\n', t,processing_time)
    vector2send=[];
    for i=1:3:length(u)
        vector2send=[vector2send;u(i),u(i+1),u(i+2)];
    end
    
    bitdrones_server.send_message(vector2send);
    information_sent=1;
        %processing_time=toc
        %if processing_time<0.05; pause(0.05-processing_time);end
    %end
end
sys = [];
% end mdlOutputs

%
%=============================================================================
% mdlTerminate
% Perform any end of simulation tasks.
%=============================================================================
%
function sys=mdlTerminate(t,x,u)
toc;
global bitdrones_server;
bitdrones_server.disconnect()
sys = [];
% end mdlTerminate