classdef ParaObj
    properties(Access=public)
        
    end
    
    methods(Access=public)
        function p = getGenerateProb(~, num)
            p = 0.00001;
        end
        
        function p = getBindProb(~, numa, numb)
            if(numa+numb>=0)
                p = 1;
            else
                p = 0.5;
            end
        end
        
        function p = getDiffuseProb(~, num)
            p = 1;
        end
        
        function p = getDegradeProb(~, num)
            k = 3;
            if (num>=k)
                p = 0.0001;
            else
                p = 0.01;
            end
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
    end
    
end