function [xl, yl, xt, yt, fontsize, cbf, basePath] = eurecca_init

% define global variables
global basePath

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

% axis limits and ticks
xl = [1.148e+05, 1.1805e+05]; % PHZD
yl = [5.5775e+05, 5.6065e+05];
xt = 114000:1e3:118000;
yt = 558000:1e3:561000;
% xl = [1.1695e+05, 1.1765e+05]; % spit hook zoom-in
% yl = [5.5976e+05, 5.6040e+05];

% colourblind-friendly colour palette
cbf.orange = [230/255, 159/255, 0];
cbf.skyblue = [86/255, 180/255, 233/255];
cbf.bluegreen = [0, 158/255, 115/255];
cbf.yellow = [240/255, 228/255, 66/255];
cbf.blue = [0/255, 114/255, 178/255];
cbf.vermilion = [213/255, 94/255, 0/255];
cbf.redpurp = [204/255, 121/255, 167/255];

% ready
return
