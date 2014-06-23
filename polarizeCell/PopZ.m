classdef PopZ < handle
    
    properties
        B;  %distribution block
        MG; %margin
        DG; %degradable
        num;%total number of small popZ (sum(sum(B)))
        Xlim;
        Ylim;
    end
    
    properties (Constant)

    end
    
    %--------------------------------------------------------------------%
    methods(Access=public)
        function obj = PopZ(b, x ,y)
            if nargin~=0
                obj.B = b;
                obj.Xlim = x;
                obj.Ylim = y;
                obj.updateMargin();
                obj.updateNum();
                obj.updateDegradable();
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

    end
    
    %--------------------------------------------------------------------%
    methods(Access=public)
        function [] = updateMargin(this)
            
            right = circshift(this.B,[ 1,0]);
            right(1,:) = 0;
            left  = circshift(this.B,[-1,0]);
            left(end,:) = 0;
            
            BBB = right + left + circshift(this.B,[0,1]) + circshift(this.B,[0,-1]);
            
            M = BBB & (this.B==0);
            
            this.MG = M;
        end
        function [] = updateNum(this)
            n = numel(find(this.B~=0));
            this.num = n;
        end
        function [] = updateDegradable(this)
            %must compute margin first!!!!!!!!!
            mg = this.MG;
            right = circshift(mg,[ 1,0]);
            right(1,:) = 0;
            left  = circshift(mg,[-1,0]);
            left(end,:) = 0;
            
            MMM = right + left + circshift(mg,[0,1]) + circshift(mg,[0,-1]);
            d = MMM & this.B;
            
            this.DG = d;
        end
        
    end
    

end