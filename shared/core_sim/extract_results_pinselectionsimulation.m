
max(rms_error(1,:))
find(max(rms_error(1,:))-rms_error(1,:)<1e-10)
rms_error(:,52)
rms_error(:,52)=[];

% figure; 
% boxplot(rms_error','Labels',{'Gramian-Based','Random'})
% title('Comparision Petween Pin Selection Methods')
% ylabel('RMS of the tracking error [meters]')


figure; plot(rms_error')
figure; plot(rms_error','-*')
figure; plot((rms_error(1,:)-rms_error(2,:))','-*')
        hold on
        plot([0 100],[ 0 0])

rms_control_eff(:,52)=[];
figure; plot((rms_control_eff(1,:)-rms_control_eff(2,:))','-*')
hold on
plot([0 100],[ 0 0])