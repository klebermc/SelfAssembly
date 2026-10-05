classdef Auxiliar_SelfAssembly
    methods(Static)
        function [is_position_free,id]= check_position_free(position_to_check,actual_x)
            %true if free
            is_position_free = true;
            N=size(actual_x,2);
            n=round(size(actual_x,1)/2);
            id=-1;
            for l=1:N
                if norm(position_to_check-actual_x(1:n,l),2)<0.02
                    %Thi position is already taken, I cannot use it as a goal
                    is_position_free=false;
                    id=l;
                end
            end
        end
        
        function is_pos_inside = check_position_inside_structure(position_to_check, S)
            is_pos_inside=false;
            N=size(S,1);
            for l=1:N
                if norm(position_to_check - S(l,:)',2)<0.02
                    %This is a valid (inside)
                    is_pos_inside=true;
                end
            end
        end
        
        function [goal_pos, circling_pos] = get_closest_circling_pos(CEFR_pos, posi, circling)
            goal_pos=CEFR_pos+circling(:,1);
            circling_pos=1;
            for l=1:4
                nextGoalPosition=CEFR_pos+circling(:,l);
                if norm((posi - nextGoalPosition),2)<norm((posi - goal_pos),2)
                    goal_pos=nextGoalPosition;
                    circling_pos=l;
                end
%                 plot3(...
%                    [nextGoalPosition(1) posi(1)],...
%                    [nextGoalPosition(2) posi(2)],...
%                    [nextGoalPosition(3) posi(3)], 'k','linewidth',1); 
            end
        end
        
        function nextCirclingPos = next_circling (actual_value,direction)
            nextCirclingPos = actual_value + direction;
            if nextCirclingPos==0; nextCirclingPos=4;end
            if nextCirclingPos==5; nextCirclingPos=1;end
        end
        
        function objects_in_fig = plot_line_3d(objects_in_fig,from, to, colour, line_width)
            objects_in_fig=[objects_in_fig,plot3(...
                                    [from(1) to(1)],...
                                    [from(2) to(2)],...
                                    [from(3) to(3)], colour, 'linewidth',line_width)];
        end
        
        function gradient = compute_gradient_MD(position, block_size)
            if round((position(3)/block_size)-0.5)>=0
                MD = abs( round((position-[0;0;block_size/2])/block_size) );
                MD(3)= 3*MD(3);
                gradient = sum(MD);
            else
                gradient = 9999; %invalid grad
            end
        end
        
        function gradient = compute_gradient_Energy(position, block_size, actual_x, gradient_neighs, id_neighs)
            gradient=9999;
            displacements=[[ block_size; 0;0],[ 0;-block_size;0],[-block_size; 0;0],[ 0; block_size;0],[ 0; 0; -block_size],[ 0; 0; block_size]];
            objects_in_fig =[];
            [free,id]=Auxiliar_SelfAssembly.check_position_free(position,actual_x);
            if free
                %first, the position has to be free for me to look for the neighbours
                for j=1:6
                    p=position+displacements(:,j);
                    objects_in_fig = Auxiliar_SelfAssembly.plot_line_3d(objects_in_fig, position, p, 'm', 1.5);
                    [free,id]=Auxiliar_SelfAssembly.check_position_free(p,actual_x);
                    if ~free
                        idx_neighV=find(id_neighs==id);
                        if gradient>gradient_neighs(idx_neighV(1))
                            gradient=gradient_neighs(idx_neighV(1));
                        end
                    end
                end
            end
            delete(objects_in_fig)
        end
        
        function neighbour_ID = position_has_a_neighbour(position, actual_x, circling, direction)
            neighbour_ID=-1;
            objects_in_fig =[];
            %first, the position has to be free for me to look for the neighbours
            CP=1;
            for j=1:4
                p=position+circling(:,CP);
                objects_in_fig = Auxiliar_SelfAssembly.plot_line_3d(objects_in_fig, position, p, 'm', 1.5);
                [free,id]=Auxiliar_SelfAssembly.check_position_free(p,actual_x);
                if ~free
                    neighbour_ID=id;
                end
                CP=Auxiliar_SelfAssembly.next_circling(CP,direction);
            end
            delete(objects_in_fig)
        end
    end
end
