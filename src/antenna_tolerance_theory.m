%% clean up the environment
clc
clear all;
close all;
format long;

%% pre-defined constants and options
speedOfLight = 299792458;
operatingFrequency = 3e6;
wavelength = speedOfLight / operatingFrequency;
increaseFactor = 0;

farFieldGrid = AngularGrid(0.002, 0.002);
aut = ImperfectParabolicReflector;
farField = NearFieldToFarField;

% parameter of the parabolic antenna
correlationLength = 4*wavelength;
radius = 10*correlationLength;
gridLength = 16*radius;
samplingPointX = 2^(ceil(log2(4*radius/wavelength * gridLength/(2*radius))));
samplingPointY = samplingPointX;

scanningGrid = PlanarGrid(samplingPointX, samplingPointY, gridLength, gridLength);
fraunhoferDistance = 2*(2*radius)^2/wavelength;

errorRatio = 1 : 10;
repitition = 1 : 5;
directivityError_dBi = zeros(length(repitition), length(errorRatio));

%% ideal case 
%% 1. generate near-field data and parse that data
rmsError = 0;
aut = aut.setUp(wavelength, radius, rmsError, correlationLength, scanningGrid);
[fieldX, fieldY] = aut.getNearField();
%% 2. implement near-field to far-field transformation
% 2a. increase the resolution of the FFT by adding more sampling points
fftSizeX = 2^(ceil(log2(scanningGrid.pointX)) + increaseFactor);
fftSizeY = 2^(ceil(log2(scanningGrid.pointY)) + increaseFactor);
farField = farField.setUp(scanningGrid, farFieldGrid, wavelength, 10*fraunhoferDistance, fftSizeX, fftSizeY);

% 2b. perform near-field to far-field transformation
[fieldTheta, fieldPhi] = farField.nf2fft(fieldX, fieldY);

[directivityX_dBi, ~] = farField.getDirectivity_dBi(fieldTheta, fieldPhi);

directivityIdeal_dBi = max(directivityX_dBi)

%% errornous case
for i = errorRatio

    for j = repitition
        %% 1. generate near-field data and parse that data
        rmsError = i*0.01*wavelength;
        aut = aut.setUp(wavelength, radius, rmsError, correlationLength, scanningGrid);
        [fieldX, fieldY] = aut.getNearField();
        %% 2. implement near-field to far-field transformation
        % 2a. increase the resolution of the FFT by adding more sampling points
        fftSizeX = 2^(ceil(log2(scanningGrid.pointX)) + increaseFactor);
        fftSizeY = 2^(ceil(log2(scanningGrid.pointY)) + increaseFactor);
        farField = farField.setUp(scanningGrid, farFieldGrid, wavelength, 10*fraunhoferDistance, fftSizeX, fftSizeY);
        
        % 2b. perform near-field to far-field transformation
        [fieldTheta, fieldPhi] = farField.nf2fft(fieldX, fieldY);
        
        [directivityX_dBi, ~] = farField.getDirectivity_dBi(fieldTheta, fieldPhi);
        
        directivityError_dBi(j,i) = max(directivityX_dBi)
    end

end

difference = directivityIdeal_dBi - directivityError_dBi;

x = mean(log(difference))';
X = [ones(10, 1), x];
y = log((0.01 : 0.01 : 0.1)');
coefficient = X\y;
yRegression = X*coefficient;
figure();
scatter(x,y);
hold on;
plot(x, yRegression);
