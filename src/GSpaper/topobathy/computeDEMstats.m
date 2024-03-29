%% Initialisation
close all
clear
clc

[basePath, fontsize, cbf, PHZ] = eurecca_init;

% Load survey info
load DEMsurveys.mat

% Load polygons
pgons = getPgons;
warning off

% Define contour levels
% contourLevels = [0.2, 1.85];  % Max Berning
% contourLevels = [-.5, 3];  % old limits used
contourLevels = [0.3, 2.3, 4.3, -1.6];  % 2021 Q4 insufficient spatial coverage

% DEM survey information
dataPathDEM = [basePath 'data' filesep 'elevation' filesep 'processed' filesep];
DEMS = dir(fullfile(dataPathDEM,'PHZ*.mat'));

% Load DEMs
wb = waitbar(0, 'Loading DEMs');
for i = 1:numel(DEMS)

    DEMS(i).data = load(DEMS(i).name);
    waitbar(i/numel(DEMS), wb, sprintf('Loading DEMs: %d%%', floor(i/numel(DEMS)*100)))
    pause(0.1)

end
close(wb)

% Crop DEMs to fit scope
wb = waitbar(0, 'Cropping DEMs to fit scope');
for i = 1:numel(DEMS)

    % Create a logical mask for points within the polygon
    inScope = inpoly2([DEMS(i).data.DEM.X(:), DEMS(i).data.DEM.Y(:)], pgons.scope);
    
    % Apply the mask to the X, Y, and Z arrays
    DEMS(i).data.DEM.X(~inScope) = NaN;
    DEMS(i).data.DEM.Y(~inScope) = NaN;
    DEMS(i).data.DEM.Z(~inScope) = NaN;

    waitbar(i/numel(DEMS), wb, sprintf('Cropping DEMs to fit scope: %d%%', floor(i/numel(DEMS)*100)))
    pause(0.1)

end
close(wb)


%% Display DEMs
% figure2
% tiledlayout('flow', 'TileSpacing','tight')
% 
% wb = waitbar(0, 'Rendering DEMs');
% for i = 1:numel(DEMS)
% 
%     data = DEMS(i).data.DEM;
%     X = data.X;
%     Y = data.Y;
%     Z = data.Z;
% 
%     nexttile
%     surf(X, Y, Z)
%     title(DEMsurveys.name(i))
% 
%     shading flat
%     cmocean('delta')
%     clim([-8, 8])
%     axis off equal
%     view(46, 90)
% 
%     waitbar(i/numel(DEMS), wb, sprintf('Rendering DEMs: %d%%', floor(i/numel(DEMS)*100)))
%     pause(0.1)
% 
% end
% close(wb)


%% Initialise contour maps (foreshore)

% Preallocation
contourData = cell(size(DEMS));
objectProp = cell(size(DEMS));
x = cell(size(DEMS));
y = cell(size(DEMS));
indices = cell(size(DEMS));

figure2
tiledlayout('flow', 'TileSpacing','tight')

wb = waitbar(0, 'Rendering contour maps');
for i = 1:numel(DEMS)

    data = DEMS(i).data.DEM;
    X = data.X;
    Y = data.Y;
    Z = data.Z;

    nexttile
    [contourData{i}, objectProp{i}] = contourf(X, Y, Z, contourLevels(1:2), 'ShowText','off');
    title(DEMsurveys.name(i))
    hold on

    shading flat
    cmocean('delta')
    clim([-8, 8])
    axis off equal
    view(46, 90)

    % Find the major contour lines
    [contourX, contourY, ~] = C2xyz(contourData{i});

    % Use cellfun to calculate the length of each array in the cell
    arrayLengths = cellfun(@numel, contourX);
    
    % Use logical indexing to find the indices of significant contour lines
    indices{i} = find(arrayLengths > 100);
    x{i} = contourX(indices{i});
    y{i} = contourY(indices{i});

    % Check whether the correct contours have been selected
    for k = 1:numel(indices{i})
        x{i}{k} = smoothdata(x{i}{k}, "lowess",50);
        y{i}{k} = smoothdata(y{i}{k}, "lowess",50);
        plot(x{i}{k}, y{i}{k}, 'r', 'LineWidth',2)
    end
    % patch(pgons.south_beach(:,1), pgons.south_beach(:,2), 'b', 'FaceAlpha',.2, 'EdgeColor','b', 'LineWidth',3)
    % patch(pgons.spit_sea(:,1), pgons.spit_sea(:,2), 'y', 'FaceAlpha',.2, 'EdgeColor','y', 'LineWidth',3)
    % patch(pgons.hook(:,1), pgons.hook(:,2), 'g', 'FaceAlpha',.2, 'EdgeColor','g', 'LineWidth',3)
    % patch(pgons.lagoon(:,1), pgons.lagoon(:,2), 'w', 'FaceAlpha',.2, 'EdgeColor','w', 'LineWidth',3)
    % patch(pgons.ceres(:,1), pgons.ceres(:,2), 'k', 'FaceAlpha',.2, 'EdgeColor','k', 'LineWidth',3)
    % patch(pgons.gate(:,1), pgons.gate(:,2), 'm', 'FaceAlpha',.2, 'EdgeColor','m', 'LineWidth',3)
    % text(mean(pgons.south_beach(:,1)), mean(pgons.south_beach(:,2)), "1", 'FontSize',fontsize, 'FontWeight','bold', 'HorizontalAlignment','center', 'Color','b')
    % text(mean(pgons.spit_sea(:,1)), mean(pgons.spit_sea(:,2)), "2", 'FontSize',fontsize, 'FontWeight','bold', 'HorizontalAlignment','center', 'Color','y')
    % text(mean(pgons.hook(:,1)), mean(pgons.hook(:,2)), "3", 'FontSize',fontsize, 'FontWeight','bold', 'HorizontalAlignment','center', 'Color','g')
    % text(mean(pgons.lagoon(:,1)), mean(pgons.lagoon(:,2)), "4", 'i = 1FontSize',fontsize, 'FontWeight','bold', 'HorizontalAlignment','center', 'Color','w')
    % text(mean(pgons.ceres(:,1)), mean(pgons.ceres(:,2)), "5", 'FontSize',fontsize, 'FontWeight','bold', 'HorizontalAlignment','center', 'Color','k')
    % text(mean(pgons.gate(:,1)), mean(pgons.gate(:,2)), "6", 'FontSize',fontsize, 'FontWeight','bold', 'HorizontalAlignment','center', 'Color','m')
    hold off

    waitbar(i/numel(DEMS), wb, sprintf('Rendering contour maps: %d%%', floor(i/numel(DEMS)*100)))
    pause(0.1)

end
close(wb)

clearvars ans arrayLengths contourData contourX contourY data dataPathDEM i inScope k objectProp wb X Y Z
close all


%% Crop DEMs (zone 1: south_beach)

% Preallocation
X1 = cell(size(DEMS));
Y1 = cell(size(DEMS));
Z1 = cell(size(DEMS));
x1 = cell(size(DEMS));
y1 = cell(size(DEMS));
contourMask = cell(size(DEMS));

wb = waitbar(0, 'Cropping DEMs (zone 1)');
for i = 1:numel(DEMS)
    
    % Copy variables
    X1{i} = DEMS(i).data.DEM.X;
    Y1{i} = DEMS(i).data.DEM.Y;
    Z1{i} = DEMS(i).data.DEM.Z;
    x1{i} = x{i};
    y1{i} = y{i};

    % Create a logical mask for points within the polygon
    inPolygon = inpoly2([X1{i}(:), Y1{i}(:)], pgons.south_beach);

    % Apply area mask
    X1{i}(~inPolygon) = NaN;
    Y1{i}(~inPolygon) = NaN;
    Z1{i}(~inPolygon) = NaN;

    % Same for the contour lines
    inPolygonC = cell(size(indices{i}));
    contourLine = cell(size(indices{i}));
    for j = 1:numel(indices{i})
        inPolygonC{j} = inpoly2([x1{i}{j}', y1{i}{j}'], pgons.south_beach);

        x1{i}{j} = x1{i}{j}(inPolygonC{j});
        y1{i}{j} = y1{i}{j}(inPolygonC{j});
        contourLine{j} = [x1{i}{j}', y1{i}{j}'];
    end

    % Only keep the longest three non-empty contour lines
    arrayLengths = cellfun(@length, contourLine);
    [sortedLengths, sortedIndices] = sort(arrayLengths, 'descend');
    contourLine = contourLine(sortedIndices(1:3));
    contourLine = contourLine(~cellfun('isempty', contourLine));

    % Reorder the contour lines to produce the correct polygon
    if length(contourLine) == 2 || i == 5  % Q3 2020
        contourMask{i} = [contourLine{2}(1, :); contourLine{1}; flipud(contourLine{2})];
    elseif length(contourLine) == 3
        contourMask{i} = [contourLine{3}(1, :); contourLine{1}; flipud(contourLine{2}); flipud(contourLine{3})];
    else
        fprintf(2, ['Iteration ', num2str(i), ': ', char(DEMsurveys.name(i)), ' has <2 contour lines\n']);
    end

    % Create a logical mask for points within the contour polygon
    try
        betweenContours = inpoly2([X1{i}(:), Y1{i}(:)], contourMask{i});
    catch
        fprintf(2, ['Error in iteration ', num2str(i), ': ', char(DEMsurveys.name(i)), '\n']);
        continue
    end

    % Apply the mask
    X1{i}(~betweenContours) = NaN;
    Y1{i}(~betweenContours) = NaN;
    Z1{i}(~betweenContours) = NaN;
    
    waitbar(i/numel(DEMS), wb, sprintf('Cropping DEMs (zone 1): %d%%', floor(i/numel(DEMS)*100)))
    pause(0.1)

end
close(wb)


%% Display contour maps (zone 1: south_beach)

% Preallocation
poly1_array = cell(1, length(DEMS));
perimeter1 = nan(size(DEMS));
area1 = nan(size(DEMS));
volume1 = nan(size(DEMS));

figure2
tiledlayout('flow', 'TileSpacing','tight')

