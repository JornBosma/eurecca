% OBS-calibration for SEDMEX campaign
% J.W. Bosma, 2023

%% Initialisation
close all
clear
clc

[~, ~, ~, ~, fontsize, ~] = eurecca_init;

Names = {'L1C1STM'; 'L2C3STM'; 'L3C1STM'; 'L5C1STM'; 'L6C1STM'; 'L2C7STM';...
    'L2C5STM1'; 'L2C5STM2'; 'L4C1OBS1'; 'L4C1OBS2'; 'L2C5STMarray1';...
    'L2C5STMarray2'; 'L2C5STMarray3'; 'L2C5STMarray4'; 'L2C5STMarray5'};

rowNames = {'p1', 'p2', 'p3'};

%% L2 (-0.75 m +NAP)
load L2_075cm.mat
columnNames_L2_075 = L2_075.Properties.VariableNames;
columnNames_L2_075(1) = [];

% calibration-curve coefficients
p_L2_075 = nan(3, width(L2_075)-1);
for n = 2:width(L2_075)
    p_L2_075(:,n-1) = polyfit(L2_075{:,n}*1000, L2_075{:,1}, 2);
end
p_L2_075 = array2table(p_L2_075, "VariableNames",Names, "RowNames",rowNames);

%% L2 (-1.20 m +NAP)
load L2_120cm.mat
columnNames_L2_120 = L2_120.Properties.VariableNames;
columnNames_L2_120(1) = [];

% calibration-curve coefficients
p_L2_120 = nan(3, width(L2_120)-1);
for n = 2:width(L2_120)
    p_L2_120(:,n-1) = polyfit(L2_120{:,n}*1000, L2_120{:,1}, 2);
end
p_L2_120 = array2table(p_L2_120, "VariableNames",Names, "RowNames",rowNames);

%% L5 (-0.75 m +NAP)
load L5_075cm.mat
L5_075 = removevars(L5_075, ["L4C1OBS1_V" "L4C1OBS2_V" "L2C5STMarray4_V"]); % no data
columnNames_L5_075 = L5_075.Properties.VariableNames;
columnNames_L5_075(1) = [];

% calibration-curve coefficients
p_L5_075 = nan(3, width(L5_075)-1);
for n = 2:width(L5_075)
    p_L5_075(:,n-1) = polyfit(L5_075{:,n}*1000, L5_075{:,1}, 2);
end
p_L5_075 = array2table(p_L5_075, "VariableNames",Names([1:8 11:13 15]), "RowNames",rowNames);

%% Store results
% writetable(L2_075,'/Users/jwb/Downloads/calib_L2_075.csv')
% writetable(L2_120,'/Users/jwb/Downloads/calib_L2_120.csv')
% writetable(L5_075,'/Users/jwb/Downloads/calib_L5_075.csv')
% 
% writetable(p_L2_075,'/Users/jwb/Downloads/coef_L2_075.csv', 'WriteRowNames',true)
% writetable(p_L2_120,'/Users/jwb/Downloads/coef_L2_120.csv', 'WriteRowNames',true)
% writetable(p_L5_075,'/Users/jwb/Downloads/coef_L5_075.csv', 'WriteRowNames',true)

%% Example

% STEP 1: load OBS data
info = ncinfo('L1C1VEC_20210930.nc');
t = ncread('L1C1VEC_20210930.nc', 't'); % minutes since 2021-09-30 00:00:00
sf = ncread('L1C1VEC_20210930.nc', 'sf'); % sampling frequency [Hz]

T_L1C1 = ncread('L1C1VEC_20210930.nc', 'anl1'); % turbidity [counts mV]
T_L2C3 = ncread('L2C3VEC_20210930.nc', 'anl1'); % turbidity [counts mV]
T_L3C1 = ncread('L3C1VEC_20210930.nc', 'anl1'); % turbidity [counts mV]
T_L4C1 = ncread('L4C1VEC_20210930.nc', 'anl1'); % turbidity [counts mV]
T_L5C1 = ncread('L5C1VEC_20210930.nc', 'anl1'); % turbidity [counts mV]
T_L6C1 = ncread('L6C1VEC_20210930.nc', 'anl1'); % turbidity [counts mV]

