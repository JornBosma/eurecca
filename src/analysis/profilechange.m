%% Initialisation
close all
clear
clc

[~, ~, ~, ~, fontsize] = eurecca_init;

% basePath = [filesep 'Volumes' filesep 'geo.data.uu.nl' filesep ...
%     'research-eurecca' filesep 'FieldVisits' filesep ...
%     '20210908_SEDMEX' filesep 'Data Descriptor'];

dataPath = [filesep 'Volumes' filesep 'T7 Shield' filesep 'Data Descriptor'];

for n = 1:7
    file{n} = [dataPath, '/TRANSECTS/field_visits_projected_netcdf/alleen_loop/track' num2str(n-1) '.nc'];
    track{n} = ncinfo(file{n});
    x{n} = ncread(file{n}, 'x'); % xRD [m]
    y{n} = ncread(file{n}, 'y'); % yRD [m]
    d{n} = ncread(file{n}, 'd'); % x-shore distance [m]
    profiles{n} = ncread(file{n}, '__xarray_dataarray_variable__'); % depth [m]
    ID{n} = ncread(file{n}, 'ID'); % profile ID (seconds since 2020-10-16 12:56:53)
    range{n} = 1:length(ID{n});
end

date{1} = datetime(ID{1}, 'ConvertFrom','epochtime','Epoch','2020-10-16 12:30:59', 'Format','yyyy-MM-dd');
date{2} = datetime(ID{2}, 'ConvertFrom','epochtime','Epoch','2020-10-16 12:56:53', 'Format','yyyy-MM-dd');
date{3} = datetime(ID{3}, 'ConvertFrom','epochtime','Epoch','2020-10-16 13:13:15', 'Format','yyyy-MM-dd');
date{4} = datetime(ID{4}, 'ConvertFrom','epochtime','Epoch','2020-10-16 13:27:09', 'Format','yyyy-MM-dd');
date{5} = datetime(ID{5}, 'ConvertFrom','epochtime','Epoch','2020-10-16 13:41:35', 'Format','yyyy-MM-dd');
date{6} = datetime(ID{6}, 'ConvertFrom','epochtime','Epoch','2020-10-16 13:57:36', 'Format','yyyy-MM-dd');
date{7} = datetime(ID{7}, 'ConvertFrom','epochtime','Epoch','2020-10-16 14:29:55', 'Format','yyyy-MM-dd');

% remove erroneous measurements
profiles{5}(:,18) = NaN;
profiles{5}(:,26) = NaN;

% colourblind-friendly colours
orange = [230/255, 159/255, 0];
blue = [86/255, 180/255, 233/255];
yellow = [240/255, 228/255, 66/255];
redpurp = [204/255, 121/255, 167/255];
bluegreen = [0, 158/255, 115/255];

%% Long-term monitoring
surv{1} = [1 2 3 4 24 25 26 27];
surv{2} = [1 2 4 6 27 28 29 30];
surv{3} = [1 2 3 5 25 26 27 28];
surv{4} = [1 2 4 6 07 08 09 10];
surv{5} = [1 2 3 5 26 27 28 29];
surv{6} = [1 2 3 5 25 26 27 28];
surv{7} = [1 2 3 5 25 26 27 28];

% date check
for n = 1:7
    date_check(:,n) = date{n}(surv{n});
end

