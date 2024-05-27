% reference:
% [1] https://uk.mathworks.com/matlabcentral/fileexchange/23385-nf2ff
% [2] https://uk.mathworks.com/matlabcentral/fileexchange/27876-near-field-to-far-field-transformation?s_tid=FX_rc2_behav
% [3] http://www.mysimlabs.com/matlab/surfgen/rsgeng2D.m


%% clean up the environment
clc
clear all;
close all;
format long;

%% Define constants
disp("Define constants");
SPEED_OF_LIGHT       = 299792458;
FREQUENCY_PARABOLIC  = 10e9;
WAVELENGTH_PARABOLIC = SPEED_OF_LIGHT / FREQUENCY_PARABOLIC;

% farFieldGrid = AngularGrid(0.002, 0.002);
% 
% farField = NearFieldToFarField;
% fileNameX = "";
% fileNameY = "";

%% parameters of the parabolic antenna
disp("Define parameters of the parabolic antenna");
RADIUS = 1.8;
F_D_RATIO = 0.4;
FOCAL_LENGTH = F_D_RATIO * 2 * RADIUS;
ANTENNA_DEPTH = FOCAL_LENGTH - (4*FOCAL_LENGTH^2 - RADIUS^2) / (4*FOCAL_LENGTH);
FRESNEL_DISTANCE = 0.62 * sqrt(8*RADIUS^3 / WAVELENGTH);
FRAUNHOFER_DISTANCE = 2 * (2*RADIUS)^2 / WAVELENGTH;
SCANNING_DISTANCE = ANTENNA_DEPTH + FRESNEL_DISTANCE;
SAMPLING_POINT_X = 256;
SAMPLING_POINT_Y = 256;

%% parabolic antenna design
parabolicAntenna = design(reflectorParabolic, FREQUENCY_PARABOLIC);
parabolicAntenna.Radius = RADIUS;
parabolicAntenna.FocalLength = FOCAL_LENGTH;

%% Near-Field and Far-Field sampling grid points
ffGrid = AngularGrid(0.002);
nnGrid = PlanarGrid(SAMPLING_POINT_X, SAMPLING_POINT_Y, 16*RADIUS, 16*RADIUS);

% %% parameters of the open-ended rectangular waveguide
% % standard: WR-90
% guideWidth = 22.86e-3;
% guideHeight = 10.16e-3;
% 
% 
% %% parameters of the horn antenna
% % type:  PM7320x
% flareLength = 130e-3;
% flareWidth = 75e-3;
% flareHeight = 50e-3;

%% generate near-field data and display corresponding quantities
disp("Generate Near-Field data using AutField");
nf = AutField(parabolicAntenna,FREQUENCY_PARABOLIC,nnGrid, ffGrid, SCANNING_DISTANCE);
displayDirectivity(nf);
displayNearField(nf);

%% implement near-field to far-field transformation
disp("Implement NF2FFT using NearFieldToFarField");
INCREASE_FACTOR = 2;
FFT_SIZE_X = 2^(ceil(log2(SAMPLING_POINT_X)) + INCREASE_FACTOR);
FFT_SIZE_Y = 2^(ceil(log2(SAMPLING_POINT_Y)) + INCREASE_FACTOR);
nf2ff = NearFieldToFarField();
nf2ff = setUp(nf2ff, nf.nearField, ffGrid, WAVELENGTH, 10*FRAUNHOFER_DISTANCE, FFT_SIZE_X, FFT_SIZE_Y);
nf2ff = nf2fft(nf2ff);
displaySpectrum(nf2ff);
displayInterpSpectrum(nf2ff);
displayFarField(nf2ff);
displayDirectivity(nf2ff);

%% 1. generate near-field data or parse the data files

if GENERATE_AUT_DATA == 1
    % begin::define parabolic antenna and relevant quantities
%     parabolicAntenna = design(reflectorParabolic, operatingFrequency);
%     parabolicAntenna.Radius = radius;
%     parabolicAntenna.FocalLength = focalLength;
%     antennaDepth = focalLength - (4*focalLength^2 - radius^2) / (4*focalLength);
%     fresnelDistance = 0.62 * sqrt(8*radius^3 / wavelength);
%     fraunhoferDistance = 2*(2*radius)^2/wavelength;
%     scanningDistance = antennaDepth + fresnelDistance;
%     scanningDistance = antennaDepth + 40*wavelength;
%     nearFieldGrid = PlanarGrid(samplingPointX, samplingPointY, 16*radius, 16*radius);
    % end::define parabolic antenna and relevant quantities

    % begin::define horn antenna and relevant quantities
    hornAntenna = design(horn, operatingFrequency);
    hornAntenna.Height = guideHeight;
    hornAntenna.Width = guideWidth;
    hornAntenna.FlareLength = flareLength;
    hornAntenna.FlareWidth = flareWidth;
    hornAntenna.FlareHeight = flareHeight;
    hornAntenna.Tilt = [-90, 180];
    hornAntenna.TiltAxis = [0 1 0; 0 0 1];
    fresnelDistance = 0.62 * sqrt(flareWidth^3 / wavelength);
    fraunhoferDistance = 2 * (flareWidth)^2 / wavelength;
    scanningDistance = 0.5*hornAntenna.Length + flareLength + 5*fresnelDistance;
    nearFieldGrid = PlanarGrid(samplingPointX, samplingPointY, 1.9*4, 1.9*4);
    show(hornAntenna);
    % end::define horn antenna

    % generate near-field components
    aut = AutField(hornAntenna, operatingFrequency, nearFieldGrid, farFieldGrid, scanningDistance);
    [nearFieldX, nearFieldY] = aut.getNearField();
    [xDirectivityX_dBi, xDirectivityY_dBi] = aut.getDirectivity_dBi();

    % plot near-field components
    [fieldFigure, verticalFieldPlot, horizontalFieldPlot] = plotPolarisation(nearFieldGrid.x, nearFieldGrid.y, nearFieldX, nearFieldY);

