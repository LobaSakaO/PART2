clf;

Xlim = 50;
Ylim = 30;
[Xmap, Ymap] = meshgrid(1:Xlim+1, 1:Ylim+1);
Map = zeros(Xlim, Ylim);
h = surf(Xmap, Ymap, [Map Map(:, Ylim);Map(Xlim, :) 0]');
shading flat;
axis([1 Xlim+1 1 Ylim+1 0 5 0 2]);
set(gca, 'View', [0 90], 'XGrid','off');

cell = PopZCell();
cell.handle_graph = h;
cell.draw(h);
% pause(1);

cell.generate();
cell.draw(h);
% pause(1);
cell.bind();
cell.draw(h);
% pause(1);

cell.generate();
cell.draw(h);
% pause(1);
cell.bind();
cell.draw(h);
% pause(1);

cell.PopZList.length()

% pause(1);
% cell.degrade();
% cell.draw(h);
% 
% pause(1);
% cell.degrade();
% cell.draw(h);
% 
% pause(1);
% cell.degrade();
% cell.draw(h);