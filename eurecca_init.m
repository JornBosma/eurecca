function [basePath, fontsize, cbf, PHZ, SEDMEX] = eurecca_init

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
fontsize = 30;
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
% not colourblind-friendly
cbf.qual12 = ["#a6cee3"; ...
        "#1f78b4"; ...
        "#b2df8a"; ...
        "#33a02c"; ...
        "#fb9a99"; ...
        "#e31a1c"; ...
        "#fdbf6f"; ...
        "#ff7f00"; ...
        "#cab2d6"; ...
        "#6a3d9a"; ...
        "#ffff99"; ...
        "#b15928"];
cbf.custom12 = ...
   [1.000000000000000   0.500000000000000   0.800000000000000; ...
    0.992156862745098	0.749019607843137	0.435294117647059; ...
    0.000000000000000   1.000000000000000   1.000000000000000; ...
    0.792156862745098	0.698039215686275	0.839215686274510; ...
    1.000000000000000   0.498039215686275	0.000000000000000; ...
    0.698039215686275	0.874509803921569	0.541176470588235; ...
    1.000000000000000	1.000000000000000	0.000000000000000; ...
    0.890196078431373	0.101960784313725	0.109803921568627; ...
    0.415686274509804	0.239215686274510	0.603921568627451; ...
    0.694117647058824	0.349019607843137	0.156862745098039; ...
    0.121568627450980	0.470588235294118	0.705882352941177; ...
    0.200000000000000	0.627450980392157	0.172549019607843];

% tidal datums wrt NAP @ PHZ
PHZ.NAP = 0; % local reference datum [m]
PHZ.MHWS = 0.81; % mean high water spring [m] (visually determined from waterinfo)
PHZ.MLWS = -1.07; % mean low water spring [m] (visually determined from waterinfo)

% tidal datums during SEDMEX: Woerdman et al., 2022
SEDMEX.MHW = 0.68; % mean high water [m]
SEDMEX.MLW = -0.57; % mean low water [m]
SEDMEX.MWL = 0.16; % mean water level [m]
SEDMEX.MaxWL = 1.34; % maximum water level [m]
SEDMEX.MinWL = -1.07; % minimum water level [m]
SEDMEX.MSTR = 1.77; % mean spring tidal range [m]
SEDMEX.MNTR = 0.92; % mean neap tidal range [m]
SEDMEX.MTR = 1.25; % mean neap tidal range [m]
SEDMEX.MaxTR = 1.77; % maximum tidal range [m]
SEDMEX.MinTR = 0.92; % minimum tidal range [m]

% tidal datums (slotgemiddelden 2011): HHNK & Witteveen+Bos, 2016
PHZ.DHW = 2.95; % decennial (1/10y) high water level [m+NAP]
PHZ.BHW = 2.4; % biennial (1/2y) high water level [m+NAP]
PHZ.AHW = 2.25; % annual (1/1y) high water level [m+NAP]
PHZ.MHW = 0.64; % mean high water level [m+NAP]
PHZ.MSL = 0.04; % mean sea level [m+NAP]
PHZ.MLW = -0.69; % mean low water level [m+NAP]
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