%% Calculations
% smooth profiles and centre around intersection with z=0
X = 50;
m = 1;
% for n = 1:7
for n = [1:3 5:7] % discard track 4
    prof_smooth{m} = movmean(profiles{n}(:, surv{n}), 3, 1, 'omitnan');
    idx_0 = find(prof_smooth{m} >= 0, 1, 'first');
    prof_centred{m} = prof_smooth{m}(idx_0-X:idx_0+X, :);

    for p = 1:width(prof_centred{m})
        idx_LW = find(prof_centred{m}(:,p) >= -1, 1, 'first');
        if isempty(idx_LW)
            idx_LW = find(prof_centred{m}(:,p) == min(prof_centred{m}(:,p))); % if max > -1, then find idx of min
        end

        idx_MW = find(prof_centred{m}(:,p) >= 0, 1, 'first');

        idx_HW = find(prof_centred{m}(:,p) >= 1, 1, 'first');
        if isempty(idx_HW)
            idx_HW = find(prof_centred{m}(:,p) == max(prof_centred{m}(:,p))); % if max < 1, then find idx of max
        end
        slope_LW = gradient(prof_centred{m}(idx_LW:idx_MW, p));
        meanSlope_LW{m}(p) = 1/mean(slope_LW, 'omitnan');
        slope_HW = gradient(prof_centred{m}(idx_MW:idx_HW, p));
        meanSlope_HW{m}(p) = 1/mean(slope_HW, 'omitnan');
    end

    m = m+1;
end
clear idx_0 idx_LW idx_MW idx_HW m n p

% manual corrections
meanSlope_HW{5}(5) = NaN;
meanSlope_HW{6}(3) = NaN;
meanSlope_LW{6}(3) = NaN;
meanSlope_LW{6}(5) = NaN;

%% Visualisation: profile evolution L1 & L4
% tracknames = {'L$_1$','L$_2$','L$_3$','L$_{3.5}$','L$_4$','L$_5$','L$_6$'};
tracknames = {'L$_1$','L$_2$','L$_3$','L$_4$','L$_5$','L$_6$'};

f1a = figure;

m = 1;
tiledlayout(1,2, 'TileSpacing','tight')
for n = [4 1]
    axs{m} = nexttile; % Ln
    plot(prof_centred{n}, 'LineWidth', 2); hold on
    text(2, 1.8, tracknames{n}, 'FontSize',fontsize, 'EdgeColor','k')

    yline(0,'-.')
    yline([-1 1],'--')
    % fill([0 X*2 X*2 0], [0 0 1 1], 'g', 'LineStyle','none', 'FaceAlpha',.05)
    area(0:X*2, ones(1,length(prof_centred{n})), 'FaceColor',yellow, 'FaceAlpha',0.1, 'EdgeColor','none')
    text(X-40,.75, ['$\Delta_{first}$ = 1:',mat2str(meanSlope_HW{n}(1),2)], 'FontSize',fontsize/1.2)
    text(X-40,.25, ['$\Delta_{last}$',repmat('\ ',1,2), '= 1:',mat2str(meanSlope_HW{n}(end),2)], 'FontSize',fontsize/1.2)

    % fill([0 X*2 X*2 0], [0 0 -1 -1], 'm', 'LineStyle','none', 'FaceAlpha',.05)
    area(0:X*2, ones(1,length(prof_centred{n}))*-1, 'FaceColor',bluegreen, 'FaceAlpha',0.1, 'EdgeColor','none')
    text(X+20,-.25, ['$\Delta_{first}$ = 1:',mat2str(meanSlope_LW{n}(1),2)], 'FontSize',fontsize/1.2)
    text(X+20,-.75, ['$\Delta_{last}$',repmat('\ ',1,2), '= 1:',mat2str(meanSlope_LW{n}(end),2)], 'FontSize',fontsize/1.2)

    xlim([0 X*2])
    ylim([-2, 2])
    xticks(10:20:X*2)
    xticklabels(-X+10:20:X-10)
    
    newcolors = crameri('-vik');
    colororder(flipud(newcolors(1:round(256/numel(surv{n})):256, :)))

    m = m+1;

end

xlabel([axs{1} axs{2}], 'x-shore distance (m)')
ylabel(axs{1}, 'bed level (m +NAP)')
yticklabels(axs{2}, {})

legend(axs{2}, string(datetime(date{5}(surv{5}), 'Format','dd-MM-yy')),...
    'Location','northeast', 'NumColumns',6, 'Box','on', 'FontSize',fontsize/1.2)

