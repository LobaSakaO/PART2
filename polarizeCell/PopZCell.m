classdef PopZCell < handle
    properties
        PopZList;
        PopZ_All;%sum Big ParJ
        PopZ_MG_All; %show all collider
        handle_graph;
        
        
    end
    
    properties(Constant)
        Xlim = 50;
        Ylim = 30;
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
            kgenerate = 0.1;
            tmp_gen = binornd(1, kgenerate, [x, y]) & (this.PopZ_All==0);
            tmpp = find(tmp_gen);
            for i = 1:numel(tmpp)
                tmp = PopZCell.ZEROS();
                tmp(tmpp(i))=1;
                this.push_front(PopZ(tmp));
%                 this.PopZList.display();
            end
            
            this.PopZ_All = this.computePopZ_All();
        end
        
        function [] = bind(this)
            display('binding...');
            i = 1;
            while(i<=this.PopZList.length())
                display(i);
                if(isempty(find(this.getMargin(i) & this.PopZ_All))==false)
                    j = i+1;
                    tmp_all = this.PopZ_All;
                    while(j<=this.PopZList.length())
                        j
                        if(isempty(find(this.getMargin(i) & this.getBlock(j)))==false)
                            if(binornd(1, this.getBindProb(this.PopZList.get(i), this.PopZList.get(j))))%bind success%)
                                display('binding!');
%                                 display(i);
%                                 display(j);
                                this.PopZList.insert(PopZ(this.getBlock(i)|this.getBlock(j)), j+1);
%                                 this.drawII(this.getBlock(j+1));
%                                 pause(0.1);
                                this.PopZList.pop(j);
                                this.PopZList.pop(i);
                                i = i-1;
                                break;
                            else
                                display('not bind QQ');
                                tmp_all = tmp_all-this.getBlock(j);
                                if(isempty(find(this.getMargin(i) & tmp_all))==true)
                                    display('break!');
                                    break;
                                end
                            end
                        end
                        j = j+1;
                    end
                end
                i = i+1;
            end
            
            display(this.PopZList.length());
        end
        
        function [] = degrade(this)
            for i=1:this.PopZList.length()
                tmp = this.PopZList.get(i);
                tmp.degrade();
            end
            this.PopZ_All = this.computePopZ_All();
        end
        
        function [] = diffuse(this)
            i=1;
            while(i<=this.PopZList.length())
                hi = this.PopZList.get(i);
                if(binornd(1, hi.getDiffuseProb)==true)
                    dir = randi([-1,1], [1,2]);
                    ifDiffuse = circshift(hi.getBlock(), dir);
                    collider = this.PopZ_All - hi.getBlock();
                    collider()
                    if(==PopZCell.ZEROS())
                    end
                end
            end
        end
        
        function [] = draw(this, h)
            set(h, 'ZDATA', [this.PopZ_All this.PopZ_All(:, PopZCell.Ylim);this.PopZ_All(PopZCell.Xlim, :) 0]');
            drawnow;
        end
        
        function [] = drawII(this, m)
            a = m+this.PopZ_All;
            set(this.handle_graph, 'ZDATA', [a a(:, PopZCell.Ylim);a(PopZCell.Xlim, :) 0]');
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
        
        function p = getBindProb(ZA, ZB)
            p = 0.8;   %�üg��
        end
    end
    
end