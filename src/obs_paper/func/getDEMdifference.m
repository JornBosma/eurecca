function diffDEM = getDEMdifference(A, B)
    % Isolate DEM height values
    Z1 = A.DEM.Z;
    Z2 = B.DEM.Z;
    
    % Compute the DEM of difference
    diffDEM = Z2 - Z1;
end
