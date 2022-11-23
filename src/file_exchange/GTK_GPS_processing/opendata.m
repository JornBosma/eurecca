%% GTK_GPS recording data processing
% in this script the measurements of XYZ profiles lines will be processed:
% 1. loading of each file with the measurements by openening all folders at
% once ---> GPS_measurements_copy (redacted profile lines)
% 2. redirect raw data in structure
% 3. create an array specific trendline and project all measurement to new
% line
% 4. visualization of trendline projection
% 5. rotate xy data of trendline to y coord.
% 6. save all variables (raw, 3D and 2D lines)

% Specify the folder where the files live.
clear
close all
% myFoldercsv = 'C:\Users\jelle\OneDrive\Documenten\MSc\thesis\cross-sections'; % location where folders live
myFoldercsv = '/Users/jwb/Library/CloudStorage/OneDrive-UniversiteitUtrecht/eurecca-wp2/src/file_exchange/GTK_GPS_processing'; % location where folders live
% Check to make sure that folder actually exists.  Warn user if it doesn't.
if ~isfolder(myFoldercsv)
    errorMessage = sprintf('Error: The following folder does not exist:\n%s\nPlease specify a new folder.', myFoldercsv);
    uiwait(warndlg(errorMessage));
    myFoldercsv = uigetdir(); % Ask for a new one.
    if myFoldercsv == 0
         % User clicked Cancel
         return;
    end
end

numItercsv= 17;
tablescsv   = cell(numItercsv,1);
filePatterncsv = fullfile(myFoldercsv, '**/*.csv'); % Change to whatever pattern you need.
theFilescsv = dir(filePatterncsv);
for k = 1 : length(theFilescsv)
    baseFileNamecsv = theFilescsv(k).name;
    fullFileNamecsv = fullfile(theFilescsv(k).folder, baseFileNamecsv);
    %fprintf(1, 'Now reading %s\n', fullFileNamecsv);
    % Now do whatever you want with this file name,
    % such as reading it in as an image array with imread()
    t= readtable(fullFileNamecsv);
    tablescsv{k} = t;
  end

% % Get a list of all files in the folder, and its subfolders, with the desired file name pattern.
% filePattern = fullfile(myFolder, '**/*.png'); % Change to whatever pattern you need.

%
myFoldertxt = 'C:\Users\jelle\OneDrive\Documenten\MSc\thesis\cross-sections';
% Check to make sure that folder actually exists.  Warn user if it doesn't.
if ~isfolder(myFoldertxt)
    errorMessage = sprintf('Error: The following folder does not exist:\n%s\nPlease specify a new folder.', myFoldertxt);
    uiwait(warndlg(errorMessage));
    myFoldertxt = uigetdir(); % Ask for a new one.
    if myFoldertxt == 0
         % User clicked Cancel
         return;
    end
end
% Get a list of all files in the folder, and its subfolders, with the desired file name pattern.
numItertxt= 4;
tablestxt   = cell(numItertxt,1);
filePatterntxt = fullfile(myFoldertxt, '**/*.txt'); % Change to whatever pattern you need.
theFilestxt = dir(filePatterntxt);
for k = 1 : length(theFilestxt)
    baseFileNametxt = theFilestxt(k).name;
    fullFileNametxt = fullfile(theFilestxt(k).folder, baseFileNametxt);
    %fprintf(1, 'Now reading %s\n', fullFileNametxt);
    % Now do whatever you want with this file name,
    % such as reading it in as an image array with imread()
    t1= readtable(fullFileNametxt);
    tablestxt{k} = t1;
end

%% csv data
% data format in .csv
P0914= tablescsv{1,1};
P0916= tablescsv{2,1};
P0917= tablescsv{3,1};
P0918= tablescsv{4,1};
P0919= tablescsv{5,1};
P0923= tablescsv{6,1};
P0926= tablescsv{7,1};
P0930= tablescsv{8,1};
P1002= tablescsv{9,1};
P1003= tablescsv{10,1};
P1005_1= tablescsv{11,1};
P1005_2= tablescsv{12,1};
P1006= tablescsv{13,1};
P1010= tablescsv{14,1};
P1013= tablescsv{15,1};
P1015= tablescsv{16,1};
P1018= tablescsv{17,1};

%append P1005 data
P1005=[P1005_1(:,1:6);P1005_2];


%% txt data
% data format in .txt
P0913= tablestxt{1,1};
P0915= tablestxt{2,1};
P1007= tablestxt{3,1};
P1011= tablestxt{4,1};


