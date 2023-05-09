%% Initialisation
close all
clear
clc

[~, ~, ~, ~, fontsize, ~] = eurecca_init;

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

% tracknames = {'L$_1$','L$_2$','L$_3$','L$_{3.5}$','L$_4$','L$_5$','L$_6$'};
tracknames = {'L$_1$','L$_2$','L$_3$','L$_4$','L$_5$','L$_6$'};

% remove erroneous measurements
profiles{5}(:,18) = NaN;
profiles{5}(:,26) = NaN;

% water levels
MHWS = 0.81; % mean high water spring [m]
MLWS = -1.07; % mean low water spring [m]
MSL = 0; % mean sea level [m]
NAP = MSL-0.1; % local reference datum [m]

% colourblind-friendly colour palette
orange = [230/255, 159/255, 0];
blue = [86/255, 180/255, 233/255];
yellow = [240/255, 228/255, 66/255];
redpurp = [204/255, 121/255, 167/255];
bluegreen = [0, 158/255, 115/255];

newcolors = crameri('-vik');
colours = newcolors(1:round(length(newcolors)/5):length(newcolors), :);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Long-term monitoring
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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

%% Smooth profiles and centre around intersection with z=0
X = 50;
m = 1;
% for n = 1:7
for n = [1:3 5:7] % discard track 4
    prof_smooth{m} = movmean(profiles{n}(:, surv{n}), 3, 1, 'omitnan');
    idx_0{m} = find(prof_smooth{m} >= MSL, 1, 'first');
    prof_centred{m} = prof_smooth{m}(idx_0{m}-X:idx_0{m}+X, :);

    for p = 1:width(prof_centred{m})

        try
            idx_LW{m}(p) = find(prof_centred{m}(:,p) >= MLWS, 1, 'first');
        catch
            try
                idx_LW{m}(p) = find(prof_centred{m}(:,p) == min(prof_centred{m}(:,p))); % if max > MLWS, then find idx of min
            catch
                idx_LW{m}(p) = 1;
            end
        end
        
        try
            idx_MW{m}(p) = find(prof_centred{m}(:,p) >= MSL, 1, 'first');
        catch
            idx_MW{m}(p) = 1;
        end

        try
            idx_HW{m}(p) = find(prof_centred{m}(:,p) >= MHWS, 1, 'first')-1;
        catch
            try
                idx_HW{m}(p) = find(prof_centred{m}(:,p) == max(prof_centred{m}(:,p)))-1; % if max < MHWS, then find idx of max
            catch
                idx_HW{m}(p) = 1;
            end
        end

        aLW_p = polyfit(idx_LW{m}(p):idx_MW{m}(p), prof_centred{m}(idx_LW{m}(p):idx_MW{m}(p), p), 1);
        % aLW_fit{m}{:,p} = polyval(aLW_p, idx_LW{m}(p):idx_MW{m}(p));
        aLW_mean{m}(p) = aLW_p(1);

        aHW_p = polyfit(idx_MW{m}(p):idx_HW{m}(p), prof_centred{m}(idx_MW{m}(p):idx_HW{m}(p), p), 1);
        % aHW_fit{m}{:,p} = polyval(aHW_p, idx_MW{m}(p):idx_HW{m}(p));
        aHW_mean{m}(p) = aHW_p(1);

        intX_LW1{m}(p) = (MLWS - aLW_p(2)) / aLW_p(1);
        intX_LW2{m}(p) = (MSL - aLW_p(2)) / aLW_p(1);
        aLW_fit{m}{:,p} = polyval(aLW_p, intX_LW1{m}(p):intX_LW2{m}(p));

        intX_HW1{m}(p) = (MSL - aHW_p(2)) / aHW_p(1);
        intX_HW2{m}(p) = (MHWS - aHW_p(2)) / aHW_p(1);
        aHW_fit{m}{:,p} = polyval(aHW_p, intX_HW1{m}(p):intX_HW2{m}(p));

    end

    m = m+1;
end
% clear idx_0 idx_LW idx_MW idx_HW m n p

% manual corrections (e.g., because of too few data points)
aHW_mean{4}(5) = NaN; % because dummy values
aLW_mean{4}(5) = NaN; % because dummy values
aHW_mean{6}(3) = NaN;

%% Create table with slopes
for n = 1:6
    slopesHW(:,n) = round(1./aHW_mean{n});
    slopesLW(:,n) = round(1./aLW_mean{n});
end

%% Visualisation: profile evolution L1 - L6
f0 = figure;

