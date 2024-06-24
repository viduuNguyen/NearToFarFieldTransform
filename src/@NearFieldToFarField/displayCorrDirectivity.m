% displayCorrDirectivity(obj)
%
% Displays the corrected directivity of the NearFieldToFarField object based on the
% selected mode (probe correction or other). It plots the corrected directivity
% components obj.corrDirectivityX and obj.corrDirectivityY in a single figure.
%
% Input arguments:
%   obj - Instance of the NearFieldToFarField class.
%
% Output:
%   f   - Figure handle of the plotted figure.
%   ax  - Axes handle of the subplot where the directivity is displayed.
%
% Details:
%   This function plots the corrected directivity components stored in
%   obj.corrDirectivityX and obj.corrDirectivityY on the same figure. It uses
%   VectorQuantity.multiplePlot to visualize the directivity in different polar
%   planes. The xlabel indicates the elevation angle in degrees, and the ylabel
%   represents the directivity in dBi with the maximum value indicated. A legend
%   shows the directivity components for phi angles of 0 degrees and 90 degrees.
%
%   If the mode property of obj is set to "normal", an error is thrown because
%   the function is not intended to be used in this mode.
%
% See also: NearFieldToFarField, VectorQuantity.


function [f, ax] = displayCorrDirectivity(obj)
    arguments
        obj NearFieldToFarField 
    end
    
    if (obj.mode == "normal") 
        error("Incorrect option for mode");
    end
    
    f = figure(Name="NF2FFT algorithm");
    ax = subplot(1,1,1);
    VectorQuantity.multiplePlot([obj.corrDirectivityX, obj.corrDirectivityY], ax);
    xlabel(ax, "elevation (degree)");
    maxDirectivity = 10*log10(max(obj.corrDirectivityX.y, [], "all"));
    ylabel(ax, sprintf("directivity (dBi), max = %2.0f (dBi)", maxDirectivity));
    legend(ax, "phi = 0^{\circ}", "phi = 90^{\circ}");
    
end