function [f, ax] = displayNearFieldPhase(obj, viewAngle)
    
    arguments
        obj       AutField 
        viewAngle (1,2)    = [0, 90]
    end
    
    f = figure(Name="Phase of the Near-Field");
    xAxis = subplot(1,2,1);
    yAxis = subplot(1,2,2);
    ax = [xAxis, yAxis];

    phaseMeshgrid = MeshgridQuantity(obj.nearField.xGrid,    ...
                                     obj.nearField.yGrid,    ...
                                     angle(obj.nearField.X), ...
                                     angle(obj.nearField.Y), ...
                                     "signed");
    surface(phaseMeshgrid, xAxis, yAxis, viewAngle);
end