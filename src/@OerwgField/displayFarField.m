% displayFarField - Display the normalized electric far-field of the open-ended rectangular waveguide.
%
%   displayFarField(obj, viewAngle)
%
%   Inputs:
%       obj - OerwgField object.
%       viewAngle (optional) - View angles for displaying the far-field. Default is [0, 90].
%
%   This method creates a figure with two subplots to display the normalized
%   electric far-field of the open-ended rectangular waveguide. It uses the surface
%   function to plot the far-field data stored in obj.fieldX on the specified
%   subplots (xAxis and yAxis). The far-field data is assumed to be stored in
%   obj.fieldX as a MeshgridQuantity object. The scale of the far-field display
%   is set to "20log".
%
%   Parameters:
%       viewAngle - View angles [azimuth, elevation] in degrees to specify the direction
%                   from which the far-field is viewed. Default is [0, 90] (top-down view).
%
%   Example:
%       guideWidth = 0.2; % 20 cm (replace with actual guide width in meters)
%       guideHeight = 0.1; % 10 cm (replace with actual guide height in meters)
%       wavelength = 0.03; % 30 mm (replace with actual wavelength in meters)
%       farFieldDistance = 1.0; % 1 meter (replace with actual distance in meters)
%       farFieldGrid = AngularGrid(100, 50); % Replace with actual grid parameters
%
%       oerwg = OerwgField(guideWidth, guideHeight, wavelength, farFieldDistance, farFieldGrid);
%
%       % Display the far-field of the waveguide
%       oerwg.displayFarField([0, 90]);
%
%   See also: OerwgField, MeshgridQuantity, surface.

function displayFarField(obj, viewAngle)
    
    arguments
        obj       OerwgField 
        viewAngle (1,2)      = [0, 90]
    end
    
    f = figure(Name="Normalised electric Far-Field of the open-ended rectangular waveguide");
    xAxis = subplot(1,2,1);
    yAxis = subplot(1,2,2);
    
    surface(obj.fieldX, xAxis, yAxis, viewAngle);
    xlabel([xAxis, yAxis], "x (m)");
    ylabel([xAxis, yAxis], "y (m)");
    zlabel([xAxis, yAxis], "Far-Field (dB)");
    title(xAxis, "Co-Polar Far-Field");
    title(yAxis, "Cross-Polar Far-Field");
end