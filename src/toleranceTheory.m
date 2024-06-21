%% clean up the environment
clc
clear variables;
close all;
format long;

%% define constants
disp("define constants");
SPEED_OF_LIGHT = 299792458;
FREQUENCY      = 3e6;
WAVELENGTH     = SPEED_OF_LIGHT / FREQUENCY;
INCREASE_FACTOR = 0;

%% define parameters of the parabolic antenna
CORRELATION_LENGTH = 4 * WAVELENGTH;
RADIUS = 10 * CORRELATION_LENGTH;
FRAUNHOFER_DISTANCE = 2 * (2*RADIUS)^2 / WAVELENGTH;

GRID_LENGTH = 16 * RADIUS;
SAMPLING_POINT_X = 2^(ceil(log2(GRID_LENGTH / (WAVELENGTH / 2))));
SAMPLING_POINT_Y = SAMPLING_POINT_X;

fprintf("sampling point of x- and y- coordinates: %d \n", SAMPLING_POINT_X);

%% define Near-Field and Far-Field sampling grid
disp("define Near-Field and Far-Field sampling grid");
nfGrid = PlanarGrid(SAMPLING_POINT_X, SAMPLING_POINT_Y, GRID_LENGTH, GRID_LENGTH);
ffGrid = AngularGrid(0.001);

%% compute ideal case for reference
% generate near-field data
rmsError = 0;
aut = ImperfectParabolicReflector(WAVELENGTH,         ...
                                  RADIUS,             ...
                                  rmsError,           ...
                                  CORRELATION_LENGTH, ...
                                  nfGrid);

aut = getNearField(aut);

farField = NearFieldToFarField;

% apply nf2fft
FFT_SIZE_X = 2^(ceil(log2(SAMPLING_POINT_X)) + INCREASE_FACTOR);
FFT_SIZE_Y = FFT_SIZE_X;

farField = setUp(farField, aut.nearField, ffGrid, WAVELENGTH, 10*FRAUNHOFER_DISTANCE, FFT_SIZE_X, FFT_SIZE_Y);

farField = nf2fft(farField, "normal");
% displaySpectrum(farField);
% displayInterpSpectrum(farField);
% displayDirectivity(farField);
directivityIdeal = max(farField.directivityX.y(:));
directivityIdeal_dBi = 10 .* log10(directivityIdeal);

directivityTheory = 4*pi*(pi*RADIUS^2) / WAVELENGTH^2;
directivityTheory_dBi = 10*log10(directivityTheory);

fprintf("theoretical gain is %f dBi, ideal computed gain is %f dBi \n", directivityTheory_dBi, directivityIdeal_dBi);

%% erroneous case
% define loop index
ERROR_RATIO_COUNT = 10;
LOOP_COUNT        = 10;
directivityError_dBi = zeros(LOOP_COUNT, ERROR_RATIO_COUNT);

for m = 1 : ERROR_RATIO_COUNT
    for n = 1 : LOOP_COUNT
        rmsError = m * 0.01 * WAVELENGTH;
        aut = ImperfectParabolicReflector(WAVELENGTH,         ...
                                          RADIUS,             ...
                                          rmsError,           ...
                                          CORRELATION_LENGTH, ...
                                          nfGrid);
        
        aut = getNearField(aut);

        farField = setUp(farField, aut.nearField, ffGrid, WAVELENGTH, 10*FRAUNHOFER_DISTANCE, FFT_SIZE_X, FFT_SIZE_Y);
        farField = nf2fft(farField, "normal");
        directivityError = max(farField.directivityX.y(:));
        directivityError_dBi(n,m) = 10*log10(directivityError);
        fprintf("errorIndex = %d, loopIndex = %d, directivity=%f\n", m, n, directivityError_dBi(n,m));
    end
end

difference = directivityIdeal_dBi - directivityError_dBi;

x = mean(log(difference))';
X = [ones(ERROR_RATIO_COUNT, 1), x];
y = log((1:ERROR_RATIO_COUNT)' .* 0.01);
coefficient = X\y;
yRegression = X*coefficient;

linearRegression = figure();
scatter(x,y, 50, "filled");
hold on;
plot(x, yRegression, LineWidth=2);
hold off;

xlabel("x = ln( reduction / dBi )");
ylabel("y = ln(\epsilon / \lambda)");
title("Linear Regression");
txt = sprintf("y = %f x + %f", coefficient(2), coefficient(1));
text(-1, -4.5, txt);

fontsize(20,"points");