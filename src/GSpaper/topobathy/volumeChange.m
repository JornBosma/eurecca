%% Initialisation
close all
clear
clc

[basePath, fontsize, cbf, PHZ] = eurecca_init;

dataPath = [basePath 'data' filesep 'elevation' filesep 'processed' filesep];
DEMS = dir(fullfile(dataPath,'PHZ*.mat'));

% Survey information
load DEMsurveys.mat
surveyNames = DEMsurveys.name;
surveyDates = DEMsurveys.survey_date;

% Polygons
pgons = getPgons;
pgonNames = fieldnames(pgons);

% Define the elevation values for the contour lines
contourLevels = [PHZ.LAT, PHZ.AHW];
% contourLevels = [0, 3];

%% Computations
wb1 = waitbar(0, 'Processing surveys');
for i = 1:numel(DEMS)
    
    % Load DEMs
    DEMS(i).data = load(DEMS(i).name);
    surveyName = char(surveyNames(i));
    data = DEMS(i).data;
    X = data.DEM.X;
    Y = data.DEM.Y;
    Z = data.DEM.Z;
    
    wb2 = waitbar(0, 'Computing polygon volumes');
    pos_wb1 = get(wb1, 'position');
    pos_wb2 = [pos_wb1(1) pos_wb1(2)+pos_wb1(4) pos_wb1(3) pos_wb1(4)];
    set(wb2, 'position',pos_wb2, 'doublebuffer','on')

    for j = 1%:numel(pgonNames)  % Loop through the polygons
        
        % Select polygon
        pgonName = pgonNames{j};
        pgonValues = pgons.(pgonName);  % Access the field using dynamic field names

        % Use inpolygon to find which grid cells are within the polygon
        inArea = inpolygon(X, Y, pgonValues(:,1), pgonValues(:,2));
        
        % Apply first mask
        X_temp = X;
        Y_temp = Y;
        Z_temp = Z;
        X_temp(~inArea) = NaN;
        Y_temp(~inArea) = NaN;
        Z_temp(~inArea) = NaN;

        % Extract contour lines from the DEM
        figure('Name',[surveyName,': ', upper(pgonName)])
        tiledlayout(2,1, 'TileSpacing','none', 'Padding','tight')
        nexttile
        [contourData, objectProp] = contourf(X, Y, Z_temp, contourLevels, 'ShowText','on');
        hold on; axis off; axis equal
        clabel(contourData, objectProp, 'FontSize',15, 'Color','red')
        patch(pgonValues(:,1), pgonValues(:,2), 'r', 'FaceAlpha',.1, 'EdgeColor','r', 'LineWidth',3)
        
        % Find the major contour line
        [contourX, contourY, ~] = C2xyz(contourData);
        
        % Initialize variables to store information about the longest and second longest arrays
        maxLength = 0;
        secondMaxLength = 0;
        idxLowerContour = 0;
        idxUpperContour = 0;
        
        % Iterate through the cell array
        for k = 1:length(contourX)
            currentArray = contourX{k};
            currentLength = length(currentArray);
            
            % Check if the current array is longer than the previous longest
            if currentLength > maxLength
                secondMaxLength = maxLength;
                idxUpperContour = idxLowerContour;
                
                maxLength = currentLength;
                idxLowerContour = k;
            elseif currentLength > secondMaxLength
                secondMaxLength = currentLength;
                idxUpperContour = k;
            end
        end
        
        % Smooth contours to remove noisy patterns
        x1 = smoothdata(contourX{idxLowerContour}, "movmean", round(length(contourX{idxLowerContour})/50));
        y1 = smoothdata(contourY{idxLowerContour}, "movmean", round(length(contourY{idxLowerContour})/50));
        x2 = smoothdata(contourX{idxUpperContour}, "movmean", round(length(contourX{idxUpperContour})/50));
        y2 = smoothdata(contourY{idxUpperContour}, "movmean", round(length(contourY{idxUpperContour})/50));

        % Check whether the correct contours have been selected
        plot(x1, y1, 'g', 'LineWidth',3)
        plot(x2, y2, 'g', 'LineWidth',3)
        hold off

        % Create polygons from the contour coordinates
        xpos = X_temp(:);
        ypos = Y_temp(:);
        z = Z_temp(:);
        vert = [xpos, ypos];
        node1 = [x1; y1]';
        node2 = [x2; y2]';
        edge = []; % It's assumed that the vertices in NODE are connected in ascending order
        
        [stat1, bnds1] = inpoly2(vert, node1, edge);
        [stat2, bnds2] = inpoly2(vert, node2, edge);

        % The lower contour may not always be the longest
        if mean(z(stat2), 'omitmissing') > mean(z(stat1), 'omitmissing')
            highLim = stat2;
            lowLim = stat1;
        else
            highLim = stat1;
            lowLim = stat2;
        end
        
        interiorZhigh = z(highLim);
        interiorZlow = z(lowLim);

        % Check whether the correct area has been selected
        nexttile
        plot(xpos(~lowLim), ypos(~lowLim), 'r.', ...
            'MarkerSize',14)
        axis equal off; hold on;
        plot(xpos(lowLim), ypos(lowLim),'b.', ...
            'MarkerSize',14)
        plot(xpos(highLim), ypos(highLim),'r.', ...
            'MarkerSize',14)
        % plot(xpos(bnds1), ypos(bnds1),'ks')
        % plot(xpos(bnds2), ypos(bnds2),'ks')
        legend('exterior', 'interior')
        hold off; linkaxes
        
        totalVolume = abs(sum(interiorZlow, 'omitmissing') - sum(interiorZhigh, 'omitmissing'));

        fprintf('%s, %s, between %.2f and %.2f m+NAP: V_tot = %.2d m^3\n',...
            surveyName, upper(pgonName), contourLevels(1), contourLevels(2), totalVolume);
        drawnow

        waitbar(j/numel(pgonNames), wb2, sprintf('Computing polygon volumes: %d%%', floor(j/numel(pgonNames)*100)))
        pause(1)

    end

    waitbar(i/numel(DEMS), wb1, sprintf('Processing surveys: %d%%', floor(i/numel(DEMS)*100)))
    pause(0.1)
    close(wb2)

end
close(wb1)

%% Test case (regular grid required)
% % Use inpolygon to find which grid cells are within the polygon
% inArea = inpolygon(X, Y, pgns.spit(:,1), pgns.spit(:,2));
% 
% % Calculate the volume of each cell where Z > 0 and it's inside the polygon
% cell_area = abs(X(1, 2) - X(1, 1)) * abs(Y(2, 1) - Y(1, 1)); % Calculate cell area in square meters
% volume_per_cell = cell_area * max(0, Z) .* inArea; % Volume for each cell inside the polygon
% 
% % Sum up the volumes for cells inside the polygon where Z > 0
% total_volume = sum(volume_per_cell(:), 'omitmissing');

