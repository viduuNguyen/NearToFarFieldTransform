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


%         function correlatedRoughSurface = getRandomRoughSurface(o)
%             uncorrelatedRoughSurface = o.rmsError*randn(o.nearFieldGrid.pointX, o.nearFieldGrid.pointY);
%              gaussianFilter = exp(-(abs(o.nearFieldGrid.x) + abs(o.nearFieldGrid.y))/(o.correlationLength/2));
%             normalisingFactor = 2 * o.nearFieldGrid.lengthX / (o.nearFieldGrid.pointX * o.correlationLength);
%             correlatedRoughSurface = normalisingFactor * ifft2(fft2(uncorrelatedRoughSurface) .* fft2(gaussianFilter));
%         end