grid([axs{1} axs{2}], 'on')
grid([axs{1} axs{2}], 'minor')

% exportgraphics(f1a, '/Users/jwb/Library/CloudStorage/OneDrive-UniversiteitUtrecht/Events/NCK/2023/poster/figures/profiles.png')

%% Visualisation: profile evolution
% tracknames = {'L$_1$','L$_2$','L$_3$','L$_{3.5}$','L$_4$','L$_5$','L$_6$'};
tracknames = {'L$_1$','L$_2$','L$_3$','L$_4$','L$_5$','L$_6$'};

f1a = figure;

tiledlayout(3,2)
for n = 1:6

    axs{n} = nexttile; % Ln
    plot(prof_centred{n}, 'LineWidth', 2); hold on
    text(2, 1.65, tracknames{n}, 'FontSize',fontsize/1.3, 'EdgeColor','k')

    yline(0,'-.')
    yline([-1 1],'--')
    fill([0 X*2 X*2 0], [0 0 1 1], 'g', 'LineStyle','none', 'FaceAlpha',.05)
    text(X-40,.75, ['$\Delta_{first}$ = 1:',mat2str(meanSlope_HW{n}(1),2)], 'FontSize',fontsize/1.3)
    text(X-40,.25, ['$\Delta_{last}$',repmat('\ ',1,2), '= 1:',mat2str(meanSlope_HW{n}(end),2)], 'FontSize',fontsize/1.3)

    fill([0 X*2 X*2 0], [0 0 -1 -1], 'm', 'LineStyle','none', 'FaceAlpha',.05)
    text(X+20,-.25, ['$\Delta_{first}$ = 1:',mat2str(meanSlope_LW{n}(1),2)], 'FontSize',fontsize/1.3)
    text(X+20,-.75, ['$\Delta_{last}$',repmat('\ ',1,2), '= 1:',mat2str(meanSlope_LW{n}(end),2)], 'FontSize',fontsize/1.3)

    xlim([0 X*2])
    ylim([-2, 2])
    xticks(10:20:X*2)
    xticklabels(-X+10:20:X-10)

    newcolors = crameri('-vik');
    colororder(flipud(newcolors(1:round(256/numel(surv{n})):256, :)))

    grid on
    grid minor

end

xlabel([axs{5} axs{6}], 'x-shore distance (m)')
ylabel(axs{3}, 'bed level (m +NAP)')

legend(axs{4}, string(datetime(date{5}(surv{5}), 'Format','dd-MM-yy')),...
    'Location','eastoutside', 'NumColumns',1, 'Box','on', 'FontSize',fontsize/1.2)

% exportgraphics(f1a, '/Users/jwb/Library/CloudStorage/Dropbox/Apps/Overleaf/manuscript_observation/Figures/Xshore_profiles.png')

%% Visualisation: slope evolution
f1b = figure;

tiledlayout(2,1)

nexttile
for n = 1:6
    plot(date_check, meanSlope_HW{n}, '-o'); hold on
    ylim([0 50])
end
legend(tracknames, 'Location','northoutside', 'NumColumns',6)

nexttile
for n = 1:6
    plot(date_check, meanSlope_LW{n}, '-o'); hold on
    ylim([0 50])
end

%% Visualisation: slope evolution
f1c = figure;

tiledlayout(2, width(meanSlope_HW))

x = linspace(-1, 1);
for n = 1:width(meanSlope_HW)
    nexttile
    for m = 1:width(meanSlope_HW{n})
        plot(x, (1/meanSlope_HW{n}(m))*x, 'LineWidth',2); hold on
    end
    title(tracknames{n})

    set(gca,'XTick',[])
    set(gca,'YTick',[])
    set(gca,'XTickLabel',[]);
    set(gca,'YTickLabel',[]);

    newcolors = crameri('-vik');
    colororder(flipud(newcolors(1:round(256/numel(meanSlope_HW{n})):256, :)))