% STEP 2: apply transmission factor (or attenuation factor)
transfac = 0.07629; % transmission factor
T2_L1C1 = T_L1C1*transfac; % turbidity [mV]
T2_L2C3 = T_L2C3*transfac; % turbidity [mV]
T2_L3C1 = T_L3C1*transfac; % turbidity [mV]
T2_L4C1 = T_L4C1*transfac; % turbidity [mV]
T2_L5C1 = T_L5C1*transfac; % turbidity [mV]
T2_L6C1 = T_L6C1*transfac; % turbidity [mV]

% STEP 3: remove backround noise
[T3_L1C1, bg_L1C1] = removeOffsetSTM(T2_L1C1, sf);
[T3_L2C3, bg_L2C3] = removeOffsetSTM(T2_L2C3, sf);
[T3_L3C1, bg_L3C1] = removeOffsetSTM(T2_L3C1, sf);
[T3_L4C1, bg_L4C1] = removeOffsetSTM(T2_L4C1, sf);
[T3_L5C1, bg_L5C1] = removeOffsetSTM(T2_L5C1, sf);
[T3_L6C1, bg_L6C1] = removeOffsetSTM(T2_L6C1, sf);

% STEP 4: apply calibration
SSC_L1C1 = polyval(p_L2_120.L1C1STM, T3_L1C1); % suspended sediment concentration [kg/m3]
SSC_L2C3 = polyval(p_L2_075.L2C3STM, T3_L2C3); % suspended sediment concentration [kg/m3]
SSC_L3C1 = polyval(p_L2_120.L3C1STM, T3_L3C1); % suspended sediment concentration [kg/m3]
SSC_L4C1 = polyval(p_L2_120.L4C1OBS1, T3_L4C1); % suspended sediment concentration [kg/m3]
SSC_L5C1 = polyval(p_L5_075.L5C1STM, T3_L5C1); % suspended sediment concentration [kg/m3]
SSC_L6C1 = polyval(p_L5_075.L6C1STM, T3_L6C1); % suspended sediment concentration [kg/m3]

SSC_L1C1(SSC_L1C1<0) = 0; % if negative concentration then 0
SSC_L2C3(SSC_L2C3<0) = 0;
SSC_L3C1(SSC_L3C1<0) = 0;
SSC_L4C1(SSC_L4C1<0) = 0;
SSC_L5C1(SSC_L5C1<0) = 0;
SSC_L6C1(SSC_L6C1<0) = 0;

% STEP 5: build timetable
t0 = datetime('2021-09-30 00:00:00');

L1C1 = array2timetable(SSC_L1C1(:,1), 'SampleRate',sf, 'StartTime',t0, 'VariableNames',{'SSC'});
L2C3 = array2timetable(SSC_L2C3(:,1), 'SampleRate',sf, 'StartTime',t0, 'VariableNames',{'SSC'});
L3C1 = array2timetable(SSC_L3C1(:,1), 'SampleRate',sf, 'StartTime',t0, 'VariableNames',{'SSC'});
L4C1 = array2timetable(SSC_L4C1(:,1), 'SampleRate',sf, 'StartTime',t0, 'VariableNames',{'SSC'});
L5C1 = array2timetable(SSC_L5C1(:,1), 'SampleRate',sf, 'StartTime',t0, 'VariableNames',{'SSC'});
L6C1 = array2timetable(SSC_L6C1(:,1), 'SampleRate',sf, 'StartTime',t0, 'VariableNames',{'SSC'});