else
    [nearFieldX, nearFieldY, nearFieldGrid] = farField.parseNearFieldFiles(fileNameX, fileNameY);
    % plot near-field components
    [fieldFigure, verticalFieldPlot, horizontalFieldPlot] = plotPolarisation(nearFieldGrid.x, nearFieldGrid.y, nearFieldX, nearFieldY);
end

set(fieldFigure, "Name", "vertical and horizontal polarisation of electrical Near-Field at the scanning plane");
xlabel([verticalFieldPlot, horizontalFieldPlot], "x(m)");
ylabel([verticalFieldPlot, horizontalFieldPlot], "y(m)");
zlabel(verticalFieldPlot, "E_x (dB)");
zlabel(horizontalFieldPlot, "E_y(dB)");
title(verticalFieldPlot, "vertical polarisation");
title(horizontalFieldPlot, "horizontal polarisation");

%% 2. implement near-field to far-field transformation
% 2a. increase the resolution of the FFT by adding more sampling points
fftSizeX = 2^(ceil(log2(nearFieldGrid.pointX)) + increaseFactor);
fftSizeY = 2^(ceil(log2(nearFieldGrid.pointY)) + increaseFactor);

% 2b. perform near-field to far-field transformation
farField = farField.setUp(nearFieldGrid, farFieldGrid, wavelength, 10 * fraunhoferDistance, fftSizeX, fftSizeY);

% begin::compute near-field to far-field and plot wave-number components
% if wave-number components are not necessary, nf2fft is a shortcut
% [spectrumX, spectrumY, ~] = farField.getSpectrum(nearFieldX, nearFieldY);
% [farFieldTheta, farFieldPhi] = farField.getFarFieldFromSpectrum(spectrumX, spectrumY);
% 
% [waveNumberYGrid, waveNumberXGrid] = meshgrid(farField.waveNumberY, farField.waveNumberX);
% [spectrumFigure, verticalSpectrumPlot, horizontalSpectrumPlot] = plotPolarisation(waveNumberXGrid, waveNumberYGrid, spectrumX, spectrumY);
% 
% set(spectrumFigure, "Name", "vertical and horizontal polarisation of wave-number components at the scanning plane");
% xlabel([verticalSpectrumPlot, horizontalSpectrumPlot], "k_x(m^{-1})");
% ylabel([verticalSpectrumPlot, horizontalSpectrumPlot], "k_y(m^{-1})");
% zlabel(verticalSpectrumPlot, "f_x (dB)");
% zlabel(horizontalSpectrumPlot, "f_y(dB)");
% title(verticalSpectrumPlot, "vertical polarisation");
% title(horizontalSpectrumPlot, "horizontal polarisation");
% end::compute near-field to far-field and plot wave-number components

% if wave-number components are not necessary, nf2fft is a shortcut
farField = farField.nf2fft(nearFieldX, nearFieldY);

% get quantities of the radiation
[waveNumberX, waveNumberY] = farField.getWaveNumberComponent();
[spectrumX, spectrumY] = farField.getSpectrum();
[interpSpectrumX, interpSpectrumY] = farField.getInterpolatedSpectrum();

[farFieldTheta, farFieldPhi] = farField.getFarField();
[directivityX_dBi, directivityY_dBi] = farField.getDirectivity_dBi(farFieldTheta, farFieldPhi);

% plot the spectrum components and compare the pattern from NF2FFT and MATLAB antenna toolbox

[waveNumberYGrid, waveNumberXGrid] = meshgrid(farField.waveNumberY, farField.waveNumberX);
[spectrumFigure, verticalSpectrumPlot, horizontalSpectrumPlot] = plotPolarisation(waveNumberXGrid, waveNumberYGrid, spectrumX, spectrumY);

set(spectrumFigure, "Name", "vertical and horizontal polarisation of wave-number components at the scanning plane");
xlabel([verticalSpectrumPlot, horizontalSpectrumPlot], "k_x(m^{-1})");
ylabel([verticalSpectrumPlot, horizontalSpectrumPlot], "k_y(m^{-1})");
zlabel(verticalSpectrumPlot, "f_x (dB)");
zlabel(horizontalSpectrumPlot, "f_y(dB)");
title(verticalSpectrumPlot, "vertical polarisation");
title(horizontalSpectrumPlot, "horizontal polarisation");