end
legend(string(datetime(date_check(:,n), 'Format','dd-MM-yy')),...
    'Location','eastoutside', 'NumColumns',1, 'Box','on', 'FontSize',fontsize/1.2)

for n = 1:width(meanSlope_LW)
    nexttile
    for m = 1:width(meanSlope_LW{n})
        plot(x, (1/meanSlope_LW{n}(m))*x, 'LineWidth',2); hold on
    end
    title(tracknames{n})

    set(gca,'XTick',[])
    set(gca,'YTick',[])
    set(gca,'XTickLabel',[]);
    set(gca,'YTickLabel',[]);

    newcolors = crameri('-vik');
    colororder(flipud(newcolors(1:round(256/numel(meanSlope_LW{n})):256, :)))
end

%% Visualisation: slope evolution
f1d = figure;

tiledlayout(2, width(meanSlope_HW))

for n = 1:width(meanSlope_HW)
    nexttile
    for m = 1:numel(meanSlope_HW{n})
        polarplot([atan(1/meanSlope_HW{n}(m)); atan(1/meanSlope_HW{n}(m))]*12, [-1; 1]*60, 'LineWidth',3); hold on
        ax = gca;
        ax.RGrid = 'off';
        ax.ThetaGrid = 'off';
        ax.RTick = [];
        ax.ThetaTick = [];
        % ax.ThetaAxisUnits = 'radians';
        ax.ThetaColor = 'r';
        ax.LineWidth = 5;
    end
    title(tracknames{n}, 'FontSize',fontsize)

    newcolors = crameri('-vik');
    colororder(flipud(newcolors(1:round(256/numel(meanSlope_HW{n})):256, :)))
end
legend(string(datetime(date_check(:,1), 'Format','dd-MM-yy')),...
    'Location','eastoutside', 'NumColumns',1, 'Box','off', 'FontSize',fontsize/1.2)

for n = 1:width(meanSlope_LW)
    nexttile
    for m = 1:numel(meanSlope_LW{n})
        polarplot([atan(1/meanSlope_LW{n}(m)); atan(1/meanSlope_LW{n}(m))]*12, [-1; 1]*60, 'LineWidth',3); hold on
        ax = gca;
        ax.RGrid = 'off';
        ax.ThetaGrid = 'off';
        ax.RTick = [];
        ax.ThetaTick = [];
        % ax.ThetaAxisUnits = 'radians';
        ax.ThetaColor = 'r';
        ax.LineWidth = 5;
    end

    newcolors = crameri('-vik');
    colororder(flipud(newcolors(1:round(256/numel(meanSlope_HW{n})):256, :)))
end
clear ax

% exportgraphics(f1d, '/Users/jwb/Library/CloudStorage/Dropbox/Apps/Overleaf/manuscript_observation/Figures/Xshore_slopes.png')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% SEDMEX
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear surv
% surv{1} = [6 07:15 17:23];
% surv{2} = [8 10:18 20:26];
% surv{3} = [7 08:16 18:24];
% surv{4} = [7 09:17 19:25];
% surv{5} = [6 08:16 18:24];
% surv{6} = [6 08:16 18:24];

surv{1} = [6 07:23];
surv{2} = [8 10:26];
surv{3} = [7 08:24];
surv{4} = [7 09:25];
surv{5} = [6 08:24];
surv{6} = [7 08:24];

% date check
m = 1;
for n = [1:3 5:7]
    date_check_sedmex(:,m) = date{n}(surv{m});
    m = m+1;
end

