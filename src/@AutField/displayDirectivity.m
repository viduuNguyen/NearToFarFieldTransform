% displayDirectivity - Display the directivity of the antenna under test (AUT) in specified view angles.
%
%   [f, ax] = displayDirectivity(obj)
%
%   Inputs:
%       obj - AutField object.
%
%   Outputs:
%       f  - Figure handle of the generated plot.
%       ax - Axes handle of the subplot containing the directivity plot.
%
%   This function creates a figure and subplot to display the directivity
%   patterns of the AUT in the xz and yz planes. It uses VectorQuantity's
%   multiplePlot method to plot directivity data stored in obj.directivityX
%   and obj.directivityY. The maximum directivity value is annotated on the
%   plot, and labels and legends are added for clarity.
%
%   Dependencies:
%       VectorQuantity - Custom class representing vector quantities (included in this code).
%
%   See also: VectorQuantity.multiplePlot.


function [f, ax] =  displayDirectivity(obj)
    arguments
        obj AutField 
    end
    
    f = figure(Name="MATLAB antenna toolbox");
    ax = subplot(1,1,1);
    VectorQuantity.multiplePlot([obj.directivityX, obj.directivityY], ax);
    maxDirectivity = max(obj.directivityX.y, [], "all");
    xlabel(ax, "elevation (degree)");
    ylabel(ax, sprintf("directivity (dBi), max = %2.0f(dBi)", maxDirectivity));
    legend(ax, "phi = 0^{\circ}", "phi = 90^{\circ}");
    
end