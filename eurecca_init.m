function [xl, yl, xt, yt, fontsize, basePath] = eurecca_init

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
set(groot, 'DefaultAxesFontSize', 34)
set(groot, 'DefaultTextInterpreter', 'latex')
set(groot, 'DefaultAxesTickLabelInterpreter', 'latex')
set(groot, 'DefaultLegendInterpreter', 'latex')
set(groot, 'DefaultLegendLocation', 'northwest')
% set(groot, 'DefaultLegendBox', 'off')
set(groot, 'DefaultAxesBox', 'off')

% set parameters
fontsize = 34;

% axis limits and ticks
xl = [1.148e+05, 1.1805e+05]; % PHZD
yl = [5.5775e+05, 5.6065e+05];
xt = 114000:1e3:118000;
yt = 558000:1e3:561000;
% xl = [1.1695e+05, 1.1765e+05]; % spit hook zoom-in
% yl = [5.5976e+05, 5.6040e+05];

% ready
return