for n = 2:size(SSC_L1C1, 2)
    L1C1_temp = array2timetable(SSC_L1C1(:,n), 'SampleRate',sf, 'StartTime',t0+minutes(t(n)), 'VariableNames',{'SSC'});
    L2C3_temp = array2timetable(SSC_L2C3(:,n), 'SampleRate',sf, 'StartTime',t0+minutes(t(n)), 'VariableNames',{'SSC'});
    L3C1_temp = array2timetable(SSC_L3C1(:,n), 'SampleRate',sf, 'StartTime',t0+minutes(t(n)), 'VariableNames',{'SSC'});
    L4C1_temp = array2timetable(SSC_L4C1(:,n), 'SampleRate',sf, 'StartTime',t0+minutes(t(n)), 'VariableNames',{'SSC'});
    L5C1_temp = array2timetable(SSC_L5C1(:,n), 'SampleRate',sf, 'StartTime',t0+minutes(t(n)), 'VariableNames',{'SSC'});
    L6C1_temp = array2timetable(SSC_L6C1(:,n), 'SampleRate',sf, 'StartTime',t0+minutes(t(n)), 'VariableNames',{'SSC'});

    L1C1 = [L1C1; L1C1_temp];
    L2C3 = [L2C3; L2C3_temp];
    L3C1 = [L3C1; L3C1_temp];
    L4C1 = [L4C1; L4C1_temp];
    L5C1 = [L5C1; L5C1_temp];
    L6C1 = [L6C1; L6C1_temp];
end
clear L1C1_temp L2C3_temp L3C1_temp L4C1_temp L5C1_temp L6C1_temp

% STEP 6: transform data (e.g. time averaging)
dt = minutes(10);

L1C1 = retime(L1C1, 'regular', @mean, 'TimeStep',dt);
L2C3 = retime(L2C3, 'regular', @mean, 'TimeStep',dt);
L3C1 = retime(L3C1, 'regular', @mean, 'TimeStep',dt);
L4C1 = retime(L4C1, 'regular', @mean, 'TimeStep',dt);
L5C1 = retime(L5C1, 'regular', @mean, 'TimeStep',dt);
L6C1 = retime(L6C1, 'regular', @mean, 'TimeStep',dt);

%% Visualisation
figure
plot(L1C1.Time, L1C1.SSC, 'LineWidth',2); hold on
plot(L2C3.Time, L2C3.SSC, 'LineWidth',2)
plot(L3C1.Time, L3C1.SSC, 'LineWidth',2)
plot(L4C1.Time, L4C1.SSC, 'LineWidth',2)
% plot(L5C1.Time, L5C1.SSC, 'LineWidth',2)
plot(L6C1.Time, L6C1.SSC, 'LineWidth',2)

xlabel('time (s)')
ylabel('SSC (kg m$^{-3}$)')
legend('L1C1','L2C3','L3C1','L4C1','L6C1', 'Location','northeastoutside')

%% L1C1
info = ncinfo('tailored_L1C1VEC.nc');
t = ncread('tailored_L1C1VEC.nc', 't'); % minutes since 2021-09-30 00:00:00

eta_L1C1 = ncread('tailored_L1C1VEC.nc', 'zs'); % flow velocity [m/s]
umag_L1C1 = ncread('tailored_L1C1VEC.nc', 'umag'); % flow velocity [m/s]
Hm0_L1C1 = ncread('tailored_L1C1VEC.nc', 'Hm0'); % flow velocity [m/s]

t0 = datetime('2021-09-11 00:00:00');

L1C1_b = array2timetable([eta_L1C1, umag_L1C1, Hm0_L1C1], 'TimeStep',minutes(10),...
    'StartTime',t0, 'VariableNames',{'eta', 'umag', 'Hm0'});

%% Visualisation
figure
tiledlayout(2,1, 'TileSpacing','tight')

ax1 = nexttile;
plot(L1C1_b.Time, L1C1_b.eta, 'LineWidth',2); hold on
plot(L1C1_b.Time, L1C1_b.umag, 'LineWidth',2)
plot(L1C1_b.Time, L1C1_b.Hm0, 'LineWidth',2); hold off
legend('$\eta$ (m)', 'u$_{mag}$ (m s$^{-1}$)', 'H$_{m0}$ (m)')

xlim([datetime('2021-09-30') datetime('2021-10-01')])
xticklabels ''

ax2 = nexttile;
plot(L1C1.Time, L1C1.SSC, 'LineWidth',2)

xlim([datetime('2021-09-30') datetime('2021-10-01')])
xlabel('time (s)')
ylabel('SSC (kg m$^{-3}$)')
linkaxes([ax1, ax2], 'x')
zoom xon
