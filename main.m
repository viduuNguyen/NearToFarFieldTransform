% reference:
% [1] https://uk.mathworks.com/matlabcentral/fileexchange/23385-nf2ff
% [2] https://uk.mathworks.com/matlabcentral/fileexchange/27876-near-field-to-far-field-transformation?s_tid=FX_rc2_behav
% [3] http://www.mysimlabs.com/matlab/surfgen/rsgeng2D.m


%% clean up the environment
clc
clear all;
close all;
format long;

%% pre-defined constants and options
speedOfLight = 299792458;
operatingFrequency = 1.3e9;
wavelength = speedOfLight / operatingFrequency;
increaseFactor = 2;
samplingPointX = 256;
samplingPointY = 256;
farFieldGrid = AngularGrid(0.002, 0.002);
GENERATE_AUT_DATA = 1;
farField = NearFieldToFarField;
fileNameX = "";
fileNameY = "";

%% parameters of the parabolic antenna
radius = 1.8; 
focalLengthOverDiameter = 0.4;
focalLength = focalLengthOverDiameter*2*radius;

%% 1. generate near-field data or parse the data files

if GENERATE_AUT_DATA == 1
    % define near-field scanning grid
    nearFieldGrid = PlanarGrid(samplingPointX, samplingPointY, 16*radius, 16*radius);

    % define parabolic antenna and relevant quantities
    ant = reflectorParabolic("Radius", radius, "FocalLength", focalLength);
    antennaDepth = focalLength - (4*focalLength^2 - radius^2) / (4*focalLength);
    fresnelDistance = 0.62 * sqrt(8*radius^3 / wavelength);
    fraunhoferDistance = 2*(2*radius)^2/wavelength;
    scanningDistance = antennaDepth + fresnelDistance;
    
    % generate near-field components
    aut = AutField(ant, operatingFrequency, nearFieldGrid, farFieldGrid, scanningDistance);
    [nearFieldX, nearFieldY, ~] = aut.getNearField();
    [xDirectivityX_dBi, xDirectivityY_dBi] = aut.getDirectivity_dBi();

    % plot near-field components
    plotNearField(nearFieldGrid, nearFieldX, nearFieldY);

else
    [nearFieldX, nearFieldY, nearFieldGrid] = farField.parseNearFieldFiles(fileNameX, fileNameY);
    % plot near-field components
    plotNearField(nearFieldGrid, nearFieldX, nearFieldY);
end

%% 2. implement near-field to far-field transformation
% 2a. increase the resolution of the FFT by adding more sampling points
fftSizeX = 2^(ceil(log2(nearFieldGrid.pointX)) + increaseFactor);
fftSizeY = 2^(ceil(log2(nearFieldGrid.pointY)) + increaseFactor);

% 2b. perform near-field to far-field transformation
farField = farField.setUp(nearFieldGrid, farFieldGrid, wavelength, 10 * fraunhoferDistance, fftSizeX, fftSizeY);

[farFieldTheta, farFieldPhi] = farField.nf2fft(nearFieldX, nearFieldY);

% 2c. compute the directivity in co-polar and cross-polar plane
[directivityX_dBi, directivityY_dBi] = farField.getDirectivity_dBi(farFieldTheta, farFieldPhi);

% plot the antenna's pattern

if GENERATE_AUT_DATA == 0
    plotPattern(farFieldGrid, directivityX_dBi, directivityY_dBi);
else 
    plotPattern(farFieldGrid, directivityX_dBi, directivityY_dBi, xDirectivityX_dBi, xDirectivityY_dBi);
end

%% functions

function plotPattern(farFieldgrid, directivityNfffV, directivityNfffH, directivityMatlabV, directivityMatlabH)

    % define the necessary values
    elevation = 180/pi*farFieldgrid.theta(:,1);
    minDirectivityNfff = min(directivityNfffV);
    maxDirectivityNfff = max(directivityNfffV);
    minDirectivityMatlab = min(directivityNfffV);
    maxDirectivityMatlab = max(directivityNfffV);

    figure();
    if nargin == 3
        % compare the directivity of the antenna in two slicing plane (phi=0 and phi=pi/2) by NF2FFT
        plot(elevation, directivityNfffV, elevation, directivityNfffH);
        set(gca,'XLim',[-90 90]);
        set(gca,'YLim',[minDirectivityNfff - 5, maxDirectivityNfff + 5]);
        xlabel('\theta (Deg)');
        ylabel(sprintf('Directivity, Dmax = %4.2f dBi', maxDirectivityNfff));
        title("2D-Slice Pattern of the antenna by NF2FFT");
        grid;
        legend('phi = 0 Deg', 'phi = 90 Deg');
    end
    

    if nargin > 3
        % compare the directivity of the antenna in two slicing plane (phi=0 and phi=pi/2) by NF2FFT
        directivityNfffPlot = subplot(2,2,1);
        plot(directivityNfffPlot, elevation, directivityNfffV, elevation, directivityNfffH);
        ylabel(sprintf('Directivity, Dmax = %4.2f dBi', maxDirectivityNfff));
        ylim(directivityNfffPlot, [minDirectivityNfff - 5, maxDirectivityNfff + 5]);
        title("2D-Slice Pattern of the antenna by NF2FFT");
        grid;
        legend('phi = 0 Deg', 'phi = 90 Deg');

        % compare the directivity of the antenna in two slicing plane (phi=0 and phi=pi/2) by MATLAB antenna toolbox
        directivityMatlabPlot = subplot(2,2,2);
        plot(directivityMatlabPlot, elevation, directivityMatlabV, elevation, directivityMatlabH);
        ylabel(sprintf('Directivity, Dmax = %4.2f dBi', maxDirectivityMatlab));
        ylim(directivityMatlabPlot, [minDirectivityMatlab - 5, maxDirectivityMatlab + 5]);
        title("2D-Slice Pattern of the antenna by MATLAB antenna toolbox");
        grid;
        legend('phi = 0^{\circ}', 'phi = 90^{\circ}');
    
        % compare the directivity of the antenna in elevation cut (phi=0) by NF2FFT and by MATLAB antenna toolbox
        directivityVPlot = subplot(2,2,3);
        plot(directivityVPlot, elevation, directivityNfffV, elevation, directivityMatlabV);
        ylabel(sprintf('Directivity, Dmax = %4.2f dBi', maxDirectivityNfff));
        ylim(directivityVPlot, [minDirectivityNfff - 5, maxDirectivityNfff + 5]);
        title("Pattern of the antenna in the phi = 0^{\circ} plane");
        grid;
        legend('NF2FFT', 'MATLAB antenna toolbox');

        % compare the directivity of the antenna in sliding plane (phi=pi/2) by NF2FFT and by MATLAB antenna toolbox
        directivityHPlot = subplot(2,2,4);
        plot(directivityHPlot, elevation, directivityNfffH, elevation, directivityMatlabH);
        ylabel(sprintf('Directivity, Dmax = %4.2f dBi', maxDirectivityMatlab));
        ylim(directivityHPlot, [minDirectivityMatlab - 5, maxDirectivityMatlab + 5]);
        title("Pattern of the antenna in the phi = 90^{\circ} plane");
        grid;
        legend('NF2FFT', 'MATLAB antenna toolbox');
        
        % configure label and limit of the X-axis
        xlabel([directivityNfffPlot, directivityMatlabPlot, directivityVPlot, directivityHPlot],'\theta (^{\circ})');
        xlim([directivityNfffPlot, directivityMatlabPlot, directivityVPlot, directivityHPlot],[-90 90]);

    end
end