%% Calculations
% smooth profiles and centre around intersection with z=0
X = 30;
m = 1;
% for n = 1:7
for n = [1:3 5:7] % discard track 4
    prof_smooth{m} = movmean(profiles{n}(:, surv{m}), 3, 1, 'omitnan');
    idx_0 = find(prof_smooth{m} >= 0, 1, 'first');
    prof_centred{m} = prof_smooth{m}(idx_0-X:idx_0+X, :);

    for p = 1:width(prof_centred{m})
        idx_LW = find(prof_centred{m}(:,p) >= -1, 1, 'first');
        if isempty(idx_LW)
            idx_LW = find(prof_centred{m}(:,p) == min(prof_centred{m}(:,p))); % if max > -1, then find idx of min
        end

        idx_MW = find(prof_centred{m}(:,p) >= 0, 1, 'first');

        idx_HW = find(prof_centred{m}(:,p) >= 1, 1, 'first');
        if isempty(idx_HW)
            idx_HW = find(prof_centred{m}(:,p) == max(prof_centred{m}(:,p))); % if max < 1, then find idx of max
        end
        slope_LW = gradient(prof_centred{m}(idx_LW:idx_MW, p));
        meanSlope_LW{m}(p) = 1/mean(slope_LW, 'omitnan');
        slope_HW = gradient(prof_centred{m}(idx_MW:idx_HW, p));
        meanSlope_HW{m}(p) = 1/mean(slope_HW, 'omitnan');
    end

    m = m+1;
end
clear idx_0 idx_LW idx_MW idx_HW m n p

% remove erroneous measurements
prof_centred{1}(11:12, 12) = NaN;
prof_centred{2}(7:9, 12) = NaN;

%% Visualisation: profile evolution
tracknames = {'L$_1$','L$_2$','L$_3$','L$_4$','L$_5$','L$_6$'};

f2a = figure;

tiledlayout(3,2)
for n = 1:6

    ax{n} = nexttile; % Ln
    plot(prof_centred{n}, 'LineWidth', 2); hold on
    text(2, 1.65, tracknames{n}, 'FontSize',fontsize/1.3, 'EdgeColor','k')

    yline(0,'-.')
    yline([-1 1],'--')
    fill([0 X*2 X*2 0], [0 0 1 1], 'g', 'LineStyle','none', 'FaceAlpha',.05)
    text(X-25,.75, ['$\Delta_{first}$ = 1:',mat2str(meanSlope_HW{n}(1),2)], 'FontSize',fontsize/1.3)
    text(X-25,.25, ['$\Delta_{last}$',repmat('\ ',1,2), '= 1:',mat2str(meanSlope_HW{n}(end),2)], 'FontSize',fontsize/1.3)

    fill([0 X*2 X*2 0], [0 0 -1 -1], 'm', 'LineStyle','none', 'FaceAlpha',.05)
    text(X+10,-.25, ['$\Delta_{first}$ = 1:',mat2str(meanSlope_LW{n}(1),2)], 'FontSize',fontsize/1.3)
    text(X+10,-.75, ['$\Delta_{last}$',repmat('\ ',1,2), '= 1:',mat2str(meanSlope_LW{n}(end),2)], 'FontSize',fontsize/1.3)

    xlim([0 X*2])
    ylim([-2, 2])
    xticks(10:10:X*2)
    xticklabels(-X+10:10:X-10)

    newcolors = crameri('-vik');
    colororder(flipud(newcolors(1:round(256/numel(surv{n})):256, :)))

    grid on
    grid minor

end

xlabel([ax{5} ax{6}], 'x-shore distance (m)')
ylabel(ax{3}, 'bed level (m +NAP)')

legend(ax{4}, string(datetime(date{5}(surv{5}), 'Format','dd-MM-yy')),...
    'Location','eastoutside', 'NumColumns',1, 'Box','on', 'FontSize',fontsize/1.2)

% exportgraphics(f2a, '/Users/jwb/Library/CloudStorage/Dropbox/Apps/Overleaf/manuscript_observation/Figures/Xshore_profiles_sedmex.png')

%% Visualisation: slope evolution
f2b = figure;

tiledlayout(2, width(meanSlope_HW))

