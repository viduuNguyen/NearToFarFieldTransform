% displayCorrFarField(obj, viewAngle)
%
% Displays the corrected far-field of the NearFieldToFarField object with probe
% correction based on the selected mode. It plots the corrected far-field
% components obj.corrFarField.X and obj.corrFarField.Y in a single figure.
%
% Input arguments:
%   obj       - Instance of the NearFieldToFarField class.
%   viewAngle - Optional. View angle specification in degrees for the surface plot.
%               Default is [0, 90].
%
% Output:
%   f   - Figure handle of the plotted figure.
%   ax  - Axes handles of the subplots where the far-field components are displayed.
%
% Details:
%   This function plots the corrected far-field components stored in
%   obj.corrFarField.X and obj.corrFarField.Y on the same figure. It uses
%   surface plotting with surface(obj.corrFarField, xAxis, yAxis, viewAngle) to
%   visualize the far-field in the x and y directions. The xlabel indicates the
%   x-axis in meters, the ylabel represents the y-axis in meters, and the zlabel
%   shows the far-field in dB. The title of xAxis represents the Phi-component of
%   Far-Field, and yAxis represents the Theta-component of Far-Field.
%
%   If the mode property of obj is set to "normal", an error is thrown because
%   the function is not intended to be used in this mode.
%
% See also: NearFieldToFarField, surface.


function [f, ax] = displayCorrFarField(obj, viewAngle)
    
    arguments
        obj       NearFieldToFarField 
        viewAngle (1,2)               = [0, 90]
    end
    
    if (obj.mode == "normal") 
        error("Incorrect option for mode");
    end

    f = figure(Name="Normalised electric Far-Field with probe correction");
    xAxis = subplot(1,2,1);
    yAxis = subplot(1,2,2);
    ax=[xAxis, yAxis];
    
    surface(obj.corrFarField, xAxis, yAxis, viewAngle);
    xlabel([xAxis, yAxis], "x (m)");
    ylabel([xAxis, yAxis], "y (m)");
    zlabel([xAxis, yAxis], "Far-Field (dB)");
    title(xAxis, "Phi-component of Far-Field");
    title(yAxis, "Theta-component of Far-Field");
end