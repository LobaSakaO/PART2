clf;

Xlim = 15;
Ylim = 10;
[Xmap, Ymap] = meshgrid(1:Xlim+1, 1:Ylim+1);
Map = zeros(Xlim, Ylim);
h = surf(Xmap, Ymap, [Map Map(:, Ylim);Map(Xlim, :) 0]');
shading flat;
axis([1 Xlim+1 1 Ylim+1 0 5 0 2]);
set(gca, 'View', [0 90], 'XGrid','off');

tmp = zeros(Xlim, Ylim);
tmp(5,3)=1;
tmp(5,4)=1;
A = BPopZ(tmp);
A.draw(h);

% pause(1);
% 
% tmp = zeros(Xlim, Ylim);
% tmp(6,3)=1;
% tmp(6,2)=1;
% tmp(7,2)=1;
% A.bind(tmp);
% A.draw(h);
% 
% pause(1);
% 
% A.diffuse([1,1]);
% A.draw(h);
% 
% pause(1);
% 
% tmp = zeros(Xlim, Ylim);
% tmp(7,5)=1;
% A.isCollide(tmp)

list = DList();
list.push_front(A);

list.display();
list.length()
display(list)
