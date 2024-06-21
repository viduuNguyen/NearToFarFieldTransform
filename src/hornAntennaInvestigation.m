% clean up the environment
clc; clear variables; close all; format long;

% Pre-defined constants and options
disp("define constants");
SPEED_OF_LIGHT = 299792458;
FREQUENCY      = 10e9;
WAVELENGTH     = SPEED_OF_LIGHT / FREQUENCY; 

% Parameters of the open-ended rectangular waveguide
disp("define parameters of the oerwg");
GUIDE_HEIGHT = 10.16e-3;
GUIDE_WIDTH  = 22.86e-3;

% Design the rectangular waveguide at the operating frequency
disp("design the oerwg");

oerwg          = design(waveguide, FREQUENCY);
oerwg.Width    = GUIDE_WIDTH;
oerwg.Height   = GUIDE_HEIGHT;
oerwg.Tilt     = [+90 - 5, 0]; % the waveguide tilts 5 degree about the y-axis
oerwg.TiltAxis = [0,1,0; 0,0,1];

% Display the rectangular waveguide
figure();
show(oerwg);
title('Open-ended Rectangular Waveguide');

% Parameters of the horn antenna
disp("define parameters of the horn antenna");
FLARE_HEIGHT = 50e-3;
FLARE_WIDTH  = 75e-3;
FLARE_LENGTH = 130e-3;

% Design the horn antenna at the operating frequency
disp("design the horn antenna");
hornAnt             = design(horn, FREQUENCY);
hornAnt.Height      = GUIDE_HEIGHT;
hornAnt.Width       = GUIDE_WIDTH;
hornAnt.FlareLength = FLARE_LENGTH;
hornAnt.FlareWidth  = FLARE_WIDTH;
hornAnt.FlareHeight = FLARE_HEIGHT;
hornAnt.Tilt        = [-90 + 5, 180]; % the horn tilts 5 degree about the y-axis 
hornAnt.TiltAxis    = [0,1,0; 0,0,1];

% Display the horn antenna
figure();
show(hornAnt);
title("Horn antenna");

% disp("impedance of the oerwg");
impedanceWg = impedance(oerwg, FREQUENCY);
fprintf("impedance of the oerwg: %d + i*%d\n",real(impedanceWg), imag(impedanceWg));

% Add a load to the horn antenna
% disp("impedance of the horn antenna");
impedanceHorn = impedance(hornAnt, FREQUENCY);
fprintf("impedance of the horn antenna: %d + i*%d\n",real(impedanceHorn), imag(impedanceHorn));

% Calculate the distances for placement
% FRESNEL_DISTANCE    = 0.62 * sqrt(FLARE_WIDTH^3 / WAVELENGTH);
% SCANNING_DISTANCE   = FRESNEL_DISTANCE;
FRAUNHOFER_DISTANCE = 2 * (FLARE_WIDTH)^2 / WAVELENGTH;
SCANNING_DISTANCE   = 13e-2;

% Create the conformal array system with the horn and waveguide
OERWG_OFFSET_X = [-GUIDE_HEIGHT/2, 0, oerwg.Length/2];
OERWG_OFFSET_Y = [0, +GUIDE_HEIGHT/2, oerwg.Length/2];
HORN_OFFSET  = [-GUIDE_HEIGHT/2, 0, -hornAnt.Length/2 - FLARE_LENGTH];


positionX = [HORN_OFFSET(:)'; OERWG_OFFSET_X(:)'] + [0,0,0; 0,0, SCANNING_DISTANCE];
positionY = [HORN_OFFSET(:)'; OERWG_OFFSET_Y(:)'] + [0,0,0; 0,0, SCANNING_DISTANCE];

system = conformalArray("Element", {hornAnt, oerwg}, ...
                        "ElementPosition", positionX);
system.Reference = "origin"; 

% Display the antenna system
figure();
show(system);
title('Antenna System with horn antenna and open-ended rectangular waveguide for vertical polarisation');

