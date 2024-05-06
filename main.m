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

function plotNearField(grid, nearFieldX, nearFieldY)
    % Define set 
    x_ = grid.x(:,1);
    y_ = grid.y(1,:);

    % plot the electric Near-Field components
    figure("Name","Electric Near-Field components at the scanning plane after parsing");
    subplot(121);
    surf(x_, y_, 20*log10(abs(nearFieldX)));
    xlabel("x (m)");
    ylabel("y (m)");
    zlabel("|E_x| (dB)");
    title("co-polarisation");
    set(gca,'XLim',[min(x_) max(x_)]);
    set(gca,'YLim',[min(y_) max(y_)]);
    shading flat;
    colorbar;

    subplot(122);
    surf(x_, y_, 20*log10(abs(nearFieldY)));
    xlabel("x (m)");
    ylabel("y (m)");
    zlabel("|E_y| (dB)");
    title("cross-polarisation");
    set(gca,'XLim',[min(x_) max(x_)]);
    set(gca,'YLim',[min(y_) max(y_)]);
    shading flat;
    colorbar;
end

function plotPattern(farFieldgrid, directivityCo, directivityCross, xDirectivityCo, xDirectivityCross)

    % define the range of the elevation from -pi/2 to pi/2
    elevation = 180/pi*farFieldgrid.theta(:,1);
    
    % compare the directivity of the antenna in two slicing plane (phi=0 and phi=pi/2) by NF2FFT
    figure("Name","Pattern of the antenna by NF2FFT");
    plot(elevation, directivityCo, elevation, directivityCross);
    xlabel('\theta (Deg)');
    ylabel(sprintf('Directivity, Dmax = %4.2f dBi', max(directivityCo)));
    set(gca,'XLim',[-50 50]);
    set(gca,'YLim',[-20 40]);
    grid;
    legend('co-planar ', 'cross-planar');

    if nargin > 3
        % compare the directivity of the antenna in two slicing plane (phi=0 and phi=pi/2) by MATLAB antenna toolbox
        figure("Name","Pattern of the antenna by MATLAB antenna toolbox");
        plot(elevation, xDirectivityCo, elevation, xDirectivityCross);
        xlabel('\theta (Deg)');
        ylabel(sprintf('Directivity, Dmax = %4.2f dBi', max(xDirectivityCo)));
        set(gca,'XLim',[-50 50]);
        set(gca,'YLim',[-20 40]);
        grid;
        legend('co-planar ', 'cross-planar');
    
        % compare the directivity of the antenna in elevation cut (phi=0) by NF2FFT and by MATLAB antenna toolbox
        figure("Name","Pattern of the antenna in co-planar slicing");
        plot(elevation, directivityCo, elevation, xDirectivityCo);
        xlabel('\theta (Deg)');
        ylabel(sprintf('Directivity, Dmax = %4.2f dBi', max(directivityCo)));
        set(gca,'XLim',[-50 50]);
        set(gca,'YLim',[-20 40]);
        grid;
        legend('NF2FFT', 'MATLAB antenna toolbox');

        % compare the directivity of the antenna in sliding plane (phi=pi/2) by NF2FFT and by MATLAB antenna toolbox
        figure("Name","Pattern of the antenna in cross-planar slicing");
        plot(elevation, directivityCross, elevation, xDirectivityCross);
        xlabel('\theta (Deg)');
        ylabel(sprintf('Directivity, Dmax = %4.2f dBi', max(directivityCo)));
        set(gca,'XLim',[-50 50]);
        set(gca,'YLim',[-20 40]);
        grid;
        legend('NF2FFT', 'MATLAB antenna toolbox');

    end
end
