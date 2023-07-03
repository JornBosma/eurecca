% Generate sample XYZ data
[X, Y] = meshgrid(1:10, 1:10);
Z = peaks(10);

% Contour levels of interest
contourLevels = [1, -0.5];

% Compute volume between contours using sum
totalVolumeSum = getVbetweenContours(X, Y, Z, contourLevels, 'sum');

% Compute volume between contours using trapz
totalVolumeTrapz = getVbetweenContours(X, Y, Z, contourLevels, 'trapz');

disp(totalVolumeSum);
disp(totalVolumeTrapz);