wb = waitbar(0, 'Rendering contour maps');
for i = 1:numel(DEMS)

    % Compute geometric quantities
    try 
        polyin = polyshape(contourMask{i});
        poly1_array{i} = polyin;
        perimeter1(i) = perimeter(polyin);
        area1(i) = area(polyin);
        volume1(i) = sum(Z1{i}(:)-contourLevels(4),'omitmissing');  % With respect to base level platform
    catch
        poly1_array{i} = poly1_array{i-1};
        perimeter1(i) = NaN;
        area1(i) = NaN;
        volume1(i) = NaN;

        fprintf(2, ['Error in iteration ', num2str(i), ': ', char(DEMsurveys.name(i)), '\n']);
        continue
    end

    % Visualise the area of interest
    nexttile
    contourf(X1{i}, Y1{i}, Z1{i}, contourLevels, 'ShowText','off'); hold on
    plot(polyin, "FaceAlpha",0, "LineWidth",3, "EdgeColor",'r')

    [xpoly,ypoly] = centroid(polyin);
    text(xpoly-300, ypoly+100, ['P = ', num2str(perimeter1(i), '%.2e'), ' m\newline' ...
        'A = ', num2str(area1(i), '%.2e'), ' m^2\newline' ...
        'V = ', num2str(volume1(i), '%.2e'), ' m^3'], "FontSize",fontsize/2)

    title(DEMsurveys.name(i))
    cmocean('delta')
    clim([-8, 8])
    axis off equal
    view(46, 90)

    waitbar(i/numel(DEMS), wb, sprintf('Rendering contour maps: %d%%', floor(i/numel(DEMS)*100)))
    pause(0.1)

end
close(wb)

clearvars arrayLengths betweenContours contourLine contourMask i inPolygon inPolygonC j polyin sortedIndices sortedLengths wb x1 X1 xpoly y1 Y1 ypoly Z1
close all


%% Crop DEMs (zone 2: spit_sea)

% Preallocation
X2 = cell(size(DEMS));
Y2 = cell(size(DEMS));
Z2 = cell(size(DEMS));
x2 = cell(size(DEMS));
y2 = cell(size(DEMS));
contourMask = cell(size(DEMS));

wb = waitbar(0, 'Cropping DEMs (zone 2)');
for i = 1:numel(DEMS)
    
    % Copy variables
    X2{i} = DEMS(i).data.DEM.X;
    Y2{i} = DEMS(i).data.DEM.Y;
    Z2{i} = DEMS(i).data.DEM.Z;
    x2{i} = x{i};
    y2{i} = y{i};

    % Create a logical mask for points within the polygon
    inPolygon = inpoly2([X2{i}(:), Y2{i}(:)], pgons.spit_sea);

    % Apply area mask
    X2{i}(~inPolygon) = NaN;
    Y2{i}(~inPolygon) = NaN;
    Z2{i}(~inPolygon) = NaN;

    % Same for the contour lines
    inPolygonC = cell(size(indices{i}));
    contourLine = cell(size(indices{i}));
    for j = 1:numel(indices{i})
        inPolygonC{j} = inpoly2([x2{i}{j}', y2{i}{j}'], pgons.spit_sea);

        x2{i}{j} = x2{i}{j}(inPolygonC{j});
        y2{i}{j} = y2{i}{j}(inPolygonC{j});
        contourLine{j} = [x2{i}{j}', y2{i}{j}'];
    end

    % Only keep the longest three non-empty contour lines
    arrayLengths = cellfun(@length, contourLine);
    [sortedLengths, sortedIndices] = sort(arrayLengths, 'descend');
    contourLine = contourLine(sortedIndices(1:2));
    contourLine = contourLine(~cellfun('isempty', contourLine));

    % Check whether the lower contour line has sufficient coverage
    if length(contourLine{2}) < 1000
        fprintf(2, ['Iteration ', num2str(i), ': ', char(DEMsurveys.name(i)), ' has insufficient coverage\n']);
        continue
    end

    % Reorder the contour lines to produce the correct polygon
    if length(contourLine) == 2
        contourMask{i} = [contourLine{2}(1, :); contourLine{1}; flipud(contourLine{2})];
    % elseif length(contourLine) == 3
    %     contourMask{i} = [contourLine{2}(1, :); contourLine{1}; contourLine{3}; flipud(contourLine{2})];
    % elseif length(contourLine) == 4
    %     contourMask{i} = [contourLine{2}(1, :); contourLine{1};  contourLine{3}; contourLine{4}; flipud(contourLine{2})];
    else
        fprintf(2, ['Iteration ', num2str(i), ': ', char(DEMsurveys.name(i)), ' has <2 contour lines\n']);
    end

    % Create a logical mask for points within the contour polygon
    try
        betweenContours = inpoly2([X2{i}(:), Y2{i}(:)], contourMask{i});
    catch
        fprintf(2, ['Error in iteration ', num2str(i), ': ', char(DEMsurveys.name(i)), '\n']);
        continue
    end

    % Apply the mask
    X2{i}(~betweenContours) = NaN;
    Y2{i}(~betweenContours) = NaN;
    Z2{i}(~betweenContours) = NaN;
    
    waitbar(i/numel(DEMS), wb, sprintf('Cropping DEMs (zone 2): %d%%', floor(i/numel(DEMS)*100)))
    pause(0.1)

end
close(wb)


%% Display contour maps (zone 2: spit_sea)

% Preallocation
poly2_array = cell(1, length(DEMS));
perimeter2 = nan(size(DEMS));
area2 = nan(size(DEMS));
volume2 = nan(size(DEMS));

figure2
tiledlayout('flow', 'TileSpacing','tight')

wb = waitbar(0, 'Rendering contour maps');
for i = 1:numel(DEMS)

    % Compute geometric quantities
    try 
        polyin = polyshape(contourMask{i});
        poly2_array{i} = polyin;
        perimeter2(i) = perimeter(polyin);
        area2(i) = area(polyin);
        volume2(i) = sum(Z2{i}(:)-contourLevels(4),'omitmissing');  % With respect to base level platform
    catch
        poly2_array{i} = poly2_array{i-1};
        perimeter2(i) = NaN;
        area2(i) = NaN;
        volume2(i) = NaN;

        fprintf(2, ['Error in iteration ', num2str(i), ': ', char(DEMsurveys.name(i)), '\n']);
        continue
    end

    % Visualise the area of interest
    nexttile
    contourf(X2{i}, Y2{i}, Z2{i}, contourLevels, 'ShowText','off'); hold on
    plot(polyin, "FaceAlpha",0, "LineWidth",3, "EdgeColor",'r')

    [xpoly,ypoly] = centroid(polyin);
    text(xpoly-300, ypoly+100, ['P = ', num2str(perimeter2(i), '%.2e'), ' m\newline' ...
        'A = ', num2str(area2(i), '%.2e'), ' m^2\newline' ...
        'V = ', num2str(volume2(i), '%.2e'), ' m^3'], "FontSize",fontsize/2)

    title(DEMsurveys.name(i))
    cmocean('delta')
    clim([-8, 8])
    axis off equal
    view(46, 90)

    waitbar(i/numel(DEMS), wb, sprintf('Rendering contour maps: %d%%', floor(i/numel(DEMS)*100)))
    pause(0.1)

end
close(wb)

clearvars arrayLengths betweenContours contourLine contourMask i inPolygon inPolygonC j polyin sortedIndices sortedLengths wb x2 X2 xpoly y2 Y2 ypoly Z2
close all


%% Crop DEMs (zone 3: hook)

% Preallocation
X3 = cell(size(DEMS));
Y3 = cell(size(DEMS));
Z3 = cell(size(DEMS));
x3 = cell(size(DEMS));
y3 = cell(size(DEMS));
contourMask = cell(size(DEMS));

wb = waitbar(0, 'Cropping DEMs (zone 3)');
for i = 1:numel(DEMS)
    
    % Copy variables
    X3{i} = DEMS(i).data.DEM.X;
    Y3{i} = DEMS(i).data.DEM.Y;
    Z3{i} = DEMS(i).data.DEM.Z;
    x3{i} = x{i};
    y3{i} = y{i};

    % Create a logical mask for points within the polygon
    inPolygon = inpoly2([X3{i}(:), Y3{i}(:)], pgons.hook);

    % Apply area mask
    X3{i}(~inPolygon) = NaN;
    Y3{i}(~inPolygon) = NaN;
    Z3{i}(~inPolygon) = NaN;

    % Same for the contour lines
    inPolygonC = cell(size(indices{i}));
    contourLine = cell(size(indices{i}));
    for j = 1:numel(indices{i})
        inPolygonC{j} = inpoly2([x3{i}{j}', y3{i}{j}'], pgons.hook);

        x3{i}{j} = x3{i}{j}(inPolygonC{j});
        y3{i}{j} = y3{i}{j}(inPolygonC{j});
        contourLine{j} = [x3{i}{j}', y3{i}{j}'];
    end

    % Only keep the longest three non-empty contour lines
    arrayLengths = cellfun(@length, contourLine);
    [sortedLengths, sortedIndices] = sort(arrayLengths, 'descend');
    if i == 5 || i == 6  % Q3 2020 or Q4 2020
        contourLine = contourLine(sortedIndices([1, 3]));
    elseif i == 8  % Q2 2021
        contourLine = contourLine(sortedIndices(1:2));
    else
        contourLine = contourLine(sortedIndices(1:3));
    end
    contourLine = contourLine(~cellfun('isempty', contourLine));
    
    % % Initialize a logical mask to identify arrays with length >= 100
    % mask = cellfun(@(x) length(x) >= 100, contourLine);
    % 
    % % Remove arrays with length < 100 using the mask
    % contourLine = contourLine(mask);

    % Reorder the contour lines to produce the correct polygon
    if length(contourLine) == 1
        contourMask{i} = contourLine{1};
    elseif length(contourLine) == 2 && i == 2
        contourMask{i} = [contourLine{2}(end, :); contourLine{1}; contourLine{2}];
    elseif length(contourLine) == 2
        contourMask{i} = [contourLine{2}(1, :); contourLine{1}; flipud(contourLine{2})];
    elseif length(contourLine) == 3
        contourMask{i} = [contourLine{3}(1, :); contourLine{2}; contourLine{1}; flipud(contourLine{3})];
    else
        fprintf(2, ['Iteration ', num2str(i), ': ', char(DEMsurveys.name(i)), ' has <1 contour lines\n']);
    end

    % Create a logical mask for points within the contour polygon
    try
        betweenContours = inpoly2([X3{i}(:), Y3{i}(:)], contourMask{i});
    catch
        fprintf(2, ['Error in iteration ', num2str(i), ': ', char(DEMsurveys.name(i)), '\n']);
        continue
    end

    % Apply the mask
    X3{i}(~betweenContours) = NaN;
    Y3{i}(~betweenContours) = NaN;
    Z3{i}(~betweenContours) = NaN;
    
    waitbar(i/numel(DEMS), wb, sprintf('Cropping DEMs (zone 3): %d%%', floor(i/numel(DEMS)*100)))
    pause(0.1)

end
close(wb)


%% Display contour maps (zone 3: hook)

