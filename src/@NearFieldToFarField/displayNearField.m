% displayNearField(obj, viewAngle)
%
% Displays the magnitude of the near-field data of the NearFieldToFarField object
% in a surface plot with normalized electric Far-Field. It plots the near-field
% magnitude obj.nearField in two subplots, xAxis and yAxis.
%
% Input arguments:
%   obj       - Instance of the NearFieldToFarField class.
%   viewAngle - Optional argument specifying the viewing angles for the surface plot.
%               Default is [0, 90].
%
% Output:
%   f   - Figure handle of the plotted figure.
%   ax  - Axes handles of the subplots (xAxis and yAxis).
%
% Details:
%   The function checks if the near-field data obj.nearField is empty. If it is
%   empty, an error is thrown indicating that the near-field data must be imported
%   first using the setUp method. Otherwise, it creates a figure with the Name
%   "Magnitude of the Near-Field data". It sets up two subplots, xAxis and yAxis,
%   and plots the near-field magnitude using the surface function. The xlabel,
%   ylabel, and zlabel indicate the x, y, and near-field (dB) respectively. Titles
%   for xAxis and yAxis indicate "Co-Polar Near-Field" and "Cross-Polar Near-Field"
%   respectively.
%
% See also: NearFieldToFarField, surface, setUp.


function [f, ax] = displayNearField(obj, viewAngle)

    arguments
        obj       NearFieldToFarField
        viewAngle (1,2) = [0, 90]
    end
    
    if isempty(obj.nearField)  
        error("The Near-Field data must be imported first by using method setUp");
    end

    f = figure(Name="Magnitude of the Near-Field data");
    xAxis = subplot(1,2,1);
    yAxis = subplot(1,2,2);
    ax = [xAxis, yAxis];
    surface(obj.nearField, xAxis, yAxis, viewAngle);
    xlabel([xAxis, yAxis], "x (m)");
    ylabel([xAxis, yAxis], "y (m)");
    zlabel([xAxis, yAxis], "Near-Field (dB)");
    title(xAxis, "Co-Polar Near-Field");
    title(yAxis, "Cross-Polar Near-Field");

end