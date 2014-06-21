classdef PopZ < handle
    
    properties
        B;  %distribution block
        MG; %margin
        DG; %degradable
        num;%total number of small popZ (sum(sum(B)))
    end
    
    properties (Constant)
        Xlim = 15;
        Ylim = 10;
    end
    
    %--------------------------------------------------------------------%
    methods(Access=public)
        function obj = PopZ(b)
            if nargin~=0
                obj.B = b;
                obj.updateProperties();
            end
        end
        
        function [] = draw(Z, h)
            set(h, 'ZDATA', [Z.B Z.B(:, PopZ.Ylim);Z.B(PopZ.Xlim, :) 0]');
            drawnow;
        end
        function [] = drawMargin(Z, h)
            set(h, 'ZDATA', [Z.MG Z.MG(:, PopZ.Ylim);Z.MG(PopZ.Xlim, :) 0]');
            drawnow;
        end
        
        function b = getBlock(this)
            b = this.B;
        end
        function mg = getMargin(this)
            mg = this.MG;
        end
        function n = getNum(this)
            n = this.num;
        end
        
        function collided = isCollide(this, collider)
            collided = numel(find(this.MG & collider));
        end
        
        function [] = degrade(this)
            x = PopZCell.Xlim;
            y = PopZCell.Ylim;
            tmp_deg = binornd(1, PopZ.getDegradeProb(this.num), [x, y]);
            degraded = tmp_deg & this.DG;
            this.B = this.B - degraded;
            this.updateProperties();
        end
        
        function [] = bind(this, binded)
            %binded is a PopZ that has intersection with MG
            this.B = this.B + binded.getBlock();
            this.updateProperties();
        end
        
        function [] = diffuse(this, vec)
            this.B = circshift(this.B, vec);
            this.updateProperties();
        end
        
        
    end
    
    %--------------------------------------------------------------------%
    methods(Access=private) %helper functions
        function M = computeMargin(this)
            
            right = circshift(this.B,[ 1,0]);
            right(1,:) = 0;
            left  = circshift(this.B,[-1,0]);
            left(end,:) = 0;
            
            BBB = right + left + circshift(this.B,[0,1]) + circshift(this.B,[0,-1]);
            
            M = BBB & (this.B==0);
        end
        function n = computeNum(this)
            n = numel(find(this.B~=0));
        end
        function d = computeDegradable(this)
            %must compute margin first!!!!!!!!!
            mg = this.MG;
            right = circshift(mg,[ 1,0]);
            right(1,:) = 0;
            left  = circshift(mg,[-1,0]);
            left(end,:) = 0;
            
            MMM = right + left + circshift(mg,[0,1]) + circshift(mg,[0,-1]);
            d = MMM & this.B;
        end
        function [] = updateProperties(this)
            this.MG  = this.computeMargin();
            this.num = this.computeNum();
            this.DG  = this.computeDegradable();
        end
    end
    
    %--------------------------------------------------------------------%
    methods(Static) %get probability
        function p = getDiffuseProb(num)
            p = 0.1;    %¶Ã¼gªº
        end
        function p = getDegradeProb(num)
            p = 0.5;   %¶Ã¼gªº
        end
        function p = getBindProb(n1, n2)
            p = 0.03;   %¶Ã¼gªº
        end
    end
end