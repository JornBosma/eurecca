%% Initialisation
close all
clear
clc

[~, ~, ~, ~, fontsize] = eurecca_init;

basePath = [filesep 'Volumes' filesep 'geo.data.uu.nl' filesep ...
    'research-eurecca' filesep 'FieldVisits' filesep ...
    '20210908_SEDMEX' filesep 'Data Descriptor'];

% addpath(genpath([basePath filesep 'ADV']))

file = [basePath, '/ADV/L2C3VEC/QC_loose/L2C3VEC_20211015.nc'];

%% L2C3
L2C3b = ncinfo(file);
L2C3_t = ncread(file, 't');
L2C3_f = ncread(file, 'sf');
L2C3_anl1 = ncread(file, 'anl1');

L2C3_u = ncread(file, 'u');
L2C3_v = ncread(file, 'v');
L2C3_w = ncread(file, 'w');
L2C3_U = sqrt(L2C3_u.^2 + L2C3_v.^2 + L2C3_w.^2);

L2C3_u30 = mean(L2C3_u, 'omitnan');
L2C3_v30 = mean(L2C3_v, 'omitnan');
L2C3_w30 = mean(L2C3_w, 'omitnan');
L2C3_U30 = mean(L2C3_U, 'omitnan');
% L2C3_U30 = sqrt(L2C3_u30.^2 + L2C3_v30.^2 + L2C3_w30.^2);

L2C3_K30 = 0.5*rms([L2C3_u30; L2C3_v30; L2C3_w30], 1, 'includenan');

K = computeTKE(L2C3_u, L2C3_v, L2C3_w); % mean turbulence kinetic energy [J/kg] = [m^2/s^2]

%%
nburst = strings(1, length(L2C3_t));
for n = 1:length(L2C3_t)
    nburst(n) = ['Burst_', mat2str(n)];
end

L2C3_tt_u = array2timetable(L2C3_u, 'SampleRate', L2C3_f, 'VariableNames', nburst);
L2C3_tt_v = array2timetable(L2C3_v, 'SampleRate', L2C3_f, 'VariableNames', nburst);
L2C3_tt_w = array2timetable(L2C3_w, 'SampleRate', L2C3_f, 'VariableNames', nburst);

L2C3_u_1m_mean = retime(L2C3_tt_u, 'minutely', 'mean');
% L2C3_1sec_k = retime([L2C3_tt_u, L2C3_tt_v, L2C3_tt_w], 'secondly', @computeTKE);

L2C3_tt_anl1 = array2timetable(L2C3_anl1, 'SampleRate', L2C3_f, 'VariableNames', nburst);
L2C3_anl1_1m_mean = retime(L2C3_tt_anl1, 'minutely', 'mean');



%% Visualisation
figure
tiledlayout(2, 1)

nexttile
plot(L2C3_u_1m_mean.Time, L2C3_u_1m_mean.Burst_1)

nexttile
plot(L2C3_anl1_1m_mean.Time, L2C3_anl1_1m_mean.Burst_1)

xlabel('minutes')
% xticks(0:120:max(L2C3_t))