for n = 1:width(meanSlope_HW)
    nexttile
    for m = 1:numel(meanSlope_HW{n})
        polarplot([atan(1/meanSlope_HW{n}(m)); atan(1/meanSlope_HW{n}(m))]*12, [-1; 1]*60, 'LineWidth',3); hold on
        ax = gca;
        ax.RGrid = 'off';
        ax.ThetaGrid = 'off';
        ax.RTick = [];
        ax.ThetaTick = [];
        % ax.ThetaAxisUnits = 'radians';
        ax.ThetaColor = 'r';
        ax.LineWidth = 5;
    end
    title(tracknames{n}, 'FontSize',fontsize)

    newcolors = crameri('-vik');
    colororder(flipud(newcolors(1:round(256/numel(meanSlope_HW{n})):256, :)))
end
legend(string(datetime(date_check_sedmex(:,1), 'Format','dd-MM-yy')),...
    'Location','eastoutside', 'NumColumns',1, 'Box','off', 'FontSize',fontsize/1.2)

for n = 1:width(meanSlope_LW)
    nexttile
    for m = 1:numel(meanSlope_LW{n})
        polarplot([atan(1/meanSlope_LW{n}(m)); atan(1/meanSlope_LW{n}(m))]*12, [-1; 1]*60, 'LineWidth',3); hold on
        ax = gca;
        ax.RGrid = 'off';
        ax.ThetaGrid = 'off';
        ax.RTick = [];
        ax.ThetaTick = [];
        % ax.ThetaAxisUnits = 'radians';
        ax.ThetaColor = 'r';
        ax.LineWidth = 5;
    end

    newcolors = crameri('-vik');
    colororder(flipud(newcolors(1:round(256/numel(meanSlope_HW{n})):256, :)))
end

% exportgraphics(f2b, '/Users/jwb/Library/CloudStorage/Dropbox/Apps/Overleaf/manuscript_observation/Figures/Xshore_slopes_sedmex.png')

%% Initialisation: track locations
load PHZ_2022_Q4.mat
DEM.Z(DEM.Z<0) = NaN;

L1C1 = [117421.461, 560053.687]; % vector
L2C5 = [117199.347, 559816.116]; % 3D-sonar
L3C1 = [116838.947, 559536.489]; % vector
L4C1 = [116103.892, 558946.574]; % 3D-sonar
L5C1 = [115670.000, 558603.700]; % vector
L6C1 = [115401.500, 558224.500]; % vector

LXCX = [L1C1; L2C5; L3C1; L4C1; L5C1; L6C1];
Tr_names = {'L1'; 'L2'; 'L3'; 'L4'; 'L5'; 'L6'};

%% Visualisation: track locations
f3 = figure;
surf(DEM.X, DEM.Y, DEM.Z); hold on
scatter(LXCX(:,1), LXCX(:,2), 500, '|', 'r', 'LineWidth',3);
ax = gca; ax.SortMethod = 'childorder';
text(LXCX(:, 1)+20, LXCX(:, 2)-150, Tr_names, 'FontSize',fontsize)
xlabel('easting [RD] (m)')
ylabel('northing [RD] (m)')
clim([-5 5])
colormap('gray')

shading flat
view(46, 90)
axis vis3d
axis off

ta = annotation('textarrow', [.82 .84], [.63 .65], 'String','N');
ta.FontSize = fontsize;
ta.Interpreter = 'latex';
ta.LineWidth = 6;
ta.HeadStyle = 'hypocycloid';
ta.HeadWidth = 30;
ta.HeadLength = 30;
an = annotation('ellipse', [.80 .60 .05 .06]);
an.LineWidth = 2;

% exportgraphics(f3, '/Users/jwb/Library/CloudStorage/Dropbox/Apps/Overleaf/manuscript_observation/Figures/tracklocs.png')
% exportgraphics(f3, '/Users/jwb/Library/CloudStorage/Dropbox/Apps/Overleaf/manuscript_observation/Figures/davosmap.png')