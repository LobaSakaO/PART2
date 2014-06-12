classdef PopZCell < handle
    properties
        BPopZList;
        BPopZ_All;%sum Big ParJ
        BPopZ_MG_ALL; %show all collider
        PopZ_All;%exclude Big ParJ
        
        
    end
    
    properties(Constant)
        Xlim = 15;
        Ylim = 10;
    end
    
    methods
        function [] = generate(this)
            kgenerate = 0.2;
            tmp_gen = binornd(1, kgenerate, [this.Xlim, this.Ylim]);
            PopZ_All(tmp_gen)=1;
        end
        
        function [] = degrade(this)
        end
        
        function [] = diffuse(this)
        end
        
        function [] = draw(this, h)
            drawnow;
        end
        
    end
    
    methods(Static)
    end
    
end