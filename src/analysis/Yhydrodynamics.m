%% Initialisation
close all
clear
clc

[~, ~, ~, ~, fontsize, ~] = eurecca_init;

dataPath = [filesep 'Volumes' filesep 'T7 Shield' filesep 'Data Descriptor'];

ossi_locs = {'L1C2', 'L2C6', 'L2C8', 'L2C9', 'L4C3', 'L5C2', 'L6C2'};
adv_locs = {'L1C1', 'L2C4', 'L3C1', 'L4C1', 'L5C1', 'L6C1'};

for n = 1:length(ossi_locs)
%     addpath(genpath([dataPath filesep 'OSSI' filesep ossi_locs{n} 'OSSI' filesep 'tailored' filesep]))
    OSSIpath{n} = [filesep 'OSSI' filesep ossi_locs{n} 'OSSI' filesep 'tailored' filesep];
    ossi_info{n} = ncinfo([dataPath OSSIpath{n} ossi_locs{n} 'OSSI.nc']);
    ossi_t{n} = ncread([dataPath OSSIpath{n} ossi_locs{n} 'OSSI.nc'], 't'); % minutes since 2021-09-10 19:00:00
    h{n} = ncread([dataPath OSSIpath{n} ossi_locs{n} 'OSSI.nc'], 'd');
end

for n = 1:length(adv_locs)
%     addpath(genpath([dataPath filesep 'ADV' filesep adv_locs{n} 'VEC' filesep 'tailored_loose' filesep]))
    ADVpath{n} = [filesep 'ADV' filesep adv_locs{n} 'VEC' filesep 'tailored_loose' filesep];
    adv_info{n} = ncinfo([dataPath ADVpath{n} adv_locs{n} 'VEC.nc']);
    adv_t{n} = ncread([dataPath ADVpath{n} adv_locs{n} 'VEC.nc'], 't'); % minutes since 2021-09-10 19:00:00
    U{n} = ncread([dataPath ADVpath{n} adv_locs{n} 'VEC.nc'], 'umag');
    U_dir{n} = ncread([dataPath ADVpath{n} adv_locs{n} 'VEC.nc'], 'uang');
    Hm0{n} = ncread([dataPath ADVpath{n} adv_locs{n} 'VEC.nc'], 'Hm0');
    wave_ang{n} = ncread([dataPath ADVpath{n} adv_locs{n} 'VEC.nc'], 'svdtheta');
end

tv{1} = datetime('2021-09-11 00:00:00') + minutes(adv_t{1}); % L1C1 (til 18-Oct-2021 09:50:00)
tv{2} = datetime('2021-09-10 19:00:00') + minutes(adv_t{2}); % L2C4 (til 18-Oct-2021 04:50:00)
tv{3} = datetime('2021-09-11 00:00:00') + minutes(adv_t{3}); % L3C1 (til 18-Oct-2021 09:50:00)
tv{4} = datetime('2021-09-10 19:00:00') + minutes(adv_t{4}); % L4C1 (til 18-Oct-2021 04:50:00)
tv{5} = datetime('2021-09-11 00:00:00') + minutes(adv_t{5}); % L5C1 (til 18-Oct-2021 09:50:00)
tv{6} = datetime('2021-09-11 00:10:00') + minutes(adv_t{6}); % L6C1 (til 18-Oct-2021 10:00:00)

tv{7} = datetime('2021-09-10 19:00:00') + minutes(ossi_t{1}); % L1C2 (til 18-Oct-2021 09:50:00)

p{1} = 2:5358;
p{2} = 32:5388;
p{3} = p{1};
p{4} = p{2};
p{5} = p{1};
p{6} = 1:5357;

p{7} = 32:5388; % ossi

p{8} = 146:5502; % sontek

%% SONTEK
addpath('/Users/jwb/Library/CloudStorage/OneDrive-UniversiteitUtrecht/GitHub/sedmex/results/ADV/SonTek')
load baseParameters_10min_L2C5_SON1.mat

U_sontek = sqrt(L2C5_SON1_par(:, 11).^2 + L2C5_SON1_par(:, 12).^2); % mean horizontal velocity
U_sontek(U_sontek > .8) = NaN;

%%
taxis = tv{6}(1):minutes(10):tv{6}(5357);
taxis2 = tv{7}(32):minutes(10):tv{7}(5388);
h = h{7}(p{7});

U_75 = [U{1}(p{1}), U{2}(p{2}), U{3}(p{3}), U{4}(p{4}), U{5}(p{5}), U{6}(p{6})];
% U_75 = [U{1}(p{1}), U_sontek(p{8}), U{3}(p{3}), U{4}(p{4}), U{5}(p{5}), U{6}(p{6})];
U_75(any(isnan(U_75), 2), :) = NaN; % only if all instruments have measured
U_75 = fliplr(U_75);

