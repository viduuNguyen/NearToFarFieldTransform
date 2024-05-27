function obj = nf2fft(obj)
    arguments
        obj NearFieldToFarField 
    end
%     
%     xGrid = obj.nearFieldGrid.x;
%     yGrid = obj.nearFieldGrid.y;
%     obj.nearField = MeshgridQuantity(xGrid ,yGrid ,nearFieldX, nearFieldY);
%     
    
    % compute and interpolate the spectrum and store to obj.spectrum, obj.interpSpectrum
    obj = computeSpectrum(obj);
    
    % compute the directivity in 2 different slicing planes
    obj = computeFarField(obj);
    
    obj = computeDirectivity(obj);
%     [directivityX, directivityY] = o.computeDirectivity(o.fieldTheta, o.fieldPhi);

end