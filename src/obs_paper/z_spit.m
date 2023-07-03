%% Initialisation
close all
clear
clc

[~, ~, ~, ~, fontsize, ~] = eurecca_init;

% colourblind-friendly colour palette
orange = [230/255, 159/255, 0];
blue = [86/255, 180/255, 233/255];
yellow = [240/255, 228/255, 66/255];
redpurp = [204/255, 121/255, 167/255];
bluegreen = [0, 158/255, 115/255];

newcolors = crameri('-vik');
colours = newcolors(1:round(length(newcolors)/5):length(newcolors), :);

% water levels
MHWS = 0.81; % mean high water spring [m]
MLWS = -1.07; % mean low water spring [m]
MSL = 0; % mean sea level [m]
NAP = MSL-0.1; % local reference datum [m]

% settings
pgns = getPolygons;
contourLevels = [MHWS, MSL];

% load DEMs
load DEMsurveys.mat
SurveyDates = DEMsurveys.survey_date;

A = load('PHZ_2019_Q0','-mat'); % 01/05/2019
B = load('PHZ_2019_Q4','-mat'); % 09/11/2019
C = load('PHZ_2020_Q4','-mat'); % 26/11/2020
D = load('PHZ_2021_Q4','-mat'); % 16/11/2021
E = load('PHZ_2022_Q4','-mat'); % 07/12/2022

dates = SurveyDates([1 2 6 10 14]);

struc = [A B C D E];

%% Computations
for n = 1:numel(struc)
    mask = inpolygon(struc(n).DEM.X, struc(n).DEM.Y, pgns.north(:, 1), pgns.north(:, 2));
    struc(n).DEM.X(~mask) = NaN;
    struc(n).DEM.Y(~mask) = NaN;
    struc(n).DEM.Z(~mask) = NaN;
end

%% Visualisation
figure

hold on

for n = 1:numel(struc)
    contour(struc(n).DEM.X, struc(n).DEM.Y, struc(n).DEM.Z, [0 0], 'LineWidth',3)
end

colororder(flipud(newcolors(1:round(256/numel(struc)):256, :)))

legend(string(dates, 'dd/MM/yyyy'))
