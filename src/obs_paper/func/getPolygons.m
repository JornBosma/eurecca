function pgns = getPolygons

    % Define the polygons
    xv_N = [117260; 117340; 117330; 117420; 117500; 117490; 117380; 117360; 117260];
    yv_N = [560100; 560080; 560020; 559950; 560100; 560270; 560290; 560170; 560100];
    
    xv_spit = [116120; 116200; 117420; 117330; 116120];
    yv_spit = [559060; 558980; 559950; 560020; 559060];
    
    xv_S = [115110; 115260; 115780; 116200; 116120; 115690; 115110];
    yv_S = [558000; 558000; 558650; 558980; 559060; 558710; 558000];
    
    xv_beach = [115110; 115230; 115780; 117420; 117330; 115690; 115110];
    yv_beach = [558000; 558000; 558650; 559950; 560020; 558710; 558000];
    
    xv_scope = [114850; 115108; 116300; 118062; 118062; 116920; 114850];
    yv_scope = [557860; 557772; 557774; 559208; 560612; 560526; 557860];
    
    % Create the structure with field names
    pgns = struct('north', [], 'spit', [], 'south', [], 'beach', [], 'scope', []);

    % Assign values to the matrices within the structure
    pgns.north = [xv_N, yv_N];
    pgns.spit = [xv_spit, yv_spit];
    pgns.south = [xv_S, yv_S];
    pgns.beach = [xv_beach, yv_beach];
    pgns.scope = [xv_scope, yv_scope];

end