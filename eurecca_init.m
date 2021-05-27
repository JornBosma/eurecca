function eurecca_init

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
set(groot, 'DefaultAxesFontSize', 16)
set(groot, 'DefaultTextInterpreter', 'latex')
set(groot, 'DefaultAxesTickLabelInterpreter', 'latex')
set(groot, 'DefaultLegendInterpreter', 'latex')
set(groot, 'DefaultLegendLocation', 'northwest')
set(groot, 'DefaultLegendBox', 'off')
set(groot, 'DefaultAxesBox', 'off')

% ready
return