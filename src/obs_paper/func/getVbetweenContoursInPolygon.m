function totalVolume = getVbetweenContoursInPolygon(A, contourLevels, polygon, method)

    % Initialisation
    X = A.DEM.X;
    Y = A.DEM.Y;
    Z = A.DEM.Z;

    % Step 1: Generate a logical mask for the selected cells
    mask1 = inpolygon(X, Y, polygon(:, 1), polygon(:, 2));

    X(~mask1) = NaN;
    Y(~mask1) = NaN;
    Z(~mask1) = NaN;

    % Step 2: Identify the contour lines
    contourMatrix = contour(X, Y, Z, contourLevels);
    
    % Step 3: Extract the coordinates between the contour lines
    xPoints = contourMatrix(1, 2:end);
    yPoints = contourMatrix(2, 2:end);
    
    % Step 4: Extract the coordinates between the contour lines
    mask2 = inpolygon(X, Y, xPoints, yPoints);

    % X(~mask2) = NaN;
    % Y(~mask2) = NaN;
    % Z(~mask2) = NaN;

    % Step 5: Compute the total volume using the specified method
    selectedZ = Z(mask2);
    if strcmpi(method, 'sum')
        totalVolume = sum(selectedZ(:), 'omitnan');
    elseif strcmpi(method, 'trapz')
        totalVolume = trapz(selectedZ(:));
    else
        error('Invalid method. Choose either "sum" or "trapz".');
    end
end
