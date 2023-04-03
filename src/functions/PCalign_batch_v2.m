%% Script to match point clouds
clc
clear all
close all

% Define input parameters
baseP = 'F:\ErosionExperiments\BedMes';
T = 'T1';
numScans = 12;
DenoiseNeighbors = 4; % Number of points used to denoise the clouds
theta = deg2rad(-8.5); % Angle for point cloud correction - DO NOT CHANGE

%%
cd(baseP);
addpath([baseP '\functions']);
% Remove custom pointcloud tools

%% Loop

for j = 157:212
    exp = ['exp' num2str(j,'%03.f')]
    % Load point clouds
    files = dir([baseP '\ScanData\' exp '\' T '\Raw']);
    PC = cell(numScans,1);
    for i = 1:numScans
        ptCl = importdata([baseP '\ScanData\' exp '\' T '\Raw\' files(i+2,1).name]);

        % create xyz file
        xyzData = ptCl.data(:,3:5);
        xyzData = xyzData(:,[2 3 1]);
        xyzData(:,3) = -xyzData(:,3);

        PC{i,1} = pointCloud(xyzData);
        clear ptCl xyzData cmdStr
    end

    %% Transform point cloud to correct for slope
    %Translate along X
    rot = [1 0 0; ...
          0 cos(theta) -sin(theta); ...
          0 sin(theta) cos(theta)];

    trans = [0, 0, 0];
    tform = rigid3d(rot,trans);

    PCcor = cell(numScans,1);
    for i = 1:numScans
        PCcor{i,1} = pctransform(PC{i,1},tform);
    %     figure(i)
    %     pcshow(PCcor{i,1})
    %     xlabel('X'); ylabel('Y'); zlabel('Z')
    end
    clear rot trans tform PC
    
    %% Denoise the clouds
    PCcor_dn = cell(numScans,1);
    for i = 1:numScans
        PCcor_dn{i,1} = pcdenoise(PCcor{i,1},'NumNeighbors',DenoiseNeighbors);
    %     figure(i)
    %     pcshow(PCcor_dn{i,1})
    %     xlabel('X'); ylabel('Y'); zlabel('Z')
    end

    %% Correct Y
    Correction = 0:-200:-2600;

    PCxyz = cell(numScans,1);
    PtCl = cell(numScans,1);
    for i = 1:numScans
        PCxyz{i,1} = PCcor_dn{i,1}.Location;
        PCxyz{i,1}(:,2) = PCxyz{i,1}(:,2) + Correction(i);
        PtCl{i,1} = pointCloud(PCxyz{i,1});
    end
    clear PCcor PCcor_dn PCxyz PC

    %% Combine aligned clouds
    PCdefC = cell(numScans,1);
    for i = 1:numScans
        PCdefC{i,1} = PtCl{i,1}.Location;
    end

    % Combine aligned point clouds
    PCdef = cell2mat(PCdefC);

    %% Convert cloud to raster
    dx=floor(min(PCdef(:,1))):1:ceil(max(PCdef(:,1)));
    dy=floor(min(PCdef(:,2))):1:ceil(max(PCdef(:,2)));
    [X,Y]=meshgrid(dx,dy);
    Z=griddata(PCdef(:,1),PCdef(:,2),PCdef(:,3), X, Y, 'natural');

    %% Export Cloud data
    PC.xyz = [X(:),Y(:),Z(:)];
    PC.X = X;
    PC.Y = Y;
    PC.Z = Z;
    save([baseP '\ScanData\' exp '\' T '\Processed\DEM_' exp '.mat'],'PC');
    
    clear PC Z dx dy X Y PCdefC PCcor PC files
end