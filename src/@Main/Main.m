% Main class for Near-Field to Far-Field transformation simulation.
%
% Properties (Public):
%   xGrid - X-coordinate sampling grid for Near-Field.
%   yGrid - Y-coordinate sampling grid for Near-Field.
%   phasorX - Phasor data corresponding to xGrid.
%   phasorY - Phasor data corresponding to yGrid.
%   frequency - Frequency of the signal.
%
% Properties (Public, GetAccess):
%   directivityX - Directivity in the X direction without probe correction.
%   directivityY - Directivity in the Y direction without probe correction.
%   corrDirectivityX - Directivity in the X direction with probe correction.
%   corrDirectivityY - Directivity in the Y direction with probe correction.
%
% Properties:
%   farFieldGridSpace - Grid space in radians for Far-Field angular grid (default: 0.005).
%   interpolationFactor - Power of base 2 for zero-padding elements (default: 0).
%
% Methods:
%   Transform - Performs the Near-Field to Far-Field transformation using NF2FFT algorithm.
%
% Example Usage:
%   % Create Main instance and perform transformation
%   mainObj = Main();
%   mainObj.Transform();

classdef Main
    properties (Access=public)
        %% Near-Field data
        xGrid 
        yGrid 
        phasorX
        phasorY
        frequency

        %% Interpolation Factors
        farFieldGridSpace                   = 0.005; % Grid space in radian
        interpolationFactor {mustBeInteger} = 0;     % power of base 2 of zero-padding elements
    end

    properties(GetAccess=public)
        directivityX
        directivityY
        corrDirectivityX
        corrDirectivityY
    end

    methods
        function obj = Transform(obj)
            assert(isequal(size(obj.xGrid) == size(obj.yGrid), [1,1]), "The sampling meshgrid must have the same dimension");
            
            ffGrid = AngularGrid(obj.farFieldGridSpace);
            nf2ffObj = NearFieldToFarField;
            nfInput = parseNearFieldWorkspace(nf2ffObj, obj.xGrid, obj.yGrid, obj.phasorX, obj.phasorY);
             
            GUIDE_HEIGHT                         = 10.16e-3;
            GUIDE_WIDTH                          = 22.86e-3;
            WAVELENGTH                           = 299792458 / obj.frequency;
            FRAUNHOFER_DISTANCE                  = 10;
            [SAMPLING_POINT_X, SAMPLING_POINT_Y] = size(nfInput.xGrid);
            FFT_SIZE_X                           = 2^(ceil(log2(SAMPLING_POINT_X)) + obj.interpolationFactor);
            FFT_SIZE_Y                           = 2^(ceil(log2(SAMPLING_POINT_Y)) + obj.interpolationFactor);

            probeAnt = OerwgField(GUIDE_WIDTH, GUIDE_HEIGHT, WAVELENGTH, 10*FRAUNHOFER_DISTANCE, ffGrid);
            
            nf2ffObj = setUp(nf2ffObj,               ...
                             nfInput,                ...
                             ffGrid,                 ...
                             WAVELENGTH,             ...
                             10*FRAUNHOFER_DISTANCE, ...
                             FFT_SIZE_X,             ...
                             FFT_SIZE_Y);

            nf2ffObj = nf2fft(nf2ffObj, "both", probeAnt);

            displayNearField(nf2ffObj, [30, 60]);
            displayNearFieldPhase(nf2ffObj);
%             displaySpectrum(nf2ffObj);
            displayInterpSpectrum(nf2ffObj, [30, 60]);

            figure(Name="Pattern comparison")
            ax(1) = subplot(1,2,1);
            VectorQuantity.multiplePlot([nf2ffObj.directivityX, nf2ffObj.corrDirectivityX], ax(1));
            legend(ax(1), "NF2FFT Without Probe Correction", "Nf2FF With Probe Correction", Location="south")
            
            ax(2) = subplot(1,2,2);
            VectorQuantity.multiplePlot([nf2ffObj.directivityY, nf2ffObj.corrDirectivityY], ax(2));
            legend(ax(2), "NF2FFT Without Probe Correction", "Nf2FF With Probe Correction", Location="south")
            
            obj.directivityX = nf2ffObj.directivityX;
            obj.directivityY = nf2ffObj.directivityY;
            obj.corrDirectivityX = nf2ffObj.corrDirectivityX;
            obj.corrDirectivityY = nf2ffObj.corrDirectivityY;
        end
    end

end