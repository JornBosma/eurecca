%% Initialisation
close all
clear
clc

[xl, yl, ~, ~, fontsize, ~] = eurecca_init;

% colourblind-friendly colour palette
orange = [230/255, 159/255, 0];
blue = [86/255, 180/255, 233/255];
yellow = [240/255, 228/255, 66/255];
redpurp = [204/255, 121/255, 167/255];
bluegreen = [0, 158/255, 115/255];

newcolors = crameri('-vik');
colours = newcolors(1:round(length(newcolors)/5):length(newcolors), :);

%% Figure 0: study site
AHN1 = 'R5_09DN1.TIF';
AHN2 = 'R5_09DN2.TIF';

info1 = georasterinfo(AHN2);
info2 = georasterinfo(AHN2);

[A1, R1] = readgeoraster(AHN1, 'OutputType','double');
[A2, R2] = readgeoraster(AHN2, 'OutputType','double');

m1 = info1.MissingDataIndicator;
m2 = info2.MissingDataIndicator;

A1 = standardizeMissing(A1, m1);
A2 = standardizeMissing(A2, m2);

load zSounding.mat z_2021_Q1
survey = z_2021_Q1;

% load PHZ_2022_Q4.mat
% DEM.Z(DEM.Z<0) = NaN;

%% Visualisation
f0 = figure;
mapshow(A1, R1, 'DisplayType','surface', 'ZData',zeros(R1.RasterSize)); hold on
mapshow(A2, R2, 'DisplayType','surface', 'ZData',zeros(R2.RasterSize))
scatter(survey.xRD, survey.yRD, [], survey.z, '.'); hold off
% surf(DEM.X, DEM.Y, DEM.Z); hold off

c = colorbar;
c.Label.String = 'm +NAP';
c.Label.Interpreter = 'latex';
c.TickLabelInterpreter = 'latex';
c.FontSize = fontsize;
clim([-2, 10]);

crameri('fes', 'pivot',0)

view(48.5, 90)
xlim([xl(1) xl(2)])
ylim([yl(1) yl(2)])

xlabel('easting [RD] (m)')
ylabel('northing [RD] (m)')

set(gca, 'Color',[0 0.4470 0.7410])
set(gcf, 'Color','w')
