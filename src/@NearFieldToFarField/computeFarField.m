% computeFarField(obj)
%
% Computes the far-field components for the given NearFieldToFarField object
% and stores the results in obj.farField.
%
% Input arguments:
%   obj - Instance of the NearFieldToFarField class.
%
% Output:
%   No direct output. The computed far-field components are stored in the
%   obj.farField property of the input object.
%
% Details:
%   This function computes the far-field components based on the following
%   inputs from the object:
%   - obj.waveNumber: Wave number of the electromagnetic wave.
%   - obj.farFieldDistance: Distance at which the far-field components are
%     computed.
%   - obj.farFieldGrid: AngularGrid object specifying the grid points for
%     theta and phi angles.
%   - obj.interpSpectrum: MeshgridQuantity object containing the interpolated
%     spectrum components in x and y coordinates.
%
%   It computes the radial-dependent component C, and then computes the
%   spectrum components at the far-field distance. Using these, it calculates
%   the far-field components in theta and phi coordinates. The results are
%   stored in obj.farField as a MeshgridQuantity object, with the x and y
%   coordinates corresponding to the angular positions and the fieldTheta
%   and fieldPhi components stored in dB units (20*log10).
%
% See also: NearFieldToFarField, MeshgridQuantity.


function obj = computeFarField(obj)
    % compute the far-field components and store in obj.farField
    
    arguments
        obj NearFieldToFarField 
    end
    
    % compute radial-dependent component
    C = 1j*(obj.waveNumber*exp(-1j*obj.waveNumber*obj.farFieldDistance)) / ...
        (2*pi*obj.farFieldDistance);
    
    % compute the spectrum at farFieldDistance
    spectrumTheta = obj.interpSpectrum.X .* cos(obj.farFieldGrid.phi) + ...
                    obj.interpSpectrum.Y .* sin(obj.farFieldGrid.phi);
    
    spectrumPhi = (-obj.interpSpectrum.X .* sin(obj.farFieldGrid.phi) +   ...
                    obj.interpSpectrum.Y .* cos(obj.farFieldGrid.phi)) .* ...
                    cos(obj.farFieldGrid.theta);
                
    % compute the far-field components in theta- and phi-coordinate
    fieldTheta = C .* spectrumTheta;
    fieldPhi   = C .* spectrumPhi;
    
    % meshgrid of data points in x- and y- coordinate
    xGrid = obj.farFieldDistance .* sin(obj.farFieldGrid.theta) .* cos(obj.farFieldGrid.phi);
    yGrid = obj.farFieldDistance .* sin(obj.farFieldGrid.theta) .* sin(obj.farFieldGrid.phi);
    
    obj.farField = MeshgridQuantity(xGrid,      ...
                                    yGrid,      ...
                                    fieldTheta, ...
                                    fieldPhi,   ...
                                    "20log");
end