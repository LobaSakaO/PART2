clf;

saveFilm = true;   %remember to rename film that has been saved.


Xlim = 50;
Ylim = 30;

[Xmap, Ymap] = meshgrid(1:Xlim+1, 1:Ylim+1);
Map = zeros(Xlim, Ylim);
h = surf(Xmap, Ymap, [Map Map(:, Ylim);Map(Xlim, :) 0]');
shading flat;
axis([1 Xlim+1 1 Ylim+1 0 5 0 2]);
set(gca, 'View', [0 90], 'XGrid','off');

pa = ParaObj(h);
cell = PopZCell(Xlim, Ylim, pa, h);


if(saveFilm)
    mov = VideoWriter('5', 'MPEG-4');
    open(mov);
    for time = 1:1500
        title({['in steps ',num2str(time)]; ['PopZList.length()= ', num2str(cell.PopZList.length())]; ['total PopZ = ', num2str(sum(sum(cell.PopZ_All)))]});
        cell.diffuse();
        cell.draw();
        m = getframe;
        writeVideo(mov, m);

        cell.generate();
        cell.draw();
        m = getframe;
        writeVideo(mov, m);

        cell.bind();
        cell.draw();
        m = getframe;
        writeVideo(mov, m);

        cell.degrade();
        cell.draw();
        m = getframe;
        writeVideo(mov, m);
    end
    close(mov);
else
    time = 1;
    while(true)
        title({['in steps ',num2str(time)]; ['PopZList.length()= ', num2str(cell.PopZList.length())]});
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