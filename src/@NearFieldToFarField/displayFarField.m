% displayFarField(obj, viewAngle)
%
% Displays the far-field components of the NearFieldToFarField object in a
% normalized electric Far-Field plot. It plots the far-field components obj.farField
% in two subplots, xAxis and yAxis.
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
%   This function checks the mode property of obj. If mode is set to "corrected", 
%   an error is thrown because the function is not applicable in this mode.
%
%   The function creates a figure with the Name "Normalised electric Far-Field". 
%   It sets up two subplots, xAxis and yAxis, and plots the far-field components
%   stored in obj.farField using the surface function. The xlabel, ylabel, and 
%   zlabel indicate the x, y, and Far-Field (dB) respectively. Titles for xAxis 
%   and yAxis indicate "Phi-component of Far-Field" and "Theta-component of 
%   Far-Field" respectively.
%
% See also: NearFieldToFarField, surface.


function [f, ax] = displayFarField(obj, viewAngle)
    
    arguments
        obj       NearFieldToFarField 
        viewAngle (1,2)               = [0, 90]
    end
    
    if (obj.mode == "corrected") 
        error("This methos is not applicable for this mode");
    end

    f = figure(Name="Normalised electric Far-Field");
    xAxis = subplot(1,2,1);
    yAxis = subplot(1,2,2);
    ax = [xAxis, yAxis];
    surface(obj.farField, xAxis, yAxis, viewAngle);
    xlabel([xAxis, yAxis], "x (m)");
    ylabel([xAxis, yAxis], "y (m)");
    zlabel([xAxis, yAxis], "Far-Field (dB)");
    title(xAxis, "Phi-component of Far-Field");
    title(yAxis, "Theta-component of Far-Field");
end