% computeSpectrum(obj)
%
% Computes the spectrum components for the given NearFieldToFarField object
% and stores the results in obj.spectrum and obj.interpSpectrum.
%
% Input arguments:
%   obj - Instance of the NearFieldToFarField class.
%
% Output:
%   No direct output. The computed spectrum components are stored in the
%   obj.spectrum and obj.interpSpectrum properties of the input object.
%
% Details:
%   This function computes the spectrum components from the near-field data
%   stored in obj.nearField. It computes the spectrum in rectangular coordinates
%   (spectrumX and spectrumY) using FFT and FFT shift operations. It then computes
%   the wave-number components in x and y coordinates and creates a MeshgridQuantity
%   object (obj.spectrum) to store these components.
%
%   It also computes the wave-number components with respect to theta and phi
%   coordinates for far-field interpolation. Using these components, it interpolates
%   the spectrum components from rectangular to angular coordinates (interpSpectrumX
%   and interpSpectrumY) using spline interpolation. These interpolated components
%   are stored in obj.interpSpectrum as a MeshgridQuantity object.
%
% See also: NearFieldToFarField, MeshgridQuantity.


function obj = computeSpectrum(obj)
    
    % compute plane wave spectrum components
    spectrumX = fftshift(fft2(obj.nearField.X, obj.fftSizeX, obj.fftSizeY));
    spectrumY = fftshift(fft2(obj.nearField.Y, obj.fftSizeX, obj.fftSizeY));
    
    % compute indices of the near-field grid
    indexX = -obj.fftSizeX/2 : obj.fftSizeX/2 - 1;
    indexY = -obj.fftSizeY/2 : obj.fftSizeY/2 - 1;
    
    % compute the grid space between adjacent points
    spaceX = abs(obj.nearField.xGrid(1,1) - obj.nearField.xGrid(2,1));
    spaceY = abs(obj.nearField.yGrid(1,1) - obj.nearField.yGrid(1,2));
    
    % compute wave-number components in x- and y-coordinate
    waveNumberX = 2*pi*indexX/(obj.fftSizeX*spaceX);
    waveNumberY = 2*pi*indexY/(obj.fftSizeY*spaceY);
    
    [waveNumberYGrid, waveNumberXGrid] = meshgrid(waveNumberY, waveNumberX); 
    
    obj.spectrum = MeshgridQuantity(waveNumberXGrid, ...
                                    waveNumberYGrid, ...
                                    spectrumX,       ...
                                    spectrumY,       ...
                                    "20log");
                                   
    % re-compute the wave-number components w.r.t theta- and phi-coordinate
    interpWaveNumberX = obj.waveNumber * sin(obj.farFieldGrid.theta) .* ...
                        cos(obj.farFieldGrid.phi);
    interpWaveNumberY = obj.waveNumber * sin(obj.farFieldGrid.theta) .* ...
                        sin(obj.farFieldGrid.phi);
    
    % interpolate the spectrum components (from rectangular to angular coordinates)
    interpSpectrumX = interp2(waveNumberX,       ...
                              waveNumberY,       ...
                              abs(spectrumX)',   ...
                              interpWaveNumberX, ...
                              interpWaveNumberY, ...
                              "spline");
                          
    interpSpectrumY = interp2(waveNumberX,       ...
                              waveNumberY,       ...
                              abs(spectrumY)',   ...
                              interpWaveNumberX, ...
                              interpWaveNumberY, ...
                              "spline");
                              
    obj.interpSpectrum = MeshgridQuantity(interpWaveNumberX, ...
                                          interpWaveNumberY, ...
                                          interpSpectrumX,   ...
                                          interpSpectrumY,   ...
                                          "20log");
end