[interpSpectrumFigure, verticalInterpSpectrumPlot, horizontalInterpSpectrumPlot] = plotPolarisation(Xq, Yq, interpSpectrumX, interpSpectrumY);

set(interpSpectrumFigure, "Name", "vertical and horizontal polarisation of wave-number components after interpolation at the scanning plane");
xlabel([verticalInterpSpectrumPlot, horizontalInterpSpectrumPlot], "k_x(m^{-1})");
ylabel([verticalInterpSpectrumPlot, horizontalInterpSpectrumPlot], "k_y(m^{-1})");
zlabel(verticalInterpSpectrumPlot, "f_x (dB)");
zlabel(horizontalInterpSpectrumPlot, "f_y(dB)");
title(verticalInterpSpectrumPlot, "vertical polarisation");
title(horizontalInterpSpectrumPlot, "horizontal polarisation");

if GENERATE_AUT_DATA == 0
    comparePattern(farFieldGrid, directivityX_dBi, directivityY_dBi);
else 
    comparePattern(farFieldGrid, directivityX_dBi, directivityY_dBi, xDirectivityX_dBi, xDirectivityY_dBi);
end

%% functions

function comparePattern(farFieldgrid, directivityNfffV, directivityNfffH, directivityMatlabV, directivityMatlabH)

    % define set of elevation from -90 to 90 degree
    elevation = 180/pi*farFieldgrid.theta(:,1);

    figure();
    if nargin == 3 % no input from MATLAB antenna toolbox
        % compare the directivity of the antenna in two slicing plane (phi=0 and phi=pi/2) by NF2FFT
        directivityNfffPlot = axis;
        plotXY(directivityNfffPlot, elevation, directivityNfffV, directivityNfffH);
        xlabel('\theta ^{\circ}');
        ylabel(sprintf('Directivity, Dmax (NFFF) = %4.2f dBi', max(directivityNfffV)));
        title("2D-Slice Pattern of the antenna by NF2FFT");
        legend('phi = 0^{\circ}', 'phi = 90^{\circ}');
    end

    if nargin == 5
        % compare the directivity of the antenna in two slicing plane (phi=0 and phi=pi/2) by NF2FFT
        directivityNfffPlot = subplot(2,2,1);
        plotXY(directivityNfffPlot, elevation, directivityNfffV, directivityNfffH);
        ylabel(sprintf('Directivity, Dmax (NFFF) = %4.2f dBi', max(directivityNfffV)));
        title("2D-Slice Pattern of the antenna by NF2FFT");
        legend('phi = 0^{\circ}', 'phi = 90^{\circ}');

        % compare the directivity of the antenna in two slicing plane (phi=0 and phi=pi/2) by MATLAB antenna toolbox
        directivityMatlabPlot = subplot(2,2,2);
        plotXY(directivityMatlabPlot, elevation, directivityMatlabV, directivityMatlabH);
        ylabel(sprintf('Directivity, Dmax (MATLAB) = %4.2f dBi', max(directivityMatlabV)));
        title("2D-Slice Pattern of the antenna by MATLAB antenna toolbox");
        legend('phi = 0^{\circ}', 'phi = 90^{\circ}');
    
        % compare the directivity of the antenna in elevation cut (phi=0) by NF2FFT and by MATLAB antenna toolbox
        directivityVPlot = subplot(2,2,3);
        plotXY(directivityVPlot, elevation, directivityNfffV, directivityMatlabV);
        ylabel(sprintf('Directivity, Dmax (NFFF) = %4.2f dBi', max(directivityNfffV)));
        title("Pattern of the antenna in the phi = 0^{\circ} plane");
        legend('NF2FFT', 'MATLAB antenna toolbox');

        % compare the directivity of the antenna in sliding plane (phi=pi/2) by NF2FFT and by MATLAB antenna toolbox
        directivityHPlot = subplot(2,2,4);
        plotXY(directivityHPlot, elevation, directivityNfffH, directivityMatlabH);
        ylabel(sprintf('Directivity, Dmax (NFFF) = %4.2f dBi', max(directivityNfffH)));
        title("Pattern of the antenna in the phi = 90^{\circ} plane");
        legend('NF2FFT', 'MATLAB antenna toolbox');
        
        % configure label and limit of the X-axis
        xlabel([directivityNfffPlot, directivityMatlabPlot, directivityVPlot, directivityHPlot],'\theta ^{\circ}');
    end
end

function plotXY(plt, X, Y1, Y2)
    %% descripttion
    % plt:  axis instance
    % X:    set of values in X-axis
    % Y1:   set of values in Y-axis of the first curve
    % Y2:   set of values in Y-axis of the second curve
    
    if nargin == 3
        minY = min(Y1);
        maxY = max(Y1);
        plot(plt, X, Y1);
    elseif nargin == 4
        minY = min(min(Y1), min(Y2));
        maxY = max(max(Y1), max(Y2));
        plot(plt, X, Y1, X, Y2);
    end
    % set limit of the Y-axis with a variance of 5
    ylim(plt, [minY - 5, maxY + 5]);
    grid;
end
