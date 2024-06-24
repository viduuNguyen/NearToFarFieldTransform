% displayDirectivity(obj)
%
% Displays the directivity of the NearFieldToFarField object in the elevation
% plane. It plots the directivity components obj.directivityX and
% obj.directivityY in a single figure.
%
% Input arguments:
%   obj - Instance of the NearFieldToFarField class.
%
% Output:
%   f   - Figure handle of the plotted figure.
%   ax  - Axes handle of the subplot where the directivity components are displayed.
%
% Details:
%   This function plots the directivity components stored in obj.directivityX
%   and obj.directivityY on the same figure. It uses VectorQuantity.multiplePlot
%   to plot the directivity values against the elevation in degrees. The xlabel
%   indicates the elevation in degrees, and the ylabel represents the directivity
%   in dBi. The legend shows the directivity values for phi = 0 degrees and phi =
%   90 degrees.
%
%   If the mode property of obj is set to "corrected", an error is thrown because
%   the function is not applicable in this mode.
%
% See also: NearFieldToFarField, VectorQuantity.multiplePlot.


function [f, ax] = displayDirectivity(obj)
    arguments
        obj NearFieldToFarField 
    end
    
    if (obj.mode == "corrected") 
        error("This methos is not applicable for this mode");
    end
    
    f = figure(Name="NF2FFT algorithm");
    ax = subplot(1,1,1);
    VectorQuantity.multiplePlot([obj.directivityX, obj.directivityY], ax);
    xlabel(ax, "elevation (degree)");
    maxDirectivity = 10*log10(max(obj.directivityX.y, [], "all"));
    ylabel(ax, sprintf("directivity (dBi), max = %2.0f (dBi)", maxDirectivity));
    legend(ax, "phi = 0^{\circ}", "phi = 90^{\circ}");
    
end