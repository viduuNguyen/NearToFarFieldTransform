function obj = nf2fft(obj, mode, probeAntenna)
    arguments
        obj  NearFieldToFarField
        mode string              = "normal" % choose to apply probe correction or not
        probeAntenna             = []       % 
    end
    
    if mode ~= "normal" && isempty(probeAntenna)
        error("The probe antenna should be provided to use this mode");
    end
    
    % compute and interpolate the spectrum and store to obj.spectrum, obj.interpSpectrum
    obj = computeSpectrum(obj);
   
    % compute far-field and directivity in 2 different planes
    switch mode
        case "normal"
            % without applying probe correction
            obj = computeFarField(obj);
            [obj.directivityX, obj.directivityY] = computeDirectivity(obj, obj.farField.X, obj.farField.Y);
            
        case "corrected"
            % applying probe correction
            obj = computeCorrFarField(obj, probeAntenna);
            [obj.corrDirectivityX, obj.corrDirectivityY] = computeDirectivity(obj, obj.corrFarField.X, obj.corrFarField.Y);
        case "both"
            % applying both approaches for comparison
            obj = computeFarField(obj);
            [obj.directivityX, obj.directivityY] = computeDirectivity(obj, obj.farField.X, obj.farField.Y);
            obj = computeCorrFarField(obj, probeAntenna);
            [obj.corrDirectivityX, obj.corrDirectivityY] = computeDirectivity(obj, obj.corrFarField.X, obj.corrFarField.Y);
        otherwise
            error("Incorrect input for mode");
    end
    obj.mode = mode;
    
end