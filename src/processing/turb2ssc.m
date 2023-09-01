% Calibration and time-averaging of OBS-data
% J.W. Bosma, 2023

%% Initialisation
close all
clear
clc

[~, ~, ~, ~, fontsize, ~] = eurecca_init;

%% STEP 1: load OBS data
folderPath = [filesep 'Volumes' filesep 'T7 Shield' filesep 'DataDescriptor' filesep 'hydrodynamics' filesep 'ADV' filesep 'L6C1VEC' filesep' 'raw_netcdf'];
filePattern = 'L6C1VEC_*.nc';
fileList = dir(fullfile(folderPath, filePattern));

fileName = fullfile(folderPath, fileList(1).name);
fs = ncread(fileName, 'sf'); % sampling frequency [Hz]
L6C1_raw = ncread(fileName, 'anl1');
for i = 2:length(fileList)
    fileName = fullfile(folderPath, fileList(i).name);
    temp = ncread(fileName, 'anl1');
    L6C1_raw = horzcat(L6C1_raw, temp);
end
clear temp

%% STEP 2: apply transmission factor (or attenuation factor)
transfac = 5000/2^fs; % transmission factor
L6C1_turb = L6C1_raw*transfac; % turbidity [mV]

%% STEP 3: remove backround noise
[L6C1_nobg, L6C1_bg] = removeOffsetSTM(L6C1_turb, fs);

%% STEP 4: apply calibration
coef_L2_075 = readtable('/Volumes/T7 Shield/DataDescriptor/suspsediment/coef_L2_075.csv'); % calibration coefficients
L6C1_cal = polyval(coef_L2_075.L6C1STM, L6C1_nobg); % suspended sediment concentration [kg/m3]

%% STEP 5: remove negative values
L6C1_cal(L6C1_cal<0) = 0; % if negative concentration then 0

%% STEP 6: build timetable
t0 = datetime('2021-09-11 00:00:00');
L6C1 = array2timetable(L6C1_cal(:,1), 'SampleRate',fs, 'StartTime',t0, 'VariableNames',{'SSC'});

for n = 2:size(L6C1_cal, 2)
    temp = array2timetable(L6C1_cal(:,n), 'SampleRate',fs, 'StartTime',t0+minutes((n-1)*30), 'VariableNames',{'SSC'});
    L6C1 = vertcat(L6C1, temp);
end
clear temp

%% STEP 7: transform data (e.g. time averaging)
dt = minutes(10);
L6C1 = retime(L6C1, 'regular', @mean, 'TimeStep',dt);
