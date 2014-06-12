classdef BPopZList < handle
    properties
        list;
        BPopZAll;
    end
    
    methods(Access = public)
        function obj = BPopZList()
            if (nargin~=0)
                obj.list = DList();
            end
        end
        
        function [] = merge(this, merged)
            
        end
        
        function [] = add(this, added)
            
        end
    end
    
    
    
end