% Preallocation
poly3_array = cell(1, length(DEMS));
perimeter3 = nan(size(DEMS));
area3 = nan(size(DEMS));
volume3 = nan(size(DEMS));

figure2
tiledlayout('flow', 'TileSpacing','tight')

wb = waitbar(0, 'Rendering contour maps');
for i = 1:numel(DEMS)

    % Compute geometric quantities
    try 
        polyin = polyshape(contourMask{i});
        poly3_array{i} = polyin;
        perimeter3(i) = perimeter(polyin);
        area3(i) = area(polyin);
        volume3(i) = sum(Z3{i}(:)-contourLevels(4),'omitmissing');  % With respect to base level platform
    catch
        poly3_array{i} = poly3_array{i-1};
        perimeter3(i) = NaN;
        area3(i) = NaN;
        volume3(i) = NaN;

        fprintf(2, ['Error in iteration ', num2str(i), ': ', char(DEMsurveys.name(i)), '\n']);
        continue
    end

    % Visualise the area of interest
    nexttile
    contourf(X3{i}, Y3{i}, Z3{i}, contourLevels, 'ShowText','off'); hold on
    plot(polyin, "FaceAlpha",0, "LineWidth",3, "EdgeColor",'r')

    [xpoly,ypoly] = centroid(polyin);
    text(xpoly-100, ypoly+50, ['P = ', num2str(perimeter3(i), '%.2e'), ' m\newline' ...
        'A = ', num2str(area3(i), '%.2e'), ' m^2\newline' ...
        'V = ', num2str(volume3(i), '%.2e'), ' m^3'], "FontSize",fontsize/2)

    title(DEMsurveys.name(i))
    cmocean('delta')
    clim([-8, 8])
    axis off equal
    view(46, 90)

    waitbar(i/numel(DEMS), wb, sprintf('Rendering contour maps: %d%%', floor(i/numel(DEMS)*100)))
    pause(0.1)

end
close(wb)

clearvars arrayLengths betweenContours contourLine contourMask i inPolygon inPolygonC j polyin3 sortedIndices sortedLengths wb x3 X3 xpoly y3 Y3 ypoly Z3
close all


%% Crop DEMs (zone 4: lagoon)

% Preallocation
X4 = cell(size(DEMS));
Y4 = cell(size(DEMS));
Z4 = cell(size(DEMS));
x4 = cell(size(DEMS));
y4 = cell(size(DEMS));
contourMask = cell(size(DEMS));

wb = waitbar(0, 'Cropping DEMs (zone 4)');
for i = 1:numel(DEMS)
    
    % Copy variables
    X4{i} = DEMS(i).data.DEM.X;
    Y4{i} = DEMS(i).data.DEM.Y;
    Z4{i} = DEMS(i).data.DEM.Z;
    x4{i} = x{i};
    y4{i} = y{i};

    % Create a logical mask for points within the polygon
    inPolygon = inpoly2([X4{i}(:), Y4{i}(:)], pgons.lagoon);

    % Apply area mask
    X4{i}(~inPolygon) = NaN;
    Y4{i}(~inPolygon) = NaN;
    Z4{i}(~inPolygon) = NaN;

    % Same for the contour lines
    inPolygonC = cell(size(indices{i}));
    contourLine = cell(size(indices{i}));
    for j = 1:numel(indices{i})
        inPolygonC{j} = inpoly2([x4{i}{j}', y4{i}{j}'], pgons.lagoon);

        x4{i}{j} = x4{i}{j}(inPolygonC{j});
        y4{i}{j} = y4{i}{j}(inPolygonC{j});
        contourLine{j} = [x4{i}{j}', y4{i}{j}'];
    end

    % Only keep the longest three non-empty contour lines
    arrayLengths = cellfun(@length, contourLine);
    [sortedLengths, sortedIndices] = sort(arrayLengths, 'descend');
    contourLine = contourLine(sortedIndices(1:3));
    contourLine = contourLine(~cellfun('isempty', contourLine));
    
    % Initialize a logical mask to identify arrays with length >= 500
    mask = cellfun(@(x) length(x) >= 500, contourLine);

    % Remove arrays with length < 500 using the mask
    contourLine = contourLine(mask);

    % Reorder the contour lines to produce the correct polygon
    if length(contourLine) == 2
        contourMask{i} = [contourLine{2}(1, :); contourLine{1}; flipud(contourLine{2})];
    elseif length(contourLine) == 3
        contourMask{i} = [contourLine{3}(1, :); contourLine{1}; flipud(contourLine{2}); flipud(contourLine{3})];
    else
        fprintf(2, ['Iteration ', num2str(i), ': ', char(DEMsurveys.name(i)), ' has <2 contour lines\n']);
    end

    % Create a logical mask for points within the contour polygon
    try
        betweenContours = inpoly2([X4{i}(:), Y4{i}(:)], contourMask{i});
    catch
        fprintf(2, ['Error in iteration ', num2str(i), ': ', char(DEMsurveys.name(i)), '\n']);
        continue
    end

    % Apply the mask
    X4{i}(~betweenContours) = NaN;
    Y4{i}(~betweenContours) = NaN;
    Z4{i}(~betweenContours) = NaN;
    
    waitbar(i/numel(DEMS), wb, sprintf('Cropping DEMs (zone 4): %d%%', floor(i/numel(DEMS)*100)))
    pause(0.1)

end
close(wb)


%% Display contour maps (zone 4: lagoon)

% Preallocation
poly4_array = cell(1, length(DEMS));
perimeter4 = nan(size(DEMS));
area4 = nan(size(DEMS));
volume4 = nan(size(DEMS));

figure2
tiledlayout('flow', 'TileSpacing','tight')

wb = waitbar(0, 'Rendering contour maps');
for i = 1:numel(DEMS)

    % Compute geometric quantities
    try 
        polyin = polyshape(contourMask{i});
        poly4_array{i} = polyin;
        perimeter4(i) = perimeter(polyin);
        area4(i) = area(polyin);
        volume4(i) = sum(Z4{i}(:)-contourLevels(4),'omitmissing');  % With respect to base level platform
    catch
        poly4_array{i} = poly4_array{i-1};
        perimeter4(i) = NaN;
        area4(i) = NaN;
        volume4(i) = NaN;

        fprintf(2, ['Error in iteration ', num2str(i), ': ', char(DEMsurveys.name(i)), '\n']);
        continue
    end

    % Visualise the area of interest
    nexttile
    contourf(X4{i}, Y4{i}, Z4{i}, contourLevels, 'ShowText','off'); hold on
    plot(polyin, "FaceAlpha",0, "LineWidth",3, "EdgeColor",'r')

    [xpoly,ypoly] = centroid(polyin);
    text(xpoly-300, ypoly+100, ['P = ', num2str(perimeter4(i), '%.2e'), ' m\newline' ...
        'A = ', num2str(area4(i), '%.2e'), ' m^2\newline' ...
        'V = ', num2str(volume4(i), '%.2e'), ' m^3'], "FontSize",fontsize/2)

    title(DEMsurveys.name(i))
    cmocean('delta')
    clim([-8, 8])
    axis off equal
    view(46, 90)

    waitbar(i/numel(DEMS), wb, sprintf('Rendering contour maps: %d%%', floor(i/numel(DEMS)*100)))
    pause(0.1)

end
close(wb)

clearvars arrayLengths betweenContours contourLine contourMask i inPolygon inPolygonC j polyin sortedIndices sortedLengths wb x4 X4 xpoly y4 Y4 ypoly Z4
close all


%% Crop DEMs (zone 5: Ceres)

% Preallocation
X5 = cell(size(DEMS));
Y5 = cell(size(DEMS));
Z5 = cell(size(DEMS));
x5 = cell(size(DEMS));
y5 = cell(size(DEMS));
contourMask = cell(size(DEMS));

wb = waitbar(0, 'Cropping DEMs (zone 5)');
for i = 1:numel(DEMS)
    if i == 6
        continue  % Q4 2020 insufficient spatial coverage
    end
    
    % Copy variables
    X5{i} = DEMS(i).data.DEM.X;
    Y5{i} = DEMS(i).data.DEM.Y;
    Z5{i} = DEMS(i).data.DEM.Z;
    x5{i} = x{i};
    y5{i} = y{i};

    % Create a logical mask for points within the polygon
    inPolygon = inpoly2([X5{i}(:), Y5{i}(:)], pgons.ceres);

    % Apply area mask
    X5{i}(~inPolygon) = NaN;
    Y5{i}(~inPolygon) = NaN;
    Z5{i}(~inPolygon) = NaN;

    % Same for the contour lines
    inPolygonC = cell(size(indices{i}));
    contourLine = cell(size(indices{i}));
    for j = 1:numel(indices{i})
        inPolygonC{j} = inpoly2([x5{i}{j}', y5{i}{j}'], pgons.ceres);

        x5{i}{j} = x5{i}{j}(inPolygonC{j});
        y5{i}{j} = y5{i}{j}(inPolygonC{j});
        contourLine{j} = [x5{i}{j}', y5{i}{j}'];
    end

    % Only keep the longest three non-empty contour lines
    arrayLengths = cellfun(@length, contourLine);
    [sortedLengths, sortedIndices] = sort(arrayLengths, 'descend');
    if i == 4  % Q2 2020
        contourLine = contourLine(sortedIndices([1, 2, 4]));
    else
        contourLine = contourLine(sortedIndices(1:3));
    end
    contourLine = contourLine(~cellfun('isempty', contourLine));
    
    if i ~= 4
    
    % Initialize a logical mask to identify arrays with length >= 300
    mask = cellfun(@(x) length(x) >= 300, contourLine);

    % Remove arrays with length < 300 using the mask
    contourLine = contourLine(mask);

    end

    % Reorder the contour lines to produce the correct polygon
    if length(contourLine) == 2
        contourMask{i} = [contourLine{2}(1, :); contourLine{1}; flipud(contourLine{2})];
    elseif length(contourLine) == 3 && i == 4
        contourMask{i} = [contourLine{2}(1, :); contourLine{1}; flipud(contourLine{3}); flipud(contourLine{2})];
    elseif length(contourLine) == 3
        contourMask{i} = [contourLine{3}(1, :); contourLine{1}; flipud(contourLine{2}); flipud(contourLine{3})];
    else
        fprintf(2, ['Iteration ', num2str(i), ': ', char(DEMsurveys.name(i)), ' has <2 contour lines\n']);
    end

    % Create a logical mask for points within the contour polygon
    try
        betweenContours = inpoly2([X5{i}(:), Y5{i}(:)], contourMask{i});
    catch
        fprintf(2, ['Error in iteration ', num2str(i), ': ', char(DEMsurveys.name(i)), '\n']);
        continue
    end

    % Apply the mask
    X5{i}(~betweenContours) = NaN;
    Y5{i}(~betweenContours) = NaN;
    Z5{i}(~betweenContours) = NaN;
    
    waitbar(i/numel(DEMS), wb, sprintf('Cropping DEMs (zone 5): %d%%', floor(i/numel(DEMS)*100)))
    pause(0.1)

