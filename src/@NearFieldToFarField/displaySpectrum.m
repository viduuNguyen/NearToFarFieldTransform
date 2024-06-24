% displaySpectrum(obj, viewAngle)
%
% Displays the spectrum components in x- and y-coordinates of the NearFieldToFarField
% object in a surface plot. The plot shows the spectrum stored in obj.spectrum in two
% subplots, xAxis and yAxis.
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
%   The function creates a figure with the Name "Spectrum components in x- and y-coordinate".
%   It sets up two subplots, xAxis and yAxis. It plots the spectrum stored in obj.spectrum
%   using the surface function. The xlabel, ylabel, and zlabel indicate the wavenumber
%   component X, wavenumber component Y, and spectrum (in dB) respectively. Titles for xAxis
%   and yAxis indicate "Co-Polar wave spectrum" and "Cross-Polar wave spectrum" respectively.
%
% See also: NearFieldToFarField, surface.


function [f, ax] = displaySpectrum(obj, viewAngle)
    
    arguments
        obj       NearFieldToFarField
        viewAngle (1,2)               = [0, 90]
    end
    
    f = figure(Name="Spectrum components in x- and y-coordinate");
    xAxis = subplot(1,2,1);
    yAxis = subplot(1,2,2);
    ax = [xAxis, yAxis];

    surface(obj.spectrum, xAxis, yAxis, viewAngle);
    xlabel([xAxis, yAxis], "wavenumber component X (m^{-1})");
    ylabel([xAxis, yAxis], "wavenumber component Y (m^{-1})");
    zlabel([xAxis, yAxis], "spectrum (dB)");
    title(xAxis, "Co-Polar wave spectrum");
    title(yAxis, "Cross-Polar wave spectrum");
end