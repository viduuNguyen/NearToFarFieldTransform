% setUp(obj, nearField, farFieldGrid, wavelength, farFieldDistance, fftSizeX, fftSizeY)
%
% Sets up the instance attributes of NearFieldToFarField class.
%
% Input arguments:
%   obj - Instance of NearFieldToFarField class to be set up
%   nearField - MeshgridQuantity object containing near-field data
%   farFieldGrid - AngularGrid object defining the angular grid for far-field computations
%   wavelength - Wavelength of the signal in meters (must be positive)
%   farFieldDistance - Distance to the far-field plane in meters (must be positive)
%   fftSizeX - Size of FFT in the x-direction (must be positive integer)
%   fftSizeY - Size of FFT in the y-direction (must be positive integer)
%
% Details:
%   This function initializes the attributes of the NearFieldToFarField instance
%   with the provided near-field data, far-field grid specifications, wavelength,
%   far-field distance, and FFT sizes. It computes the wave number from the 
%   wavelength and sets it as an attribute of the instance for further computations.
%
% Example:
%   % Create an instance of NearFieldToFarField class
%   obj = NearFieldToFarField();
%
%   % Assume nearField, farFieldGrid, wavelength, farFieldDistance, fftSizeX, and fftSizeY are defined
%
%   % Set up the instance with the provided parameters
%   obj = obj.setUp(nearField, farFieldGrid, wavelength, farFieldDistance, fftSizeX, fftSizeY);
%
% See also: NearFieldToFarField, MeshgridQuantity, AngularGrid


function obj = setUp(obj, nearField, farFieldGrid, wavelength, farFieldDistance, fftSizeX, fftSizeY)
    
    arguments
        obj              NearFieldToFarField
        nearField        MeshgridQuantity
        farFieldGrid     AngularGrid
        wavelength       {mustBePositive}
        farFieldDistance {mustBePositive}
        fftSizeX         {mustBeInteger, mustBePositive}
        fftSizeY         {mustBeInteger, mustBePositive}
    end

    % set the instance's attributes
    obj.farFieldGrid     = farFieldGrid;
    obj.nearField        = nearField;
    obj.farFieldDistance = farFieldDistance;
    obj.fftSizeX         = fftSizeX;
    obj.fftSizeY         = fftSizeY;
    

    % compute the wave number and wave number components
    obj.waveNumber = 2*pi/wavelength;
    
end