U_dir_75 = [U_dir{1}(p{1}), U_dir{2}(p{2}), U_dir{3}(p{3}), U_dir{4}(p{4}), U_dir{5}(p{5}), U_dir{6}(p{6})];
U_dir_75(any(isnan(U_dir_75), 2), :) = NaN; % only if all instruments have measured
U_dir_75 = fliplr(U_dir_75);

Hm0_75 = [Hm0{1}(p{1}), Hm0{2}(p{2}), Hm0{3}(p{3}), Hm0{4}(p{4}), Hm0{5}(p{5}), Hm0{6}(p{6})];
Hm0_75(any(isnan(Hm0_75), 2), :) = NaN; % only if all instruments have measured
Hm0_75 = fliplr(Hm0_75);

wave_ang_75 = [wave_ang{1}(p{1}), wave_ang{2}(p{2}), wave_ang{3}(p{3}), wave_ang{4}(p{4}), wave_ang{5}(p{5}), wave_ang{6}(p{6})];
wave_ang_75(any(isnan(wave_ang_75), 2), :) = NaN; % only if all instruments have measured
wave_ang_75 = fliplr(wave_ang_75);

% adv_locs{2} = 'L2C5*';
adv_locs = fliplr(adv_locs);

%% Calculations
% for n = 1:length(locations)
% 
%     Vr{n} = ncread([locations{n} 'VEC.nc'], 'ud_mean');      % time- and depth-averaged velocity
%     Udelta{n} = ncread([locations{n} 'VEC.nc'], 'ud_ssm');   % peak near-bed orbital velocity
% %     Udelta{n} = Udelta{n}*2;                                 % factor difference between L2C3 and L2C10
%     T{n} = ncread([locations{n} 'VEC.nc'], 'Tm01');          % wave period
%     h{n} = ncread([locations{n} 'VEC.nc'], 'd');             % water depth
% %     h{n} = h{n}-1;                                           % depth difference between L2C6 and L2C3
%     h{n}(h{n}<0.1) = NaN;
%     D50{n} = 0.8e-3;                                         % median grain diameter of the sediment
%     rhos{n} = 2650;                                          % sediment density
%     rhow{n} = 1025;                                          % water density
%     
%     [fw{n}, TauC{n}, ThetaC{n}, TauW{n}, ThetaW{n}, TauM{n}, ThetaM{n}, TauCW{n}, ...
%         ThetaCW{n}, UstarW{n}, UstarCW{n}] = bedshearstresses(Vr{n}, Udelta{n},...
%         T{n}, h{n}, D50{n}, rhos{n}, rhow{n});
% 
% end

%% Visualisation
f = figure2;
tiledlayout(5, 1, 'TileSpacing','tight')

% nexttile
% boxchart(U_75, 'Notch', 'on')
% hold on
% plot(mean(U_75, 'omitnan'), '-o', 'LineWidth', 2)
% hold off
% % set(gca,'xticklabel',{[]})
% ylabel('U (m s$^{-1}$)')
% ylim([0 .6])
% xticklabels(adv_locs)
% legend('velocity data', 'mean velocity')

nexttile
plot(taxis2, h)
ylabel('h (m + NAP)')
legend(ossi_locs{1}, 'Orientation', 'horizontal', 'Location', 'northoutside')
axis tight

nexttile
plot(taxis, U_75, 'o')
ylabel('U (m s$^{-1}$)')
legend(adv_locs, 'Orientation', 'horizontal', 'Location', 'northoutside')
axis tight

nexttile
plot(taxis, U_dir_75, 'o')
ylabel('U$_{dir}$ (deg)')
% legend(adv_locs, 'Orientation', 'horizontal', 'Location', 'northoutside')
axis tight

nexttile
plot(taxis, Hm0_75, 'o')
ylabel('H$_{m0}$ (m)')
% legend(adv_locs, 'Orientation', 'horizontal', 'Location', 'northoutside')
axis tight

nexttile
plot(taxis, wave_ang_75, 'o')
ylabel('wave angle (deg)')
% legend(adv_locs, 'Orientation', 'horizontal', 'Location', 'northoutside')
axis tight

% exportgraphics(f, '/Users/jwb/Library/CloudStorage/Dropbox/Apps/Overleaf/MDPI Article 1 (draft)/Figures/fig8.pdf')

%% Visualisation
% f = figure2;
% tiledlayout(2, 3)
% 
% nexttile
% plot(taxis2, h)
% ylabel('h (m + NAP)')
% legend(ossi_locs{1}, 'Orientation', 'horizontal', 'Location', 'northoutside')
% axis tight
% 
% nexttile([2 2])
% boxchart(U_75, 'Notch', 'on')
% hold on
% plot(mean(U_75, 'omitnan'), '-o', 'LineWidth', 2)
% hold off
% % set(gca,'xticklabel',{[]})
% ylabel('U (m s$^{-1}$)')
% ylim([0 .6])
% xticklabels(adv_locs)
% legend('velocity data', 'mean velocity')
% 
% nexttile
% plot(taxis, U_75)
% ylabel('U (m s$^{-1}$)')
% legend(adv_locs, 'Orientation', 'horizontal', 'Location', 'northoutside')
% axis tight