end
close(wb)


%% Display contour maps (zone 5: Ceres)

% Preallocation
poly5_array = cell(1, length(DEMS));
perimeter5 = nan(size(DEMS));
area5 = nan(size(DEMS));
volume5 = nan(size(DEMS));

figure2
tiledlayout('flow', 'TileSpacing','tight')

wb = waitbar(0, 'Rendering contour maps');
for i = 1:numel(DEMS)

    % Compute geometric quantities
    try 
        polyin = polyshape(contourMask{i});
        poly5_array{i} = polyin;
        perimeter5(i) = perimeter(polyin);
        area5(i) = area(polyin);
        volume5(i) = sum(Z5{i}(:)-contourLevels(4),'omitmissing');  % With respect to base level platform
    catch
        poly5_array{i} = poly5_array{i-1};
        perimeter5(i) = NaN;
        area5(i) = NaN;
        volume5(i) = NaN;

        fprintf(2, ['Error in iteration ', num2str(i), ': ', char(DEMsurveys.name(i)), '\n']);
        continue
    end

    % Visualise the area of interest
    nexttile
    contourf(X5{i}, Y5{i}, Z5{i}, contourLevels, 'ShowText','off'); hold on
    plot(polyin, "FaceAlpha",0, "LineWidth",3, "EdgeColor",'r')

    [xpoly,ypoly] = centroid(polyin);
    text(xpoly-300, ypoly+100, ['P = ', num2str(perimeter5(i), '%.2e'), ' m\newline' ...
        'A = ', num2str(area5(i), '%.2e'), ' m^2\newline' ...
        'V = ', num2str(volume5(i), '%.2e'), ' m^3'], "FontSize",fontsize/2)

    title(DEMsurveys.name(i))
    cmocean('delta')
    clim([-8, 8])
    axis off equal
    view(46, 90)

    waitbar(i/numel(DEMS), wb, sprintf('Rendering contour maps: %d%%', floor(i/numel(DEMS)*100)))
    pause(0.1)

end
close(wb)

clearvars arrayLengths betweenContours contourLine contourMask i inPolygon inPolygonC j polyin sortedIndices sortedLengths wb x5 X5 xpoly y5 Y5 ypoly Z5
close all


%% Crop DEMs (zone 6: Gate)
% 
% % Preallocation
% X6 = cell(size(DEMS));
% Y6 = cell(size(DEMS));
% Z6 = cell(size(DEMS));
% x6 = cell(size(DEMS));
% y6 = cell(size(DEMS));
% contourMask = cell(size(DEMS));
% 
% wb = waitbar(0, 'Cropping DEMs (zone 6)');
% for i = 1:numel(DEMS)
%     if i == 6
%         continue  % Q4 2020 insufficient spatial coverage
%     end
% 
%     % Copy variables
%     X6{i} = DEMS(i).data.DEM.X;
%     Y6{i} = DEMS(i).data.DEM.Y;
%     Z6{i} = DEMS(i).data.DEM.Z;
%     x6{i} = x{i};
%     y6{i} = y{i};
% 
%     % Create a logical mask for points within the polygon
%     inPolygon = inpoly2([X6{i}(:), Y6{i}(:)], pgons.gate);
% 
%     % Apply area mask
%     X6{i}(~inPolygon) = NaN;
%     Y6{i}(~inPolygon) = NaN;
%     Z6{i}(~inPolygon) = NaN;
% 
%     % Same for the contour lines
%     inPolygonC = cell(size(indices{i}));
%     contourLine = cell(size(indices{i}));
%     for j = 1:numel(indices{i})
%         inPolygonC{j} = inpoly2([x6{i}{j}', y6{i}{j}'], pgons.gate);
% 
%         x6{i}{j} = x6{i}{j}(inPolygonC{j});
%         y6{i}{j} = y6{i}{j}(inPolygonC{j});
%         contourLine{j} = [x6{i}{j}', y6{i}{j}'];
%     end
% 
%     % Only keep the longest three non-empty contour lines
%     arrayLengths = cellfun(@length, contourLine);
%     [sortedLengths, sortedIndices] = sort(arrayLengths, 'descend');
%     contourLine = contourLine(sortedIndices(1:3));
%     contourLine = contourLine(~cellfun('isempty', contourLine));
% 
%     % Reorder the contour lines to produce the correct polygon
%     if length(contourLine) == 2
%         contourMask{i} = [contourLine{2}(1, :); contourLine{1}; flipud(contourLine{2})];
%     elseif length(contourLine) == 3
%         contourMask{i} = [contourLine{3}(1, :); contourLine{1}; flipud(contourLine{2}); flipud(contourLine{3})];
%     else
%         fprintf(2, ['Iteration ', num2str(i), ': ', char(DEMsurveys.name(i)), ' has <2 contour lines\n']);
%     end
% 
%     % Create a logical mask for points within the contour polygon
%     try
%         betweenContours = inpoly2([X6{i}(:), Y6{i}(:)], contourMask{i});
%     catch
%         fprintf(2, ['Error in iteration ', num2str(i), ': ', char(DEMsurveys.name(i)), '\n']);
%         continue
%     end
% 
%     % Apply the mask
%     X6{i}(~betweenContours) = NaN;
%     Y6{i}(~betweenContours) = NaN;
%     Z6{i}(~betweenContours) = NaN;
% 
%     waitbar(i/numel(DEMS), wb, sprintf('Cropping DEMs (zone 6): %d%%', floor(i/numel(DEMS)*100)))
%     pause(0.1)
% 
% end
% close(wb)
% 
% 
% %% Display contour maps (zone 6: Gate)
% 
% % Preallocation
% poly6_array = cell(1, length(DEMS));
% perimeter6 = nan(size(DEMS));
% area6 = nan(size(DEMS));
% volume6 = nan(size(DEMS));
% 
% figure2
% tiledlayout('flow', 'TileSpacing','tight')
% 
% wb = waitbar(0, 'Rendering contour maps');
% for i = 1:numel(DEMS)
% 
%     % Compute geometric quantities
%     try 
%         polyin = polyshape(contourMask{i});
%         poly6_array{i} = polyin;
%         perimeter6(i) = perimeter(polyin);
%         area6(i) = area(polyin);
%         volume6(i) = sum(Z6{i}(:)-contourLevels(4),'omitmissing');  % With respect to base level platform
%     catch
%         poly6_array{i} = poly6_array{i-1};
%         perimeter6(i) = NaN;
%         area6(i) = NaN;
%         volume6(i) = NaN;
% 
%         fprintf(2, ['Error in iteration ', num2str(i), ': ', char(DEMsurveys.name(i)), '\n']);
%         continue
%     end
% 
%     % Visualise the area of interest
%     nexttile
%     contourf(X6{i}, Y6{i}, Z6{i}, contourLevels, 'ShowText','off'); hold on
%     plot(polyin, "FaceAlpha",0, "LineWidth",3, "EdgeColor",'r')
% 
%     [xpoly,ypoly] = centroid(polyin);
%     text(xpoly-300, ypoly+100, ['P = ', num2str(perimeter6(i), '%.2e'), ' m\newline' ...
%         'A = ', num2str(area6(i), '%.2e'), ' m^2\newline' ...
%         'V = ', num2str(volume6(i), '%.2e'), ' m^3'], "FontSize",fontsize/2)
% 
%     title(DEMsurveys.name(i))
%     cmocean('delta')
%     clim([-8, 8])
%     axis off equal
%     view(46, 90)
% 
%     waitbar(i/numel(DEMS), wb, sprintf('Rendering contour maps: %d%%', floor(i/numel(DEMS)*100)))
%     pause(0.1)
% 
% end
% close(wb)
% 
% clearvars arrayLengths betweenContours contourLine contourMask i inPolygon inPolygonC j polyin sortedIndices sortedLengths wb x6 X6 xpoly y6 Y6 ypoly Z6
% close all
% 

%% Initiate contour maps (dry beach)

% Preallocation
contourData = cell(size(DEMS));
objectProp = cell(size(DEMS));
x = cell(size(DEMS));
y = cell(size(DEMS));
indices = cell(size(DEMS));

figure2
tiledlayout('flow', 'TileSpacing','tight')

wb = waitbar(0, 'Rendering contour maps');
for i = 1:numel(DEMS)

    data = DEMS(i).data.DEM;
    X = data.X;
    Y = data.Y;
    Z = data.Z;

    nexttile
    [contourData{i}, objectProp{i}] = contourf(X, Y, Z, [contourLevels(2), contourLevels(3)], 'ShowText','off');
    title(DEMsurveys.name(i))
    hold on

    shading flat
    cmocean('delta')
    clim([-8, 8])
    axis off equal
    view(46, 90)

    % Find the major contour lines
    [contourX, contourY, ~] = C2xyz(contourData{i});

    % Use cellfun to calculate the length of each array in the cell
    arrayLengths = cellfun(@numel, contourX);
    
    % Use logical indexing to find the indices of significant contour lines
    indices{i} = find(arrayLengths > 500);
    x{i} = contourX(indices{i});
    y{i} = contourY(indices{i});

    % Check whether the correct contours have been selected
    for k = 1:numel(indices{i})
        x{i}{k} = smoothdata(x{i}{k}, "lowess",50);
        y{i}{k} = smoothdata(y{i}{k}, "lowess",50);
        plot(x{i}{k}, y{i}{k}, 'r', 'LineWidth',2)
    end
    % patch(pgons.south_beach(:,1), pgons.south_beach(:,2), 'b', 'FaceAlpha',.2, 'EdgeColor','b', 'LineWidth',3)
    % patch(pgons.spit(:,1), pgons.spit(:,2), 'y', 'FaceAlpha',.2, 'EdgeColor','y', 'LineWidth',3)
    % patch(pgons.NW_beach(:,1), pgons.NW_beach(:,2), 'm', 'FaceAlpha',.2, 'EdgeColor','m', 'LineWidth',3)
    % text(mean(pgons.south_beach(:,1)), mean(pgons.south_beach(:,2)), "7", 'FontSize',fontsize, 'FontWeight','bold', 'HorizontalAlignment','center', 'Color','b')
    % text(mean(pgons.spit(:,1)), mean(pgons.spit(:,2)), "8", 'FontSize',fontsize, 'FontWeight','bold', 'HorizontalAlignment','center', 'Color','y')
    % text(mean(pgons.NW_beach(:,1)), mean(pgons.NW_beach(:,2)), "9", 'FontSize',fontsize, 'FontWeight','bold', 'HorizontalAlignment','center', 'Color','m')
    hold off

    waitbar(i/numel(DEMS), wb, sprintf('Rendering contour maps: %d%%', floor(i/numel(DEMS)*100)))
    pause(0.1)