tl = tiledlayout(2,3, 'TileSpacing','tight');
for n = 1:6

    axs{n} = nexttile; % Ln
    plot(prof_centred{n}, 'LineWidth', 3); hold on
    text(axs{n}, 1.6, 1.55, tracknames{n}, 'Color','r', 'FontSize',fontsize*1.4, 'EdgeColor','r')

    yline(MHWS, '--', 'FontSize',fontsize, 'Interpreter','latex', 'LineWidth',3)
    yline(MSL, '-.', 'FontSize',fontsize, 'Interpreter','latex', 'LineWidth',3)
    yline(MLWS, '--', 'FontSize',fontsize, 'Interpreter','latex', 'LineWidth',3)

    % area(0:X*2, ones(1,length(prof_centred{n}))*MHWS, 'FaceColor',yellow, 'FaceAlpha',0.1, 'LineStyle','none')
    % text(X-39,.7*MHWS, ['$\Delta_{first}$ = 1:',mat2str(1/aHW_mean{n}(1),2)], 'FontSize',fontsize)
    % text(X-39,.7*MHWS-.36, ['$\Delta_{last}$',repmat('\ ',1,2), '= 1:',mat2str(1/aHW_mean{n}(end),2)], 'FontSize',fontsize)

    % area(0:X*2, ones(1,length(prof_centred{n}))*MLWS, 'FaceColor',bluegreen, 'FaceAlpha',0.1, 'LineStyle','none')
    % text(X+21,-.43*MHWS, ['$\Delta_{first}$ = 1:',mat2str(1/aLW_mean{n}(1),2)], 'FontSize',fontsize)
    % text(X+21,-.43*MHWS-.36, ['$\Delta_{last}$',repmat('\ ',1,2), '= 1:',mat2str(1/aLW_mean{n}(end),2)], 'FontSize',fontsize)

    xlim([0 X*2])
    ylim([-2, 2])
    xticks(10:20:X*2)
    xticklabels(-X+10:20:X-10)
    axs{n}.FontSize = fontsize;
    
    colororder(flipud(newcolors(1:round(256/numel(surv{n})):256, :)))
    grid on
    grid minor

end

yline(axs{3}, MHWS, '--', 'MHWS', 'FontSize',fontsize*.8, 'Interpreter','latex', 'LineWidth',3)
yline(axs{6}, MHWS, '--', 'MHWS', 'FontSize',fontsize*.8, 'Interpreter','latex', 'LineWidth',3)
yline(axs{3}, MSL, '-.', 'MSL', 'FontSize',fontsize*.8, 'Interpreter','latex', 'LineWidth',3)
yline(axs{6}, MSL, '-.', 'MSL', 'FontSize',fontsize*.8, 'Interpreter','latex', 'LineWidth',3)
yline(axs{3}, MLWS, '--', 'MLWS', 'FontSize',fontsize*.8, 'Interpreter','latex', 'LineWidth',3)
yline(axs{6}, MLWS, '--', 'MLWS', 'FontSize',fontsize*.8, 'Interpreter','latex', 'LineWidth',3)

yticks(axs{1}, -1:2)
yticks(axs{4}, -2:1)

set([axs{1} axs{2} axs{3}],'xticklabel',[])
set([axs{2} axs{3} axs{5} axs{6}],'yticklabel',[])

xlabel(tl, 'x-shore distance (m)', 'FontSize',fontsize, 'Interpreter','latex')
ylabel(tl, 'bed level (m +NAP)', 'FontSize',fontsize, 'Interpreter','latex')

hl = legend(axs{4}, string(datetime(date{5}(surv{5}), 'Format','dd-MM-yy')),...
    'Location','eastoutside', 'NumColumns',1, 'Box','on', 'FontSize',fontsize);
hl.Layout.Tile = 'East';

clear axs

%% Visualisation: profile evolution L1 - L6
f1 = figure;

