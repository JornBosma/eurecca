%% Initialisation
close all
clear
clc

[~, fontsize, ~, PHZ] = eurecca_init;

warning off

% addpath('/Users/jwb/Local_NoSync/OET/matlab/')
% oetsettings('quiet')

% folderPath = '/Users/jwb/Library/CloudStorage/OneDrive-UniversiteitUtrecht/PHZ/DataDescriptor/sediment_marlies/csv';
folderPath = [filesep 'Volumes' filesep 'T7 Shield' filesep 'DataDescriptor' filesep 'grainsizes' filesep];

% List all files in the folder
fileList = dir(fullfile(folderPath, 'GS_*.csv'));

S = struct();

for n = 1:length(fileList)
    fileName = fileList(n).name;
    dataPath = [folderPath filesep fileName];

    opts = detectImportOptions(dataPath);
    opts = setvaropts(opts,'Date_ddMMyyyy','InputFormat','dd/MM/yyyy'); 

    [~, fileNam, ~] = fileparts(fileName); % Extract the name without extension
    T = readtable(dataPath, opts);
    S.(fileNam) = T;
end

%% Apply masks
% load DEM
% A = load('PHZ_2019_Q0','-mat');
B = load('PHZ_2022_Q4','-mat');

% load polygons
pgns = getPolygons;

% mask_scope = inpolygon(A.DEM.X, A.DEM.Y, pgns.scope(:,1), pgns.scope(:,2));
% A.DEM.Z(~mask_scope) = NaN;
mask_scope = inpolygon(B.DEM.X, B.DEM.Y, pgns.scope(:,1), pgns.scope(:,2));
B.DEM.Z(~mask_scope) = NaN;

% mask_harbour = inpolygon(A.DEM.X, A.DEM.Y, pgns.harbour(:,1), pgns.harbour(:,2));
% A.DEM.Z(mask_harbour) = NaN;
mask_harbour = inpolygon(B.DEM.X, B.DEM.Y, pgns.harbour(:,1), pgns.harbour(:,2));
B.DEM.Z(mask_harbour) = NaN;

% contourMatrixA = contourc(A.DEM.X(1,:), A.DEM.Y(:,1), A.DEM.Z, [0 0]);
% xA = contourMatrixA(1, 2:end);
% yA = contourMatrixA(2, 2:end);
% xA(xA<min(A.DEM.X(1,:))) = NaN;
% yA(yA<min(A.DEM.Y(:,1))) = NaN;

contourMatrixB = contourc(B.DEM.X(1,:), B.DEM.Y(:,1), B.DEM.Z, [0 0]);
xB = contourMatrixB(1, 2:end);
yB = contourMatrixB(2, 2:end);
xB(xB<min(B.DEM.X(1,:))) = NaN;
yB(yB<min(B.DEM.Y(:,1))) = NaN;

%% Visualisation of all horizontal sample locations
f0 = figure;
tiledlayout(3,4, 'TileSpacing','none', 'Padding','tight')

ax1 = nexttile;
plot(xB, yB, '-k', 'LineWidth', 2); hold on
scatter(S.GS_20201016.xRD_inaccurate_m, S.GS_20201016.yRD_inaccurate_m, 40, 'r', 'filled', 'LineWidth',2);
title('2020-10-16', 'FontSize',fontsize*.7, 'Units','normalized',...
    'Position',[.5, .65]);

ax2 = nexttile;
plot(xB, yB, '-k', 'LineWidth', 2); hold on
scatter(S.GS_20201202.xRD_m, S.GS_20201202.yRD_m, 40, 'r', 'filled', 'LineWidth',2);
title('2020-12-02', 'FontSize',fontsize*.7, 'Units','normalized',...
    'Position',[.5, .65]);

ax3 = nexttile;
plot(xB, yB, '-k', 'LineWidth', 2); hold on
scatter(S.GS_20201203.xRD_m, S.GS_20201203.yRD_m, 40, 'r', 'filled', 'LineWidth',2);
title('2020-12-03', 'FontSize',fontsize*.7, 'Units','normalized',...
    'Position',[.5, .65]);

ax4 = nexttile;
plot(xB, yB, '-k', 'LineWidth', 2); hold on
scatter(S.GS_20210408.xRD_m, S.GS_20210408.yRD_m, 40, 'r', 'filled', 'LineWidth',2);
title('2021-04-08', 'FontSize',fontsize*.7, 'Units','normalized',...
    'Position',[.5, .65]);

ax5 = nexttile;
plot(xB, yB, '-k', 'LineWidth', 2); hold on
scatter(S.GS_20210606.xRD_inaccurate_m, S.GS_20210606.yRD_inaccurate_m, 40, 'r', 'filled', 'LineWidth',2);
title('2021-06-06', 'FontSize',fontsize*.7, 'Units','normalized',...
    'Position',[.5, .65]);

ax6 = nexttile;
plot(xB, yB, '-k', 'LineWidth', 2); hold on
scatter(S.GS_20210920.xRD_m, S.GS_20210920.yRD_m, 40, 'r', 'filled', 'LineWidth',2);
title({'2021-09-20  2021-10-07','2021-09-28  2021-10-15','2021-10-01                    '}, 'FontSize',fontsize*.7, 'Units','normalized',...
    'Position',[.5, .65]);

ax7 = nexttile;
plot(xB, yB, '-k', 'LineWidth', 2); hold on
scatter(S.GS_20210921.xRD_m, S.GS_20210921.yRD_m, 40, 'r', 'filled', 'LineWidth',2);
title({'2021-09-21','2021-09-28'}, 'FontSize',fontsize*.7, 'Units','normalized',...
    'Position',[.5, .65]);