%% Profile measurements _month_day

Profiles_0913= profile_finder(P0913);
Profiles_0914= profile_finder(P0914); 
Profiles_0915= profile_finder(P0915);
Profiles_0916= profile_finder(P0916);
Profiles_0917= profile_finder(P0917);
Profiles_0918= profile_finder(P0918);
Profiles_0919= profile_finder(P0919);
Profiles_0923= profile_finder(P0923);
Profiles_0926= profile_finder(P0926);
Profiles_0930= profile_finder(P0930);
Profiles_1002= profile_finder(P1002);
Profiles_1003= profile_finder(P1003);
Profiles_1005= profile_finder(P1005);
Profiles_1006= profile_finder(P1006);
Profiles_1007= profile_finder(P1007);
Profiles_1010= profile_finder(P1010);
Profiles_1011= profile_finder(P1011);
Profiles_1013= profile_finder(P1013);
Profiles_1015= profile_finder(P1015);
Profiles_1018= profile_finder(P1018);

%% structure of cross-sections with date of recording
% not all profiles are recorded on the same day. Amount of profile
% recordings vary for each day S=September O= October

L1_struct_raw = struct ('S13',Profiles_0913.L1,'S14',Profiles_0914.L1, 'S15',Profiles_0915.L1,'S16',Profiles_0916.L1,'S17',Profiles_0917.L1,'S18',Profiles_0918.L1,...
    'S19',Profiles_0919.L1,'S23',Profiles_0923.L1,'S26',Profiles_0926.L1,'S30',Profiles_0930.L1,'O02',Profiles_1002.L1,'O03',Profiles_1003.L1,...
    'O05',Profiles_1005.L1,'O06',Profiles_1006.L1,'O07',Profiles_1007.L1,'O10',Profiles_1010.L1,'O11',Profiles_1011.L1,'O13',Profiles_1013.L1,...
    'O15',Profiles_1015.L1,'O18',Profiles_1018.L1);
L1_3D_raw=struct2cell(L1_struct_raw);

L2_struct_raw = struct ('S13',Profiles_0913.L2,'S14',Profiles_0914.L2, 'S15',Profiles_0915.L2,'S16',Profiles_0916.L2,'S17',Profiles_0917.L2,'S18',Profiles_0918.L2,...
    'S19',Profiles_0919.L2,'S23',Profiles_0923.L2,'S26',Profiles_0926.L2,'S30',Profiles_0930.L2,'O02',Profiles_1002.L2,'O03',Profiles_1003.L2,...
    'O05',Profiles_1005.L2,'O06',Profiles_1006.L2,'O07',Profiles_1007.L2,'O10',Profiles_1010.L2,'O11',Profiles_1011.L2,'O13',Profiles_1013.L2,...
    'O15',Profiles_1015.L2,'O18',Profiles_1018.L2);
L2_3D_raw=struct2cell(L2_struct_raw);

L3_struct_raw = struct ('S13',Profiles_0913.L3,'S14',Profiles_0914.L3, 'S15',Profiles_0915.L3,'S16',Profiles_0916.L3,'S17',Profiles_0917.L3,'S18',Profiles_0918.L3,...
    'S19',Profiles_0919.L3,'S23',Profiles_0923.L3,'S26',Profiles_0926.L3,'S30',Profiles_0930.L3,'O02',Profiles_1002.L3,'O03',Profiles_1003.L3,...
    'O05',Profiles_1005.L3,'O06',Profiles_1006.L3,'O07',Profiles_1007.L3,'O10',Profiles_1010.L3,'O11',Profiles_1011.L3,'O13',Profiles_1013.L3,...
    'O15',Profiles_1015.L3,'O18',Profiles_1018.L3);
L3_3D_raw=struct2cell(L3_struct_raw);

L4_struct_raw = struct ('S13',Profiles_0913.L4,'S14',Profiles_0914.L4, 'S15',Profiles_0915.L4,'S16',Profiles_0916.L4,'S17',Profiles_0917.L4,'S18',Profiles_0918.L4,...
    'S19',Profiles_0919.L4,'S23',Profiles_0923.L4,'S26',Profiles_0926.L4,'S30',Profiles_0930.L4,'O02',Profiles_1002.L4,'O03',Profiles_1003.L4,...
    'O05',Profiles_1005.L4,'O06',Profiles_1006.L4,'O07',Profiles_1007.L4,'O10',Profiles_1010.L4,'O11',Profiles_1011.L4,'O13',Profiles_1013.L4,...
    'O15',Profiles_1015.L4,'O18',Profiles_1018.L4);
