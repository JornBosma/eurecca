clear all;
close all;

% relevant paths
% cd('R:\Zandmotor');
sedmexInit;
global basePath;
PS = PLOT_STANDARDS();
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

%%
timein=datetime(2021,09,11,00,00,00);
timeout=datetime(2021,10,18,10,00,00);
time=[timein:2:timeout];


hours=[timein:hours(6):timeout];

%%
range=[datetime(2021,09,15,00,00,00):datetime(2021,09,17,00,00,00)];

figure(1);
tiledlayout(5,1)
nexttile
    plot(datetime(eurecca2METtime(L1C1VEC(:,1))),L1C1VEC(:,2)); hold on
    xlim([range(1) range(end)]);
    xticks(hours);
nexttile
    plot(datetime(eurecca2METtime(L2C10VEC(:,1))),L2C10VEC(:,2)); hold on
    xlim([range(1) range(end)]);
    xticks(hours);

nexttile
    plot(datetime(eurecca2METtime(L4C1VEC(:,1))),L4C1VEC(:,2)); hold on
    xlim([range(1) range(end)]);
    xticks(hours);
nexttile
    plot(datetime(eurecca2METtime(L5C1VEC(:,1))),L5C1VEC(:,2)); hold on
    xlim([range(1) range(end)]);
    xticks(hours);
nexttile
    plot(datetime(eurecca2METtime(L6C1VEC(:,1))),L6C1VEC(:,2)); hold on
    xlim([range(1) range(end)]);
    xticks(hours);
    
    %%
    range=[datetime(2021,10,03,00,00,00):datetime(2021,10,05,00,00,00)];

figure(1);
tiledlayout(5,1)
nexttile
    plot(datetime(eurecca2METtime(L1C1VEC(:,1))),L1C1VEC(:,2)); hold on
    xlim([range(1) range(end)]);
    xticks(hours);
nexttile
    plot(datetime(eurecca2METtime(L2C10VEC(:,1))),L2C10VEC(:,2)); hold on
    xlim([range(1) range(end)]);
    xticks(hours);

nexttile
    plot(datetime(eurecca2METtime(L4C1VEC(:,1))),L4C1VEC(:,2)); hold on
    xlim([range(1) range(end)]);
    xticks(hours);
nexttile
    plot(datetime(eurecca2METtime(L5C1VEC(:,1))),L5C1VEC(:,2)); hold on
    xlim([range(1) range(end)]);
    xticks(hours);
nexttile
    plot(datetime(eurecca2METtime(L6C1VEC(:,1))),L6C1VEC(:,2)); hold on
    xlim([range(1) range(end)]);
    xticks(hours);


%%

figure(3)
 plot(datetime(eurecca2METtime(L6C1VEC(:,1))),OSSI01Par(:,4)); hold on
    xlim([range(1) range(end)]);
    xticks(hours);









