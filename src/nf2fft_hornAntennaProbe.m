%% clean up the environment
clc; clear variables; close all; format long;

load("../Result/NF2FF/horn5DegreeY_probe/sParamX_32.mat");
load("../Result/NF2FF/horn5DegreeY_probe/sParamY_32.mat");

%% define constants
disp("define constants");
FREQUENCY = 10e9;

main = Main();

main.xGrid = nfGrid.x;
main.yGrid = nfGrid.y;
main.phasorX = sParamX;
main.phasorY = sParamY;
main.frequency = FREQUENCY;

main = main.Transform();
