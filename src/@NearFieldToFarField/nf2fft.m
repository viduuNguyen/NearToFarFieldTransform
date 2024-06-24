% nf2fft(obj, mode, probeAntenna)
%
% Performs near-field to far-field transformation based on the specified mode.
%
% Input arguments:
%   obj - Instance of NearFieldToFarField class containing near-field data
%   mode - String indicating the mode of operation:
%          - "normal": Computes far-field and directivity without probe correction.
%          - "corrected": Applies probe correction and computes corrected far-field
%                         and directivity.
%          - "both": Computes both normal and corrected results for comparison.
%   probeAntenna - Optional parameter required only when mode is "corrected" or "both".
%                  It represents the probe antenna used for correction.
%
% Output:
%   obj - Updated instance of NearFieldToFarField class with computed spectrum,
%         far-field (and corrected if applicable), directivity (and corrected if applicable),
%         and mode set.
%
% Details:
%   This function first computes and interpolates the spectrum from the near-field data.
%   Depending on the specified mode, it then computes either the normal far-field and directivity,
%   or applies probe correction and computes corrected far-field and directivity, or computes
%   both for comparison purposes. It stores the computed results back into the object instance.
%
% Example:
%   % Create an instance of NearFieldToFarField class
%   obj = NearFieldToFarField();
%   
%   % Import near-field data and set up parameters (not shown in this function)
%   % ...
%   
%   % Perform near-field to far-field transformation without probe correction
%   obj = nf2fft(obj, "normal");
%   
%   % Display far-field results
%   [f, ax] = obj.displayFarField();
%
% See also: NearFieldToFarField, computeSpectrum, computeFarField, computeCorrFarField, computeDirectivity


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