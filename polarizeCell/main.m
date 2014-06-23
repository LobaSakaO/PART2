clf;

saveFilm = true;   %remember to rename film that has been saved.

mov = avifile('1.avi', 'fps', 1/60);

Xlim = 50;
Ylim = 30;

[Xmap, Ymap] = meshgrid(1:Xlim+1, 1:Ylim+1);
Map = zeros(Xlim, Ylim);
h = surf(Xmap, Ymap, [Map Map(:, Ylim);Map(Xlim, :) 0]');
shading flat;
axis([1 Xlim+1 1 Ylim+1 0 5 0 2]);
set(gca, 'View', [0 90], 'XGrid','off');

pa = ParaObj();
cell = PopZCell(Xlim, Ylim, pa, h);


if(saveFilm)
    for time = 1:5000
        title(time);
        cell.diffuse();
        cell.draw();
        m = getframe(h);
        mov = addframe(mov, m);

        cell.generate();
        cell.draw();
        m = getframe(h);
        mov = addframe(mov, m);

        cell.bind();
        cell.draw();
        m = getframe(h);
        mov = addframe(mov, m);

        cell.degrade();
        cell.draw();
        m = getframe(h);
        mov = addframe(mov, m);        
    end
    mov = close(mov);
else
    time = 1;
    while(true)
        title(time);
    %     display('diffusing...');
        cell.diffuse();
        cell.draw();

    %     display('generating...');
        cell.generate();
        cell.draw();

    %     display('binding...');
        cell.bind();
        cell.draw();

    %     display('degrading...');
        cell.degrade();
        cell.draw();

        time = time+1;
    end
end