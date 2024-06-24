% displayNearField - Display the normalized electric near-field of the imperfect parabolic reflector.
%
%   displayNearField(obj)
%
%   Inputs:
%       obj - ImperfectParabolicReflector object.
%
%   This function creates a figure with two subplots to display the normalized
%   electric near-field of the imperfect parabolic reflector. It uses the surface
%   function to plot the near-field data stored in obj.nearField on the specified
%   subplots (xAxis and yAxis). The near-field is assumed to be stored in obj.nearField
%   as a MeshgridQuantity object. The scale of the near-field display is set to "20log".
%
%   Example:
%       wavelength = 0.03; % 30 mm (replace with actual wavelength in meters)
%       radius = 0.2; % 20 cm (replace with actual radius in meters)
%       rmsError = 0.01; % 1 cm (replace with actual RMS error in meters)
%       correlationLength = 0.05; % 5 cm (replace with actual correlation length in meters)
%       nearFieldGrid = PlanarGrid(256, 256, 1.0, 1.0); % Replace with actual grid parameters
%
%       reflector = ImperfectParabolicReflector(wavelength, radius, rmsError, correlationLength, nearFieldGrid);
%
%       % Display the near-field of the reflector
%       reflector.displayNearField();
%
%   See also: ImperfectParabolicReflector, MeshgridQuantity, surface.


function displayNearField(obj)
    
    arguments
        obj ImperfectParabolicReflector 
    end
    
    f = figure(Name="Normalised electric Near-Field of the Imperfect Parabolic Reflector at the scanning plane");
    xAxis = subplot(1,2,1);
    yAxis = subplot(1,2,2);
    
    surface(obj.nearField, xAxis, yAxis, scale="20log");
end