L4_3D_raw=struct2cell(L4_struct_raw);

L5_struct_raw = struct ('S13',Profiles_0913.L5,'S14',Profiles_0914.L5, 'S15',Profiles_0915.L5,'S16',Profiles_0916.L5,'S17',Profiles_0917.L5,'S18',Profiles_0918.L5,...
    'S19',Profiles_0919.L5,'S23',Profiles_0923.L5,'S26',Profiles_0926.L5,'S30',Profiles_0930.L5,'O02',Profiles_1002.L5,'O03',Profiles_1003.L5,...
    'O05',Profiles_1005.L5,'O06',Profiles_1006.L5,'O07',Profiles_1007.L5,'O10',Profiles_1010.L5,'O11',Profiles_1011.L5,'O13',Profiles_1013.L5,...
    'O15',Profiles_1015.L5,'O18',Profiles_1018.L5);
L5_3D_raw=struct2cell(L5_struct_raw);

L6_struct_raw = struct ('S13',Profiles_0913.L6,'S14',Profiles_0914.L6, 'S15',Profiles_0915.L6,'S16',Profiles_0916.L6,'S17',Profiles_0917.L6,'S18',Profiles_0918.L6,...
    'S19',Profiles_0919.L6,'S23',Profiles_0923.L6,'S26',Profiles_0926.L6,'S30',Profiles_0930.L6,'O02',Profiles_1002.L6,'O03',Profiles_1003.L6,...
    'O05',Profiles_1005.L6,'O06',Profiles_1006.L6,'O07',Profiles_1007.L6,'O10',Profiles_1010.L6,'O11',Profiles_1011.L6,'O13',Profiles_1013.L6,...
    'O15',Profiles_1015.L6,'O18',Profiles_1018.L6);
L6_3D_raw=struct2cell(L6_struct_raw);


names = fieldnames(L2_struct_raw);



%% ------------ projection of line onto trendline --------%%
%Due to NaN and variable line length a hard coded section follows.

%% trendline L1

x1 = [117350:1:117650];     % length of the trendline
m1 = -0.355346246936036;    % slope of the trendline 
b1 = 6.017795581737806e+05; % y line crossing 
y1 = m1*x1 + b1;            % trendline formula
perpSlope1 = -1/m1;         % slope of a line perpendicular to the trendline

L1_3D = NaN(500,3,20);      %create empty array of trendline length

for i = 1:20
yInt1 = -perpSlope1 * L1_3D_raw{i,1}(:,1) + L1_3D_raw{i,1}(:,2);
xIntersection1 = (yInt1 - b1) / (m1 - perpSlope1); 
yIntersection1 = perpSlope1 * xIntersection1 + yInt1;
xsize1 = 500 - length(xIntersection1);
L1_3D(:,1,i) = [xIntersection1;NaN(xsize1,1)];
L1_3D(:,2,i) = [yIntersection1;NaN(xsize1,1)];
L1_3D(:,3,i) = [L1_3D_raw{i,1}(:,3);NaN(xsize1,1)];
end


%
%% trendline L2
x2 = [117100:1:117320]; % length of the trendline
m2 = -0.932805293479589; % slope of the trendline
b2 = 669141.805666030;   % Intersection
y2 = m2*x2 + b2;            % trendline
perpSlope2 = -1/m2;       % slope of a line perpendicular to the trendline

% for loop for all profiles of L2
L2_3D = NaN(500,3,20);    %create empty array
for i = 1:20
yInt2 = -perpSlope2 * L2_3D_raw{i,1}(:,1) + L2_3D_raw{i,1}(:,2);
xIntersection2 = (yInt2 - b2) / (m2 - perpSlope2); 
yIntersection2 = perpSlope2 * xIntersection2 + yInt2;
xsize2 = 500 - length(xIntersection2);
L2_3D(:,1,i) = [xIntersection2;NaN(xsize2,1)];
L2_3D(:,2,i) = [yIntersection2;NaN(xsize2,1)];
L2_3D(:,3,i) = [L2_3D_raw{i,1}(:,3);NaN(xsize2,1)];
end

%% projection of line onto trendline L3
x3 = [116780:1:116950]; % length of the trendline
m3 = [-1.44023112873361]; % slope of the trendline
b3 = [727814.649999293];   % Intersection
y3 = m3*x3 + b3;            % trendline
perpSlope3 = -1/m3;       % slope of a line perpendicular to the trendline