end
close(wb)

clearvars arrayLengths contourData contourX contourY data dataPathDEM i inScope k objectProp wb X Y Z
close all


%% Crop DEMs (zone 7: south_beach upper)

% Preallocation
X7 = cell(size(DEMS));
Y7 = cell(size(DEMS));
Z7 = cell(size(DEMS));
x7 = cell(size(DEMS));
y7 = cell(size(DEMS));
contourMask = cell(size(DEMS));

wb = waitbar(0, 'Cropping DEMs (zone 7)');
for i = 1:numel(DEMS)
    
    % Copy variables
    X7{i} = DEMS(i).data.DEM.X;
    Y7{i} = DEMS(i).data.DEM.Y;
    Z7{i} = DEMS(i).data.DEM.Z;
    x7{i} = x{i};
    y7{i} = y{i};

    % Create a logical mask for points within the polygon
    inPolygon = inpoly2([X7{i}(:), Y7{i}(:)], pgons.south_beach);

    % Apply area mask
    X7{i}(~inPolygon) = NaN;
    Y7{i}(~inPolygon) = NaN;
    Z7{i}(~inPolygon) = NaN;

    % Same for the contour lines
    inPolygonC = cell(size(indices{i}));
    contourLine = cell(size(indices{i}));
    for j = 1:numel(indices{i})
        inPolygonC{j} = inpoly2([x7{i}{j}', y7{i}{j}'], pgons.south_beach);

        x7{i}{j} = x7{i}{j}(inPolygonC{j});
        y7{i}{j} = y7{i}{j}(inPolygonC{j});
        contourLine{j} = [x7{i}{j}', y7{i}{j}'];
    end

    % Only keep the longest three non-empty contour lines
    arrayLengths = cellfun(@length, contourLine);
    [sortedLengths, sortedIndices] = sort(arrayLengths, 'descend');
    contourLine = contourLine(sortedIndices(1:3));
    contourLine = contourLine(~cellfun('isempty', contourLine));

    % Reorder the contour lines to produce the correct polygon
    if length(contourLine) == 2
        contourMask{i} = [contourLine{2}(1, :); contourLine{1}; flipud(contourLine{2})];
    elseif length(contourLine) == 3
        contourMask{i} = [contourLine{3}(1, :); contourLine{1}; flipud(contourLine{2}); flipud(contourLine{3})];
    else
        fprintf(2, ['Iteration ', num2str(i), ': ', char(DEMsurveys.name(i)), ' has <2 contour lines\n']);
    end

    % Create a logical mask for points within the contour polygon
    try
        betweenContours = inpoly2([X7{i}(:), Y7{i}(:)], contourMask{i});
    catch
        fprintf(2, ['Error in iteration ', num2str(i), ': ', char(DEMsurveys.name(i)), '\n']);
        continue
    end

    % Apply the mask
    X7{i}(~betweenContours) = NaN;
    Y7{i}(~betweenContours) = NaN;
    Z7{i}(~betweenContours) = NaN;
    
    waitbar(i/numel(DEMS), wb, sprintf('Cropping DEMs (zone 7): %d%%', floor(i/numel(DEMS)*100)))
    pause(0.1)

end
close(wb)


%% Display contour maps (zone 7: south_beach upper)

% Preallocation
poly7_array = cell(1, length(DEMS));
perimeter7 = nan(size(DEMS));
area7 = nan(size(DEMS));
volume7 = nan(size(DEMS));

figure2
tiledlayout('flow', 'TileSpacing','tight')

wb = waitbar(0, 'Rendering contour maps');
for i = 1:numel(DEMS)

    % Compute geometric quantities
    try 
        polyin = polyshape(contourMask{i});
        poly7_array{i} = polyin;
        perimeter7(i) = perimeter(polyin);
        area7(i) = area(polyin);
        volume7(i) = sum(Z7{i}(:)-contourLevels(4),'omitmissing');  % With respect to base level platform
    catch
        poly7_array{i} = poly7_array{i-1};
        perimeter7(i) = NaN;
        area7(i) = NaN;
        volume7(i) = NaN;

        fprintf(2, ['Error in iteration ', num2str(i), ': ', char(DEMsurveys.name(i)), '\n']);
        continue
    end

    % Visualise the area of interest
    nexttile
    contourf(X7{i}, Y7{i}, Z7{i}, contourLevels(2), 'ShowText','off'); hold on
    plot(polyin, "FaceAlpha",0, "LineWidth",3, "EdgeColor",'r')

    [xpoly,ypoly] = centroid(polyin);
    text(xpoly-300, ypoly+100, ['P = ', num2str(perimeter7(i), '%.2e'), ' m\newline' ...
        'A = ', num2str(area7(i), '%.2e'), ' m^2\newline' ...
        'V = ', num2str(volume7(i), '%.2e'), ' m^3'], "FontSize",fontsize/2)

    title(DEMsurveys.name(i))
    cmocean('delta')
    clim([-8, 8])
    axis off equal
    view(46, 90)

    waitbar(i/numel(DEMS), wb, sprintf('Rendering contour maps: %d%%', floor(i/numel(DEMS)*100)))
    pause(0.1)

end
close(wb)

clearvars arrayLengths betweenContours contourLine contourMask i inPolygon inPolygonC j polyin sortedIndices sortedLengths wb x7 X7 xpoly y7 Y7 ypoly Z7
close all


%% Crop DEMs (zone 8: spit upper)

% Preallocation
X8 = cell(size(DEMS));
Y8 = cell(size(DEMS));
Z8 = cell(size(DEMS));
x8 = cell(size(DEMS));
y8 = cell(size(DEMS));
contourMask = cell(size(DEMS));

wb = waitbar(0, 'Cropping DEMs (zone 8)');
for i = 1:numel(DEMS)
    
    % Copy variables
    X8{i} = DEMS(i).data.DEM.X;
    Y8{i} = DEMS(i).data.DEM.Y;
    Z8{i} = DEMS(i).data.DEM.Z;
    x8{i} = x{i};
    y8{i} = y{i};

    % Create a logical mask for points within the polygon
    inPolygon = inpoly2([X8{i}(:), Y8{i}(:)], pgons.spit);

    % Apply area mask
    X8{i}(~inPolygon) = NaN;
    Y8{i}(~inPolygon) = NaN;
    Z8{i}(~inPolygon) = NaN;

    % Same for the contour lines
    inPolygonC = cell(size(indices{i}));
    contourLine = cell(size(indices{i}));
    for j = 1:numel(indices{i})
        inPolygonC{j} = inpoly2([x8{i}{j}', y8{i}{j}'], pgons.spit);

        x8{i}{j} = x8{i}{j}(inPolygonC{j});
        y8{i}{j} = y8{i}{j}(inPolygonC{j});
        contourLine{j} = [x8{i}{j}', y8{i}{j}'];
    end

    % Only keep the longest three non-empty contour lines
    arrayLengths = cellfun(@length, contourLine);
    [sortedLengths, sortedIndices] = sort(arrayLengths, 'descend');
    contourLine = contourLine(sortedIndices(1:3));
    contourLine = contourLine(~cellfun('isempty', contourLine));

    % Reorder the contour lines to produce the correct polygon
    if length(contourLine) == 2
        contourMask{i} = [contourLine{2}(1, :); contourLine{1}; flipud(contourLine{2})];
    elseif length(contourLine) == 3
        contourMask{i} = [contourLine{3}(1, :); contourLine{1}; flipud(contourLine{2}); flipud(contourLine{3})];
    else
        fprintf(2, ['Iteration ', num2str(i), ': ', char(DEMsurveys.name(i)), ' has <2 contour lines\n']);
    end

    % Create a logical mask for points within the contour polygon
    try
        betweenContours = inpoly2([X8{i}(:), Y8{i}(:)], contourMask{i});
    catch
        fprintf(2, ['Error in iteration ', num2str(i), ': ', char(DEMsurveys.name(i)), '\n']);
        continue
    end

    % Apply the mask
    X8{i}(~betweenContours) = NaN;
    Y8{i}(~betweenContours) = NaN;
    Z8{i}(~betweenContours) = NaN;
    
    waitbar(i/numel(DEMS), wb, sprintf('Cropping DEMs (zone 8): %d%%', floor(i/numel(DEMS)*100)))
    pause(0.1)

end
close(wb)


%% Display contour maps (zone 8: spit upper)

% Preallocation
poly8_array = cell(1, length(DEMS));
perimeter8 = nan(size(DEMS));
area8 = nan(size(DEMS));
volume8 = nan(size(DEMS));

figure2
tiledlayout('flow', 'TileSpacing','tight')

wb = waitbar(0, 'Rendering contour maps');
for i = 1:numel(DEMS)

    % Compute geometric quantities
    try 
        polyin = polyshape(contourMask{i});
        poly8_array{i} = polyin;
        perimeter8(i) = perimeter(polyin);
        area8(i) = area(polyin);
        volume8(i) = sum(Z8{i}(:)-contourLevels(4),'omitmissing');  % With respect to base level platform
    catch
        poly8_array{i} = poly8_array{i-1};
        perimeter8(i) = NaN;
        area8(i) = NaN;
        volume8(i) = NaN;

        fprintf(2, ['Error in iteration ', num2str(i), ': ', char(DEMsurveys.name(i)), '\n']);
        continue
    end

    % Visualise the area of interest
    nexttile
    contourf(X8{i}, Y8{i}, Z8{i}, contourLevels(2), 'ShowText','off'); hold on
    plot(polyin, "FaceAlpha",0, "LineWidth",3, "EdgeColor",'r')

    [xpoly,ypoly] = centroid(polyin);
    text(xpoly-300, ypoly+100, ['P = ', num2str(perimeter8(i), '%.2e'), ' m\newline' ...
        'A = ', num2str(area8(i), '%.2e'), ' m^2\newline' ...
        'V = ', num2str(volume8(i), '%.2e'), ' m^3'], "FontSize",fontsize/2)

    title(DEMsurveys.name(i))
    cmocean('delta')
    clim([-8, 8])
    axis off equal
    view(46, 90)

    waitbar(i/numel(DEMS), wb, sprintf('Rendering contour maps: %d%%', floor(i/numel(DEMS)*100)))
    pause(0.1)

end
close(wb)

