classdef NearFieldToFarField
    
    properties (Access=private)
        waveNumber       {mustBePositive} = 1 % wave number
        spectrum         MeshgridQuantity     % spectrum components in x- and y-coordinates
        interpSpectrum   MeshgridQuantity     % interpolated spectrum components in x- and y-coordinates
        
        nearField        MeshgridQuantity     % near-field components in x- and y-coordinates
        farField         MeshgridQuantity     % far-field components in x- and y-coordinates
        
        directivityX     VectorQuantity       % directivity in xz plane
        directivityY     VectorQuantity       % directivity in yz plane
        
        nearFieldGrid    PlanarGrid           % near-field scanning grid
        farFieldGrid     AngularGrid          % far-field scanning grid
        farFieldDistance                      % far-field distance
        fftSizeX                              % size of the fft in x coordinate
        fftSizeY                              % size of the fft in y coordinate
    end

    methods(Access=public)
        
        [fieldX, fieldY, grid] = parseNearFieldFiles(obj, fileNameX, fileNameY)
        
        obj = setUp(obj, nearField, farFieldGrid, wavelength, farFieldDistance, fftSizeX, fftSizeY)
        
        obj = nf2fft(obj)
        
        displaySpectrum(obj)
        
        displayInterpSpectrum(obj)
        
        displayFarField(obj)
        
        displayDirectivity(obj)
        
    end

    methods(Access=private)
        
        obj = computeSpectrum(obj)
        
        obj = computeFarField(obj)
        
        obj = computeDirectivity(obj)
        
    end
    
    methods(Static, Access=private)
        % valuating the data and generate a PlanarGrid
        grid = getNearGrid(dataX, dataY)
    end

end