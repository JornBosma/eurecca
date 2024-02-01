%% Initialisation
close all
clear
clc

[~, fontsize, ~, ~, ~] = eurecca_init;
% fontsize = 38; % ultra-wide screen

dataPath = [filesep 'Volumes' filesep 'T7 Shield' filesep 'DataDescriptor' filesep 'hydrodynamics' filesep];

% addpath('/Users/jwb/Local_NoSync/OET/matlab/')
% oetsettings('quiet')

locs = {'L6', 'L5', 'L4', 'L3', 'L2', 'L1'};

locs_extended_adv = locs(1:3);
locs_extended_adv{4} = '';
locs_extended_adv{5} = 'L3';
locs_extended_adv{6} = 'L2';
locs_extended_adv{7} = 'L1';

locs_extended_adv2 = locs(1:3);
locs_extended_adv2{4} = '';
locs_extended_adv2{5} = 'L3';
locs_extended_adv2{6} = '';
locs_extended_adv2{7} = 'L1';

locs_extended_ossi = locs(1:3);
locs_extended_ossi{4} = '';
locs_extended_ossi{5} = '';
locs_extended_ossi{6} = '';
locs_extended_ossi{7} = 'L2';
locs_extended_ossi{8} = 'L1';


%% Load ADV data
adv_locs = {'L6C1', 'L5C1', 'L4C1', 'L3C1', 'L2C5', 'L1C1'};

% t_start = datetime('2021-09-01 00:00:00');

for n = 1:length(adv_locs)
    if n == 5
        ADVpath{n} = [dataPath 'ADV' filesep adv_locs{n} 'SONTEK1' filesep 'tailored_' adv_locs{n} 'SONTEK1.nc'];
        info_adv.(adv_locs{n}) = ncinfo(ADVpath{n});
        t_adv{n} = ncread(ADVpath{n}, 't'); % seconds since 2021-09-01 00:00:00
        U_adv{n} = ncread(ADVpath{n}, 'umag');
        Uang_adv{n} = ncread(ADVpath{n}, 'uang');
        hab_adv{n} = ncread(ADVpath{n}, 'h');
        zb_adv{n} = ncread(ADVpath{n}, 'zb');
        % Hm0_adv{n} = ncread(ADVpath{n}, 'Hm0');
    else
        ADVpath{n} = [dataPath 'ADV' filesep adv_locs{n} 'VEC' filesep 'tailored_' adv_locs{n} 'VEC.nc'];
        info_adv.(adv_locs{n}) = ncinfo(ADVpath{n});
        t_adv{n} = ncread(ADVpath{n}, 't'); % seconds since 2021-09-01 00:00:00
        U_adv{n} = ncread(ADVpath{n}, 'umag');
        Uang_adv{n} = ncread(ADVpath{n}, 'uang');
        hab_adv{n} = ncread(ADVpath{n}, 'h');
        zb_adv{n} = ncread(ADVpath{n}, 'zb');
        Hm0_adv{n} = ncread(ADVpath{n}, 'Hm0');
    end

    % Checks if measurement volume is not buried
    U_adv{n}(hab_adv{n} < .05) = NaN;
    U_adv{n}(U_adv{n} < .002) = NaN;
    Uang_adv{n}(hab_adv{n} < .05) = NaN;
    Uang_adv{n}(U_adv{n} < .002) = NaN;
    Hm0_adv{n}(hab_adv{n} < .05) = NaN;
    Hm0_adv{n}(U_adv{n} < .002) = NaN;
end


%% Select useful data from equal periods

% Step 1: Find the length of the shortest array
minLength = min(cellfun(@length, U_adv));

% Step 2: Truncate each array in the cell array
U_adv = cellfun(@(x) x(1:minLength), U_adv, 'UniformOutput',false);
Uang_adv = cellfun(@(x) x(1:minLength), Uang_adv, 'UniformOutput',false);
hab_adv = cellfun(@(x) x(1:minLength), hab_adv, 'UniformOutput',false);
Hm0_adv = cellfun(@(x) x(1:minLength), Hm0_adv, 'UniformOutput',false);
Hm0_adv{:,5} = Hm0_adv{:,5}';

U = cell2mat(U_adv);
Uang = cell2mat(Uang_adv);
hab = cell2mat(hab_adv);
Hm0 = cell2mat(Hm0_adv);

% Step 1: Identify rows with NaNs
rowsWithNaNs = any(isnan(U), 2);

% Step 2: Remove these rows
U_clean = U(~rowsWithNaNs, :);
Uang_clean = Uang(~rowsWithNaNs, :);
hab_clean = hab(~rowsWithNaNs, :);
Hm0_clean = Hm0(~rowsWithNaNs, :);


