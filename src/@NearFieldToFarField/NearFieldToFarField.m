classdef NearFieldToFarField
    
    properties (Access=private)
        waveNumber       {mustBePositive} = 1  % wave number
        spectrum         MeshgridQuantity      % spectrum components in x- and y-coordinates
        interpSpectrum   MeshgridQuantity      % interpolated spectrum components in x- and y-coordinates
        
        nearField        MeshgridQuantity      % near-field components in x- and y-coordinates
        farField         MeshgridQuantity      % far-field components in x- and y-coordinates
        corrFarField     MeshgridQuantity      % far-field with probe correction
        
        
        
        nearFieldGrid    PlanarGrid            % near-field scanning grid
        farFieldGrid     AngularGrid           % far-field scanning grid
        farFieldDistance                       % far-field distance
        fftSizeX                               % size of the fft in x coordinate
        fftSizeY                               % size of the fft in y coordinate
        
        mode             string           = "" % choice for probe correction
        probeAntenna                    
    end
    
    properties(Access=public)
        directivityX     VectorQuantity        % directivity in xz plane
        directivityY     VectorQuantity        % directivity in yz plane
        
        corrDirectivityX VectorQuantity        % directivity with probe correction
        corrDirectivityY VectorQuantity
    end

    methods(Access=public)
        
        nearField = parseNearFieldFiles(obj, fileNameX, fileNameY)
        
        nearField = parseNearFieldWorkspace(obj, xGrid, yGrid, phasorX, phasorY)
        
        obj = setUp(obj, nearField, farFieldGrid, wavelength, farFieldDistance, fftSizeX, fftSizeY)
        
        obj = nf2fft(obj, mode, probeAntenna)

        [f, ax] = displayNearField(obj, viewAngle)
        
        [f, ax] = displayNearFieldPhase(obj, viewAngle)
        
        displaySpectrum(obj, viewAngle)
        
        [f, ax] = displayInterpSpectrum(obj, viewAngle)
        
        displayFarField(obj, viewAngle)
        
        displayDirectivity(obj)
        
        displayCorrFarField(obj, viewAngle)
        
        displayCorrDirectivity(obj)
        
    end

    methods(Access=private)
        
        obj = computeSpectrum(obj)
        
        obj = computeFarField(obj)
        
        obj = computeCorrFarField(obj)
        
        [directivityX, directivityY] = computeDirectivity(obj, fieldX, fieldY)
        
    end
    
    methods(Static, Access=private)
        % valuating the data and generate a PlanarGrid
        grid = getNearGrid(dataX, dataY)
    end

end