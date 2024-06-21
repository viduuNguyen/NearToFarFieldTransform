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