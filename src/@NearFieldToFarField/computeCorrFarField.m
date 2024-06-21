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