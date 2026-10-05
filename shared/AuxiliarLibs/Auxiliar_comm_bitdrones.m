classdef Auxiliar_comm_bitdrones
   properties
      bitdrones_server_ip
      bitdrones_server_port
      udp_connection
   end
   methods
      function obj = connect(obj,IP,PORT)
        obj.bitdrones_server_ip=IP;
        obj.bitdrones_server_port=PORT;
        obj.udp_connection = udp(IP,PORT,'Timeout',0.1);
        fopen(obj.udp_connection);
      end
      function send_message(obj,des_position)
          %Here I consider that every desired position is in a row, with 3 elements
         msg='ip';
         for row=1:size(des_position,1)
             msg=strcat(msg,':');
             msg=strcat(msg,num2str(row,'%02d'));
             msg=strcat(msg,'_');
             for col=1:size(des_position,2)
                msg=strcat(msg,num2str(des_position(row,col),'%.3f'));
                msg=strcat(msg,',');
             end
         end
         msg=strcat(msg,'f');
         disp(msg);
         fwrite(obj.udp_connection,msg);
      end
      function [agents_actual_position,agents_actual_states] = receive_message(obj)
          agents_actual_position=[];
          agents_actual_states=[];

          if obj.udp_connection.BytesAvailable>0
             %obj.udp_connection.DatagramTerminateMode = 'off';
             received_data = fscanf(obj.udp_connection);
             message_split = split(received_data,["i","p","f",":"]);
             for i=1:size(message_split,1)
                 if strlength(message_split(i))>4
                     fprintf("{%s} ",message_split{i});
                     agent_level_message=split(message_split(i),["_",","]);
                     if size(agent_level_message,1)==5 %there is a comma as last char, thus there will be an empty value here after processing
                         if ~any(isnan([str2double(agent_level_message(2)), str2double(agent_level_message(3)), str2double(agent_level_message(4))]))
                            agents_actual_position(round(str2double(agent_level_message(1))),:)=[str2double(agent_level_message(2)), str2double(agent_level_message(3)), str2double(agent_level_message(4))];
                         end
                     end 
                     if size(agent_level_message,1)==6 %there is a comma as last char, thus there will be an empty value here after processing
                         if ~any(isnan([str2double(agent_level_message(3)), str2double(agent_level_message(4)), str2double(agent_level_message(5))]))
                            agents_actual_position(round(str2double(agent_level_message(1))),:)=[str2double(agent_level_message(3)), str2double(agent_level_message(4)), str2double(agent_level_message(5))];
                            agents_actual_states(round(str2double(agent_level_message(1))))=str2double(agent_level_message(2));
                         end
                     end 
                 end
             end
%              disp(agents_actual_position);
          end
          fprintf("\n");
      end
      function disconnect(obj)
         fclose(obj.udp_connection);
         delete(obj.udp_connection)
         %clear obj.udp_connection
      end
   end
end

% host='<drone server IP>'
% port=1520
% str = 'ip:01_1.1,1.2,1.3:02_2.1,2.2,2.3:03_3.1,3.2,3.3:04_4.1,4.2,4.3f'
% u = udp(host,port)
% fopen(u)
% while true
% %Send string over udp
% fwrite(u,str)
% pause(1)
% end
% fclose(u)
