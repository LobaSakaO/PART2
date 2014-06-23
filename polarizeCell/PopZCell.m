classdef PopZCell < handle
    properties
        PopZList;
        PopZ_All;%sum Big ParJ
        handle_graph;
        para = ParaObj();
        
        Xlim;
        Ylim;  
    end
    

    methods
        function obj = PopZCell(xlim, ylim, paraObj, h)
            obj.Xlim = xlim;
            obj.Ylim = ylim;
            obj.para = paraObj();
            obj.handle_graph = h;
            obj.PopZList = DList();
            obj.PopZ_All = obj.computePopZ_All();
        end
        
        function [] = generate(this)
            x = this.Xlim;
            y = this.Ylim;
            tmp_gen = binornd(1, this.para.getGenerateProb(), [x, y]) & (this.PopZ_All==0);
            tmpp = find(tmp_gen);
            for i = 1:numel(tmpp)
                tmp = this.ZEROS();
                tmp(tmpp(i))=1;
                this.PopZList.push_back(PopZ(tmp, this.Xlim, this.Ylim));
            end
            
            this.PopZ_All = this.computePopZ_All();
        end
        
        function [] = bind(this)
%             display('binding...');
            i = 1;
%             count = 0;
            while(i<=this.PopZList.length())
                hi = this.PopZList.get(i);
                if(isempty(find(hi.getMargin() & this.PopZ_All))==false)
                    
%                     this.drawII(hi.getBlock());
%                     pause(1);
%                     this.drawII(hi.getMargin());
%                     pause(1);
                    
%                     count = count+1;
                    
                    poleArea = this.para.getPoleArea(this.Xlim,this.Ylim);
                    if(  numel(find( hi.getMargin() & this.PopZ_All & poleArea ) )~=0 )
                        j = i+1;
                        tmp_all = this.PopZ_All;
                        while(j<=this.PopZList.length())
                            hj = this.PopZList.get(j);
                            if(isempty(find(hi.getMargin() & hj.getBlock()))==false)
                                if(binornd(1, this.para.getBindProb(hi.getNum(), hj.getNum())))%bind success%)
%                                     display('binding!');
                                    this.PopZList.insert(PopZ(hi.getBlock()|hj.getBlock(), this.Xlim, this.Ylim), j+1);
%                                     this.drawII(this.getBlock(j+1));
%                                     pause(0.5);
                                    this.PopZList.pop(j);
                                    this.PopZList.pop(i);
                                    i = i-1;
                                    break;
                                else
%                                     display('not bind QQ');
                                    tmp_all = tmp_all-hj.getBlock();
                                    if(isempty(find(hi.getMargin() & tmp_all))==true)
%                                         display('break!');
                                        break;
                                    end
                                end
                            end
                            j = j+1;
                        end
                    end
                end
                i = i+1;
            end
%             display(count);
%             length = this.PopZList.length();
%             display(length);
        end
        
        function [] = degrade(this)
            i=1;
            while( i<=this.PopZList.length())
                hi = this.PopZList.get(i);
                hi.updateDegradable();                
                x = this.Xlim;
                y = this.Ylim;
                tmp_deg = binornd(1, this.para.getDegradeProb(hi.getNum()), [x, y]);
                degraded = tmp_deg & hi.DG;
                if (isempty(find(degraded))~=false)
                    hi.B = hi.getBlock() - degraded;
                    hi.updateMargin();
                    hi.updateNum();

                    if (isempty(find(hi.getBlock()))==true)
    %                     display('disappear!');
                        this.PopZList.pop(i);
                        i = i-1;
                    else
                        splitList = DList();
                        huntedBlock = hi.getBlock();
                        while(isempty(find(huntedBlock))==false)
                            b = this.huntBlock(huntedBlock);
                            splitList.push_back(PopZ(b, this.Xlim, this.Ylim));
                            huntedBlock = huntedBlock-b;
                        end
                        if (splitList.length()>1)
    %                         display('split!');
                            this.PopZList.pop(i);
                            for jj=1:splitList.length();
                                this.PopZList.insert_after(splitList.get(jj),i-1);
                            end
                            i=i+splitList.length()-1;
                        end
                    end
                end
                
                i = i+1;
            end
            this.PopZ_All = this.computePopZ_All();
        end
        
        function [] = diffuse(this)
%             display('difusing...');
            x = this.Xlim;
            y = this.Ylim;
            i=1;
            while(i<=this.PopZList.length())
                
                hi = this.PopZList.get(i);
                if(binornd(1, this.para.getDiffuseProb(hi.num))==true)
                    if (hi.getNum()==1)
                        v = find((this.PopZ_All==0));
                        j = randi([1,numel(v)]);
                        tmp = this.ZEROS();
                        tmp(j) = 1;

                        this.PopZ_All = this.PopZ_All - hi.getBlock();
                        hi.B = tmp;
                        hi.updateMargin();
                        this.PopZ_All = this.PopZ_All + hi.getBlock();

                    else
                        dir = randi([-1,1], [1,2]);
                        ifDiffuse = circshift([zeros(1,y); hi.getBlock(); zeros(1,y)], dir);
                        collider = [ones(1,y); this.PopZ_All - hi.getBlock(); ones(1,y)];
                        if(hi.getNum() > this.para.getCenterDiffusable())
                            if(isempty(find(ifDiffuse&([ones(1,y); this.para.getPoleArea(x, y)==0; ones(1,y)] )))==false)
                                dir(1) = 0;
                            end
                        end
                        if(isempty(find(ifDiffuse & collider)))
                            this.PopZ_All = this.PopZ_All - hi.getBlock();
                            hi.B = circshift(hi.getBlock(),dir);
                            hi.updateMargin();
                            this.PopZ_All = this.PopZ_All + hi.getBlock();
                        end
                    end
                end
                i = i+1;
            end
        end
        
        function [] = draw(this)
            m = this.PopZ_All;
            m = m + 0.1*((m==0) & this.para.getPoleArea(this.Xlim, this.Ylim));
            set(this.handle_graph, 'ZDATA', [m m(:, this.Ylim);m(this.Xlim, :) 0]');
            drawnow;
        end
        
        function [] = drawII(this, m)
            a = this.PopZ_All;
            a(find(m)) = 5;
            set(this.handle_graph, 'ZDATA', [a a(:, this.Ylim);a(this.Xlim, :) 0]');
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
            m = this.ZEROS();
            for i=1:this.PopZList.length()
                m = m + this.getBlock(i);
            end
        end
 
        
        function [] = updateData(this)
            this.PopZ_All = this.computePopZ_All();
        end
        
        function M = huntBlock(this,hb)
            M = this.ZEROS();
            v = find(hb);
            M(v(1))=1;
            while(true)
                right = circshift(M,[ 1,0]);
                right(1,:) = 0;
                left  = circshift(M,[-1,0]);
                left(end,:) = 0;
                BBB = right + left + circshift(M,[0,1]) + circshift(M,[0,-1]);
                Margin = BBB & (M==0);
                
                neighbor = Margin & hb;
                
                if (isempty(find(neighbor)))
                    break;
                else
                    M = M + neighbor;
                end
            end            
        end
        
        function m = ZEROS(this)
            m = zeros(this.Xlim, this.Ylim);
        end 
    end

end