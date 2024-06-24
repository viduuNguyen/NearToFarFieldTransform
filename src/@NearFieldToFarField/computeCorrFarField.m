% computeCorrFarField(obj, probeAntenna)
%
% Computes the corrected far-field components with probe correction using
% the provided probe antenna.
%
% Input arguments:
%   obj          - Instance of the NearFieldToFarField class.
%   probeAntenna - Antenna object representing the probe used for correction.
%
% Output:
%   obj - Updated instance of NearFieldToFarField with the corrected far-field
%         components stored in obj.corrFarField.
%
% Details:
%   This function computes the corrected far-field components for both
%   vertical and horizontal polarizations based on the provided probeAntenna.
%   It uses the far-field components (fieldVTheta, fieldVPhi, fieldHTheta,
%   fieldHPhi) from the probeAntenna and the interpolated spectrum components
%   (spectrumV, spectrumH) from obj.interpSpectrum to compute the corrected
%   far-field components (fieldTheta, fieldPhi) for the instance obj.
%
%   The computation involves:
%   - Determinant calculation.
%   - Spectrum calculation at the far-field distance.
%   - Computing corrected fieldTheta and fieldPhi using the determinant,
%     spectrumTheta, spectrumPhi, and far-field components from the probeAntenna.
%
% See also: NearFieldToFarField, MeshgridQuantity

function obj = computeCorrFarField(obj, probeAntenna)
    
    arguments 
        obj NearFieldToFarField 
        probeAntenna
    end
    
    % define far-field components for each polarisation measurement
    fieldV      = probeAntenna.fieldX;
    fieldVTheta = fieldV.X;
    fieldVPhi   = fieldV.Y;
    
    fieldH      = probeAntenna.fieldY;
    fieldHTheta = fieldH.X;
    fieldHPhi   = fieldH.Y;
    
    % define quantities and compute corrected far-field components
    determinant = fieldHTheta .* fieldVPhi - fieldVTheta .* fieldHPhi;
    spectrumV   = obj.interpSpectrum.X;
    spectrumH   = obj.interpSpectrum.Y;
    
    % compute the spectrum at farFieldDistance
    spectrumTheta = spectrumV .* cos(obj.farFieldGrid.phi) + ...
                    spectrumH .* sin(obj.farFieldGrid.phi);
    
    spectrumPhi = (-spectrumV .* sin(obj.farFieldGrid.phi) +   ...
                    spectrumH .* cos(obj.farFieldGrid.phi)) .* ...
                    cos(obj.farFieldGrid.theta);
    
    term = cos(obj.farFieldGrid.theta) ./ determinant;

    fieldTheta = term .* (spectrumH .* fieldVPhi - spectrumV .* fieldHPhi);
    fieldPhi   = term .* (spectrumH .* fieldVTheta - spectrumV .* fieldHTheta); 
    
    % meshgrid of data points in x- and y- coordinate
    x_ = obj.farFieldDistance .* sin(obj.farFieldGrid.theta) .* cos(obj.farFieldGrid.phi);
    y_ = obj.farFieldDistance .* sin(obj.farFieldGrid.theta) .* sin(obj.farFieldGrid.phi);
    
    obj.corrFarField = MeshgridQuantity(x_,y_,fieldTheta,fieldPhi, "20log");
end