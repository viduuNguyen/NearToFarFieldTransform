%% clean up the environment
clc
clear variables;
close all;
format long;

%% define constants
disp("define constants");
SPEED_OF_LIGHT = 299792458;
FREQUENCY = 1.3e9;
WAVELENGTH = SPEED_OF_LIGHT / FREQUENCY;
INCREASE_FACTOR = 0;

farFieldGrid = AngularGrid(0.002);
aut = ImperfectParabolicReflector;
farField = NearFieldToFarField;

%% define parameters of the parabolic antenna
disp("define parameters of the parabolic antenna");
CORRELATION_LENGTH = 4 * WAVELENGTH;
RADIUS             = 10 * CORRELATION_LENGTH;
GRID_LENGTH        = 16 * RADIUS;
SAMPLING_POINT_X   = 2^(ceil(log2(2 * GRID_LENGTH / WAVELENGTH)));
SAMPLING_POINT_Y   = SAMPLING_POINT_X;

scanningGrid = PlanarGrid(SAMPLING_POINT_X, SAMPLING_POINT_Y, GRID_LENGTH, GRID_LENGTH);
FRAUNHOFER_DISTANCE = 2 * (2 * RADIUS)^2 / WAVELENGTH;

errorRatio = 1 : 10;
repitition = 1 : 5;
directivityError_dBi = zeros(length(repitition), length(errorRatio));

%% ideal case 
%% 1. generate near-field data and parse that data
rmsError = 0;
aut = aut.setUp(WAVELENGTH, RADIUS, rmsError, CORRELATION_LENGTH, scanningGrid);
[fieldX, fieldY] = aut.getNearField();
%% 2. implement near-field to far-field transformation
% 2a. increase the resolution of the FFT by adding more sampling points
FFT_SIZE_X = 2^(ceil(log2(SCANNING_POINT_X)) + INCREASE_FACTOR);
FFT_SIZE_Y = FFT_SIZE_X;

nf2ff = setUp(nf2ff, nf.nearField, ffGrid, WAVELENGTH, 10*FRAUNHOFER_DISTANCE, FFT_SIZE_X, FFT_SIZE_Y);


farField = farField.setUp(scanningGrid, farFieldGrid, WAVELENGTH, 10*FRAUNHOFER_DISTANCE, FFT_SIZE_X, FFT_SIZE_Y);

% 2b. perform near-field to far-field transformation
[fieldTheta, fieldPhi] = farField.nf2fft(fieldX, fieldY);

[directivityX_dBi, ~] = farField.getDirectivity_dBi(fieldTheta, fieldPhi);

directivityIdeal_dBi = max(directivityX_dBi);

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
        
        directivityError_dBi(j,i) = max(directivityX_dBi);
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