%% Check 'time series'
figureRH;
tiledlayout(2,1)

nexttile
plot(U_clean(1000:end,:), 'LineWidth',2)
legend(adv_locs, "Location","northeastoutside")

nexttile
plot(Hm0_clean(1000:end,:), 'LineWidth',2)
zoom xon


%% Calculations
% Vr = U_clean;  % time- and depth-averaged velocity [m/s]
% Udelta = ;  % peak near-bed orbital velocity [m/s]
% T = ;  % wave period [s]
% h = ;  % water depth [m]
% D50 = 1e-3;  % median grain diameter of the sediment [m]
% rhos = 2650;  % sediment density [kg/m^3]
% rhow = 1025;  % water density [kg/m^3]
% 
% [fw, TauC, ThetaC, TauW, ThetaW, TauM, ThetaM, TauCW, ...
%     ThetaCW, UstarW, UstarCW] = bedshearstresses(Vr, Udelta, T, h, ...
%     D50, rhos, rhow);


%% Box plot: longshore distribution time-average flow velocity
U_clean_box = [U_clean(:,1:3), NaN(length(U_clean),1), U_clean(:,4:6)];

f1a = figure('Position',[1401 844 2040 493]);
boxchart(U_clean_box)  % , 'MarkerStyle','none' (no outliers)
set(gca,'xticklabel',[])
ylabel('U (m s^{-1})')
ylim([0 .55])
xticklabels(locs_extended_adv)
set(gca, 'TickLength', [0 0]);  % Hide x-tick lines


%% Box plot: longshore distribution time-average wave height
Hm0_clean_box = [Hm0_clean(:,1:3), NaN(length(Hm0_clean),1), Hm0_clean(:,4:6)];

f1b = figure('Position',[1401 844 2040 493]);
boxchart(Hm0_clean_box, 'MarkerStyle','none')  % no outliers
set(gca,'xticklabel',[])
ylabel('H_{m0} (m)')
ylim([0 .55])
xticklabels(locs_extended_adv2)
set(gca, 'TickLength', [0 0]);  % Hide x-tick lines


%% Polar histograms

% Preallocate a 1x6 array of Axes objects
ax = gobjects(1, size(U_clean, 2));

% f2 = figureRH;
f2 = figure(Position=[1961 414 1480 923]);
tiledlayout(2, 3, "TileSpacing","none");
for i = 1:size(U_clean, 2)
    ax(i) = nexttile; plot([],[]);
    Options = CurrentRoseOptions(24);
    % WindRose(Uang_clean(:,i), U_clean(:,i), 'axes',gca, 'cmap',crameri('-roma'), 'legendtype',0);
    WindRose(Uang_clean(:,i), U_clean(:,i), Options)
    camroll(-46)  % Rotate diagrams to match contour map orientation
end
% legend(ax(2), 'off')
% legend(ax(3), 'off')
% legend(ax(5), 'off')
% legend(ax(6), 'off')


%% Load OSSI data
ossi_locs = {'L6C2', 'L5C2', 'L4C3', 'L2C9', 'L1C2'};

% t_start = datetime('2021-09-01 00:00:00');

for n = 1:length(ossi_locs)
    OSSIpath{n} = [dataPath 'pressuresensors' filesep ossi_locs{n} 'OSSI' filesep 'tailored_' ossi_locs{n} 'OSSI.nc'];
    info_ossi.(ossi_locs{n}) = ncinfo(OSSIpath{n});
    t_ossi{n} = ncread(OSSIpath{n}, 't'); % minutes since 2021-09-10 19:00:00
    zb_ossi{n} = ncread(OSSIpath{n}, 'zb');
    Hm0_ossi{n} = ncread(OSSIpath{n}, 'Hm0');
end

Hm0 = cell2mat(Hm0_ossi);


%% Check 'time series'
figureRH;
plot(Hm0(1000:end,:), 'LineWidth',2)
legend(ossi_locs, "Location","northeastoutside")
zoom xon


%% Box plot: longshore distribution time-average wave height
Hm0_box = [Hm0(:,1:3), NaN(length(Hm0),3), Hm0(:,4:5)];

f1 = figure('Position',[1722 892 1719 445]);
boxchart(Hm0_box, 'MarkerStyle','none', 'BoxWidth',.2)  % no outliers
set(gca,'xticklabel',[])
ylabel('H_{m0} (m)')
ylim([0 .42])
get(gca, 'XTick');
xticklabels(locs_extended_ossi)
set(gca, 'TickLength', [0 0]);  % Hide x-tick lines

