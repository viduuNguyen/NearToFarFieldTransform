% clean up the environment
clc
clear all;
close all;
format long;

% Pre-defined constants and options
speedOfLight = 299792458;
operatingFrequency = 10e9;
wavelength = speedOfLight / operatingFrequency;

% Parameters of the open-ended rectangular waveguide
guideHeight = 10.16e-3; % Height of the waveguide
guideWidth = 22.86e-3;  % Width of the waveguide

% Design the rectangular waveguide at the operating frequency
rectangularWaveguide = design(waveguide, operatingFrequency);
rectangularWaveguide.Width = guideWidth;
rectangularWaveguide.Height = guideHeight;
rectangularWaveguide.Tilt = [+90, 180];  % Tilt to face the horn antenna
rectangularWaveguide.TiltAxis = [0 1 0; 0 0 1];

% Display the rectangular waveguide
figure();
show(rectangularWaveguide);
title('Open-ended Rectangular Waveguide');

% Parameters of the horn antenna
flareHeight = 50e-3;
flareWidth = 75e-3;
flareLength = 130e-3;

% Design the horn antenna at the operating frequency
hornAntenna = design(horn, operatingFrequency);
hornAntenna.Height = guideHeight;
hornAntenna.Width = guideWidth;
hornAntenna.FlareLength = flareLength;
hornAntenna.FlareWidth = flareWidth;
hornAntenna.FlareHeight = flareHeight;
hornAntenna.Tilt = [-90, 180];  % Tilt to face the waveguide
hornAntenna.TiltAxis = [0 1 0; 0 0 1];

% Add a load to the horn antenna
load = lumpedElement("Impedance", 50);
hornAntenna.Load = load;

% Calculate the distances for placement
fresnelDistance = 0.62 * sqrt(flareWidth^3 / wavelength);
fraunhoferDistance = 2 * (flareWidth)^2 / wavelength;
scanningDistance = 0.5 * hornAntenna.Length + flareLength + 3 * wavelength;

% Create the conformal array system with the horn and waveguide
system = conformalArray("Element", {hornAntenna, rectangularWaveguide}, ...
                        "ElementPosition", [0 0 0; 0 0 scanningDistance]);

% Display the antenna system
figure();
show(system);
title('Antenna System with Horn and Waveguide');

% Calculate S-parameters
scatteringParameters = sparameters(system, operatingFrequency, 50);

% Display the S-parameters
disp('S-parameters:');
disp(scatteringParameters.Parameters);

% Plot S-parameters
figure;
rfplot(scatteringParameters);
title('S-parameters of the Antenna System');
