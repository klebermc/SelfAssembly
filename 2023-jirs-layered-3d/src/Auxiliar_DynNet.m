classdef Auxiliar_DynNet
    methods(Static)
        function [ A, hops_graph ] = change_net_topology_add( A, i, j )
            A(i,j)=1;
            A(j,i)=1;
            G = graph(A);
            hops_graph=distances(G);
        end
        
        function [ A, hops_graph ] = change_net_topology_remove( A, i, j )
            A(i,j)=0;
            A(j,i)=0;
            G = graph(A);
            hops_graph=distances(G);
        end
        
        function [A_dist] = distance_between_nodes(A, x, n)
            for i=1:size(A,1)
                for j=1:size(A,1)
                    A_dist(i,j) = norm(x(1:n,i)-x(1:n,j),2);
                end
            end
        end
    end
end
