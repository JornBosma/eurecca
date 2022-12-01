%% Initialisation
close all
clear
clc

[~, ~, ~, ~, fontsize] = eurecca_init;

basePath = [filesep 'Volumes' filesep 'geo.data.uu.nl' filesep ...
    'research-eurecca' filesep 'FieldVisits' filesep ...
    '20210908_SEDMEX' filesep 'Data Descriptor'];

% addpath(genpath([basePath filesep 'ADV']))
% addpath(genpath([basePath filesep 'SOLO']))

file1 = [basePath, '/ADV/L2C4VEC/tailored_loose/L2C4VEC.nc'];
file2 = [basePath, '/SOLO/L2C4SOLO/tailored/L2C4SOLO.nc'];

start = datetime('2021-09-10 19:00:00'); % UTC+2

L2C4VEC = ncinfo(file1);
zs_vec = ncread(file1, 'zs');

L2C4SOLO = ncinfo(file2);
d = ncread(file2, 'd');

%% Visualisation
f = figure;
plot(d)