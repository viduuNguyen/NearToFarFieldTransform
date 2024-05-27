function obj = setUp(obj, nearField, farFieldGrid, wavelength, farFieldDistance, fftSizeX, fftSizeY)
    
    arguments
        obj              NearFieldToFarField
        nearField        MeshgridQuantity
        farFieldGrid     AngularGrid
        wavelength       {mustBePositive}
        farFieldDistance {mustBePositive}
        fftSizeX         {mustBeInteger, mustBePositive}
        fftSizeY         {mustBeInteger, mustBePositive}
    end

    % set the instance's attributes
    obj.farFieldGrid     = farFieldGrid;
    obj.nearField        = nearField;
    obj.farFieldDistance = farFieldDistance;
    obj.fftSizeX         = fftSizeX;
    obj.fftSizeY         = fftSizeY;
    

    % compute the wave number and wave number components
    obj.waveNumber = 2*pi/wavelength;
    
end