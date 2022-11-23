%% Initialisation
close all
clear
clc

[~, ~, ~, ~, fontsize] = eurecca_init;

basePath = [filesep 'Volumes' filesep 'geo.data.uu.nl' filesep 'research-eurecca' filesep 'FieldVisits' filesep '20210908_SEDMEX' filesep];

%% L1C1
addpath([basePath filesep 'data UU' filesep 'ADV' filesep 'L1C1 Nortek Vector #VEC9095' filesep 'QC'])
L1C1 = ncinfo('L1C1VEC_20210911.nc');
L1C1_t = ncread('L1C1VEC_20210911.nc', 't');
L1C1_f = ncread('L1C1VEC_20210911.nc', 'sf');
L1C1_anl1 = ncread('L1C1VEC_20210911.nc', 'anl1');

L1C1_u = ncread('L1C1VEC_20210911.nc', 'u');
L1C1_v = ncread('L1C1VEC_20210911.nc', 'v');
L1C1_w = ncread('L1C1VEC_20210911.nc', 'w');
L1C1_U = sqrt(L1C1_u.^2 + L1C1_v.^2 + L1C1_w.^2);

L1C1_u30 = mean(L1C1_u, 'omitnan');
L1C1_v30 = mean(L1C1_v, 'omitnan');
L1C1_w30 = mean(L1C1_w, 'omitnan');
L1C1_U30 = mean(L1C1_U, 'omitnan');
% L1C1_U30 = sqrt(L1C1_u30.^2 + L1C1_v30.^2 + L1C1_w30.^2);

L1C1_K30 = 0.5*rms([L1C1_u30; L1C1_v30; L1C1_w30], 1, 'includenan');

K = computeTKE(L1C1_u, L1C1_v, L1C1_w); % mean turbulence kinetic energy [J/kg] = [m^2/s^2]

%%
nburst = strings(1, length(L1C1_t));
for n = 1:length(L1C1_t)
    nburst(n) = ['Burst_', mat2str(n)];
end

L1C1_tt_u = array2timetable(L1C1_u, 'SampleRate', L1C1_f, 'VariableNames', nburst);
L1C1_tt_v = array2timetable(L1C1_v, 'SampleRate', L1C1_f, 'VariableNames', nburst);
L1C1_tt_w = array2timetable(L1C1_w, 'SampleRate', L1C1_f, 'VariableNames', nburst);

L1C1_u_1m_mean = retime(L1C1_tt_u, 'secondly', 'mean');
% L1C1_1sec_k = retime([L1C1_tt_u, L1C1_tt_v, L1C1_tt_w], 'secondly', @computeTKE);

L1C1_tt_anl1 = array2timetable(L1C1_anl1, 'SampleRate', L1C1_f, 'VariableNames', nburst);
L1C1_anl1_1m_mean = retime(L1C1_tt_anl1, 'secondly', 'mean');

%% L2C3
% addpath([basePath 'data UU' filesep 'ADV' filesep 'L2C3 Nortek Vector #VEC9052' filesep 'QC'])
% L2C3 = ncinfo('L2C3VEC_20210911.nc');
% L2C3_u = ncread('L2C3VEC_20210911.nc', 'u');

%% L2C5
% addpath([basePath ['data UU' filesep 'ADV' filesep 'L1C1 Nortek Vector #VEC9095' filesep 'QC'])
% L2C5 = ncinfo('L2C5VEC_20210911.nc');
% L2C5_u = ncread('L2C5VEC_20210911.nc', 'u');

%% L3C1
% addpath([basePath 'data UU' filesep 'ADV' filesep 'L3C1 Nortek Vector #VEC9056' filesep 'QC'])
% L3C1 = ncinfo('L3C1VEC_20210911.nc');
% L3C1_u = ncread('L3C1VEC_20210911.nc', 'u');

%% L4C1
% addpath([basePath 'data TUD' filesep 'L4C1VEC' filesep 'QC'])
% L4C1 = ncinfo('L4C1VEC_20210911.nc');
% L4C1_u = ncread('L4C1VEC_20210911.nc', 'u');

%% L5C1
% addpath([basePath 'data UU' filesep 'ADV' filesep 'L5C1 Nortek Vector #VEC16718' filesep 'QC'])
% L5C1 = ncinfo('L5C1VEC_20210911.nc');
% L5C1_u = ncread('L5C1VEC_20210911.nc', 'u');

%% L6C1
% addpath([basePath 'data UU' filesep 'ADV' filesep 'L6C1 Nortek Vector #VEC16724' filesep 'QC'])
% L6C1 = ncinfo('L6C1VEC_20210911.nc');
% L6C1_u = ncread('L6C1VEC_20210911.nc', 'u');

%% Visualisation
figure
tiledlayout(2, 1)

nexttile
scatter(L1C1_u_1m_mean.Time, L1C1_u_1m_mean.Burst_1, 200)

nexttile
scatter(L1C1_anl1_1m_mean.Time, L1C1_anl1_1m_mean.Burst_1, 200)

xlabel('minutes')
% xticks(0:120:max(L1C1_t))
