function pgns = getPolygons

    % northern part of beach
    xv_north = [117120; 117360; 117500; 117490; 117440; 117380; 117340; 117180];
    yv_north = [560080; 559900; 560100; 560270; 560320; 560290; 560140; 560140];
    
    % lagoon side of spit
    xv_lagoon = [116060; 116120; 117275; 117170];
    yv_lagoon = [559280; 559140; 560010; 560120];

    % spit hook (accretive part)
    xv_hook = [117260; 117340; 117330; 117420; 117500; 117490; 117440; 117380; 117360];
    yv_hook = [560100; 560080; 560020; 559950; 560100; 560270; 560320; 560290; 560170];
    
    % seaward beach of spit
    xv_spit = [115690; 115780; 117420; 117330];
    yv_spit = [558710; 558650; 559950; 560020];

    % southern beach between harbour and spit
    xv_S = [115110; 115260; 115780; 115690];
    yv_S = [558000; 558000; 558650; 558710];

    % total seaward beach (= spit beach + southern beach) excl. spit hook
    xv_beach = [115110; 115260; 115780; 117420; 117330; 115690];
    yv_beach = [558000; 558000; 558650; 559950; 560020; 558710];

    % area of research project (inside scope)
    xv_scope = [114850; 115108; 115500; 118060; 118062; 116950];
    yv_scope = [557860; 557772; 557700; 560044; 560520; 560526];

    % NIOZ harbour
    xv_harbour = [114850; 115108; 115500; 115450; 114960];
    yv_harbour = [557860; 557772; 557700; 558000; 558000];

    % Texelstroom channel wall (stones)
    xv_chanwall = [115418; 115552; 116030; 118060; 118060; 115984; 115440; 115432];
    yv_chanwall = [557782; 557776; 558646; 560214; 560282; 558702; 557970; 557960];

    % dune row
    xv_dunes = [114960; 115090; 117090; 116950];
    yv_dunes = [558000; 558000; 560526; 560526];
    
    % Create the structure with field names
    pgns = struct('north',[], 'lagoon',[], 'hook',[], 'spit',[], 'south',[],...
        'beach',[], 'scope',[], 'harbour',[], 'chanwall',[], 'dunes',[]);

    % Assign values to the matrices within the structure
    pgns.north = [xv_north, yv_north];
    pgns.lagoon = [xv_lagoon, yv_lagoon];
    pgns.hook = [xv_hook, yv_hook];
    pgns.spit = [xv_spit, yv_spit];
    pgns.south = [xv_S, yv_S];
    pgns.beach = [xv_beach, yv_beach];
    pgns.scope = [xv_scope, yv_scope];
    pgns.harbour = [xv_harbour, yv_harbour];
    pgns.chanwall = [xv_chanwall, yv_chanwall];
    pgns.dunes = [xv_dunes, yv_dunes];

end