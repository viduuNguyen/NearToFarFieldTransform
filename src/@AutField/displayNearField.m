% displayNearField - Display the magnitude of the near-field of the antenna under test (AUT).
%
%   [f, ax] = displayNearField(obj, viewAngle)
%
%   Inputs:
%       obj       - AutField object.
%       viewAngle - Viewing angles for the near-field plot in degrees. Default is [0, 90].
%
%   Outputs:
%       f  - Figure handle of the generated plot.
%       ax - Axes handles of the subplots containing the near-field magnitude plots.
%
%   This function creates a figure with two subplots to display the magnitude
%   of the near-field in the x and y coordinates. It uses the surface function
%   to plot the near-field data stored in obj.nearField, with optional view angles
%   specified by viewAngle. Labels and titles are added to the subplots for clarity.
%
%   Note: The near-field data must be stored in obj.nearField as a MeshgridQuantity object.
%
%   See also: MeshgridQuantity, surface.


function [f, ax] = displayNearField(obj, viewAngle)
    
    arguments
        obj       AutField 
        viewAngle (1,2)    = [0, 90]
    end
    
    f = figure(Name="Magnitude of the Near-Field data");
    xAxis = subplot(1,2,1);
    yAxis = subplot(1,2,2);
    ax = [xAxis, yAxis];
    surface(obj.nearField, xAxis, yAxis, viewAngle);
    xlabel([xAxis, yAxis], "x (m)");
    ylabel([xAxis, yAxis], "y (m)");
    zlabel([xAxis, yAxis], "Magnitude of the Near-Field (dB)");
    title(xAxis, "Co-Polar Near-Field");
    title(yAxis, "Cross-Polar Near-Field");
end