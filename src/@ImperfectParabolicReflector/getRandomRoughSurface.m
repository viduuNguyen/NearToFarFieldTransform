% getRandomRoughSurface - Generate a random rough surface for the imperfect parabolic reflector.
%
%   errorSurface = getRandomRoughSurface(obj)
%
%   Inputs:
%       obj - ImperfectParabolicReflector object.
%
%   Outputs:
%       errorSurface - Generated random rough surface as a matrix.
%
%   This function generates a random rough surface to simulate imperfections
%   on the parabolic reflector. It uses parameters such as RMS error (obj.rmsError)
%   and correlation length (obj.correlationLength) to create an uncorrelated
%   random error surface, which is then filtered using a Gaussian filter to
%   introduce correlation among the errors. The resulting error surface is
%   normalized and returned as output.
%
%   Notes:
%   - The size and resolution of the surface are determined by the dimensions
%     of obj.nearFieldGrid.x and obj.nearFieldGrid.y.
%
%   Dependencies:
%       ImperfectParabolicReflector - Parent class containing reflector parameters.
%
%   See also: ImperfectParabolicReflector.


function errorSurface = getRandomRoughSurface(obj)
    arguments
        obj ImperfectParabolicReflector
    end
    
    % define parameters
    [POINT_X, POINT_Y] = size(obj.nearFieldGrid.x);
    LENGTH_X = max(obj.nearFieldGrid.x(:)) - min(obj.nearFieldGrid.x(:));
    
    % create uncorrelated random error
    uncorrelatedSurface = obj.rmsError .* randn(POINT_X, POINT_Y);
    
    % define Gaussian filter and normalising factor
    gaussianFilter = exp( -(abs(obj.nearFieldGrid.x) + abs(obj.nearFieldGrid.y)) ./ (obj.correlationLength/2) );
    
    normFactor = 2 * LENGTH_X / (POINT_X * obj.correlationLength);
    
    errorSurface = normFactor*(ifft2(fft2(uncorrelatedSurface) .* fft2(gaussianFilter)));
    
end
