clear all;
close all;

sedmexInit;
global basePath;

%% Open result data BaseParameters
myFolder = [basePath, 'results'];
filePattern = fullfile(myFolder, 'baseParametersOSSI*.mat');
matFiles = dir(filePattern);
      for i = 1:length(matFiles)
          baseFileName = fullfile(myFolder, matFiles(i).name);
          ref_files{i} = load(baseFileName);
      end
OSSI09Par= ref_files{1,5}.OSSI09Par;

time= datenum(eurecca2METtime(OSSI09Par(:,1)));

timein=datenum(2021,09,11,00,00,00);
timeout=datenum(2021,10,18,10,00,00);
timeaxis=[timein:2:timeout];

%% water level harmonic fitting
coef = ut_solv (time, OSSI09Par(:,2),[], 53.019253, 'auto','DiagnPlots');
figure(1);hold on
set(gcf, 'position',[100 50 1200 700],'color','white')

subplot(211); hold on
set(gca,'fontsize',10,'FontWeight','bold');
xticks(timeaxis);
datetick('x','keepticks','keeplimits');

subplot(212);
set(gca,'fontsize',10,'FontWeight','bold');


%%
name=(coef.name)';
a=(coef.A)'
g=(coef.g)'


