clear    
num_steps=[]
for counter=1:10
    try
%         sim_assembly_base_momentum
        sim_assembly_AH_difusion
        num_steps=[num_steps,t*10];
    catch
        disp('something wrong now')
    end
end
    %save(strcat('num_steps.mat'),'num_steps')