L3_3D = NaN(500,3,20);    %create empty array
for i = 1:20
yInt3 = -perpSlope3 * L3_3D_raw{i,1}(:,1) + L3_3D_raw{i,1}(:,2);
xIntersection3 = (yInt3 - b3) / (m3 - perpSlope3); 
yIntersection3 = perpSlope3 * xIntersection3 + yInt3;
xsize3 = 500 - length(xIntersection3);
L3_3D(:,1,i) = [xIntersection3;NaN(xsize3,1)];
L3_3D(:,2,i) = [yIntersection3;NaN(xsize3,1)];
L3_3D(:,3,i) = [L3_3D_raw{i,1}(:,3);NaN(xsize3,1)];
end



%% projection of line onto trendline L4
x4 = [116000:1:116150]; % length of the trendline
m4 = -1.412980711661320; % slope of the trendline
b4 = 7.230006853920975e+05;   % Intersection
y4 = m4*x4 + b4;            % trendline
perpSlope4 = -1/m4;       % slope of a line perpendicular to the trendline

% For loop for all profiles of L4
L4_3D = NaN(500,3,20);    %create empty array
for i = 1:20
yInt4 = -perpSlope4 * L4_3D_raw{i,1}(:,1) + L4_3D_raw{i,1}(:,2);
xIntersection4 = (yInt4 - b4) / (m4 - perpSlope4); 
yIntersection4 = perpSlope4 * xIntersection4 + yInt4;
xsize4 = 500 - length(xIntersection4);
L4_3D(:,1,i) = [xIntersection4;NaN(xsize4,1)];
L4_3D(:,2,i) = [yIntersection4;NaN(xsize4,1)];
L4_3D(:,3,i) = [L4_3D_raw{i,1}(:,3);NaN(xsize4,1)];
end

%% projection of line onto trendline L5
x5 = [115600:1:115750]; % length of the trendline
m5 = [-0.872466247728399]; % slope of the trendline
b5 = [659520.392276549];   % Intersection
y5 = m5*x5 + b5;            % trendline
perpSlope5 = -1/m5;       % slope of a line perpendicular to the trendline


L5_3D = NaN(500,3,20);    %create empty array
for i = 1:20
yInt5 = -perpSlope5 * L5_3D_raw{i,1}(:,1) + L5_3D_raw{i,1}(:,2);
xIntersection5 = (yInt5 - b5) / (m5 - perpSlope5); 
yIntersection5 = perpSlope5 * xIntersection5 + yInt5;
xsize5 = 500 - length(xIntersection5);
L5_3D(:,1,i) = [xIntersection5;NaN(xsize5,1)];
L5_3D(:,2,i) = [yIntersection5;NaN(xsize5,1)];
L5_3D(:,3,i) = [L5_3D_raw{i,1}(:,3);NaN(xsize5,1)];
end

%% projection of line onto trendline L6
% figure(10)
% for i = 1:20
% plot(L6_3D_raw{i,1}(:,1),L6_3D_raw{i,1}(:,2)); hold on;
% end

x6 = [115300:1:115500]; % length of the trendline
m6 = [-0.708647762754796]; % slope of the trendline
b6 = [640004.506222726];   % Intersection
y6 = m6*x6 + b6;            % trendline
perpSlope6 = -1/m6;       % slope of a line perpendicular to the trendline

L6_3D = NaN(500,3,20);    %create empty array
for i = 1:20
yInt6 = -perpSlope6 * L6_3D_raw{i,1}(:,1) + L6_3D_raw{i,1}(:,2);
xIntersection6 = (yInt6 - b6) / (m6 - perpSlope6); 
yIntersection6 = perpSlope6 * xIntersection6 + yInt6;
xsize6 = 500 - length(xIntersection6);
L6_3D(:,1,i) = [xIntersection6;NaN(xsize6,1)];
L6_3D(:,2,i) = [yIntersection6;NaN(xsize6,1)];
L6_3D(:,3,i) = [L6_3D_raw{i,1}(:,3);NaN(xsize6,1)];
end
%% ------------ Visualization -----------------------%% 
% following plot shows the formation of the trendline and projection of the
% profileline location to the location on the trendline