% % Calculate S-parameters
scatteringParameters = sparameters(system, FREQUENCY, 50);

% Display the S-parameters
disp('S-parameters of the system:');
disp(scatteringParameters.Parameters);

% define near-field scanning grid
disp("define near-field scanning grid");
SCANNING_POINT_X = 32;
SCANNING_POINT_Y = SCANNING_POINT_X;
GRID_SPACE       = 15e-2;
LENGTH_X         = 32 * GRID_SPACE;
LENGTH_Y         = LENGTH_X;
nfGrid = PlanarGrid(SCANNING_POINT_X, SCANNING_POINT_Y, LENGTH_X, LENGTH_Y);

% define scanning parameter and proceed the measurement
sParamX = ones(SCANNING_POINT_X, SCANNING_POINT_Y);

if 1

disp("vertical polarisation measurement");

for xIndex = 1 : SCANNING_POINT_X
    for yIndex = 1 : SCANNING_POINT_Y
        % move the probe antenna
        progress = (xIndex - 1) * SCANNING_POINT_Y + yIndex;
        total = SCANNING_POINT_X * SCANNING_POINT_Y;
        displayProgress = sprintf("%d/%d", progress, total);
        disp(displayProgress);
        displayPosition = sprintf("position of the probe:[%d, %d]", nfGrid.x(xIndex,1), nfGrid.y(1, yIndex));
        disp(displayPosition);
        position = [HORN_OFFSET(:)'; OERWG_OFFSET_X(:)'] + [0,0,0; nfGrid.x(xIndex,1), nfGrid.y(1,yIndex), SCANNING_DISTANCE];
        system.ElementPosition = position;
        
        % calculate S12
        S = sparameters(system, FREQUENCY, 50);
        sParamX(xIndex, yIndex) = S.Parameters(1,2);
        fprintf("transmission parameter of the system: %f + i*%f\n", real(sParamX(xIndex, yIndex)), imag(sParamX(xIndex, yIndex)));
    end
end

save("Result/NF2FF/horn_tilt_Y_probe/sParamX_32.mat", "sParamX", "nfGrid");


disp("horizontal polarisation measurement");

% horizontal polarisation
oerwg.Tilt     = [+90, 270];
oerwg.TiltAxis = [0,1,0; 0,0,1];

system = conformalArray("Element", {hornAnt, oerwg}, ...
                        "ElementPosition", positionY);

% Display the antenna system
figure();
show(system);
title('Antenna System with horn antenna and open-ended rectangular waveguide for horizontal polarisation');

sParamY = ones(SCANNING_POINT_X, SCANNING_POINT_Y);

for xIndex = 1 : SCANNING_POINT_X
    for yIndex = 1 : SCANNING_POINT_Y
        % move the probe antenna
        progress = (xIndex - 1) * SCANNING_POINT_Y + yIndex;
        total = SCANNING_POINT_X * SCANNING_POINT_Y;
        displayProgress = sprintf("%d/%d", progress, total);
        disp(displayProgress);
        displayPosition = sprintf("position of the probe:[%d, %d]", nfGrid.x(xIndex,1), nfGrid.y(1, yIndex));
        position = [HORN_OFFSET(:)'; OERWG_OFFSET_Y(:)'] + [0,0,0; nfGrid.x(xIndex,1), nfGrid.y(1,yIndex), SCANNING_DISTANCE];
        system.ElementPosition = position;
        
        % calculate S12
        S = sparameters(system, FREQUENCY, 50);
        sParamY(xIndex, yIndex) = S.Parameters(1,2);
        fprintf("transmission parameter of the system: %f + i*%f\n", real(sParamY(xIndex, yIndex)), imag(sParamY(xIndex, yIndex)));
    end
end

save("Result/NF2FF/horn_tilt_Y_probe/sParamY_32.mat", "sParamY");

end