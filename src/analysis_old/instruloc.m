%% Initialisation
close all
clear
clc

[xl, yl, xt, yt, fontsize] = eurecca_init;

% processed topo files
load('zSounding.mat')

data = {z_UTD_realisatie, z_2019_Q4, z_2020_Q1, z_2020_Q2, z_2020_Q3, z_2020_Q4, z_2021_Q1};
names = {'UTD realisatie', '2019 Q4', '2020 Q1', '2020 Q2', '2020 Q3', '2020 Q4', '2021 Q1'};

% transect starting (= most inland) points
Tr1 = [117318.148, 560099.672]; % [xRD, yRD]
Tr2 = [117135.742, 559891.6379999999];
Tr3 = [116785.954, 559615.813];
% Tr4 = [116440.859, 559327.936];
Tr5 = [115998.162, 559013.088];
Tr6 = [115604.92199999999, 558655.548];
Tr7 = [115310.487, 558287.122];

% Tr_all = [Tr1;Tr2;Tr3;Tr4;Tr5;Tr6;Tr7];
Tr_all = [Tr1;Tr2;Tr3;Tr5;Tr6;Tr7];

% first line of instruments @ z = -0.75 m
Tr1a = [117414, 560058]; % [xRD, yRD]
Tr2a = [117204, 559814];
Tr3a = [116842, 559532];
% Tr4a = [116496, 559256];
Tr5a = [116076, 558914];
Tr6a = [115676, 558598];
Tr7a = [115398, 558226];

% Tra_all = [Tr1a;Tr2a;Tr3a;Tr4a;Tr5a;Tr6a;Tr7a];
Tra_all = [Tr1a;Tr2a;Tr3a;Tr5a;Tr6a;Tr7a];

% second line of instruments @ z = -1.50 m
Tr1b = [117446, 560044]; % [xRD, yRD]
Tr2b = [117242, 559774];
% Tr3b = [116854, 559514];
% Tr4b = [116506, 559246];
Tr5b = [116094, 558892];
% Tr6b = [115718, 558562];
Tr7b = [115482, 558164];

% Trb_all = [Tr1b;Tr2b;Tr3b;Tr4b;Tr5b;Tr6b;Tr7b];
Trb_all = [Tr1b;Tr2b;Tr5b;Tr7b];

%% Visualisation: proposed instrument locations
for n = 5
    figure2('Name', names{n})
    p(1) = scatter(data{n}.xRD, data{n}.yRD, [], data{n}.z, '.'); hold on
%     p(2) = scatter(data{n}.xRD(data{n}.z==-0.75), data{n}.yRD(data{n}.z==-0.75), 4, 'g', 'filled');
%     p(3) = scatter(data{n}.xRD(data{n}.z==-1.5), data{n}.yRD(data{n}.z==-1.5), 4, 'r', 'filled');
%     p(4) = plot(Tr_all(:,1), Tr_all(:,2), 'o',...
%     'LineWidth',2,...
%     'MarkerSize',5,...
%      'MarkerEdgeColor',[0, .8, 0],...
%     'MarkerFaceColor','k');
%     text(xRD(1:3:end)+20, yRD(1:3:end)+20, transectN(1:3:end), 'Color', 'k', 'FontSize', fontsize/1.5, 'Interpreter', 'tex')
%     text(xRD_a+10, yRD_a+50, ['A1'; 'A2'; 'A3'; 'A4'; 'A5'], 'Color', 'k', 'FontSize', fontsize/1.5, 'Interpreter', 'tex')
%     p(4) = plot(xRD_c, yRD_c, 'o',...
%     'LineWidth',2,...
%     'MarkerSize',5,...
%     'MarkerEdgeColor','k',...
%     'MarkerFaceColor','w');
%     text([115777; 116497; 117217]+10, [558818; 559388; 559958]+50, ['C1'; 'C2'; 'C3'],...
%         'Color', 'k', 'FontSize', fontsize/1.5, 'Interpreter', 'tex')
    p(5) = plot(Tra_all(:,1), Tra_all(:,2), 'o',...
    'LineWidth',2,...
    'MarkerSize',5,...
     'MarkerEdgeColor',[0, .8, 0],...
    'MarkerFaceColor','k');
    text(Tra_all(:,1)-90, Tra_all(:,2)-40, {'R1','R2','R3','R4','R5','R6'}, 'Color', 'k', 'FontSize', fontsize/2, 'Interpreter', 'tex')
    text(Tra_all(:,1)-100, Tra_all(:,2)+60, num2str(Tra_all), 'Color', 'k', 'FontSize', fontsize/2, 'Interpreter', 'tex')
    p(6) = plot(Trb_all(:,1), Trb_all(:,2), 'o',...
    'LineWidth',2,...
    'MarkerSize',5,...
     'MarkerEdgeColor',[.8, 0, 0],...
    'MarkerFaceColor','k');
    text(Trb_all(:,1)-10, Trb_all(:,2)-60, num2str(Trb_all), 'Color', 'w', 'FontSize', fontsize/2, 'Interpreter', 'tex')

    xlim([114800 118400])
    ylim([557500 560800])
    xticks(114000:1e3:118000)
    yticks(558000:1e3:561000) 
    xlabel('xRD (m)')
    ylabel('yRD (m)')
    c = colorbar;
    c.Label.String = 'm +NAP';
    c.Label.Interpreter = 'latex';
    c.TickLabelInterpreter = 'latex';
    c.FontSize = fontsize;
    caxis([-5 5]);
    colormap(brewermap([], '*PuOr'))
    set(gca, 'Color', [.8 .8 .8])
%     text(117100, 558200, names{n}, 'FontSize', fontsize, 'Interpreter', 'tex')
%     legend([p(2) p(3) p(4)], {'NAP -1.6m','Sample','Core'}, 'Location', 'northwest')
    legend([p(5) p(6)], {'ADV+STM @ z $\sim$ -0.75m', 'OSSI(+CTD) @ z $\sim$ -1.50m'}, 'Location', 'northwest')
    grid on
    axis equal
end
