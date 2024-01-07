%% Initialisation
close all
clear
clc

[~, ~, ~, ~, ~] = eurecca_init;

monitoring_period = [datetime('01-Jan-2019'), datetime('01-Jan-2023')];
SEDMEX_period = [datetime('10-Sep-2021'), datetime('19-Oct-2021')];
L2_sampling_period = [datetime('19-Sep-2021'), datetime('08-Oct-2021')];


%% Oudeschild water levels

% Load Oudeschild buoy measurements
Oudeschild = readtable('20230904_029.csv', 'Range','V1:Y213210', 'VariableNamingRule','preserve');
Oudeschild.('LIMIETSYMBOOL') = []; % superfluous
Oudeschild.NUMERIEKEWAARDE(Oudeschild.NUMERIEKEWAARDE>=999) = NaN; % error code

Oudeschild = renamevars(Oudeschild,'WAARNEMINGDATUM','date');
Oudeschild = renamevars(Oudeschild,'WAARNEMINGTIJD (MET/CET)','time');
Oudeschild = renamevars(Oudeschild,'NUMERIEKEWAARDE','eta');

Oudeschild.date = datetime(Oudeschild.date, 'InputFormat','dd-MM-yyyy');
Oudeschild.DateTime = Oudeschild.date + Oudeschild.time;
Oudeschild = removevars(Oudeschild, {'date','time'});

Oudeschild.eta = Oudeschild.eta/100; % convert cm to m
Oudeschild = table2timetable(Oudeschild);


%% Water levels over period P

% Define period
P = L2_sampling_period;

% Select data within period of interest
tidal_elevation_data = Oudeschild.eta(Oudeschild.DateTime >...
    P(1) & Oudeschild.DateTime < P(2));

% Calculate Mean Water Level
mean_water_level = mean(tidal_elevation_data, "omitmissing");

% Define Minimum Peak Prominence
min_peak_prominence = 0.5; % Adjust this value based on your data

% Identify High and Low Tides with Minimum Peak Prominence
[high_tides, high_tide_indices] = findpeaks(tidal_elevation_data, 'MinPeakProminence', min_peak_prominence);
[low_tides, low_tide_indices] = findpeaks(-tidal_elevation_data, 'MinPeakProminence', min_peak_prominence);
low_tides = -low_tides; % Correcting the sign for low tides

% Calculate Mean, Max and Min High and Low Water Levels
mean_high_water_level = mean(high_tides);
mean_low_water_level = mean(low_tides);
max_high_water_level = max(high_tides);
max_low_water_level = max(low_tides);
min_high_water_level = min(high_tides);
min_low_water_level = min(low_tides);

% Initialize arrays for tidal ranges
tidal_ranges = [];

% Loop through high tides to find corresponding low tides and calculate ranges
for i = 1:length(high_tide_indices)
    % Find the next low tide after the current high tide
    next_low_tide_index = find(low_tide_indices > high_tide_indices(i), 1);
    
    % Check if a corresponding low tide exists
    if ~isempty(next_low_tide_index)
        % Calculate the tidal range
        range = high_tides(i) - low_tides(next_low_tide_index);
        
        % Store the tidal range
        tidal_ranges = [tidal_ranges, range];
    end
end

% Calculate maximum, minimum, and mean tidal range
max_tidal_range = max(tidal_ranges);
min_tidal_range = min(tidal_ranges);
mean_tidal_range = mean(tidal_ranges);

% Display the calculated values
disp(['@Oudeschild from ', datestr(P(1)), ' to ', datestr(P(2)), ':'])
disp(['Mean Water Level: ', num2str(mean_water_level, 3)]);
disp(['Mean High Water Level: ', num2str(mean_high_water_level, 3)]);
disp(['Mean Low Water Level: ', num2str(mean_low_water_level, 3)]);
disp(['Mean Tidal Range: ', num2str(mean_tidal_range, 3)]);
disp(['Max High Water Level: ', num2str(max_high_water_level, 3)]);
disp(['Max Low Water Level: ', num2str(max_low_water_level, 3)]);
disp(['Max Tidal Range: ', num2str(max_tidal_range, 3)]);
disp(['Min High Water Level: ', num2str(min_high_water_level, 3)]);
disp(['Min Low Water Level: ', num2str(min_low_water_level, 3)]);
disp(['Min Tidal Range: ', num2str(min_tidal_range, 3)]);
disp('__________________________________________________________')

% Plotting (Optional)
figureRH;
plot(tidal_elevation_data);
hold on;
plot([1 length(tidal_elevation_data)], [mean_water_level mean_water_level], 'k--', 'LineWidth', 2);
plot(high_tide_indices, high_tides, 'r^', 'MarkerFaceColor', 'r'); % High tides
plot(low_tide_indices, low_tides, 'bv', 'MarkerFaceColor', 'b'); % Low tides
hold off;
xlabel('Time');
ylabel('Tidal Elevation');
title(['@Oudeschild from ', datestr(P(1)), ' to ', datestr(P(2)), ':']);
legend('Tidal Data', 'Mean Water Level', 'High Tides', 'Low Tides');

