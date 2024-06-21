function [f, ax] = displayNearFieldPhase(obj, viewAngle)

    arguments
        obj       NearFieldToFarField
        viewAngle (1,2) = [0, 90]
    end
    
    if isempty(obj.nearField)  
        error("The Near-Field data must be imported first");
    end

    f = figure(Name="Phase of the Near-Field data");
    xAxis = subplot(1,2,1);
    yAxis = subplot(1,2,2);
    ax = [xAxis, yAxis];
    
    phaseX = angle(obj.nearField.X);
    phaseY = angle(obj.nearField.Y);

    phase = MeshgridQuantity(obj.nearField.xGrid, ...
                             obj.nearField.yGrid, ...
                             phaseX,              ...
                             phaseY,              ...
                             "signed");

    surface(phase, xAxis, yAxis, viewAngle);
    xlabel([xAxis, yAxis], "x (m)");
    ylabel([xAxis, yAxis], "y (m)");
    zlabel([xAxis, yAxis], "Phase (degree)");
    title(xAxis, "Co-Polar Near-Field");
    title(yAxis, "Cross-Polar Near-Field");


end