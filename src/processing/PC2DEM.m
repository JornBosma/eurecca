%% Initialisation
close all
clear
clc

[~, ~, ~, ~, fontsize, basePath] = eurecca_init;

load zSounding.mat
z_2022_Q3 = [z_2022_Q3; z_2022_Q3_grass];

data = {z_UTD_realisatie, z_2019_Q4, z_2020_Q1, z_2020_Q2, z_2020_Q3, z_2020_Q4...
    z_2021_Q1, z_2021_06, z_2021_09, z_2021_11, z_2022_Q1, z_2022_Q2, z_2022_Q3, z_2022_Q4};

names = {'PHZ_2019_Q3','PHZ_2019_Q4','PHZ_2020_Q1','PHZ_2020_Q2','PHZ_2020_Q3','PHZ_2020_Q4'...
    'PHZ_2021_Q1','PHZ_2021_Q2','PHZ_2021_Q3','PHZ_2021_Q4','PHZ_2022_Q1','PHZ_2022_Q2',...
    'PHZ_2022_Q3','PHZ_2022_Q4'};

%% Settings
Xlim = [floor(min(z_2022_Q3.xRD)) ceil(max(z_2022_Q3.xRD))];
Ylim = [floor(min(z_2022_Q3.yRD)) ceil(max(z_2022_Q3.yRD))];

res = 1; % 1-m resolution

%% Computations
wb = waitbar(0, 'Generating DEMs');
wb.Children.Title.Interpreter = 'none';

for survey = [11, 12]%1:length(data)

    PC = table2array(data{survey});
    
    % convert
    DEM = pointcloud2DEM(PC, Xlim, Ylim, res);
    
    % export
    save([basePath 'data' filesep 'elevation' filesep 'processed' filesep...
        names{survey} '.mat'], 'DEM')
    
    % visualise
    figure(survey)
    surf(DEM.X, DEM.Y, DEM.Z)
    xlabel('easting [RD] (m)')
    ylabel('northing [RD] (m)')
    zlabel('z (m +NAP)')
    cb = colorbar;
    cb.TickLabelInterpreter = 'latex';
    cb.Label.Interpreter = 'latex';
    cb.Label.String = 'm +NAP';
    cb.FontSize = fontsize;
    clim([-4 4])
    shading flat
    crameri('vik', 11, 'pivot', 0)
    view(0,90)
    axis vis3d

    drawnow

    waitbar(survey/length(data), wb, sprintf('Generating DEMs: %d %%', floor(survey/length(data)*100)));
    pause(0.1)
end
close(wb)
