clc;
clear all;
close all;

%------------------------------------------%
disp("test MeshgridQuantity");
[x,y] = meshgrid(-2:0.25:2, -2:0.25:2);
X = x .* exp(x.^2 + y.^2);
Y = y .* exp(x.^2 - y.^2);
m = MeshgridQuantity(x,y,X,Y);
figure(Name="Test MeshgridQuantity");
mxAxis = subplot(1,2,1);
myAxis = subplot(1,2,2);
surface(m, mxAxis, myAxis, scale="20log");
title(mxAxis, "X");
title(myAxis, "Y");

%------------------------------------------%
disp("test VectorQuantity");
theta = 0:0.01:2*pi;
speed1 = sin(theta) + cos(2*theta);
speed2 = cos(theta);

v1 = VectorQuantity(theta, speed1);
v2 = VectorQuantity(theta, speed2);
figure(Name="Test VectorQuantity - singlePlot");
v1Axis = subplot(1,2,1);
v2Axis = subplot(1,2,2);
title(v1Axis, "speed1 [angle]");
title(v1Axis, "speed2 [angle]");
singlePlot(v1, v1Axis);
singlePlot(v2, v2Axis);

figure(Name="Test VectorQuantity - multiplePlot");
vAxis = subplot(1,1,1);
VectorQuantity.multiplePlot([v1, v2], vAxis, "10log");
legend(vAxis, "speed1", "speed2");
xlabel(vAxis, "theta");
ylabel(vAxis, "speed");

%------------------------------------------%
disp("test AngularGrid");
ffGrid = AngularGrid(0.002);
size(ffGrid.theta), size(ffGrid.phi)


%------------------------------------------%
disp("test PlanarGrid");
pg = PlanarGrid(64, 64, 0.3, 0.3);
size(pg.x), size(pg.y)

%------------------------------------------%
% parameter of the antenna
SPEED_OF_LIGHT = 299792458;
FREQUENCY = 1.3e9;
WAVELENGTH = SPEED_OF_LIGHT / FREQUENCY;
RADIUS = 1.8; 
F_D_RATIO = 0.4;
FOCAL_LENGTH = F_D_RATIO * 2 * RADIUS;
ANTENNA_DEPTH = FOCAL_LENGTH - (4*FOCAL_LENGTH^2 - RADIUS^2) / (4*FOCAL_LENGTH);
FRESNEL_DISTANCE = 0.62 * sqrt(8*RADIUS^3 / WAVELENGTH);
FRAUNHOFER_DISTANCE = 2 * (2*RADIUS)^2 / WAVELENGTH;
SCANNING_DISTANCE = ANTENNA_DEPTH + FRESNEL_DISTANCE;
SAMPLING_POINT_X = 256;
SAMPLING_POINT_Y = 256;
nfGrid = PlanarGrid(SAMPLING_POINT_X, SAMPLING_POINT_X, 16*RADIUS, 16*RADIUS);
parabolicAntenna = design(reflectorParabolic, FREQUENCY);
parabolicAntenna.Radius = RADIUS;
parabolicAntenna.FocalLength = FOCAL_LENGTH;

%------------------------------------------%
disp("test AuField");
nf = AutField(parabolicAntenna, FREQUENCY, nfGrid, ffGrid, SCANNING_DISTANCE);
displayDirectivity(nf);
displayNearField(nf);

%------------------------------------------%
FFT_SIZE_X = SAMPLING_POINT_X * 2;
FFT_SIZE_Y = SAMPLING_POINT_Y * 2;
disp("test NearFieldToFarField");
nf2ff = NearFieldToFarField;
nf2ff = setUp(nf2ff, nf.nearField, ffGrid, WAVELENGTH, 10*FRAUNHOFER_DISTANCE, FFT_SIZE_X, FFT_SIZE_Y);
nf2ff = nf2fft(nf2ff);
displaySpectrum(nf2ff);
displayInterpSpectrum(nf2ff);
displayFarField(nf2ff);
displayDirectivity(nf2ff);

%------------------------------------------%
disp("test OerwgField");
%% parameters of the open-ended rectangular waveguide
% standard: WR-90
GUIDE_WIDTH = 22.86e-3;
GUIDE_HEIGHT = 10.16e-3;

pa = OerwgField(GUIDE_WIDTH,            ...
                GUIDE_HEIGHT,           ...
                WAVELENGTH,             ...
                10*FRAUNHOFER_DISTANCE, ...
                ffGrid);
                      
pa = computeFarField(pa);
displayFarField(pa);
