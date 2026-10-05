
Initial_pos = zeros(4,9);
Initial_A = zeros(9,9);
error_pos_all=[];
rms_error=[];
control_eff=[];
rms_control_eff=[];
mag_all=[];
mean_dist_traveled=[];
dist_traveled=[];
norm_dist_traveled=[];

for i=1:100
    
    procedure_time=tic;
    % Gramian selection
    [error_pos, control_effort, x , Initial_pos, Initial_A ] = sim_flocking_IFAC_function (1, Initial_pos, Initial_A);
%     figure;hold on; grid on;
    for node=1:9;  dist_traveled(i,node,1) = 0;
        for instant_time=1:size(x,3)-1;  dist_traveled(i,node,1) = dist_traveled(i,node,1) + norm(x(1:2,node,instant_time)-x(1:2,node,instant_time+1)); end
%         plot(squeeze(x(2,node,:)))
    end
    mean_dist_traveled(i,1)=mean(dist_traveled(i,:,1));
    norm_dist_traveled(i,:,1)=dist_traveled(i,:,1)/mean_dist_traveled(i,1);
    rms_error(1,i)=sqrt(mean(error_pos.^2));%rms(error_pos);
    error_pos_all=[error_pos_all; error_pos'];
    control_eff=[control_eff; control_effort];
    rms_control_eff(1,i)=sqrt(mean(control_effort.^2));%rms(control_effort);
    mag_all=[mag_all;control_effort];
    % random selection
    final_pos_gramian=x(:,:,size(x,3));

    try [error_pos, control_effort, x , Initial_pos, Initial_A ] = sim_flocking_IFAC_function (0, Initial_pos, Initial_A);
    catch; disp('something went wrong'); end
    
    for node=1:9;  dist_traveled(i,node,2) = 0;
        for instant_time=1:size(x,3)-1;   dist_traveled(i,node,2) = dist_traveled(i,node,2) + norm(x(1:2,node,instant_time)-x(1:2,node,instant_time+1));  end
    end
    mean_dist_traveled(i,2)=mean(dist_traveled(i,:,2));
    norm_dist_traveled(i,:,2)=dist_traveled(i,:,2)/mean_dist_traveled(i,2);
    
    while max(norm_dist_traveled(i,:,2))>2
        %one node traveled alone
            try [error_pos, control_effort, x , Initial_pos, Initial_A ] = sim_flocking_IFAC_function (0, Initial_pos, Initial_A);
            catch;  disp('something went wrong');  end
            for node=1:9; dist_traveled(i,node,2) = 0;
                for instant_time=1:size(x,3)-1;  dist_traveled(i,node,2) = dist_traveled(i,node,2) + norm(x(1:2,node,instant_time)-x(1:2,node,instant_time+1)); end
            end
            mean_dist_traveled(i,2)=mean(dist_traveled(i,:,2));
            norm_dist_traveled(i,:,2)=dist_traveled(i,:,2)/mean_dist_traveled(i,2);
    end
    
    error_pos_all=[error_pos_all; error_pos'];
    rms_error(2,i)=sqrt(mean(error_pos.^2));%rms(error_pos);
    control_eff=[control_eff; control_effort];
    rms_control_eff(2,i)=sqrt(mean(control_effort.^2));%rms(control_effort);
    mag_all=[mag_all;control_effort];
    final_pos_random=x(:,:,size(x,3));
       
%     close all
%     
%     fig1=figure(1); hold on; grid on;
%     last=size(error_pos_all,1);
%     title('position error')
%     plot(error_pos_all(last-1,:),'DisplayName','Gramian')
%     plot(error_pos_all(last,:),'DisplayName','Random')
%     legend show
%     hold off
%     
%     fig2=figure(2); hold on; grid on;
%     last=size(mag_all,1);
%     title('Control effort')
%     plot(mag_all(last-1,:),'DisplayName','Gramian')
%     plot(mag_all(last,:),'DisplayName','Random')
%     legend show
%     hold off
% 
%     figure
%     hold on
%     axis([0 18 0 10])
%     grid on
%     N=9;
%     objects_in_fig=[];
%     objects_in_fig=[objects_in_fig,text(mean(final_pos_gramian(1,:)),mean(final_pos_gramian(2,:))+2, 'gramian')];
%     for m=1:N
%     objects_in_fig=[objects_in_fig,plot(final_pos_gramian(1,m),final_pos_gramian(2,m), 'xr')];
%     objects_in_fig=[objects_in_fig,text(final_pos_gramian(1,m)+0.05,final_pos_gramian(2,m)+0.1, num2str(m))];
%     for j=1:N; if norm(final_pos_gramian(1:2,m)-final_pos_gramian(1:2,j))<1.3 && m>j; objects_in_fig=[objects_in_fig,plot([final_pos_gramian(1,m) final_pos_gramian(1,j)],[final_pos_gramian(2,m) final_pos_gramian(2,j)], 'g', 'linewidth',1.5)]; end; end
%     end
%     objects_in_fig=[objects_in_fig,text(mean(final_pos_random(1,:)),mean(final_pos_random(2,:))+2, 'random')];
%     for m=1:N
%     objects_in_fig=[objects_in_fig,plot(final_pos_random(1,m),final_pos_random(2,m), 'xr')];
%     objects_in_fig=[objects_in_fig,text(final_pos_random(1,m)+0.05,final_pos_random(2,m)+0.1, num2str(m))];
%     for j=1:N; if norm(final_pos_random(1:2,m)-final_pos_random(1:2,j))<1.3 && m>j; objects_in_fig=[objects_in_fig,plot([final_pos_random(1,m) final_pos_random(1,j)],[final_pos_random(2,m) final_pos_random(2,j)], 'b', 'linewidth',1.5)]; end; end
%     end
%     for m=1:N
%     objects_in_fig=[objects_in_fig,plot(Initial_pos(1,m),Initial_pos(2,m), 'xr')];
%     objects_in_fig=[objects_in_fig,text(Initial_pos(1,m)+0.05,Initial_pos(2,m)+0.1, num2str(m))];
%     %quiver(x(1,i,k),x(2,i,k),5*x(3,i,k),5*x(4,i,k));
%     for j=1:N; if norm(Initial_pos(1:2,m)-Initial_pos(1:2,j))<1.3 && m>j; objects_in_fig=[objects_in_fig,plot([Initial_pos(1,m) Initial_pos(1,j)],[Initial_pos(2,m) Initial_pos(2,j)], 'k', 'linewidth',1.5)]; end; end
%     end
%     axis tight
%     pause(3)
%     print(strcat(num2str(i),'config'),'-dpng')
% %     savefig(fig1,strcat('Error_pos',num2str(i),'.fig'))
% %     savefig(fig2,strcat('ControlEffort',num2str(i),'.fig'))
    toc(procedure_time)
end


figure; 
histogram(mean_dist_traveled(:,1),5)
figure; 
histogram(mean_dist_traveled(:,2),5)
boxplot(mean_dist_traveled,'Labels',{'Gramian-Based','Random'})
title('Comparision Petween Pin Selection Methods')
ylabel('Mean distance traveled by the nodes [meters]')
% save('selection_of_pin_v4.mat')