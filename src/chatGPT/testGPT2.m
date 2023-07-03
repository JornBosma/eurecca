% Generate sample XYZ data for the first DEM
[X1, Y1] = meshgrid(1:10, 1:10);
Z1 = peaks(10);

% Generate sample XYZ data for the second DEM
[X2, Y2] = meshgrid(1:10, 1:10);
Z2 = peaks(10) + 2; % Adding an elevation change of 2 units

% Contour levels of interest
contourLevels = [1, -0.5];

% Compute volume change between the two DEMs
volumeChange = computeVolumeBetweenContours(X2, Y2, Z2, contourLevels) - ...
               computeVolumeBetweenContours(X1, Y1, Z1, contourLevels);

disp(volumeChange);