clearvars arrayLengths betweenContours contourLine contourMask i inPolygon inPolygonC j polyin sortedIndices sortedLengths wb x8 X8 xpoly y8 Y8 ypoly Z8
close all


%% Crop DEMs (zone 9: NW_beach upper)

% Preallocation
X9 = cell(size(DEMS));
Y9 = cell(size(DEMS));
Z9 = cell(size(DEMS));
x9 = cell(size(DEMS));
y9 = cell(size(DEMS));
contourMask = cell(size(DEMS));

wb = waitbar(0, 'Cropping DEMs (zone 9)');
for i = 1:numel(DEMS)
    
    % Copy variables
    X9{i} = DEMS(i).data.DEM.X;
    Y9{i} = DEMS(i).data.DEM.Y;
    Z9{i} = DEMS(i).data.DEM.Z;
    x9{i} = x{i};
    y9{i} = y{i};

    % Create a logical mask for points within the polygon
    inPolygon = inpoly2([X9{i}(:), Y9{i}(:)], pgons.NW_beach);

    % Apply area mask
    X9{i}(~inPolygon) = NaN;
    Y9{i}(~inPolygon) = NaN;
    Z9{i}(~inPolygon) = NaN;

    % Same for the contour lines
    inPolygonC = cell(size(indices{i}));
    contourLine = cell(size(indices{i}));
    for j = 1:numel(indices{i})
        inPolygonC{j} = inpoly2([x9{i}{j}', y9{i}{j}'], pgons.NW_beach);

        x9{i}{j} = x9{i}{j}(inPolygonC{j});
        y9{i}{j} = y9{i}{j}(inPolygonC{j});
        contourLine{j} = [x9{i}{j}', y9{i}{j}'];
    end

    % Only keep the longest three non-empty contour lines
    arrayLengths = cellfun(@length, contourLine);
    [sortedLengths, sortedIndices] = sort(arrayLengths, 'descend');
    contourLine = contourLine(sortedIndices(1:3));
    contourLine = contourLine(~cellfun('isempty', contourLine));

    % Initialize a logical mask to identify arrays with length >= 500
    mask = cellfun(@(x) length(x) >= 500, contourLine);

    % Remove arrays with length < 500 using the mask
    contourLine = contourLine(mask);

    % Reorder the contour lines to produce the correct polygon
    if length(contourLine) == 2
        contourMask{i} = [contourLine{2}(1, :); contourLine{1}; flipud(contourLine{2})];
    elseif length(contourLine) == 3
        contourMask{i} = [contourLine{2}(1, :); contourLine{1}; flipud(contourLine{3}); flipud(contourLine{2})];
    else
        fprintf(2, ['Iteration ', num2str(i), ': ', char(DEMsurveys.name(i)), ' has <2 contour lines\n']);
    end

    % Create a logical mask for points within the contour polygon
    try
        betweenContours = inpoly2([X9{i}(:), Y9{i}(:)], contourMask{i});
    catch
        fprintf(2, ['Error in iteration ', num2str(i), ': ', char(DEMsurveys.name(i)), '\n']);
        continue
    end

    % Apply the mask
    X9{i}(~betweenContours) = NaN;
    Y9{i}(~betweenContours) = NaN;
    Z9{i}(~betweenContours) = NaN;
    
    waitbar(i/numel(DEMS), wb, sprintf('Cropping DEMs (zone 9): %d%%', floor(i/numel(DEMS)*100)))
    pause(0.1)

end
close(wb)


%% Display contour maps (zone 9: NW_beach upper)

% Preallocation
poly9_array = cell(1, length(DEMS));
perimeter9 = nan(size(DEMS));
area9 = nan(size(DEMS));
volume9 = nan(size(DEMS));

figure2
tiledlayout('flow', 'TileSpacing','tight')

wb = waitbar(0, 'Rendering contour maps');
for i = 1:numel(DEMS)

    % Compute geometric quantities
    try 
        polyin = polyshape(contourMask{i});
        poly9_array{i} = polyin;
        perimeter9(i) = perimeter(polyin);
        area9(i) = area(polyin);
        volume9(i) = sum(Z9{i}(:)-contourLevels(4),'omitmissing');  % With respect to base level platform
    catch
        poly9_array{i} = poly9_array{i-1};
        perimeter9(i) = NaN;
        area9(i) = NaN;
        volume9(i) = NaN;

        fprintf(2, ['Error in iteration ', num2str(i), ': ', char(DEMsurveys.name(i)), '\n']);
        continue
    end

    % Visualise the area of interest
    nexttile
    contourf(X9{i}, Y9{i}, Z9{i}, contourLevels(2), 'ShowText','off'); hold on
    plot(polyin, "FaceAlpha",0, "LineWidth",3, "EdgeColor",'r')

    [xpoly,ypoly] = centroid(polyin);
    text(xpoly-300, ypoly+100, ['P = ', num2str(perimeter9(i), '%.2e'), ' m\newline' ...
        'A = ', num2str(area9(i), '%.2e'), ' m^2\newline' ...
        'V = ', num2str(volume9(i), '%.2e'), ' m^3'], "FontSize",fontsize/2)

    title(DEMsurveys.name(i))
    cmocean('delta')
    clim([-8, 8])
    axis off equal
    view(46, 90)

    waitbar(i/numel(DEMS), wb, sprintf('Rendering contour maps: %d%%', floor(i/numel(DEMS)*100)))
    pause(0.1)

end
close(wb)

% clearvars arrayLengths betweenContours contourLine contourMask i inPolygon inPolygonC j polyin sortedIndices sortedLengths wb x9 X9 xpoly y9 Y9 ypoly Z9
% close all


%% Initiate contour maps (below NAP)

% Preallocation
contourData = cell(size(DEMS));
objectProp = cell(size(DEMS));
x = cell(size(DEMS));
y = cell(size(DEMS));
indices = cell(size(DEMS));

figure2
tiledlayout('flow', 'TileSpacing','tight')

wb = waitbar(0, 'Rendering contour maps');
for i = [1, 5, 12, 14]  % Only surveys with bathymetry

    data = DEMS(i).data.DEM;
    X = data.X;
    Y = data.Y;
    Z = data.Z;

    nexttile
    [contourData{i}, objectProp{i}] = contourf(X, Y, Z, [contourLevels(4), contourLevels(1)], 'ShowText','off');
    title(DEMsurveys.name(i))
    hold on

    shading flat
    cmocean('delta')
    clim([-8, 8])
    axis off equal
    view(46, 90)

    % Find the major contour lines
    [contourX, contourY, ~] = C2xyz(contourData{i});

    % Use cellfun to calculate the length of each array in the cell
    arrayLengths = cellfun(@numel, contourX);
    
    % Use logical indexing to find the indices of significant contour lines
    indices{i} = find(arrayLengths > 500);
    x{i} = contourX(indices{i});
    y{i} = contourY(indices{i});

    % Check whether the correct contours have been selected
    for k = 1:numel(indices{i})
        x{i}{k} = smoothdata(x{i}{k}, "lowess",50);
        y{i}{k} = smoothdata(y{i}{k}, "lowess",50);
        plot(x{i}{k}, y{i}{k}, 'r', 'LineWidth',2)
    end
    patch(pgons.south_bathy(:,1), pgons.south_bathy(:,2), 'b', 'FaceAlpha',.2, 'EdgeColor','b', 'LineWidth',3)
    patch(pgons.spit_bathy(:,1), pgons.spit_bathy(:,2), 'y', 'FaceAlpha',.2, 'EdgeColor','y', 'LineWidth',3)
    patch(pgons.north_bathy(:,1), pgons.north_bathy(:,2), 'g', 'FaceAlpha',.2, 'EdgeColor','y', 'LineWidth',3)
    patch(pgons.lagoon_bathy(:,1), pgons.lagoon_bathy(:,2), 'm', 'FaceAlpha',.2, 'EdgeColor','y', 'LineWidth',3)
    % text(mean(pgons.south_bathy(:,1)), mean(pgons.south_bathy(:,2)), "6", 'FontSize',fontsize, 'FontWeight','bold', 'HorizontalAlignment','center', 'Color','b')
    % text(mean(pgons.spit_bathy(:,1)), mean(pgons.spit_bathy(:,2)), "7", 'FontSize',fontsize, 'FontWeight','bold', 'HorizontalAlignment','center', 'Color','y')
    hold off

    waitbar(i/numel(DEMS), wb, sprintf('Rendering contour maps: %d%%', floor(i/numel(DEMS)*100)))
    pause(0.1)

end
close(wb)


%% Crop DEMs (zone 10: south_beach bathy)

% Preallocation
X10 = cell(size(DEMS));
Y10 = cell(size(DEMS));
Z10 = cell(size(DEMS));
x10 = cell(size(DEMS));
y10 = cell(size(DEMS));
contourMask = cell(size(DEMS));

wb = waitbar(0, 'Cropping DEMs (zone 10)');
for i = [1, 5, 12, 14]  % Only surveys with bathymetry
    
    % Copy variables
    X10{i} = DEMS(i).data.DEM.X;
    Y10{i} = DEMS(i).data.DEM.Y;
    Z10{i} = DEMS(i).data.DEM.Z;
    x10{i} = x{i};
    y10{i} = y{i};

    % Create a logical mask for points within the polygon
    inPolygon = inpoly2([X10{i}(:), Y10{i}(:)], pgons.south_bathy);

    % Apply area mask
    X10{i}(~inPolygon) = NaN;
    Y10{i}(~inPolygon) = NaN;
    Z10{i}(~inPolygon) = NaN;

    % Same for the contour lines
    inPolygonC = cell(size(indices{i}));
    contourLine = cell(size(indices{i}));
    for j = 1:numel(indices{i})
        inPolygonC{j} = inpoly2([x10{i}{j}', y10{i}{j}'], pgons.south_bathy);

        x10{i}{j} = x10{i}{j}(inPolygonC{j});
        y10{i}{j} = y10{i}{j}(inPolygonC{j});
        contourLine{j} = [x10{i}{j}', y10{i}{j}'];
    end

    % Only keep the longest three non-empty contour lines
    arrayLengths = cellfun(@length, contourLine);
    [sortedLengths, sortedIndices] = sort(arrayLengths, 'descend');
    try
        contourLine = contourLine(sortedIndices(1:2));
    catch
        fprintf(2, ['Error in iteration ', num2str(i), ': ', char(DEMsurveys.name(i)), '\n']);
        continue
    end
    contourLine = contourLine(~cellfun('isempty', contourLine));

    % Reorder the contour lines to produce the correct polygon
    if length(contourLine) == 2
        contourMask{i} = [contourLine{2}(1, :); contourLine{1}; flipud(contourLine{2})];
    else
        fprintf(2, ['Iteration ', num2str(i), ': ', char(DEMsurveys.name(i)), ' has <2 contour lines\n']);
    end

    % Create a logical mask for points within the contour polygon
    try
        betweenContours = inpoly2([X10{i}(:), Y10{i}(:)], contourMask{i});
    catch
        fprintf(2, ['Error in iteration ', num2str(i), ': ', char(DEMsurveys.name(i)), '\n']);
        continue
    end

    % Apply the mask
    X10{i}(~betweenContours) = NaN;
    Y10{i}(~betweenContours) = NaN;
    Z10{i}(~betweenContours) = NaN;
    
    waitbar(i/numel(DEMS), wb, sprintf('Cropping DEMs (zone 10): %d%%', floor(i/numel(DEMS)*100)))
    pause(0.1)

