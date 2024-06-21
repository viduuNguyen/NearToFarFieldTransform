% reference:
% [1] https://uk.mathworks.com/matlabcentral/fileexchange/23385-nf2ff
% [2] https://uk.mathworks.com/matlabcentral/fileexchange/27876-near-field-to-far-field-transformation?s_tid=FX_rc2_behav
% [3] http://www.mysimlabs.com/matlab/surfgen/rsgeng2D.m


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

%% define parameters of the parabolic antenna
disp("define parameters of the parabolic antenna");
RADIUS       = 1.8;
F_D_RATIO    = 0.4;
FOCAL_LENGTH = 2 * RADIUS * F_D_RATIO;

ANTENNA_DEPTH       = RADIUS^2 / (4 * FOCAL_LENGTH);
FRESNEL_DISTANCE    = 0.62 * sqrt(8*RADIUS^3 / WAVELENGTH); 
FRAUNHOFER_DISTANCE = 2 * (2 * RADIUS)^2 / WAVELENGTH;
SCANNING_DISTANCE   = ANTENNA_DEPTH + FRESNEL_DISTANCE;
% SCANNING_DISTANCE   = ANTENNA_DEPTH + 20*WAVELENGTH; 
disp("design the parabolic antenna with configuration");
parabolicAntenna             = design(reflectorParabolic, FREQUENCY);
parabolicAntenna.Radius      = RADIUS;
parabolicAntenna.FocalLength = FOCAL_LENGTH;

%% define near-field and far-field scanning grids
disp("define scanning grids");
SAMPLING_POINT_X = 256;
SAMPLING_POINT_Y = SAMPLING_POINT_X;
LENGTH_X         = 1 * SAMPLING_POINT_X * WAVELENGTH / 2;
LENGTH_Y         = LENGTH_X;
INCREASE_FACTOR  = 0;

ANGLE_OF_COVERAGE_DEGREE = atand((LENGTH_X/2) / (SCANNING_DISTANCE - ANTENNA_DEPTH));

fprintf("angle of coverage: %2.0f degree\n", ANGLE_OF_COVERAGE_DEGREE);

nfGrid = PlanarGrid(SAMPLING_POINT_X, SAMPLING_POINT_Y, LENGTH_X, LENGTH_Y);
ffGrid = AngularGrid(0.005);

%% generate near-field data
disp("generate near-field data using AutField");
nfObj = AutField(parabolicAntenna, FREQUENCY, nfGrid, ffGrid, SCANNING_DISTANCE);

%% implement near-field to far-field transformation 
FFT_SIZE_X = 2^(ceil(log2(SAMPLING_POINT_X)) + INCREASE_FACTOR);
FFT_SIZE_Y = 2^(ceil(log2(SAMPLING_POINT_Y)) + INCREASE_FACTOR);

disp("implement nf2fft using NearFieldToFarField");
nf2ffObj = NearFieldToFarField;
nf2ffObj = setUp(nf2ffObj, nfObj.nearField, ffGrid, WAVELENGTH, 10*FRAUNHOFER_DISTANCE, FFT_SIZE_X, FFT_SIZE_Y);
displayNearField(nf2ffObj, [90, 0]);
displayNearFieldPhase(nf2ffObj);
nf2ffObj = nf2fft(nf2ffObj, "normal");
% displaySpectrum(nf2ff);
[spectrumFig, ~] = displayInterpSpectrum(nf2ffObj, [90, 0]);
% displayDirectivity(nf2ff);

patternFig = figure(Name="Radiation pattern of parabolic antenna");
ax(1) = subplot(1,2,1);
VectorQuantity.multiplePlot([nfObj.directivityX, nf2ffObj.directivityX], ax(1));
legend(ax(1), "MATLAB", "NF2FFT", Location="south");
title(ax(1), "XZ plane");

ax(2) = subplot(1,2,2);
VectorQuantity.multiplePlot([nfObj.directivityY, nf2ffObj.directivityY], ax(2));
legend(ax(2), "MATLAB", "NF2FFT", Location="south");
title(ax(2), "YZ plane");

ylim(ax, [-10, 35]);
xlabel(ax, "elevation angle (degree)");
ylabel(ax, "directivity (dBi)");

