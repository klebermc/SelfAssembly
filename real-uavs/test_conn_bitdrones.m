
bitdrones_server = Auxiliar_comm_bitdrones;

bitdrones_server=bitdrones_server.connect('DRONE_SERVER_IP',1520); % set to the address of the drone server

i=0;
while i<100
    bitdrones_server.send_message([1.1 1.2 1.3; 2.1 2.2 2.3]);
    bitdrones_server.receive_message()
    pause(0.1)
    i=i+1
end

bitdrones_server.disconnect()