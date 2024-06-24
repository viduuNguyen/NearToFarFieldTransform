% displayNearFieldPhase - Display the phase of the near-field of the antenna under test (AUT).
%
%   [f, ax] = displayNearFieldPhase(obj, viewAngle)
%
%   Inputs:
%       obj       - AutField object.
%       viewAngle - Viewing angles for the near-field phase plot in degrees. Default is [0, 90].
%
%   Outputs:
%       f  - Figure handle of the generated plot.
%       ax - Axes handles of the subplots containing the near-field phase plots.
%
%   This function creates a figure with two subplots to display the phase
%   of the near-field in the x and y coordinates. It computes the phase
%   of the near-field data stored in obj.nearField, constructs a MeshgridQuantity
%   object with phase information, and uses the surface function to plot it.
%   Optional view angles can be specified by viewAngle. Labels and titles are
%   added to the subplots for clarity.
%
%   Note: The near-field data must be stored in obj.nearField as a MeshgridQuantity object.
%
%   See also: MeshgridQuantity, surface.


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
    xlabel([xAxis, yAxis], "x (m)");
    ylabel([xAxis, yAxis], "y (m)");
    zlabel([xAxis, yAxis], "Phase of the Near-Field (radian)");
    title(xAxis, "Co-Polar Near-Field");
    title(yAxis, "Cross-Polar Near-Field");
end