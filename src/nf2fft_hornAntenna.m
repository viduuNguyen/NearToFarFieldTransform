%% clean up the environment
clc
clear variables;
close all;
format long;

%% define constants
disp("define constants");
SPEED_OF_LIGHT = 299792458;
FREQUENCY = 12e9;
WAVELENGTH = SPEED_OF_LIGHT / FREQUENCY;

%% parameters of the open-ended rectangular waveguide
% standard: WR-90
disp("define horn antenna parameters");
GUIDE_HEIGHT = 10.16e-3;
GUIDE_WIDTH  = 22.86e-3;

%% parameters of the horn antenna
% type:  PM7320x
FLARE_LENGTH = 130e-3;
FLARE_WIDTH  = 75e-3;
FLARE_HEIGHT = 50e-3;

%% design horn antenna
disp("design horn antenna");
hornAnt             = design(horn, FREQUENCY);
hornAnt.Height      = GUIDE_HEIGHT;
hornAnt.Width       = GUIDE_WIDTH;
hornAnt.FlareLength = FLARE_LENGTH;
hornAnt.FlareWidth  = FLARE_WIDTH;
hornAnt.FlareHeight = FLARE_HEIGHT;
hornAnt.Tilt        = [-90, 180];
hornAnt.TiltAxis    = [0 1 0; 0 0 1];

% FRESNEL_DISTANCE    = 0.62 * sqrt(FLARE_WIDTH^3 / WAVELENGTH);
SCANNING_DISTANCE   = 13e-2;
FRAUNHOFER_DISTANCE = 2 * (FLARE_WIDTH)^2 / WAVELENGTH;
% SCANNING_DISTANCE   = hornAnt.Length/2 + FLARE_LENGTH + FRESNEL_DISTANCE;

%% define near-field and far-field scanning grids
disp("define scanning grids");
SAMPLING_POINT_X    = 32;
SAMPLING_POINT_Y    = SAMPLING_POINT_X;
INCREASE_FACTOR     = 0;
LENGTH_X            = 1.24e-2 * SAMPLING_POINT_X;
LENGTH_Y            = LENGTH_X;

nfGrid = PlanarGrid(SAMPLING_POINT_X, SAMPLING_POINT_Y, LENGTH_X, LENGTH_Y);
ffGrid = AngularGrid(0.005);

%% generate near-field data
disp("generate near-field data using AutField");
hornAntField = AutField(hornAnt, FREQUENCY, nfGrid, ffGrid, SCANNING_DISTANCE);

nf2ffObj = NearFieldToFarField;

nearField = parseNearFieldWorkspace(nf2ffObj, nfGrid.x, nfGrid.y, hornAntField.nearField.X, hornAntField.nearField.Y);

%% implement near-field to far-field transformation 
FFT_SIZE_X = 2^(ceil(log2(SAMPLING_POINT_X)) + INCREASE_FACTOR);
FFT_SIZE_Y = FFT_SIZE_X;

nf2ffObj = setUp(nf2ffObj, nearField, ffGrid, WAVELENGTH, 10*FRAUNHOFER_DISTANCE, FFT_SIZE_X, FFT_SIZE_Y);
displayNearField(nf2ffObj, [90, 0]);
displayNearFieldPhase(nf2ffObj);

disp("implement nf2fft using NearFieldToFarField");
nf2ffObj = nf2fft(nf2ffObj, "normal");
displayInterpSpectrum(nf2ffObj, [90, 0]);

comparison_result = figure(Name="Horn antenna - 32x32 scanning grid with half-wavelength scanning space");
ax(1) = subplot(1,2,1);
VectorQuantity.multiplePlot([hornAntField.directivityX, nf2ffObj.directivityX], ax(1));
legend(ax(1), "MATLAB", "NF2FFT", Location="south");
title(ax(1), "XZ plane");
ax(2) = subplot(1,2,2);
VectorQuantity.multiplePlot([hornAntField.directivityY, nf2ffObj.directivityY], ax(2));
legend(ax(2), "MATLAB", "NF2FFT", Location="south");
title(ax(2), "YZ plane");

ylim(ax, [-35, 35]);
xlim(ax, [0, 180]);
xlabel(ax, "elevation angle (degree)");
ylabel(ax, "Radiation pattern (dBi)");