tiledlayout(3,2)
for n = 1:6

    axs{n} = nexttile; % Ln
    text(axs{n}, 2, 1.62, tracknames{n}, 'FontSize',fontsize, 'EdgeColor','k'); hold on

    plot(intX_LW1{n}(1):intX_LW2{n}(1), aLW_fit{n}{:,1}, 'k', 'LineWidth',6)
    plot(intX_HW1{n}(1):intX_HW2{n}(1), aHW_fit{n}{:,1}, 'k', 'LineWidth',6)
    plot(intX_LW1{n}(end):intX_LW2{n}(end), aLW_fit{n}{:,end}, 'r', 'LineWidth',6)
    plot(intX_HW1{n}(end):intX_HW2{n}(end), aHW_fit{n}{:,end}, 'r', 'LineWidth',6)

    text(X-39,MHWS+.12, 'MHWS', 'FontSize',fontsize)
    area(0:X*2, ones(1,length(prof_centred{n}))*MHWS, 'FaceColor',yellow, 'FaceAlpha',0.1, 'LineStyle','--')
    text(X-39,.7*MHWS, ['$\Delta_{first}$ = 1:',mat2str(1/aHW_mean{n}(1),2)], 'FontSize',fontsize)
    text(X-39,.7*MHWS-.36, ['$\Delta_{last}$',repmat('\ ',1,2), '= 1:',mat2str(1/aHW_mean{n}(end),2)], 'FontSize',fontsize, 'Color','r')

    text(X+40,MSL+.12, 'MSL', 'FontSize',fontsize)
    text(X+36,MLWS-.21, 'MLWS', 'FontSize',fontsize)
    area(0:X*2, ones(1,length(prof_centred{n}))*MLWS, 'FaceColor',bluegreen, 'FaceAlpha',0.1, 'LineStyle','--')
    text(X+21,-.43*MHWS, ['$\Delta_{first}$ = 1:',mat2str(1/aLW_mean{n}(1),2)], 'FontSize',fontsize)
    text(X+21,-.43*MHWS-.36, ['$\Delta_{last}$',repmat('\ ',1,2), '= 1:',mat2str(1/aLW_mean{n}(end),2)], 'FontSize',fontsize, 'Color','r')

    xlim([0 X*2])
    ylim([-2, 2])
    xticks(10:20:X*2)
    xticklabels(-X+10:20:X-10)
    
    grid on
    grid minor

end

xlabel([axs{5} axs{6}], 'x-shore distance (m)')
ylabel(axs{3}, 'bed level (m +NAP)')

legend(axs{2}, string(datetime(date{5}(surv{5}(1)), 'Format','dd-MM-yy')),...
    '',string(datetime(date{5}(surv{5}(end)), 'Format','dd-MM-yy')),...
    'Location','northeast', 'NumColumns',2, 'Box','on', 'FontSize',fontsize)

clear axs

%% Visualisation: slope evolution L1 - L6
f2 = figure;

tiledlayout(2,1, 'TileSpacing','tight')

ax{1} = nexttile;
for n = 1:6
    plot(date_check(isfinite(aHW_mean{n}),n), 1./aHW_mean{n}(isfinite(aHW_mean{n})),...
        '-o', 'Color',colours(n,:), 'LineWidth',3); hold on
end
area(ax{1}.XLim, [100 100], 'FaceColor',yellow, 'FaceAlpha',0.1, 'LineStyle','none')

ax{2} = nexttile;
for n = 1:6
    plot(date_check(isfinite(aLW_mean{n}),n), 1./aLW_mean{n}(isfinite(aLW_mean{n})),...
        '-o', 'Color',colours(n,:), 'LineWidth',3); hold on
end
area(ax{2}.XLim, [100 100], 'FaceColor',bluegreen, 'FaceAlpha',0.1, 'LineStyle','none')

ylim([ax{1} ax{2}], [0 100])
xticklabels(ax{1}, {})
ylabel([ax{1} ax{2}], 'slope (1:x)')
legend(ax{1}, tracknames, 'Location','northoutside', 'NumColumns',6)

clear ax

%% Visualisation: profile evolution L1 & L4
f3 = figure;

m = 1;
tiledlayout(1,2, 'TileSpacing','tight')
for n = [4 1]

    axs{m} = nexttile; % Ln
    plot(prof_centred{n}, 'LineWidth', 2); hold on
    text(axs{m}, 1.8, 1.6, tracknames{n}, 'FontSize',fontsize*2, 'EdgeColor','k')

    text(X-39,MHWS+.12, 'MHWS', 'FontSize',fontsize)
    area(0:X*2, ones(1,length(prof_centred{n}))*MHWS, 'FaceColor',yellow, 'FaceAlpha',0.1, 'LineStyle','--')
    text(X-39,.7*MHWS, ['$\Delta_{first}$ = 1:',mat2str(1/aHW_mean{n}(1),2)], 'FontSize',fontsize)
    text(X-39,.7*MHWS-.36, ['$\Delta_{last}$',repmat('\ ',1,2), '= 1:',mat2str(1/aHW_mean{n}(end),2)], 'FontSize',fontsize)

    text(X+40,MSL+.12, 'MSL', 'FontSize',fontsize)
    text(X+36,MLWS-.21, 'MLWS', 'FontSize',fontsize)
    area(0:X*2, ones(1,length(prof_centred{n}))*MLWS, 'FaceColor',bluegreen, 'FaceAlpha',0.1, 'LineStyle','--')
    text(X+21,-.43*MHWS, ['$\Delta_{first}$ = 1:',mat2str(1/aLW_mean{n}(1),2)], 'FontSize',fontsize)
    text(X+21,-.43*MHWS-.36, ['$\Delta_{last}$',repmat('\ ',1,2), '= 1:',mat2str(1/aLW_mean{n}(end),2)], 'FontSize',fontsize)

    xlim([0 X*2])
    ylim([-2, 2])
    xticks(10:20:X*2)
    xticklabels(-X+10:20:X-10)
    
    colororder(flipud(newcolors(1:round(256/numel(surv{n})):256, :)))

    m = m+1;