% exportgraphics(f, '/Users/jwb/Library/CloudStorage/Dropbox/Apps/Overleaf/MDPI Article 1 (draft)/Figures/fig7.pdf')
% exportgraphics(f, 'fig7.pdf', 'BackgroundColor', 'none', 'ContentType', 'vector')

%%
% %% L2C10
% start = datetime('2021-09-10 19:00:00'); % UTC+2
% 
% L2C10VEC = ncinfo(file1);
% t1 = ncread(file1, 't'); % minutes since 2021-09-10 19:00:00
% U = ncread(file1, 'umag');
% Hm0_vec = ncread(file1, 'Hm0');
% 
% L2C10SOLO = ncinfo(file2);
% t2 = ncread(file2, 't'); % milliseconds since 2021-09-10
% z = ncread(file2, 'pm');
% z = z/10000; % Pa to m
% Hm0_solo = ncread(file2, 'Hm0');
% 
% L2C4SOLO = ncinfo(file3);
% t3 = ncread(file3, 't'); % milliseconds since 2021-09-10
% 
% L2C6OSSI = ncinfo(file4);
% z = ncread(file2, 'zs');
% Hm0_ossi = ncread(file2, 'Hm0');
% 
% tv1 = (start:minutes(10):start+minutes(t1(end)))';
% tv2 = datetime(t2/1000, 'ConvertFrom', 'epochtime', 'Epoch', '2021-09-10 19:00:00');
% tv3 = datetime(t3/1000, 'ConvertFrom', 'epochtime', 'Epoch', '2021-09-10 19:00:00');
% 
% %% Calculations
% from = '2021-09-16 00:00:00';
% to = '2021-10-16 00:00:00';
% 
% p1 = (tv1 >= datetime(from)) & (tv1 <= datetime(to));
% p2 = (tv2 >= datetime(from)) & (tv2 <= datetime(to));
% p3 = (tv3 >= datetime(from)) & (tv3 <= datetime(to));
% 
% Vr = ncread(file1, 'ud_mean');      % time- and depth-averaged velocity
% Udelta = ncread(file1, 'ud_ssm');   % peak near-bed orbital velocity
% Udelta = Udelta*2;                  % factor difference between L2C3 and L2C10
% T = ncread(file4, 'Tm01');          % wave period
% h = ncread(file4, 'd');             % water depth
% h = h-1;                            % depth difference between L2C6 and L2C3
% h(h<0.1) = NaN;
% D50 = 0.8e-3;                       % median grain diameter of the sediment
% rhos = 2650;                        % sediment density
% rhow = 1025;                        % water density
% 
% [fw, TauC, ThetaC, TauW, ThetaW, TauM, ThetaM, TauCW, ...
%     ThetaCW, UstarW, UstarCW] = bedshearstresses(Vr, Udelta,...
%     T, h, D50, rhos, rhow);
% 
% %% Visualisation
% f = figure2;
% tiledlayout(3, 1, 'TileSpacing', 'tight')
% 
% ax(1) = nexttile;
% plot(tv1(p1), z(p1))
% set(gca,'xticklabel',{[]})
% ylabel('z (m +NAP)')
% ylim([-1.5, 1.5])
% 
% ax(2) = nexttile;
% plot(tv1(p1), U(p1))
% set(gca,'xticklabel',{[]})
% ylabel('U_{mag} (m s^{-1})')
% 
% ax(3) = nexttile;
% plot(tv1(p1), Hm0_ossi(p1))
% ylabel('H_{m0} (m)')
% 
% xlim(ax, [min(tv1(p1)) max(tv1(p1))])
% linkaxes(ax, 'x')
% grid(ax, "on")
% 
% % exportgraphics(f, 'L2C10_conditions.png')
% 
% %%
% f = figure2;
% tiledlayout(3, 1, 'TileSpacing', 'tight')
% 
% ax(1) = nexttile;
% plot(tv1(p1), z(p1), 'LineWidth', 2)
% set(gca,'xticklabel',{[]})
% ylabel('z (m +NAP)')
% ylim([-1.5, 1.5])
% 
% ax(2) = nexttile;
% plot(tv1(p1), TauC(p1), 'LineWidth', 2); hold on
% plot(tv1(p1), TauW(p1), 'LineWidth', 2)
% plot(tv1(p1), TauCW(p1), 'LineWidth', 2)
% set(gca,'xticklabel',{[]})
% ylabel('\tau (N m^{-2})')
% legend('\tau_{c}', '\tau_{w}', '\tau_{cw}', 'Location', 'northeast')
% 
% ax(3) = nexttile;
% plot(tv1(p1), Hm0_ossi(p1), 'LineWidth', 2)
% ylabel('H_{m0} (m)')
% 
% xlim(ax, [min(tv1(p1)) max(tv1(p1))])
% linkaxes(ax, 'x')
% grid(ax, "on")
% 
% % exportgraphics(f, 'L2_conditions.png')
