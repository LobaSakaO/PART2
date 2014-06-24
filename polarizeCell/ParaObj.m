classdef ParaObj < handle
    properties(Access=public)
        handle_graph;
    end
    
    methods(Access=public)
        
        function obj = ParaObj(h)
            if (nargin~=0)
                obj.handle_graph = h;
            end
        end
        
        function p = getGenerateProb(~, num)
            p = 0.0002;
        end
        
        function p = getBindProb(~, numa, numb)
%             if(numa+numb>=0)
%                 p = 1;
%             else
%                 p = 0.5;
%             end
            p=1;
        end
        
        function p = getDiffuseProb(~, num)
            p = 1;
        end
        
        function p = getDegradeProb(~, num)
%             k = 3;
%             if (num>=k)
%                 p = 0.01;
%             else
%                 p = 0.02;
%             end
            p = 0.03/num;
        end
        
        function poleArea = getPoleArea(~, x, y)
            NotPoleAreaRate = 0.6;
            
            r = ceil(NotPoleAreaRate * x);
            p = ceil((x-r)/2);
            poleArea = zeros(x, y);
            poleArea(1:p,:)=1;
            poleArea(x-p:end,:)=1;
        end
        
        function max = getCenterDiffusable(~)
            max = 2;
        end
        
        function ans = isRandomDiffuseUnitPopZ(~)
            ans = true;
        end
    end
    
end