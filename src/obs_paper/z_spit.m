%% Initialisation
close all
clear
clc

[~, ~, ~, ~, fontsize, basePath] = eurecca_init;

% colourblind-friendly colour palette
orange = [230/255, 159/255, 0];
blue = [86/255, 180/255, 233/255];
yellow = [240/255, 228/255, 66/255];
redpurp = [204/255, 121/255, 167/255];
bluegreen = [0, 158/255, 115/255];

% water levels
MHWS = 0.81; % mean high water spring [m]
MLWS = -1.07; % mean low water spring [m]
MSL = 0; % mean sea level [m]
NAP = MSL-0.1; % local reference datum [m]

% settings
pgns = getPolygons;
contourLevels = [MHWS, MSL];

%%
wb = waitbar(0, 'Loading DEMs');
wb.Children.Title.Interpreter = 'none';
DEMP = [basePath 'data' filesep 'elevation' filesep 'processed' filesep];
DEMS = dir(fullfile(DEMP,'PHZ*.mat'));
for k = 1:numel(DEMS)
    DEMS(k).data = load(DEMS(k).name);
    waitbar(k/numel(DEMS), wb, sprintf('Loading DEMs: %d%%', floor(k/numel(DEMS)*100)));
    pause(0.1)
end
close(wb)

load DEMsurveys.mat
SurveyDates = DEMsurveys.survey_date;

%% Computations
% struc = [A B C D E];
for n = 1:numel(DEMS)
    struc(n) = DEMS(n).data.DEM;
end

wb = waitbar(0, 'Loading DEMs');
wb.Children.Title.Interpreter = 'none';
for n = 1:numel(struc)
    mask = inpolygon(struc(n).X, struc(n).Y, pgns.head(:, 1), pgns.head(:, 2));
    struc(n).X(~mask) = NaN;
    struc(n).Y(~mask) = NaN;
    struc(n).Z(~mask) = NaN;

    struc(n).Z = imgaussfilt(struc(n).Z,'FilterSize',3);
    waitbar(n/numel(DEMS), wb, sprintf('Masking DEMs: %d%%', floor(n/numel(DEMS)*100)));
    pause(0.1)
end
close(wb)

%% Visualisation: spit head development w/ single contour
newcolors = crameri('bilbao');
colours = newcolors(1:round(length(newcolors)/numel(struc)):length(newcolors), :);
% colours = flipud(gray(numel(struc)+1));
% alphas = 1/numel(struc):1/numel(struc):1;

f0 = figure;

hold on
for n = 1:numel(struc)
    contour(struc(n).X, struc(n).Y, struc(n).Z, [.1 .1], 'LineWidth',3, 'EdgeColor',colours(n+1,:))
    % contour(struc(n).X, struc(n).Y, struc(n).Z, [.1 .1], 'LineWidth',3, 'EdgeColor',colours(n+1,:), 'EdgeAlpha',alphas(n))
end

legend(string(SurveyDates, 'dd/MM/yyyy'), 'Location','eastoutside')
xlabel('easting [RD] (m)')
ylabel('northing [RD] (m)')
grid on; axis square

%% Visualisation: spit head development w/ multiple contours
bathys = [1 6 10 14];

f1 = figure;
tiledlayout('flow', 'TileSpacing','none')

for n = 1:length(bathys)
    
    ax{n} = nexttile;
    [C,h] = contour(struc(bathys(n)).X, struc(bathys(n)).Y, struc(bathys(n)).Z,...
        [.1 .5 1], 'LineWidth',3);
    clabel(C,h, 'FontSize',fontsize*.6, 'Interpreter','latex', 'LabelSpacing',200)
    grid on; axis square
end

yticklabels([ax{2} ax{4}], {})