figure(10)
set(gcf, 'position',[100 50 1200 700],'color','white')
subplot(121)
for i = 1:20
plot(L3_3D_raw{i,1}(:,1),L3_3D_raw{i,1}(:,2)); hold on;
end
plot(x3,y3,'k','LineWidth',2,'LineStyle','--')
xlim([1.168*10^5 1.1688*10^5])
title('Trendline of cross-sections [L3]')
xlabel('RD-coord x (m)')
ylabel('RD-coord y (m)')
set(gca,'fontsize',10,'FontWeight','bold');

subplot(122)

plot(L3_3D_raw{20,1}(:,1),L3_3D_raw{20,1}(:,2));hold on
plot(L3_3D_raw{20,1}(:,1),L3_3D_raw{20,1}(:,2),'rx','MarkerSize',15);
plot(L3_3D(:,1,20),L3_3D(:,2,20),'ro','MarkerSize',15);
plot(xIntersection3,yIntersection3,'--k','LineWidth',2);hold on
axis equal
refline(perpSlope3, yInt3(30,1));
xlabel('RD-coord x (m)')
ylabel('RD-coord y (m)')
title('Projection of cross-section onto trendline')
set(gca,'fontsize',10,'FontWeight','bold');

%% Rotation to 2D
% here trendlines will be rotated from xy coord to y coord.

%% Rotation of L1
% Vertices matrix
V_centre(1)=1.174157397783305e+05; %Centre, of line
V_centre(2)=5.600563157123325e+05; %Centre, of line
V_centre(3)=0; %Centre, of line
a=atan(m1); %Angle in degrees
Rz=[cos(a)  -sin(a) 0;...
    sin(a)  cos(a)  0;...
    0        0        1]; %Z-axis rotation