ax8 = nexttile;
plot(xB, yB, '-k', 'LineWidth', 2); hold on
scatter(S.GS_20210930.xRD_m, S.GS_20210930.yRD_m, 40, 'r', 'filled', 'LineWidth',2);
title({'2021-09-30  2021-10-11','2021-10-01  2021-10-13','2021-10-06                    '}, 'FontSize',fontsize*.7, 'Units','normalized',...
    'Position',[.5, .65]);

ax9 = nexttile;
plot(xB, yB, '-k', 'LineWidth', 2); hold on
scatter(S.GS_20211007S.xRD_m, S.GS_20211007S.yRD_m, 40, 'r', 'filled', 'LineWidth',2)
scatter(S.GS_20211015S.xRD_m, S.GS_20211015S.yRD_m, 40, 'r', 'filled', 'LineWidth',2)
title({'2021-10-07s','2021-10-15s'}, 'FontSize',fontsize*.7, 'Units','normalized',...
    'Position',[.5, .65]);

ax10 = nexttile;
plot(xB, yB, '-k', 'LineWidth', 2); hold on
scatter(S.GS_20211008.xRD_m, S.GS_20211008.yRD_m, 40, 'r', 'filled', 'LineWidth',2, 'LineWidth',1);
title('2021-10-08', 'FontSize',fontsize*.7, 'Units','normalized',...
    'Position',[.5, .65]);

ax11 = nexttile;
plot(xB, yB, '-k', 'LineWidth', 2); hold on
scatter(S.GS_20211009.xRD_m, S.GS_20211009.yRD_m, 40, 'r', 'filled', 'LineWidth',2);
title('2021-10-09', 'FontSize',fontsize*.7, 'Units','normalized',...
    'Position',[.5, .65]);

ax12 = nexttile;
plot(xB, yB, '-k', 'LineWidth', 2); hold on
scatter(S.GS_20221026.xRD_m, S.GS_20221026.yRD_m, 40, 'r', 'filled', 'LineWidth',2);
title('2022-10-26', 'FontSize',fontsize*.7, 'Units','normalized',...
    'Position',[.5, .65]);

xlim([ax1, ax2, ax3, ax4, ax5, ax6, ax7, ax8, ax9, ax10, ax11, ax12], PHZ.xLim);
ylim([ax1, ax2, ax3, ax4, ax5, ax6, ax7, ax8, ax9, ax10, ax11, ax12], PHZ.yLim);
axis([ax1, ax2, ax3, ax4, ax5, ax6, ax7, ax8, ax9, ax10, ax11, ax12], 'off');
axis([ax1, ax2, ax3, ax4, ax5, ax6, ax7, ax8, ax9, ax10, ax11, ax12], 'vis3d');
view([ax1, ax2, ax3, ax4, ax5, ax6, ax7, ax8, ax9, ax10, ax11, ax12], 46, 90);

linkaxes

%% L2 sample locations

% load data
folderPath = [filesep 'Volumes' filesep 'T7 Shield' filesep 'DataDescriptor' filesep];
dataPath = [folderPath 'topobathy' filesep 'transects' filesep 'PHZD.nc'];

trackInfo = ncinfo(dataPath);

% assign variables
x = ncread(dataPath, 'x'); % xRD [m]
y = ncread(dataPath, 'y'); % yRD [m]
z = ncread(dataPath, 'z'); % bed level [m+NAP]
d = ncread(dataPath, 'd'); % cross-shore distance [m]
ID = ncread(dataPath, 'ID'); % profile ID (days since 2020-10-16 00:00:00)
transect = ncread(dataPath, 'transect'); % tansect number (Python counting)

% timing
startDate = datetime('2020-10-16 00:00:00');
surveyDates = startDate + days(ID);

% selection
survey = 24; % 07-Oct-2021
track = 2; % L2

Zselect = z(:, survey, track);
Z = Zselect(~isnan(Zselect));
Z = movmean(Z, 5);
D = d(~isnan(Zselect));

% find sample locations
GS = readtable([folderPath 'grainsizes' filesep 'GS_20210920.csv']);
zSamples = GS.zNAP_m(1:8);
[unique_Z, unique_indices] = unique(Z);
unique_D = D(unique_indices);
dGS = interp1(unique_Z, unique_D, zSamples);
names = {'L2C2', 'L2C3', 'L2C3.5', 'L2C4', 'L2C4.5', 'L2C5W', 'L2C5E', ''};

% colourblind-friendly colour palette
orange = [230/255, 159/255, 0];
blue = [86/255, 180/255, 233/255];
yellow = [240/255, 228/255, 66/255];
redpurp = [204/255, 121/255, 167/255];
bluegreen = [0, 158/255, 115/255];

%% Visualisation
f1 = figureRH;

plot(D, Z, 'k', 'LineWidth',3); hold on
area(D, Z, 'BaseValue',-1.7, 'FaceColor',yellow)
scatter(dGS, zSamples, 200, 'filled', 'vr'); hold off

text(dGS+1, zSamples+.04, names, 'FontSize',fontsize*.8)
text(dGS(end)+1, zSamples(end)-0, 'L2C6', 'FontSize',fontsize*.8)

yline(PHZ.MHW, '--', 'MHW', 'FontSize',fontsize*.8, 'LineWidth',2)
yline(PHZ.MSL, '-.', 'MSL', 'FontSize',fontsize*.8, 'LineWidth',2)
yline(PHZ.MLW, '--', 'MLW', 'FontSize',fontsize*.8, 'LineWidth',2)

xlim([D(1), D(end)])
ylim([-1.7, 1.5])

xlabel('cross-shore distance (m)')
ylabel('bed level (m +NAP)')

legend('', 'bed', 'samples', 'Location','north')

% axis square
box off
