function obj = interpSpectrum(obj)
    arguments
        obj NearFieldToFarField
    end
    
    
    
    waveNumberX = obj.nearField.x(:,1);
    waveNumberY = obj.nearField.y(1,:);
    
    spectrum
    
    % interpolate the spectrum
    spectrumAngularX = interp2(waverNumberX, waveNumberY, );
    spectrumAngularY = interp
end
