classdef PopZCell < handle
    properties
        PopZList;
        PopZ_All;%sum Big ParJ
        PopZ_MG_All; %show all collider
        
        
    end
    
    properties(Constant)
        Xlim = 15;
        Ylim = 10;
    end
    
    methods
        function obj = PopZCell()
            x = PopZCell.Xlim;
            y = PopZCell.Ylim;
            
            obj.PopZList = DList();
            obj.PopZ_All = zeros(x, y);
            obj.PopZ_MG_All = zeros(x, y);
            
                        
            tmp = zeros(x, y);
            tmp(3,3)=1;
            tmp(3,4)=1;
            tmp(3,5)=1;
            tmp(4,3)=1;
            tmp(4,4)=1;
            tmp(4,5)=1;
            tmp(5,3)=1;
            tmp(5,4)=1;
            tmp(5,5)=1;
            obj.PopZList.push_front(PopZ(tmp));
            tmp = zeros(x, y);
            tmp(10,3)=1;
            tmp(10,4)=1;
            obj.PopZList.push_front(PopZ(tmp));

            obj.PopZ_All = obj.computePopZ_All();
        end
        
        function [] = generate(this)
            x = PopZCell.Xlim;
            y = PopZCell.Ylim;
            kgenerate = 0.2;
            tmp_gen = binornd(1, kgenerate, [x, y]) & (this.PopZ_All==0);
            
            for i = find(tmp_gen)
                tmp = PopZCell.ZEROS();
                tmp(i)=1;
                this.push_front(PopZ(tmp));
            end
            
            this.PopZ_All = this.computePopZ_All();
        end
        
        function [] = degrade(this)
            for i=1:this.PopZList.length()
                tmp = this.PopZList.get(i);
                tmp.degrade();
            end
            this.PopZ_All = this.computePopZ_All();
        end
        
        function [] = diffuse(this)
        end
        
        function [] = draw(this, h)
            set(h, 'ZDATA', [this.PopZ_All this.PopZ_All(:, PopZCell.Ylim);this.PopZ_All(PopZCell.Xlim, :) 0]');
            drawnow;
        end
        
    end
    
    methods(Access=private) %helper functions
        function b = getBlock(this, index)
            p = this.PopZList.get(index);
            b = p.getBlock();
        end
        
        function b = getMargin(this, index)
            p = this.PopZList.get(index);
            b = p.getMargin();
        end
        
        function [] = push_front(this, popZ)
            this.PopZList.push_front(popZ);
        end
        
        function m = computePopZ_All(this)
            m = PopZCell.ZEROS();
            for i=1:this.PopZList.length()
                m = m + this.getBlock(i);
            end
        end
        
        function m = computePopZ_MG_All(this)
            m = PopZCell.ZEROS();
            for i=1:this.PopZList.length()
                m = m + this.getMargin(i);
            end
        end
        
        function [] = updateData(this)
            this.PopZ_All = this.computePopZ_All();
            this.PopZ_MG_All = this.computePopZ_MG_All();
        end
        

    end
    
    methods(Static)
        function m = ZEROS(this)
            m = zeros(PopZCell.Xlim, PopZCell.Ylim);
        end
    end
    
end