%% Initialisation
close all
clear
clc

[~, fontsize, cbf, ~, ~] = eurecca_init;
% fontsize = 30; % ultra-wide screen

dataPath = [filesep 'Volumes' filesep 'T7 Shield' filesep 'DataDescriptor' filesep 'hydrodynamics' filesep];

% addpath('/Users/jwb/Local_NoSync/OET/matlab/')
% oetsettings('quiet')

sampling_dates = [datetime('20-Sep-2021'), datetime('28-Sep-2021'),...
    datetime('01-Oct-2021'), datetime('07-Oct-2021'), datetime('15-Oct-2021')];

sampling_window = [sampling_dates', sampling_dates'];
for i = 1:length(sampling_dates)
    sampling_window(i,:) = [sampling_dates(i)+hours(8), sampling_dates(i)+hours(19)];
end

Xlim = [sampling_dates(1)-days(1), sampling_dates(end)+days(1)];


%% Load ADV data
ADVs = {'L2C2VEC', 'L2C3VEC', 'L2C4VEC', 'L2C5SONTEK1', 'L2C5SONTEK2', 'L2C5SONTEK3'};

tables = cell(size(ADVs));
timetables = tables;
for n = 1:length(ADVs)
    ADVpath = [dataPath 'ADV' filesep ADVs{n} filesep 'tailored_' ADVs{n} '.nc'];
    info_nc.(ADVs{n}) = ncinfo(ADVpath);
    elapsed_secs = ncread(ADVpath, 't'); % seconds since 2021-09-01 00:00:00
    flow_magnitude = ncread(ADVpath, 'umag');
    flow_direction = ncread(ADVpath, 'uang');
    rms_orbital = ncread(ADVpath, 'u_ssm');
    height_above_bed = ncread(ADVpath, 'h');
    bed_level = ncread(ADVpath, 'zb');
    water_level = ncread(ADVpath, 'zs');

    time = datetime('2021-09-01 00:00:00','InputFormat','yyyy-MM-dd HH:mm:ss')+seconds(elapsed_secs);
    tables{n} = table(time, flow_magnitude, flow_direction, rms_orbital, height_above_bed, bed_level, water_level);
    timetables{n} = table2timetable(tables{n});
end

clearvars ADVpath dataPath bed_level elapsed_secs flow_direction flow_magnitude height_above_bed time n tables rms_orbital water_level


%% Slice timetables

% Loop through each timetable and slice it
for i = 1:length(timetables)
    currentTimeTable = timetables{i};

    % Find rows within the specific time range
    timeRange = (currentTimeTable.time >= Xlim(1)) & (currentTimeTable.time <= Xlim(2));

    % Slice the timetable
    timetables{i} = currentTimeTable(timeRange, :);
end


%% Visualisation: flow magnitude
figureRH;
tl = tiledlayout(length(ADVs),1, 'TileSpacing','tight');

ax = gobjects(1, length(ADVs));
for i = 1:length(ADVs)
    ax(i) = nexttile;
    plot(timetables{i}.time, timetables{i}.flow_magnitude,...
        'Color',cbf.blue, 'LineWidth',3)
    xregion(sampling_window(:,1), sampling_window(:,2))

    title(string(ADVs{i}), "FontSize",fontsize/2)
    xlim(Xlim)
    ylim([0, .5])
end

ylabel(tl, 'flow magnitude (m s^{-1})', 'Fontsize',fontsize)
xticklabels(ax(1:end-1), [])


%% Visualisation: flow direction
figureRH;
tl = tiledlayout(length(ADVs),1, 'TileSpacing','tight');

ax = gobjects(1, length(ADVs));
for i = 1:length(ADVs)
    ax(i) = nexttile;
    scatter(timetables{i}.time, timetables{i}.flow_direction, 20, 'filled',...
        'Color',cbf.blue, 'LineWidth',3)
    xregion(sampling_window(:,1), sampling_window(:,2))

    title(string(ADVs{i}), "FontSize",fontsize/2)
    xlim(Xlim)
    ylim([-180, 180])
    yticks(-180:90:180)
end

ylabel(tl, 'flow direction (deg N)', 'Fontsize',fontsize)
xticklabels(ax(1:end-1), [])


%% Visualisation: rms total orbital velocity
figureRH;
tl = tiledlayout(length(ADVs),1, 'TileSpacing','tight');

ax = gobjects(1, length(ADVs));
for i = 1:length(ADVs)
    ax(i) = nexttile;
    plot(timetables{i}.time, timetables{i}.rms_orbital,...
        'Color',cbf.blue, 'LineWidth',3)
    xregion(sampling_window(:,1), sampling_window(:,2))

    title(string(ADVs{i}), "FontSize",fontsize/2)
    xlim(Xlim)
    ylim([0, .4])
end

ylabel(tl, 'rms orbital velocity (m s^{-1})', 'Fontsize',fontsize)
xticklabels(ax(1:end-1), [])


%% Visualisation: height above bed
figureRH;
tl = tiledlayout(length(ADVs),1, 'TileSpacing','tight');

ax = gobjects(1, length(ADVs));
for i = 1:length(ADVs)
    ax(i) = nexttile;
    plot(timetables{i}.time, timetables{i}.height_above_bed,...
        'Color',cbf.blue, 'LineWidth',3)
    xregion(sampling_window(:,1), sampling_window(:,2))

    title(string(ADVs{i}), "FontSize",fontsize/2)
    xlim(Xlim)
    ylim([0, .8])
end

ylabel(tl, 'height above bed (m)', 'Fontsize',fontsize)
xticklabels(ax(1:end-1), [])


%% Visualisation: bed level
figureRH;
tl = tiledlayout(length(ADVs),1, 'TileSpacing','tight');

ax = gobjects(1, length(ADVs));
for i = 1:length(ADVs)
    ax(i) = nexttile;
    plot(timetables{i}.time, timetables{i}.bed_level,...
        'Color',cbf.blue, 'LineWidth',3)
    xregion(sampling_window(:,1), sampling_window(:,2))

    title(string(ADVs{i}), "FontSize",fontsize/2)
    xlim(Xlim)
    ylim([-1.1, .3])
end

ylabel(tl, 'bed level (NAP+m)', 'Fontsize',fontsize)
xticklabels(ax(1:end-1), [])


%% Visualisation: water level
figureRH;
tl = tiledlayout(length(ADVs),1, 'TileSpacing','tight');

ax = gobjects(1, length(ADVs));
for i = 1:length(ADVs)
    ax(i) = nexttile;
    plot(timetables{i}.time, timetables{i}.water_level,...
        'Color',cbf.blue, 'LineWidth',3)
    xregion(sampling_window(:,1), sampling_window(:,2))

    title(string(ADVs{i}), "FontSize",fontsize/2)
    xlim(Xlim)
    ylim([-.5, 1.4])
end

ylabel(tl, 'water level (NAP+m)', 'Fontsize',fontsize)
xticklabels(ax(1:end-1), [])

