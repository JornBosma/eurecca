%%
clear all;
close all;

sedmexInit;
global basePath;

%% Open result data BaseParameters ADV
myFolder = [basePath, 'results'];
filePattern = fullfile(myFolder, '*VEC*.mat');
matFiles = dir(filePattern);
      for i = 1:length(matFiles)
          baseFileName = fullfile(myFolder, matFiles(i).name);
          ref_files{i} = load(baseFileName);
      end
            
L1C1VEC= ref_files{1,1}.L1C1VEC;
L2C10VEC=ref_files{1,2}.L2C10VEC;
% L4C1VEC= ref_files{1,3}.L3C1VEC;
% L5C1VEC= ref_files{1,4}.L4C1VEC;
% L6C1VEC= ref_files{1,5}.L5C1VEC;
L6C1VEC= ref_files{1,6}.L6C1VEC;

%% grainsize mobility
windoctdekooy = importfile([basePath, 'dataRaw\windKNMI\wind_oct_dekooy.txt']);
winddata(:,2)=windoctdekooy.speed;
winddata(:,3)=windoctdekooy.direction;

calm= find(winddata(:,2)<=7.1);
storm= find(winddata(:,2)>=7.1);


idnan1= find( isnan(L6C1VEC(:,2)));
idnan2= find(isnan(L6C1VEC(storm,2)));

perc1=length(idnan1)/length(L6C1VEC);
perc2=length(idnan2)/length(L6C1VEC(storm,2));