for i = 1:20
V=[L1_3D(:,1,i) L1_3D(:,2,i) zeros(length(L1_3D),1)];
Vc=V-ones(size(V,1),1)*V_centre; %Centering coordinates
%Rotation matrix
Vrc=[Rz*Vc']'; %Rotating centred coordinates
Vruc=[Rz*V']'; %Rotating un-centred coordinates
Vr(:,:,i) =Vrc+ones(size(V,1),1).*V_centre; %Shifting back to original location
Vr(:,1,i)=1.172099050297094e+05;
L1_2D(:,1,i) = Vr(:,2,i);
L1_2D(:,2,i) = L1_3D(:,3,i);
end

%% rotation of L2
% Vertices matrix
V_centre(1)=1.171949460000000e+05; %Centre, of line
V_centre(2)=5.598235920000000e+05; %Centre, of line
V_centre(3)=0; %Centre, of line
a=atan(m2); %Angle in degrees
Rz=[cos(a)  -sin(a) 0;...
    sin(a)  cos(a)  0;...
    0        0        1]; %Z-axis rotation

for i = 1:20
V=[L2_3D(:,1,i) L2_3D(:,2,i) zeros(length(L2_3D),1)];
Vc=V-ones(size(V,1),1)*V_centre; %Centering coordinates
%Rotation matrix
Vrc=[Rz*Vc']'; %Rotating centred coordinates
Vruc=[Rz*V']'; %Rotating un-centred coordinates
Vr(:,:,i) =Vrc+ones(size(V,1),1).*V_centre; %Shifting back to original location
Vr(:,1,i)=1.172099050297094e+05;
L2_2D(:,1,i) = Vr(:,2,i);
L2_2D(:,2,i) = L2_3D(:,3,i);
end

%% Rotation of L3

% Vertices matrix
V_centre(1)=[116836.331870208]; %Centre, of line
V_centre(2)=[559543.327872769]; %Centre, of line
V_centre(3)=0; %Centre, of line

a=atan(m3); %Angle in degrees
Rz=[cos(a)  -sin(a) 0;...
    sin(a)  cos(a)  0;...
    0        0        1]; %Z-axis rotation

for i=1:20
V=[L3_3D(:,1,i) L3_3D(:,2,i) zeros(length(L3_3D),1)];
Vc=V-ones(size(V,1),1)*V_centre; %Centering coordinates

%Rotation matrix
Vrc=[Rz*Vc']'; %Rotating centred coordinates
Vruc=[Rz*V']'; %Rotating un-centred coordinates
Vr(:,:,i)=Vrc+ones(size(V,1),1).*V_centre; %Shifting back to original location
Vr(:,1,i)=1.172099050297094e+05;


L3_2D(:,1,i)= Vr(:,2,i);
L3_2D(:,2,i)= L3_3D(:,3,i);
end


%% rotation of L4

% Vertices matrix
V_centre(1)=1.161009537561489e+05; %Centre, of line
V_centre(2)=5.589522771291763e+05; %Centre, of line
V_centre(3)=0; %Centre, of line
a=atan(m2); %Angle in degrees
Rz=[cos(a)  -sin(a) 0;...
    sin(a)  cos(a)  0;...
    0        0        1]; %Z-axis rotation

for i = 1:20
V=[L4_3D(:,1,i) L4_3D(:,2,i) zeros(length(L4_3D),1)];
Vc=V-ones(size(V,1),1)*V_centre; %Centering coordinates
%Rotation matrix
Vrc=[Rz*Vc']'; %Rotating centred coordinates
Vruc=[Rz*V']'; %Rotating un-centred coordinates
Vr(:,:,i) =Vrc+ones(size(V,1),1).*V_centre; %Shifting back to original location
Vr(:,1,i)=1.172099050297094e+05;
L4_2D(:,1,i) = Vr(:,2,i);
L4_2D(:,2,i) = L4_3D(:,3,i);
end

%% Rotation of L5
% Vertices matrix
V_centre(1)=[115657.262825657]; %Centre, of line
V_centre(2)=[558613.334156511]; %Centre, of line
V_centre(3)=0; %Centre, of line

a=atan(m5); %Angle in degrees
Rz=[cos(a)  -sin(a) 0;...
    sin(a)  cos(a)  0;...
    0        0        1]; %Z-axis rotation

for i=1:20
V=[L5_3D(:,1,i) L5_3D(:,2,i) zeros(length(L5_3D),1)];
Vc=V-ones(size(V,1),1)*V_centre; %Centering coordinates

%Rotation matrix
Vrc=[Rz*Vc']'; %Rotating centred coordinates
Vruc=[Rz*V']'; %Rotating un-centred coordinates
Vr(:,:,i)=Vrc+ones(size(V,1),1).*V_centre; %Shifting back to original location
Vr(:,1,i)=1.172099050297094e+05;

L5_2D(:,1,i)= Vr(:,2,i);
L5_2D(:,2,i)= L5_3D(:,3,i);


end

%% Rotation of L6

% Vertices matrix
V_centre(1)=[115363.441235243]; %Centre, of line y coord
V_centre(2)=[558252.461687676]; %Centre, of line x coord
V_centre(3)=0; %Centre, of line z coord

a=atan(m6); %Angle in degrees
Rz=[cos(a)  -sin(a) 0;...
    sin(a)  cos(a)  0;...
    0        0        1]; %Z-axis rotation

for i=1:20
V=[L6_3D(:,1,i) L6_3D(:,2,i) zeros(length(L6_3D),1)];
Vc=V-ones(size(V,1),1)*V_centre; %Centering coordinates

%Rotation matrix
Vrc=[Rz*Vc']'; %Rotating centred coordinates
Vruc=[Rz*V']'; %Rotating un-centred coordinates
Vr(:,:,i)=Vrc+ones(size(V,1),1).*V_centre; %Shifting back to original location
Vr(:,1,i)=1.172099050297094e+05;

L6_2D(:,1,i)= Vr(:,2,i);
L6_2D(:,2,i)= L6_3D(:,3,i);

end

%% save all variables
% 
% %save profiles per day
% save('Profiles_day', 'Profiles_0913', 'Profiles_0914', 'Profiles_0915', 'Profiles_0916', 'Profiles_0917',...
% 'Profiles_0918', 'Profiles_0919', 'Profiles_0923', 'Profiles_0926', 'Profiles_0930', 'Profiles_1002',...
% 'Profiles_1003', 'Profiles_1005', 'Profiles_1006', 'Profiles_1007', 'Profiles_1010', 'Profiles_1011'...
% , 'Profiles_1013', 'Profiles_1015', 'Profiles_1018');
% 
% % save per profile in struct form
% save('Profiles_struct_raw','L1_struct_raw','L2_struct_raw','L3_struct_raw','L4_struct_raw','L5_struct_raw','L6_struct_raw');
% % save per profile in cell form (+ fieldnames)
% save('Profiles_3D_raw','L1_3D_raw','L2_3D_raw','L3_3D_raw','L4_3D_raw','L5_3D_raw','L6_3D_raw','names'); 
% % save per profile on trendline 3D
% save('Profiles_3D','L1_3D','L2_3D','L3_3D','L4_3D','L5_3D','L6_3D');
% % save per profile 2D
% save('Profiles_2D','L1_2D','L2_2D','L3_2D','L4_2D','L5_2D','L6_2D');
% 
% save('Fieldnames','names');
