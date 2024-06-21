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