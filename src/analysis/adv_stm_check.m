%% Initialisation
close all
clear
clc

[~, ~, ~, ~, fontsize] = eurecca_init;

labels = {'L1C1', 'L2C3', 'L3C1', 'L4C1', 'L5C1', 'L6C1'};

source{1} = 'L1C1VEC_20210925.nc';
source{2} = 'L2C3VEC_20210925.nc';
source{3} = 'L3C1VEC_20210925.nc';
source{4} = 'L4C1VEC_20210925.nc';
source{5} = 'L5C1VEC_20210925.nc';
source{6} = 'L6C1VEC_20210925.nc';

%% Calculations
for n = 1:6
    info{n} = ncinfo(source{n});
    
    t{n} = ncread(source{n}, 't');
    u{n} = ncread(source{n}, 'u');
    v{n} = ncread(source{n}, 'v');
    w{n} = ncread(source{n}, 'w');
    eta{n} = ncread(source{n}, 'eta');
    turb{n} = ncread(source{n}, 'anl1');
    uvw{n} = sqrt(u{n}.^2 + v{n}.^2 + w{n}.^2);
end

% uvw{2} = uvw{2}';

for n = 1:6
    tt{n} = array2timetable([uvw{n}(:, 42), eta{n}(:, 42), turb{n}(:, 42)], 'VariableNames', {'uvw', 'eta', 'turb'}, 'SampleRate', 16);
    rt{n} = retime(tt{n}, 'regular', 'mean', 'TimeStep', seconds(1));
end

%% Visualisation
figure2
for n = 1:6
    ax = nexttile;
    yyaxis left
    plot(t{n}, mean(uvw{n}, 'omitnan')); hold on
    plot(t{n}, mean(eta{n}, 'omitnan'))
    ylim([-0.5, 1.5])
    yyaxis right
    plot(t{n}, mean(turb{n}/1000, 'omitnan'))
    xlabel('time (min)')
    title(labels{n})
end
lg = legend(ax, 'flow velocity (m s$^{-1}$)', 'water level (m)', 'tubidity (V)', 'Orientation','horizontal');
lg.Layout.Tile = 'north';

figure2
for n = 1:6
    ax = nexttile;
    yyaxis left
    plot(rt{n}.Time, rt{n}.uvw); hold on
    plot(rt{n}.Time, rt{n}.eta)
    ylim([0, 0.5])
    yyaxis right
    plot(rt{n}.Time, rt{n}.turb)
    xlim([seconds(0), seconds(100)])
    xlabel('time (s)')
    title(labels{n})
end
lg = legend(ax, 'flow velocity (m s$^{-1}$)', 'water level (m)', 'tubidity (V)', 'Orientation','horizontal');
lg.Layout.Tile = 'north';

figure2
for n = 1:6
    plot(rt{n}.Time, rt{n}.uvw, 'o-', 'LineWidth', 3); hold on
end
xlabel('time')
ylabel('flow velocity (m s$^{-1}$)')
legend(labels, 'Location', 'north', 'NumColumns', 6)