end
close(wb)


%% Display contour maps (zone 10: south_beach bathy)

% Preallocation
poly10_array = cell(1, length(DEMS));
perimeter10 = nan(size(DEMS));
area10 = nan(size(DEMS));
volume10 = nan(size(DEMS));

figure2
tiledlayout('flow', 'TileSpacing','tight')

wb = waitbar(0, 'Rendering contour maps');
for i = [1, 5, 12, 14]  % Only surveys with bathymetry

    % Compute geometric quantities
    try 
        polyin = polyshape(contourMask{i});
        poly10_array{i} = polyin;
        perimeter10(i) = perimeter(polyin);
        area10(i) = area(polyin);
        volume10(i) = sum(Z10{i}(:)-contourLevels(4),'omitmissing');  % With respect to base level platform
    catch
        poly10_array{i} = poly10_array{i-1};
        perimeter10(i) = NaN;
        area10(i) = NaN;
        volume10(i) = NaN;

        fprintf(2, ['Error in iteration ', num2str(i), ': ', char(DEMsurveys.name(i)), '\n']);
        continue
    end

    % Visualise the area of interest
    nexttile
    contourf(X10{i}, Y10{i}, Z10{i}, [contourLevels(4), contourLevels(2)], 'ShowText','off'); hold on
    plot(polyin, "FaceAlpha",0, "LineWidth",3, "EdgeColor",'r')

    [xpoly,ypoly] = centroid(polyin);
    text(xpoly-300, ypoly+100, ['P = ', num2str(perimeter10(i), '%.2e'), ' m\newline' ...
        'A = ', num2str(area10(i), '%.2e'), ' m^2\newline' ...
        'V = ', num2str(volume10(i), '%.2e'), ' m^3'], "FontSize",fontsize/2)

    title(DEMsurveys.name(i))
    cmocean('delta')
    clim([-8, 8])
    axis off equal
    view(46, 90)

    waitbar(i/numel(DEMS), wb, sprintf('Rendering contour maps: %d%%', floor(i/numel(DEMS)*100)))
    pause(0.1)

end
close(wb)

clearvars arrayLengths betweenContours contourLine contourMask i inPolygon inPolygonC j polyin sortedIndices sortedLengths wb x10 X10 xpoly y10 Y10 ypoly Z10
close all


%% Crop DEMs (zone 11: spit_beach bathy)

% Preallocation
X11 = cell(size(DEMS));
Y11 = cell(size(DEMS));
Z11 = cell(size(DEMS));
x11 = cell(size(DEMS));
y11 = cell(size(DEMS));
contourMask = cell(size(DEMS));

wb = waitbar(0, 'Cropping DEMs (zone 11)');
for i = [1, 5, 12, 14]  % Only surveys with bathymetry
    
    % Copy variables
    X11{i} = DEMS(i).data.DEM.X;
    Y11{i} = DEMS(i).data.DEM.Y;
    Z11{i} = DEMS(i).data.DEM.Z;
    x11{i} = x{i};
    y11{i} = y{i};

    % Create a logical mask for points within the polygon
    inPolygon = inpoly2([X11{i}(:), Y11{i}(:)], pgons.spit_bathy);

    % Apply area mask
    X11{i}(~inPolygon) = NaN;
    Y11{i}(~inPolygon) = NaN;
    Z11{i}(~inPolygon) = NaN;

    % Same for the contour lines
    inPolygonC = cell(size(indices{i}));
    contourLine = cell(size(indices{i}));
    for j = 1:numel(indices{i})
        inPolygonC{j} = inpoly2([x11{i}{j}', y11{i}{j}'], pgons.spit_bathy);

        x11{i}{j} = x11{i}{j}(inPolygonC{j});
        y11{i}{j} = y11{i}{j}(inPolygonC{j});
        contourLine{j} = [x11{i}{j}', y11{i}{j}'];
    end

    % Only keep the longest three non-empty contour lines
    arrayLengths = cellfun(@length, contourLine);
    [sortedLengths, sortedIndices] = sort(arrayLengths, 'descend');
    try
        contourLine = contourLine(sortedIndices(1:2));
    catch
        fprintf(2, ['Error in iteration ', num2str(i), ': ', char(DEMsurveys.name(i)), '\n']);
        continue
    end
    contourLine = contourLine(~cellfun('isempty', contourLine));

    % Reorder the contour lines to produce the correct polygon
    if length(contourLine) == 2
        contourMask{i} = [contourLine{2}(1, :); contourLine{1}; flipud(contourLine{2})];
    else
        fprintf(2, ['Iteration ', num2str(i), ': ', char(DEMsurveys.name(i)), ' has <2 contour lines\n']);
    end

    % Create a logical mask for points within the contour polygon
    try
        betweenContours = inpoly2([X11{i}(:), Y11{i}(:)], contourMask{i});
    catch
        fprintf(2, ['Error in iteration ', num2str(i), ': ', char(DEMsurveys.name(i)), '\n']);
        continue
    end

    % Apply the mask
    X11{i}(~betweenContours) = NaN;
    Y11{i}(~betweenContours) = NaN;
    Z11{i}(~betweenContours) = NaN;
    
    waitbar(i/numel(DEMS), wb, sprintf('Cropping DEMs (zone 11): %d%%', floor(i/numel(DEMS)*100)))
    pause(0.1)

end
close(wb)


%% Display contour maps (zone 11: spit_beach bathy)

% Preallocation
poly11_array = cell(1, length(DEMS));
perimeter11 = nan(size(DEMS));
area11 = nan(size(DEMS));
volume11 = nan(size(DEMS));

figure2
tiledlayout('flow', 'TileSpacing','tight')

wb = waitbar(0, 'Rendering contour maps');
for i = [1, 5, 12, 14]  % Only surveys with bathymetry

    % Compute geometric quantities
    try 
        polyin = polyshape(contourMask{i});
        poly11_array{i} = polyin;
        perimeter11(i) = perimeter(polyin);
        area11(i) = area(polyin);
        volume11(i) = sum(Z11{i}(:)-contourLevels(4),'omitmissing');  % With respect to base level platform
    catch
        poly11_array{i} = poly11_array{i-1};
        perimeter11(i) = NaN;
        area11(i) = NaN;
        volume11(i) = NaN;

        fprintf(2, ['Error in iteration ', num2str(i), ': ', char(DEMsurveys.name(i)), '\n']);
        continue
    end

    % Visualise the area of interest
    nexttile
    contourf(X11{i}, Y11{i}, Z11{i}, [contourLevels(4), contourLevels(2)], 'ShowText','off'); hold on
    plot(polyin, "FaceAlpha",0, "LineWidth",3, "EdgeColor",'r')

    [xpoly,ypoly] = centroid(polyin);
    text(xpoly-300, ypoly+100, ['P = ', num2str(perimeter11(i), '%.2e'), ' m\newline' ...
        'A = ', num2str(area11(i), '%.2e'), ' m^2\newline' ...
        'V = ', num2str(volume11(i), '%.2e'), ' m^3'], "FontSize",fontsize/2)

    title(DEMsurveys.name(i))
    cmocean('delta')
    clim([-8, 8])
    axis off equal
    view(46, 90)

    waitbar(i/numel(DEMS), wb, sprintf('Rendering contour maps: %d%%', floor(i/numel(DEMS)*100)))
    pause(0.1)

end
close(wb)

clearvars arrayLengths betweenContours contourLine contourMask i inPolygon inPolygonC j polyin sortedIndices sortedLengths wb x11 X11 xpoly y11 Y11 ypoly Z11
close all


%% Crop DEMs (zone 12: north_beach bathy)

% Preallocation
X12 = cell(size(DEMS));
Y12 = cell(size(DEMS));
Z12 = cell(size(DEMS));
x12 = cell(size(DEMS));
y12 = cell(size(DEMS));
contourMask = cell(size(DEMS));

wb = waitbar(0, 'Cropping DEMs (zone 12)');
for i = [1, 5, 12, 14]  % Only surveys with bathymetry
    
    % Copy variables
    X12{i} = DEMS(i).data.DEM.X;
    Y12{i} = DEMS(i).data.DEM.Y;
    Z12{i} = DEMS(i).data.DEM.Z;
    x12{i} = x{i};
    y12{i} = y{i};

    % Create a logical mask for points within the polygon
    inPolygon = inpoly2([X12{i}(:), Y12{i}(:)], pgons.north_bathy);

    % Apply area mask
    X12{i}(~inPolygon) = NaN;
    Y12{i}(~inPolygon) = NaN;
    Z12{i}(~inPolygon) = NaN;

    % Same for the contour lines
    inPolygonC = cell(size(indices{i}));
    contourLine = cell(size(indices{i}));
    for j = 1:numel(indices{i})
        inPolygonC{j} = inpoly2([x12{i}{j}', y12{i}{j}'], pgons.north_bathy);

        x12{i}{j} = x12{i}{j}(inPolygonC{j});
        y12{i}{j} = y12{i}{j}(inPolygonC{j});
        contourLine{j} = [x12{i}{j}', y12{i}{j}'];
    end

    % Only keep the longest three non-empty contour lines
    arrayLengths = cellfun(@length, contourLine);
    [sortedLengths, sortedIndices] = sort(arrayLengths, 'descend');
    try
        contourLine = contourLine(sortedIndices(1:2));
    catch
        fprintf(2, ['Error in iteration ', num2str(i), ': ', char(DEMsurveys.name(i)), '\n']);
        continue
    end
    contourLine = contourLine(~cellfun('isempty', contourLine));

    % Reorder the contour lines to produce the correct polygon
    if length(contourLine) == 2
        contourMask{i} = [contourLine{2}(1, :); contourLine{1}; flipud(contourLine{2})];
    else
        fprintf(2, ['Iteration ', num2str(i), ': ', char(DEMsurveys.name(i)), ' has <2 contour lines\n']);
    end

    % Create a logical mask for points within the contour polygon
    try
        betweenContours = inpoly2([X12{i}(:), Y12{i}(:)], contourMask{i});
    catch
        fprintf(2, ['Error in iteration ', num2str(i), ': ', char(DEMsurveys.name(i)), '\n']);
        continue
    end

    % Apply the mask
    X12{i}(~betweenContours) = NaN;
    Y12{i}(~betweenContours) = NaN;
    Z12{i}(~betweenContours) = NaN;
    
    waitbar(i/numel(DEMS), wb, sprintf('Cropping DEMs (zone 12): %d%%', floor(i/numel(DEMS)*100)))
    pause(0.1)

