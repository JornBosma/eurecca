function [basePath, fontsize, cbf, PHZ] = eurecca_init

% define global variables
% global basePath

% set base path. All subdirectories are branches from the base path.
basePath = strrep(which('eurecca_init'), 'eurecca_init.m', '');

% add paths
addpath(basePath);
addpath(genpath([basePath 'src']))
addpath(genpath([basePath 'data']))
addpath(genpath([basePath 'results']))
addpath(genpath([basePath 'config']))
addpath(genpath([basePath 'bin']))
addpath(genpath([basePath 'docs']))

% set default settings
fontsize = 26;
set(groot, 'DefaultAxesFontSize', fontsize)
% set(groot, 'DefaultTextInterpreter', 'latex')
% set(groot, 'DefaultAxesTickLabelInterpreter', 'latex')
% set(groot, 'DefaultLegendInterpreter', 'latex')
% set(groot, 'DefaultLegendLocation', 'northwest')
% set(groot, 'DefaultLegendBox', 'off')
set(groot, 'DefaultAxesBox', 'off')

set(groot, 'defaultUicontrolFontName', 'Arial')
set(groot, 'defaultUitableFontName', 'Arial')
set(groot, 'defaultAxesFontName', 'Arial')
set(groot, 'defaultUipanelFontName', 'Arial')
set(groot, 'defaultTextFontName', 'Arial')

% colourblind-friendly colour palette
cbf.orange = [230/255, 159/255, 0];
cbf.skyblue = [86/255, 180/255, 233/255];
cbf.bluegreen = [0, 158/255, 115/255];
cbf.yellow = [240/255, 228/255, 66/255];
cbf.blue = [0/255, 114/255, 178/255];
cbf.vermilion = [213/255, 94/255, 0/255];
cbf.redpurp = [204/255, 121/255, 167/255];

% tidal datums wrt NAP @ PHZ
PHZ.NAP = 0; % local reference datum [m]
PHZ.MHWS = 0.81; % mean high water spring [m] (visually determined from waterinfo)
PHZ.MLWS = -1.07; % mean low water spring [m] (visually determined from waterinfo)

% tidal datums during SEDMEX: Woerdman et al., 2022
PHZ.MHW = 0.68; % mean high water [m]
PHZ.MLW = -0.57; % mean low water [m]
PHZ.MWL = 0.16; % mean water level [m]
PHZ.MaxWL = 1.34; % maximum water level [m]
PHZ.MinWL = -1.07; % minimum water level [m]
PHZ.MSTR = 1.77; % mean spring tidal range [m]
PHZ.MNTR = 0.92; % mean neap tidal range [m]
PHZ.MTR = 1.25; % mean neap tidal range [m]
PHZ.MaxTR = 1.77; % maximum tidal range [m]
PHZ.MinTR = 0.92; % minimum tidal range [m]

% tidal datums (slotgemiddelden 2011): HHNK & Witteveen+Bos, 2016
PHZ.DHW = 2.95; % decennial (1/10y) high water level [m+NAP]
PHZ.BHW = 2.4; % biennial (1/2y) high water level [m+NAP]
PHZ.AHW = 2.25; % annual (1/1y) high water level [m+NAP]
% PHZ.MHW = 0.64; % mean high water level [m+NAP]
PHZ.MSL = 0.04; % mean sea level [m+NAP]
% PHZ.MLW = -0.69; % mean low water level [m+NAP]
PHZ.LAT = -1.17; % lowest astronomical tide [m+NAP]

% axis limits and ticks
PHZ.xLim = [1.148e+05, 1.1805e+05]; % PHZD
PHZ.yLim = [5.5775e+05, 5.6065e+05];
PHZ.xTick = 114000:1e3:118000;
PHZ.yTick = 558000:1e3:561000;
PHZ.xLimHook = [1.1695e+05, 1.1765e+05]; % spit hook zoom-in
PHZ.yLimHook = [5.5976e+05, 5.6040e+05];

% ready
return
