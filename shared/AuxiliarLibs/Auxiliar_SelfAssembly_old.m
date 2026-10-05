classdef Auxiliar_SelfAssembly
    methods(Static)
        function [ output ] = row_rule( x,group,candidate_pos,structure,node_type )
           % structure is desired the position of all blocks in x,y,z
           % group is the actual set of assembled parts (containing the
           % position of the nodes)
           % candidate_pos is the position that is being considered to
           % placement of a new node
          
           %I have to do three fors => X Y and Z
           %if it is in the structure, but not in the group (yet),
           %candidate not valid
            output=1;
            for axis=1:3
                candidate_pos_row = candidate_pos(axis);
                switch axis
                    case 1
                        structure_row=structure(:,candidate_pos(2),candidate_pos(3));
                        group_row=group(:,candidate_pos(2),candidate_pos(3));
                        structure_row=reshape(structure_row,[size(structure,1),1]);
                        group_row=reshape(group_row,[size(group,1),1]);
                    case 2
                        structure_row=structure(candidate_pos(1),:,candidate_pos(3));
                        group_row=group(candidate_pos(1),:,candidate_pos(3));
                        structure_row=reshape(structure_row,[size(structure,2),1]);
                        group_row=reshape(group_row,[size(group,2),1]);
                    case 3
                        structure_row=structure(candidate_pos(1),candidate_pos(2),:);
                        group_row=group(candidate_pos(1),candidate_pos(2),:);
                        structure_row=reshape(structure_row,[size(structure,3),1]);
                        group_row=reshape(group_row,[size(group,3),1]);
                end
                xor_sg=xor(structure_row,group_row);

                if xor_sg(candidate_pos_row)
                    %this is a free position in the structure.
                    %now find if the structure is to my right or left, or none
                    i=candidate_pos_row+1;
                    pos_part_in_group_row=candidate_pos_row;
                    %looking right
                    while i<length(structure_row)+1
                        if group_row(i)==1
                            pos_part_in_group_row=i;
                            break;
                        end
                        i=i+1;
                    end
                    if pos_part_in_group_row~=candidate_pos_row
                        %found a part already placed on my right
                        if any(xor_sg(candidate_pos_row+1:pos_part_in_group_row-1))
                            %found a position that should be occupied between
                            %these two blocks, do not place it here
                            output=0;
                        end
                    end
                    %I will look left 
                    i=candidate_pos_row-1;
                    while i>0
                        if group_row(i)==1
                            pos_part_in_group_row=i;
                            break;
                        end
                        i=i-1;
                    end
                    if pos_part_in_group_row~=candidate_pos_row
                        %it is on my left then, so should I place a part here?
                        if any(xor_sg(pos_part_in_group_row+1:candidate_pos_row-1))
                            %found a position that should be occupied between
                            %these two blocks, do not place it here
                            output=0;
                        end
                    end
                    %no part already placed on my right or left, I am free to place a block
                end
            end 
        end
        
        function [ output ] = plane_rule( x,group,candidate_position,structure,node_type )
            output=0;
            output_axes=[0,0,0];
            for axis=1:3
                switch axis
                    %by choosing:
                    %axis 1, I will take the YZ plane of the candidate position
                    %axis 2, I will take the XZ plane 
                    %axis 3, I will take the XY plane
                    case 1
                        group_plane=group(candidate_position(1),:,:);
                        group_plane=reshape(group_plane,size(group,[2,3]));
                        structure_plane=structure(candidate_position(1),:,:);
                        structure_plane=reshape(structure_plane,size(group,[2,3]));
                        candidate_plane_pos = [candidate_position(2),candidate_position(3)];
                    case 2
                        group_plane=group(:,candidate_position(2),:);
                        group_plane=reshape(group_plane,size(group,[1,3]));
                        structure_plane=structure(:,candidate_position(2),:);
                        structure_plane=reshape(structure_plane,size(group,[1,3]));
                        candidate_plane_pos = [candidate_position(1),candidate_position(3)];
                    case 3
                        group_plane=group(:,:,candidate_position(3));
                        group_plane=reshape(group_plane,size(group,[1,2]));
                        structure_plane=structure(:,:,candidate_position(3));
                        structure_plane=reshape(structure_plane,size(group,[1,2]));
                        candidate_plane_pos = [candidate_position(1),candidate_position(2)];
                end
                
                if structure_plane(candidate_plane_pos(1),candidate_plane_pos(2))==1
                    %position is valid
                    %search all blocks in this contigous group to see if there is any placed 
                    
                    % I am not neighbour of anybody, that is a good sign if I am alone in this
                    % group, bad news if there is another block already
                    contiguous=[];
                    visited=[];
                    [contiguous,visited]= Auxiliar_SelfAssembly.indexes_of_a_contiguous_group(...
                        structure_plane,candidate_plane_pos,contiguous,visited);
                    %I need to see if the contiguous in the group is 0 (I am the only one here)
                    positions_filled=0;
                    for row=1:size(contiguous,1)
                        if group_plane(contiguous(row,1),contiguous(row,2))==1
                            %find one position in the cotiguous group that is already filled.
                            if norm(candidate_plane_pos - contiguous(row,:),2) == 1
                               %good, this position is my neighbour
                               output_axes(axis)=1;
                            end
                            positions_filled=positions_filled+1;
                        end
                    end
                    if positions_filled==0
                        output_axes(axis)=1;
                    end
                end
            end
            if sum(output_axes)==3 
                output=1;
            end
        end
        
        function [ output ] = balance_rule( x,group,candidate_position,structure,node_type )
            
        end
        
        function [contiguous,visited]= indexes_of_a_contiguous_group(group,position,contiguous,visited)
            do_analysis_and_recursion=true;
            if ~isempty(visited)
                if sum(visited(:, 1) == position(1) & visited(:, 2) == position(2)) == 0 
                   %I have never been in this cell
                    visited=[visited;reshape(position,[1,2])];
                else
                    %I already visited this cell
                    do_analysis_and_recursion=false;
                end
            else
                    visited=[visited;reshape(position,[1,2])];
            end

            if group(position(1),position(2))==1 && do_analysis_and_recursion
                if ~isempty(contiguous)
                    if sum(contiguous(:, 1) == position(1) & contiguous(:, 2) == position(2)) == 0 
                        %that means that I havent added this value to the contiguous matrix yet
                        contiguous=[contiguous;reshape(position,[1,2])];
                    end
                else
                    %list of contiguous is empty, I can add the value regardless
                    contiguous=[contiguous;reshape(position,[1,2])];
                end

                if position(1)+1 <= size(group,1) %look right
                    [contiguous,visited] = Auxiliar_SelfAssembly.indexes_of_a_contiguous_group(group,position(1:2)+[1,0],contiguous,visited);
                end
                if position(1)-1 > 0 %look left
                    [contiguous,visited] = Auxiliar_SelfAssembly.indexes_of_a_contiguous_group(group,position(1:2)-[1,0],contiguous,visited);
                end
                if position(2)+1 <= size(group,2) %look up
                    [contiguous,visited] = Auxiliar_SelfAssembly.indexes_of_a_contiguous_group(group,position(1:2)+[0,1],contiguous,visited);
                end
                if position(2)-1 > 0 %look down
                    [contiguous,visited] = Auxiliar_SelfAssembly.indexes_of_a_contiguous_group(group,position(1:2)-[0,1],contiguous,visited);
                end
            end
        end
        
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
                gradient = sum(abs(round((position-[0;0;block_size/2])/block_size))) + round((position(3)/block_size)-0.5);
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
