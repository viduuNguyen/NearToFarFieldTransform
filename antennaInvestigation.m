%% clean up the environment
clc
clear all;
close all;
format long;

%% pre-defined constants and options
speedOfLight = 299792458;
operatingFrequency = 10e9;
wavelength = speedOfLight / operatingFrequency;
increaseFactor = 2;
samplingPointX = 64;
samplingPointY = 64;
farFieldGrid = AngularGrid(0.1, 0.1);

%% parameters of the open-ended rectangular waveguide
guideHeight = 10.16e-3; % 
guideWidth = 22.86e-3; %

rectangularWaveguide = design(waveguide, operatingFrequency);

rectangularWaveguide.Width = guideWidth;
rectangularWaveguide.Height = guideHeight;
rectangularWaveguide.Tilt = [-90, 180];
rectangularWaveguide.TiltAxis = [0 1 0; 0 0 1];

%% parameters of the horn antenna

flareHeight = 50e-3;
flareWidth = 75e-3;
flareLength = 130e-3;

hornAntenna = design(horn, operatingFrequency);
hornAntenna.Height = guideHeight;
hornAntenna.Width = guideWidth;
hornAntenna.FlareLength = flareLength;
hornAntenna.FlareWidth = flareWidth;
hornAntenna.FlareHeight = flareHeight;
hornAntenna.Tilt = [-90, 180];
hornAntenna.TiltAxis = [0 1 0; 0 0 1];

figure();
show(hornAntenna);
figure();
pattern(hornAntenna, operatingFrequency);
nearFieldGrid = PlanarGrid(64,64,0.05, 0.05);
field = AutField(hornAntenna, operatingFrequency, nearFieldGrid, farFieldGrid, hornAntenna.Length/2);
[nearFieldX, nearFieldY, ~] = field.getNearField();
[f, plotX, plotY] = plotNearField(nearFieldGrid, nearFieldX, nearFieldY);

% figure();
% show(rectangularWaveguide);
% figure();
% pattern(rectangularWaveguide, operatingFrequency);
% nearFieldGrid = PlanarGrid(64,64,0.05, 0.05);
% field = AutField(rectangularWaveguide, operatingFrequency, nearFieldGrid, farFieldGrid, rectangularWaveguide.Length/2);
% [nearFieldX, nearFieldY, ~] = field.getNearField();
% plotNearField(nearFieldGrid, nearFieldX, nearFieldY);

set(f, "Name", "2D-Slice Pattern of the antenna by NF2FFT");
xlabel([plotX, plotY], "x(m)");
ylabel([plotX, plotY], "y(m)");
zlabel(plotX, "E_x (dB)");
zlabel(plotY, "E_y(dB)");
title(plotX, "vertical polarisation");
title(plotY, "horizontal polarisation");
