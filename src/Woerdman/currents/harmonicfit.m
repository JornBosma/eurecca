
clear all;
close all;

% relevant paths
% cd('R:\Zandmotor');
sedmexInit;
global basePath;

%% Open result data BaseParameters
myFolder = [basePath, 'results'];
filePattern = fullfile(myFolder, '*VEC*.mat');
matFiles = dir(filePattern);
      for i = 1:length(matFiles)
          baseFileName = fullfile(myFolder, matFiles(i).name);
          ref_files{i} = load(baseFileName);
      end
            
L1C1VEC= ref_files{1,1}.L1C1VEC(:,:);
L2C10VEC=ref_files{1,2}.L2C10VEC;
L3C1VEC= ref_files{1,3}.L3C1VEC(:,:);
L4C1VEC= ref_files{1,4}.L4C1VEC(:,:);
L5C1VEC= ref_files{1,5}.L5C1VEC(:,:);
L6C1VEC= ref_files{1,6}.L6C1VEC(:,:);

%% Open result data BaseParameters
myFolder = [basePath, 'results'];
filePattern = fullfile(myFolder, 'baseParametersOSSI*.mat');
matFiles = dir(filePattern);
      for i = 1:length(matFiles)
          baseFileName = fullfile(myFolder, matFiles(i).name);
          ref_files{i} = load(baseFileName);
      end
OSSI09Par= ref_files{1,5}.OSSI09Par;

time= datenum(eurecca2METtime(L2C10VEC(:,1)));

timein=datenum(2021,09,11,00,00,00);
timeout=datenum(2021,10,18,10,00,00);
timeaxis=[timein:2:timeout];

%% Harmonic analysis u,v components

L1coef = ut_solv (time, L1C1VEC(:,18),L1C1VEC(:,19), 53.019253, 'auto','DiagnPlots');
L2coef = ut_solv (time, L2C10VEC(:,18),L2C10VEC(:,19), 53.019253, 'auto','DiagnPlots');
L3coef = ut_solv (time, L3C1VEC(:,18),L3C1VEC(:,19), 53.019253, 'auto','DiagnPlots');
L4coef = ut_solv (time, L4C1VEC(:,18),L4C1VEC(:,19), 53.019253, 'auto','DiagnPlots');
L5coef = ut_solv (time, L5C1VEC(:,18),L5C1VEC(:,19), 53.019253, 'auto','DiagnPlots');
L6coef = ut_solv (time, L6C1VEC(:,18),L6C1VEC(:,19), 53.019253, 'auto','DiagnPlots');


%% Harmonic analysis long cross components 
L1coef_lc = ut_solv (time, L1C1VEC(:,2),L1C1VEC(:,3), 53.019253, 'auto','DiagnPlots');
L2coef_lc = ut_solv (time, L2C10VEC(:,2),L2C10VEC(:,3), 53.019253, 'auto','DiagnPlots');
L3coef_lc = ut_solv (time, L3C1VEC(:,2),L3C1VEC(:,3), 53.019253, 'auto','DiagnPlots');
L4coef_lc = ut_solv (time, L4C1VEC(:,2),L4C1VEC(:,3), 53.019253, 'auto','DiagnPlots');
L5coef_lc = ut_solv (time, L5C1VEC(:,2),L5C1VEC(:,3), 53.019253, 'auto','DiagnPlots');
L6coef_lc = ut_solv (time, L6C1VEC(:,2),L6C1VEC(:,3), 53.019253, 'auto','DiagnPlots');


%% hardcoded parameters for tidal ellips
SEMA(:,1)=L1coef.Lsmaj(1,1);
SEMA(:,2)=L2coef.Lsmaj(1,1);
SEMA(:,3)=L4coef.Lsmaj(1,1);
SEMA(:,4)=L5coef.Lsmaj(1,1);
SEMA(:,5)=L6coef.Lsmaj(1,1);
SEMI(:,1)=L1coef.Lsmin(1,1);
SEMI(:,2)=L2coef.Lsmin(1,1);
SEMI(:,3)=L4coef.Lsmin(1,1);
SEMI(:,4)=L5coef.Lsmin(1,1);
SEMI(:,5)=L6coef.Lsmin(1,1);
PHA(:,1)=L1coef.g(1,1);
PHA(:,2)=L2coef.g(1,1);
PHA(:,3)=L4coef.g(1,1);
PHA(:,4)=L5coef.g(1,1);
PHA(:,5)=L6coef.g(1,1);
INC(:,1)=L1coef.theta(1,1);
INC(:,2)=L2coef.theta(1,1);
INC(:,3)=L4coef.theta(1,1);
INC(:,4)=L5coef.theta(1,1);
INC(:,5)=L6coef.theta(1,1);

IND=1;

figure(100);
set(gcf, 'position',[100 50 1200 700],'color','white')

% xlabel(t,'Current bed shear stress, tau_c [Pa]','Fontweight','bold')
% ylabel(t,'Wave bed shear stress, tau_w [Pa]','Fontweight','bold')
titles={'M2 Ellips L1','M2 Ellips L2','M2 Ellips L4','M2 Ellips L5','M2 Ellips L6'};

for i=1:5
ECC=SEMI(:,i)./SEMA(:,i); 
plot_ell(SEMA(:,i), ECC, INC(:,i),PHA(:,i), IND, i);
% xlim([-0.2 0.2]); ylim([-0.2 0.2]);
title({titles{i},'(red) green (anti-) clockwise component'});
set(gca,'fontsize',10,'FontWeight','bold');
end