end

xlabel([axs{1} axs{2}], 'x-shore distance (m)')
ylabel(axs{1}, 'bed level (m +NAP)')
yticklabels(axs{2}, {})

legend(axs{2}, string(datetime(date{5}(surv{5}), 'Format','dd-MM-yy')),...
    'Location','northeast', 'NumColumns',6, 'Box','on', 'FontSize',fontsize)

grid([axs{1} axs{2}], 'on')
grid([axs{1} axs{2}], 'minor')

clear axs

%% Visualisation: profile evolution L1 & L4
f4 = figure;

m = 1;
tiledlayout(1,2, 'TileSpacing','tight')
for n = [4 1]

    axs{m} = nexttile; % Ln
    text(axs{m}, 1.8, 1.6, tracknames{n}, 'FontSize',fontsize*2, 'EdgeColor','k'); hold on

    plot(intX_LW1{n}(1):intX_LW2{n}(1), aLW_fit{n}{:,1}, 'k', 'LineWidth',6)
    plot(intX_HW1{n}(1):intX_HW2{n}(1), aHW_fit{n}{:,1}, 'k', 'LineWidth',6)
    plot(intX_LW1{n}(end):intX_LW2{n}(end), aLW_fit{n}{:,end}, 'r', 'LineWidth',6)
    plot(intX_HW1{n}(end):intX_HW2{n}(end), aHW_fit{n}{:,end}, 'r', 'LineWidth',6)

    text(X-39,MHWS+.12, 'MHWS', 'FontSize',fontsize)
    area(0:X*2, ones(1,length(prof_centred{n}))*MHWS, 'FaceColor',yellow, 'FaceAlpha',0.1, 'LineStyle','--')
    text(X-39,.7*MHWS, ['$\Delta_{first}$ = 1:',mat2str(1/aHW_mean{n}(1),2)], 'FontSize',fontsize)
    text(X-39,.7*MHWS-.36, ['$\Delta_{last}$',repmat('\ ',1,2), '= 1:',mat2str(1/aHW_mean{n}(end),2)], 'FontSize',fontsize, 'Color','r')

    text(X+40,MSL+.12, 'MSL', 'FontSize',fontsize)
    text(X+36,MLWS-.21, 'MLWS', 'FontSize',fontsize)
    area(0:X*2, ones(1,length(prof_centred{n}))*MLWS, 'FaceColor',bluegreen, 'FaceAlpha',0.1, 'LineStyle','--')
    text(X+21,-.43*MHWS, ['$\Delta_{first}$ = 1:',mat2str(1/aLW_mean{n}(1),2)], 'FontSize',fontsize)
    text(X+21,-.43*MHWS-.36, ['$\Delta_{last}$',repmat('\ ',1,2), '= 1:',mat2str(1/aLW_mean{n}(end),2)], 'FontSize',fontsize, 'Color','r')

    xlim([0 X*2])
    ylim([-2, 2])
    xticks(10:20:X*2)
    xticklabels(-X+10:20:X-10)
    
    m = m+1;

end

xlabel([axs{1} axs{2}], 'x-shore distance (m)')
ylabel(axs{1}, 'bed level (m +NAP)')
yticklabels(axs{2}, {})

legend(axs{2}, string(datetime(date{5}(surv{5}(1)), 'Format','dd-MM-yy')),...
    '',string(datetime(date{5}(surv{5}(end)), 'Format','dd-MM-yy')),...
    'Location','northeast', 'NumColumns',2, 'Box','on', 'FontSize',fontsize)

grid([axs{1} axs{2}], 'on')
grid([axs{1} axs{2}], 'minor')

clear axs
