% Generate sample XYZ data for the first DEM
[X1, Y1] = meshgrid(1:10, 1:10);
Z1 = peaks(10);

% Generate sample XYZ data for the second DEM
[X2, Y2] = meshgrid(1:10, 1:10);
Z2 = peaks(10) + 2; % Adding an elevation change of 2 units

% Compute the DEM of difference
diffDEM = getDEMdifference(Z1, Z2);

% Display the resulting difference DEM
figure;
surf(X1, Y1, diffDEM);
xlabel('X');
ylabel('Y');
zlabel('DEM Difference');
title('DEM Difference');

% Calculate and display the minimum and maximum difference values
minDifference = min(diffDEM(:));
maxDifference = max(diffDEM(:));
disp(minDifference);
disp(maxDifference);
