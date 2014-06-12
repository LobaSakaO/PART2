classdef BPopZ < handle
    
    properties
        B; %distribution block
        MG; %margin
        num;
    end
    
    properties (Constant)
        Xlim = 15;
        Ylim = 10;
    end
    
    %--------------------------------------------------------------------%
    methods(Access=public)
        function obj = BPopZ(b)
            if nargin~=0
                obj.B = b;
                obj.MG = obj.computeMargin();
                obj.num = obj.computeNum();
            end
        end
        
        function [] = draw(Z, h)
            set(h, 'ZDATA', [Z.B Z.B(:, BPopZ.Ylim);Z.B(BPopZ.Xlim, :) 0]');
            drawnow;
        end
        function [] = drawMargin(Z, h)
            set(h, 'ZDATA', [Z.MG Z.MG(:, BPopZ.Ylim);Z.MG(BPopZ.Xlim, :) 0]');
            drawnow;
        end
        
        function collided = isCollide(this, collider)
            collided = numel(find(this.MG & collider));
        end
        
        function [] = degrade(this, degraded)
            this.B = this.B - degraded;
            this.MG = this.computeMargin();
            this.num = this.computeNum();
        end
        
        function [] = bind(this, binded)
            %binded is a matrix that has intersection with MG
            this.B = this.B + binded;
            this.MG = this.computeMargin();
            this.num = this.computeNum();
        end
        
        function [] = diffuse(this, vec)
            this.B = circshift(this.B, vec);
            this.MG = this.computeMargin();
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
            
            M = ( (BBB.*(this.B==0))~=0 );
        end
        
        function n = computeNum(this)
            n = numel(find(this.B~=0));
        end
    end
    
    %--------------------------------------------------------------------%
    methods(Static)
        function p = getDiffuseProb(num)
            p = 0.1;    %¶Ã¼gªº
        end
        function p = getDegradeProb(num)
            p = 0.05;   %¶Ã¼gªº
        end
        function p = getBindProb(n1, n2)
            p = 0.03;   %¶Ã¼gªº
        end
    end
end