function [f, plotX, plotY] = plotPolarisation(xGrid, yGrid, verticalGrid, horizontalGrid)
    f = figure();
    % Define special values
    minX = min(xGrid(:,1));
    maxX = max(xGrid(:,1)); 
    minY = min(yGrid(1,:));
    maxY = max(yGrid(1,:));

    % plot the surface graph for X- and Y- components 
    plotX = subplot(1,2,1);
    surf(plotX,xGrid, yGrid, 20*log10(abs(verticalGrid)));
    pbaspect(plotX, [1 1 1]);
    shading(plotX, "flat");
    colorbar();
    
    plotY = subplot(1,2,2);
    surf(plotY, xGrid, yGrid, 20*log10(abs(horizontalGrid)));
    shading(plotY, "flat");
    pbaspect(plotY, [1 1 1]);
    colorbar();

    % configure the X- and Y- limits
    xlim([plotX, plotY], [minX, maxX]);
    ylim([plotX, plotY], [minY, maxY]);
    
end