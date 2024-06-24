%% clean up the environment
clc; clear variables; close all; format long;

%% define constants
disp("define constants");
SPEED_OF_LIGHT = 299792458;
FREQUENCY = 10e9;
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
FRAUNHOFER_DISTANCE = 2 * (FLARE_WIDTH)^2 / WAVELENGTH;
% scanning distance is measured from the aperture of the antenna
SCANNING_DISTANCE   = hornAnt.Length/2 + FLARE_LENGTH + 13e-2;

%% define near-field and far-field scanning grids
disp("define scanning grids");
SAMPLING_POINT_X = 32;
SAMPLING_POINT_Y = SAMPLING_POINT_X;
LENGTH_X         = SAMPLING_POINT_X * 1.5e-2;
LENGTH_Y         = LENGTH_X;
INCREASE_FACTOR  = 0;

nfGrid = PlanarGrid(SAMPLING_POINT_X, SAMPLING_POINT_Y, LENGTH_X, LENGTH_Y);
ffGrid = AngularGrid(0.005);

%% generate near-field data
disp("generate near-field data using AutField");
hornAntField = AutField(hornAnt, FREQUENCY, nfGrid, ffGrid, SCANNING_DISTANCE);

displayNearField(hornAntField, [30, 60]);
displayNearFieldPhase(hornAntField);

load("../Result/NF2FF/lab/coPolar_32.mat");
xGrid = xCor'/100;
yGrid = yCor'/100;
magnitudeX_dB = mag;
magnitudeX = 10.^(magnitudeX_dB / 20);
phaseX = phase;
clear("xCor", "yCor", "mag", "phase");
load("../Result/NF2FF/lab/crossPolar_32.mat");
magnitudeY_dB = mag;
magnitudeY = 10.^(magnitudeY_dB / 20);
% magnitudeY = zeros(32,32);
phaseY = phase;

phasorX = magnitudeX .* exp(1j * deg2rad(phaseX));
phasorY = magnitudeY .* exp(1j * deg2rad(phaseY));
disp("implement nf2fft using Main");

main = Main();

main.xGrid = xGrid;
main.yGrid = yGrid;
main.phasorX = phasorX;
main.phasorY = phasorY;
main.frequency = FREQUENCY;

main = main.Transform();

result_comparison = figure(Name="Horn antenna - 32x32 scanning grid with half-wavelength scanning space");
ax(1) = subplot(1,2,1);
VectorQuantity.multiplePlot([hornAntField.directivityX, main.corrDirectivityX, main.directivityX], ax(1));
legend(ax(1), "MATLAB", "NF2FFT With Probe Correction", "Nf2FF Without Probe Correction", Location="south");
title(ax(1), "XZ plane");
ax(2) = subplot(1,2,2);
VectorQuantity.multiplePlot([hornAntField.directivityY, main.corrDirectivityY, main.directivityY], ax(2));
legend(ax(2), "MATLAB", "NF2FFT With Probe Correction", "Nf2FF Without Probe Correction", Location="south");
title(ax(2), "YZ plane");
