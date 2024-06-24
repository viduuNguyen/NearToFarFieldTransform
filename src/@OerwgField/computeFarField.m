% computeFarField - Compute the far-field of an open-ended rectangular waveguide.
%
%   farField = computeFarField(waveNumber, width, height, distance, thetaGrid, phiGrid)
%
%   Inputs:
%       waveNumber - Wave number of the electromagnetic wave.
%       width      - Width of the open-ended rectangular waveguide aperture.
%       height     - Height of the open-ended rectangular waveguide aperture.
%       distance   - Distance from the waveguide aperture to the far-field measurement plane.
%       thetaGrid  - Angular grid in theta (elevation) direction.
%       phiGrid    - Angular grid in phi (azimuth) direction.
%
%   Outputs:
%       farField - MeshgridQuantity object representing the computed far-field,
%                  containing the electric field components (fieldTheta and fieldPhi)
%                  in spherical coordinates (thetaGrid, phiGrid).
%
%   This function computes the far-field of an open-ended rectangular waveguide
%   based on the specified waveguide dimensions (width and height), wave number,
%   and distance to the measurement plane. It uses the angular grids (thetaGrid,
%   phiGrid) to calculate the electric field components (fieldTheta and fieldPhi)
%   in spherical coordinates. The computed far-field is returned as a
%   MeshgridQuantity object with the components scaled to "20log".
%
%   Notes:
%   - The dimensions of thetaGrid and phiGrid must be consistent.
%   - The far-field is computed using theoretical formulas specific to the
%     geometry and dimensions of an open-ended rectangular waveguide.
%
%   See also: MeshgridQuantity.

function farField = computeFarField(waveNumber, width, height, distance, thetaGrid, phiGrid)
   
    arguments(Output)
        farField MeshgridQuantity 
    end
    
    X = 0.5 * waveNumber * width * sin(thetaGrid) .* cos(phiGrid);
    
    Y = 0.5 * waveNumber * height * sin(thetaGrid) .* sin(phiGrid);
    
    C = 1j*(width * height * waveNumber * exp(-1j*waveNumber*distance)) / (2 *pi*distance);
    
    term       = cos(X) ./ (X.^2 - (pi/2)^2) .* sin(Y) ./ Y;
    fieldTheta = -(pi/2) * C * sin(phiGrid) .* term;
    fieldPhi   = -(pi/2) * C * cos(thetaGrid) .* cos(phiGrid) .* term;
    
    % meshgrid of data points in x- and y- coordinate
    xGrid = distance .* sin(thetaGrid) .* cos(phiGrid);
    yGrid = distance .* sin(thetaGrid) .* sin(phiGrid);
    
    farField = MeshgridQuantity(xGrid,      ...
                                yGrid,      ...
                                fieldTheta, ...
                                fieldPhi,   ...
                                "20log");
                                
end