end
close(wb)


%% Display contour maps (zone 12: north_beach bathy)

% Preallocation
poly12_array = cell(1, length(DEMS));
perimeter12 = nan(size(DEMS));
area12 = nan(size(DEMS));
volume12 = nan(size(DEMS));

figure2
tiledlayout('flow', 'TileSpacing','tight')

wb = waitbar(0, 'Rendering contour maps');
for i = [1, 5, 12, 14]  % Only surveys with bathymetry

    % Compute geometric quantities
    try 
        polyin = polyshape(contourMask{i});
        poly12_array{i} = polyin;
        perimeter12(i) = perimeter(polyin);
        area12(i) = area(polyin);
        volume12(i) = sum(Z12{i}(:)-contourLevels(4),'omitmissing');  % With respect to base level platform
    catch
        poly12_array{i} = poly12_array{i-1};
        perimeter12(i) = NaN;
        area12(i) = NaN;
        volume12(i) = NaN;

        fprintf(2, ['Error in iteration ', num2str(i), ': ', char(DEMsurveys.name(i)), '\n']);
        continue
    end

    % Visualise the area of interest
    nexttile
    contourf(X12{i}, Y12{i}, Z12{i}, [contourLevels(4), contourLevels(2)], 'ShowText','off'); hold on
    plot(polyin, "FaceAlpha",0, "LineWidth",3, "EdgeColor",'r')

    [xpoly,ypoly] = centroid(polyin);
    text(xpoly-300, ypoly+100, ['P = ', num2str(perimeter12(i), '%.2e'), ' m\newline' ...
        'A = ', num2str(area12(i), '%.2e'), ' m^2\newline' ...
        'V = ', num2str(volume12(i), '%.2e'), ' m^3'], "FontSize",fontsize/2)

    title(DEMsurveys.name(i))
    cmocean('delta')
    clim([-8, 8])
    axis off equal
    view(46, 90)

    waitbar(i/numel(DEMS), wb, sprintf('Rendering contour maps: %d%%', floor(i/numel(DEMS)*100)))
    pause(0.1)

end
close(wb)

clearvars arrayLengths betweenContours contourLine contourMask i inPolygon inPolygonC j polyin sortedIndices sortedLengths wb x12 X12 xpoly y12 Y12 ypoly Z12
close all


%% Crop DEMs (zone 13: lagoon_lower)

% Preallocation
X13 = cell(size(DEMS));
Y13 = cell(size(DEMS));
Z13 = cell(size(DEMS));
x13 = cell(size(DEMS));
y13 = cell(size(DEMS));
contourMask = cell(size(DEMS));

wb = waitbar(0, 'Cropping DEMs (zone 13)');
for i = [1, 5, 12, 14]  % Only surveys with bathymetry
    
    % Copy variables
    X13{i} = DEMS(i).data.DEM.X;
    Y13{i} = DEMS(i).data.DEM.Y;
    Z13{i} = DEMS(i).data.DEM.Z;
    x13{i} = x{i};
    y13{i} = y{i};

    % Create a logical mask for points within the polygon
    inPolygon = inpoly2([X13{i}(:), Y13{i}(:)], pgons.lagoon_bathy);

    % Apply area mask
    X13{i}(~inPolygon) = NaN;
    Y13{i}(~inPolygon) = NaN;
    Z13{i}(~inPolygon) = NaN;

    % Same for the contour lines
    inPolygonC = cell(size(indices{i}));
    contourLine = cell(size(indices{i}));
    for j = 1:numel(indices{i})
        inPolygonC{j} = inpoly2([x13{i}{j}', y13{i}{j}'], pgons.lagoon_bathy);

        x13{i}{j} = x13{i}{j}(inPolygonC{j});
        y13{i}{j} = y13{i}{j}(inPolygonC{j});
        contourLine{j} = [x13{i}{j}', y13{i}{j}'];
    end

    % Only keep the longest three non-empty contour lines
    arrayLengths = cellfun(@length, contourLine);
    [sortedLengths, sortedIndices] = sort(arrayLengths, 'descend');
    contourLine = contourLine(~cellfun('isempty', contourLine));

    % Reorder the contour lines to produce the correct polygon
    if length(contourLine) == 1
        contourMask{i} = contourLine{1};
    else
        fprintf(2, ['Iteration ', num2str(i), ': ', char(DEMsurveys.name(i)), ' has <1 contour lines\n']);
    end

    % Create a logical mask for points within the contour polygon
    try
        betweenContours = inpoly2([X13{i}(:), Y13{i}(:)], contourMask{i});
    catch
        fprintf(2, ['Error in iteration ', num2str(i), ': ', char(DEMsurveys.name(i)), '\n']);
        continue
    end

    % Apply the mask
    X13{i}(~betweenContours) = NaN;
    Y13{i}(~betweenContours) = NaN;
    Z13{i}(~betweenContours) = NaN;
    
    waitbar(i/numel(DEMS), wb, sprintf('Cropping DEMs (zone 13): %d%%', floor(i/numel(DEMS)*100)))
    pause(0.1)

end
close(wb)


%% Display contour maps (zone 13: lagoon_lower)

% Preallocation
poly13_array = cell(1, length(DEMS));
perimeter13 = nan(size(DEMS));
area13 = nan(size(DEMS));
volume13 = nan(size(DEMS));

figure2
tiledlayout('flow', 'TileSpacing','tight')

wb = waitbar(0, 'Rendering contour maps');
for i = [1, 5, 12, 14]  % Only surveys with bathymetry

    % Compute geometric quantities
    try 
        polyin = polyshape(contourMask{i});
        poly13_array{i} = polyin;
        perimeter13(i) = perimeter(polyin);
        area13(i) = area(polyin);
        volume13(i) = sum(Z13{i}(:)-contourLevels(4),'omitmissing');  % With respect to base level platform
    catch
        poly13_array{i} = poly13_array{i-1};
        perimeter13(i) = NaN;
        area13(i) = NaN;
        volume13(i) = NaN;

        fprintf(2, ['Error in iteration ', num2str(i), ': ', char(DEMsurveys.name(i)), '\n']);
        continue
    end

    % Visualise the area of interest
    nexttile
    contourf(X13{i}, Y13{i}, Z13{i}, [contourLevels(4), contourLevels(2)], 'ShowText','off'); hold on
    plot(polyin, "FaceAlpha",0, "LineWidth",3, "EdgeColor",'r')

    [xpoly,ypoly] = centroid(polyin);
    text(xpoly-300, ypoly+100, ['P = ', num2str(perimeter13(i), '%.2e'), ' m\newline' ...
        'A = ', num2str(area13(i), '%.2e'), ' m^2\newline' ...
        'V = ', num2str(volume13(i), '%.2e'), ' m^3'], "FontSize",fontsize/2)

    title(DEMsurveys.name(i))
    cmocean('delta')
    clim([-8, 8])
    axis off equal
    view(46, 90)

    waitbar(i/numel(DEMS), wb, sprintf('Rendering contour maps: %d%%', floor(i/numel(DEMS)*100)))
    pause(0.1)

end
close(wb)

clearvars arrayLengths betweenContours contourLine contourMask i inPolygon inPolygonC j polyin sortedIndices sortedLengths wb x13 X13 xpoly y13 Y13 ypoly Z13
close all


%% Store variables in structure
Perimeter.SouthBeach = perimeter1;
Perimeter.SpitBeach = perimeter2;
Perimeter.Hook = perimeter3;
Perimeter.Lagoon = perimeter4;
Perimeter.Ceres = perimeter5;
% Perimeter.Gate = perimeter6;
Perimeter.SouthUpper = perimeter7;
Perimeter.SpitUpper = perimeter8;
Perimeter.NorthUpper = perimeter9;
Perimeter.SouthBathy = perimeter10;
Perimeter.SpitBathy = perimeter11;
Perimeter.NorthBathy = perimeter12;
Perimeter.LagoonBathy = perimeter13;

Area.SouthBeach = area1;
Area.SpitBeach = area2;
Area.Hook = area3;
Area.Lagoon = area4;
Area.Ceres = area5;
% Area.Gate = area6;
Area.SouthUpper = area7;
Area.SpitUpper = area8;
Area.NorthUpper = area9;
Area.SouthBathy = area10;
Area.SpitBathy = area11;
Area.NorthBathy = area12;
Area.LagoonBathy = area13;

Volume.SouthBeach = volume1;
Volume.SpitBeach = volume2;
Volume.Hook = volume3;
Volume.Lagoon = volume4;
Volume.Ceres = volume5;
% Volume.Gate = volume6;
Volume.SouthUpper = volume7;
Volume.SpitUpper = volume8;
Volume.NorthUpper = volume9;
Volume.SouthBathy = volume10;
Volume.SpitBathy = volume11;
Volume.NorthBathy = volume12;
Volume.LagoonBathy = volume13;

Polyshape.SouthBeach = poly1_array;
Polyshape.SpitBeach = poly2_array;
Polyshape.Hook = poly3_array;
Polyshape.Lagoon = poly4_array;
Polyshape.Ceres = poly5_array;
% Polyshape.Gate = poly6_array;
Polyshape.SouthUpper = poly7_array;
Polyshape.SpitUpper = poly8_array;
Polyshape.NorthUpper = poly9_array;
Polyshape.SouthBathy = poly10_array;
Polyshape.SpitBathy = poly11_array;
Polyshape.NorthBathy = poly12_array;
Polyshape.LagoonBathy = poly13_array;

level1_string = strrep(num2str(contourLevels(1)), '.', '');
level2_string = strrep(num2str(contourLevels(2)), '.', '');
level3_string = strrep(num2str(contourLevels(3)), '.', '');
level4_string = strrep(num2str(contourLevels(4)), '.', '');

save([basePath 'results' filesep 'metrics' filesep...
    'NAP_' level1_string '_' level2_string '_' level3_string '_' level4_string],...
    "Perimeter", "Area", "Volume", "Polyshape", "contourLevels")

disp('Metrics stored!');

