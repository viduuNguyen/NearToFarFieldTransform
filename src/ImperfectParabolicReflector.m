classdef ImperfectParabolicReflector
    properties (Access=private)
        wavelength
        radius                      % radius of the circular aperture  
        rmsError                    % rms error of the height variation
        correlationLength           % correlation length of the gaussian hat
        nearFieldGrid PlanarGrid  
    end

    methods (Access=public)

        function o = setUp(o, wavelength, radius, rmsError, correlationLength, nearFieldGrid)
            % set the instance's attributes
            o.wavelength = wavelength;
            o.radius = radius;
            o.rmsError = rmsError;
            o.correlationLength = correlationLength;
            o.nearFieldGrid = nearFieldGrid;
        end

        function [fieldX, fieldY] = getNearField(o)
            % aperture's amplitude distribution
            apertureAmplitude = ones(o.nearFieldGrid.pointX, o.nearFieldGrid.pointY);

            % aperture phase error distribution
            error = o.getRandomRoughSurface();
            phaseError = 4*pi*error./o.wavelength;

            % aperture phasor distribution
            fieldX = apertureAmplitude.*exp(1j*phaseError);
            condition = ((o.radius)^2 < (o.nearFieldGrid.x.^2 + o.nearFieldGrid.y.^2));
            % 45 dB lower than the main radiating beam
            fieldX(condition) = 10^(-45/10) * 0;
            fieldY = 10^(-100/10) * 0 * ones(o.nearFieldGrid.pointX, o.nearFieldGrid.pointY);
        end

    end

    methods (Access=private)
        
        function correlatedRoughSurface = getRandomRoughSurface(o)
            uncorrelatedRoughSurface = o.rmsError*randn(o.nearFieldGrid.pointX, o.nearFieldGrid.pointY);
            gaussianFilter = exp(-(abs(o.nearFieldGrid.x) + abs(o.nearFieldGrid.y))/(o.correlationLength/2));
            normalisingFactor = 2 * o.nearFieldGrid.lengthX / (o.nearFieldGrid.pointX * o.correlationLength);
            correlatedRoughSurface = normalisingFactor * ifft2(fft2(uncorrelatedRoughSurface) .* fft2(gaussianFilter));
        end

    end

end