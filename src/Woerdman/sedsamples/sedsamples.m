%% Sieve data processing
% Script reads out sediment sample data from Gradistatanalysis
% Potential sed data to add: 20201016, 20201130_Pilot, Jorn_data SEDMEX 
clear all
close all

% Sieve data - SEDMEX
base_dir = ('C:\Users\jelle\OneDrive\Documenten\MSc\thesis\database\sedmex\results\SieveAnalysis\Data\');
cross_gradstat_dir = [base_dir 'Martijn\Gradistat\'];
long_gradstat_dir = [base_dir 'Longshore\'];

% % Sieve data - Pilot
% pilot_dir1202 = [base_dir '20201130_Pilot\GS_2020-12-02\'];
% pilot_dir1203 = [base_dir '20201130_Pilot\GS_2020-12-03\'];

%% Load and process data - Cross shore full sieve
% 09/20
% Sediment size fractions
S.C0920a.sieve = xlsread([cross_gradstat_dir 'GRADISTATv9.1_0920.xlsm'],'Multiple Sample Data Input','B11:B34');
[names, raw]  = xlsread([cross_gradstat_dir 'GRADISTATv9.1_0920.xlsm'],'Multiple Sample Data Input','C7:AG7');
% Letters determine columns in which the data is located, differs per
% sample day 
letters = {'C','D', 'E' ,'F' ,'G', 'H', 'I','J' ,'K' ,'L', 'M', 'N','O' ,'P' ,'Q' ,'R' ,'S', 'T' ,'U', 'V', 'W', 'X', 'Y', 'Z', 'AA', 'AB', 'AC', 'AD', 'AE', 'AF' 'AG'};
for i=1:length(raw)
    % For loop subtracts the sieve results (mass per size fractions) from
    % the gradistat input and computes the percentage and stores it in a
    % struct
    S.C0920a.names(i) = raw(i);
    S.C0920a.sedlog(:,i) = xlsread([cross_gradstat_dir 'GRADISTATv9.1_0920.xlsm'],'Multiple Sample Data Input',[char(letters(i)) '11:' char(letters(i)) '34']);
    tot_mass = sum(S.C0920a.sedlog(:,i));
    for j=1:length(S.C0920a.sieve)
        S.C0920a.per(j,i)=(S.C0920a.sedlog(j,i)/tot_mass)*100;
    end
    S.C0920a.D10(i) = xlsread([cross_gradstat_dir 'GRADISTATv9.1_0920.xlsm'],'Multiple Sample Statistics',[char(letters(i)) '40']);
    S.C0920a.D50(i) = xlsread([cross_gradstat_dir 'GRADISTATv9.1_0920.xlsm'],'Multiple Sample Statistics',[char(letters(i)) '41']);
    S.C0920a.D90(i) = xlsread([cross_gradstat_dir 'GRADISTATv9.1_0920.xlsm'],'Multiple Sample Statistics',[char(letters(i)) '42']);
    S.C0920a.sort(i) = xlsread([cross_gradstat_dir 'GRADISTATv9.1_0920.xlsm'],'Multiple Sample Statistics',[char(letters(i)) '23']);
end
%% Load and process data - Cross shore reduced sieve
% 09/20
% Sediment size fractions
S.C0920.sieve = xlsread([cross_gradstat_dir 'GRADISTATv9.1_0920b.xlsm'],'Multiple Sample Data Input','B11:B24');
[names, raw]  = xlsread([cross_gradstat_dir 'GRADISTATv9.1_0920b.xlsm'],'Multiple Sample Data Input','C7:AG7');
% Letters determine columns in which the data is located, differs per
% sample day
letters = {'C','D', 'E' ,'F' ,'G', 'H', 'I','J' ,'K' ,'L', 'M', 'N','O' ,'P' ,'Q' ,'R' ,'S', 'T' ,'U', 'V', 'W', 'X', 'Y', 'Z', 'AA', 'AB', 'AC', 'AD', 'AE', 'AF' 'AG'};
for i=1:length(raw)
    % For loop subtracts the sieve results (mass per size fractions) from
    % the gradistat input and computes the percentage and stores it in a
    % struct
    S.C0920.names(i) = raw(i);
    S.C0920.sedlog(:,i) = xlsread([cross_gradstat_dir 'GRADISTATv9.1_0920b.xlsm'],'Multiple Sample Data Input',[char(letters(i)) '11:' char(letters(i)) '24']);
    tot_mass = sum(S.C0920.sedlog(:,i));
    for j=1:length(S.C0920.sieve)
        S.C0920.per(j,i)=(S.C0920.sedlog(j,i)/tot_mass)*100;
    end
    S.C0920.D10(i) = xlsread([cross_gradstat_dir 'GRADISTATv9.1_0920b.xlsm'],'Multiple Sample Statistics',[char(letters(i)) '40']);
    S.C0920.D50(i) = xlsread([cross_gradstat_dir 'GRADISTATv9.1_0920b.xlsm'],'Multiple Sample Statistics',[char(letters(i)) '41']);
    S.C0920.D90(i) = xlsread([cross_gradstat_dir 'GRADISTATv9.1_0920b.xlsm'],'Multiple Sample Statistics',[char(letters(i)) '42']);
    S.C0920.sort(i) = xlsread([cross_gradstat_dir 'GRADISTATv9.1_0920b.xlsm'],'Multiple Sample Statistics',[char(letters(i)) '23']);
end

% 09/28
S.C0928.sieve = xlsread([cross_gradstat_dir 'GRADISTATv9.1_0928.xlsm'],'Multiple Sample Data Input','B11:B24');
[names raw]  = xlsread([cross_gradstat_dir 'GRADISTATv9.1_0928.xlsm'],'Multiple Sample Data Input','C7:AH7');
letters = {'C','D', 'E' ,'F' ,'G', 'H', 'I','J' ,'K' ,'L', 'M', 'N','O' ,'P' ,'Q' ,'R' ,'S', 'T' ,'U', 'V', 'W', 'X', 'Y', 'Z', 'AA', 'AB', 'AC', 'AD', 'AE', 'AF' ,'AG','AH'};
clear tot_mass
for i=1:length(raw)
    S.C0928.names(i) = raw(i);
    S.C0928.sedlog(:,i) = xlsread([cross_gradstat_dir 'GRADISTATv9.1_0928.xlsm'],'Multiple Sample Data Input',[char(letters(i)) '11:' char(letters(i)) '24']);
    tot_mass = sum(S.C0928.sedlog(:,i));
    for j=1:length(S.C0928.sieve)
        S.C0928.per(j,i)=(S.C0928.sedlog(j,i)/tot_mass)*100;
    end
    S.C0928.D10(i) = xlsread([cross_gradstat_dir 'GRADISTATv9.1_0928.xlsm'],'Multiple Sample Statistics',[char(letters(i)) '40']);
    S.C0928.D50(i) = xlsread([cross_gradstat_dir 'GRADISTATv9.1_0928.xlsm'],'Multiple Sample Statistics',[char(letters(i)) '41']);
    S.C0928.D90(i) = xlsread([cross_gradstat_dir 'GRADISTATv9.1_0928.xlsm'],'Multiple Sample Statistics',[char(letters(i)) '42']);
    S.C0928.sort(i) = xlsread([cross_gradstat_dir 'GRADISTATv9.1_0928.xlsm'],'Multiple Sample Statistics',[char(letters(i)) '23']);
end

%10/01
S.C1001.sieve = xlsread([cross_gradstat_dir 'GRADISTATv9.1_1001.xlsm'],'Multiple Sample Data Input','B11:B24');
[names raw]  = xlsread([cross_gradstat_dir 'GRADISTATv9.1_1001.xlsm'],'Multiple Sample Data Input','C7:K7');
letters = {'C','D', 'E' ,'F' ,'G', 'H', 'I','J' ,'K'};
clear tot_mass
for i=1:length(raw)
    S.C1001.names(i) = raw(i);
    S.C1001.sedlog(:,i) = xlsread([cross_gradstat_dir 'GRADISTATv9.1_1001.xlsm'],'Multiple Sample Data Input',[char(letters(i)) '11:' char(letters(i)) '24']);
    tot_mass = sum(S.C1001.sedlog(:,i));
    for j=1:length(S.C1001.sieve)
        S.C1001.per(j,i)=(S.C1001.sedlog(j,i)/tot_mass)*100;
    end
    S.C1001.D10(i) = xlsread([cross_gradstat_dir 'GRADISTATv9.1_1001.xlsm'],'Multiple Sample Statistics',[char(letters(i)) '40']);
    S.C1001.D50(i) = xlsread([cross_gradstat_dir 'GRADISTATv9.1_1001.xlsm'],'Multiple Sample Statistics',[char(letters(i)) '41']);
    S.C1001.D90(i) = xlsread([cross_gradstat_dir 'GRADISTATv9.1_1001.xlsm'],'Multiple Sample Statistics',[char(letters(i)) '42']);
    S.C1001.sort(i) = xlsread([cross_gradstat_dir 'GRADISTATv9.1_1001.xlsm'],'Multiple Sample Statistics',[char(letters(i)) '23']);
end

%10/07
S.C1007.sieve = xlsread([cross_gradstat_dir 'GRADISTATv9.1_1007.xlsm'],'Multiple Sample Data Input','B11:B24');
[names raw]  = xlsread([cross_gradstat_dir 'GRADISTATv9.1_1007.xlsm'],'Multiple Sample Data Input','C7:R7');
letters = {'C','D', 'E' ,'F' ,'G', 'H', 'I','J' ,'K' ,'L', 'M', 'N','O' ,'P' ,'Q' ,'R' };
clear tot_mass
for i=1:length(raw)
    S.C1007.names(i) = raw(i);
    S.C1007.sedlog(:,i) = xlsread([cross_gradstat_dir 'GRADISTATv9.1_1007.xlsm'],'Multiple Sample Data Input',[char(letters(i)) '11:' char(letters(i)) '24']);
    tot_mass = sum(S.C1007.sedlog(:,i));
    for j=1:length(S.C1007.sieve)
        S.C1007.per(j,i)=(S.C1007.sedlog(j,i)/tot_mass)*100;
    end
    S.C1007.D10(i) = xlsread([cross_gradstat_dir 'GRADISTATv9.1_1007.xlsm'],'Multiple Sample Statistics',[char(letters(i)) '40']);
    S.C1007.D50(i) = xlsread([cross_gradstat_dir 'GRADISTATv9.1_1007.xlsm'],'Multiple Sample Statistics',[char(letters(i)) '41']);
    S.C1007.D90(i) = xlsread([cross_gradstat_dir 'GRADISTATv9.1_1007.xlsm'],'Multiple Sample Statistics',[char(letters(i)) '42']);    
    S.C1007.sort(i) = xlsread([cross_gradstat_dir 'GRADISTATv9.1_1007.xlsm'],'Multiple Sample Statistics',[char(letters(i)) '23']);
end

%10/15
S.C1015.sieve = xlsread([cross_gradstat_dir 'GRADISTATv9.1_1015.xlsm'],'Multiple Sample Data Input','B11:B24');
[names raw]  = xlsread([cross_gradstat_dir 'GRADISTATv9.1_1015.xlsm'],'Multiple Sample Data Input','C7:Y7');
letters = {'C','D', 'E' ,'F' ,'G', 'H', 'I','J' ,'K' ,'L', 'M', 'N','O' ,'P' ,'Q' ,'R' ,'S', 'T' ,'U', 'V', 'W', 'X', 'Y'};
clear tot_mass
for i=1:length(raw)
    S.C1015.names(i) = raw(i);
    S.C1015.sedlog(:,i) = xlsread([cross_gradstat_dir 'GRADISTATv9.1_1015.xlsm'],'Multiple Sample Data Input',[char(letters(i)) '11:' char(letters(i)) '24']);
    tot_mass = sum(S.C1015.sedlog(:,i));
    for j=1:length(S.C1015.sieve)
        S.C1015.per(j,i)=(S.C1015.sedlog(j,i)/tot_mass)*100;
    end
    S.C1015.D10(i) = xlsread([cross_gradstat_dir 'GRADISTATv9.1_1015.xlsm'],'Multiple Sample Statistics',[char(letters(i)) '40']);
    S.C1015.D50(i) = xlsread([cross_gradstat_dir 'GRADISTATv9.1_1015.xlsm'],'Multiple Sample Statistics',[char(letters(i)) '41']);
    S.C1015.D90(i) = xlsread([cross_gradstat_dir 'GRADISTATv9.1_1015.xlsm'],'Multiple Sample Statistics',[char(letters(i)) '42']);
    S.C1015.sort(i) = xlsread([cross_gradstat_dir 'GRADISTATv9.1_1015.xlsm'],'Multiple Sample Statistics',[char(letters(i)) '23']);
end

%% Load and process data - longshore
% 09/21
S.L0921.sieve = xlsread([long_gradstat_dir 'GRADISTAT_longshore21.xlsm'],'Multiple Sample Data Input','B11:B24');
[names raw]  = xlsread([long_gradstat_dir 'GRADISTAT_longshore21.xlsm'],'Multiple Sample Data Input','C7:O7');
letters = {'C','D', 'E' ,'F' ,'G', 'H', 'I','J' ,'K' ,'L', 'M', 'N','O'};
for i=1:length(raw)
    S.L0921.names(i) = raw(i);
    S.L0921.sedlog(:,i) = xlsread([long_gradstat_dir 'GRADISTAT_longshore21.xlsm'],'Multiple Sample Data Input',[char(letters(i)) '11:' char(letters(i)) '23']);
    tot_mass = sum(S.L0921.sedlog(:,i));
    for j=1:length(S.L0921.sieve)
        S.L0921.per(j,i)=(S.L0921.sedlog(j,i)/tot_mass)*100;
    end
    S.L0921.D10(i) = xlsread([long_gradstat_dir 'GRADISTAT_longshore21.xlsm'],'Multiple Sample Statistics',[char(letters(i)) '40']);
    S.L0921.D50(i) = xlsread([long_gradstat_dir 'GRADISTAT_longshore21.xlsm'],'Multiple Sample Statistics',[char(letters(i)) '41']);
    S.L0921.D90(i) = xlsread([long_gradstat_dir 'GRADISTAT_longshore21.xlsm'],'Multiple Sample Statistics',[char(letters(i)) '42']);
    S.L0921.sort(i) = xlsread([long_gradstat_dir 'GRADISTAT_longshore21.xlsm'],'Multiple Sample Statistics',[char(letters(i)) '23']);

end

% 09/28
S.L0928.sieve = xlsread([long_gradstat_dir 'GRADISTAT_longshore28.xlsm'],'Multiple Sample Data Input','B11:B24');
[names raw]  = xlsread([long_gradstat_dir 'GRADISTAT_longshore28.xlsm'],'Multiple Sample Data Input','C7:O7');
letters = {'C','D', 'E' ,'F' ,'G', 'H', 'I','J' ,'K' ,'L', 'M', 'N','O'};
for i=1:length(raw)
    S.L0928.names(i) = raw(i);
    S.L0928.sedlog(:,i) = xlsread([long_gradstat_dir 'GRADISTAT_longshore28.xlsm'],'Multiple Sample Data Input',[char(letters(i)) '11:' char(letters(i)) '23']);
    tot_mass = sum(S.L0928.sedlog(:,i));
    for j=1:length(S.L0928.sieve)
        S.L0928.per(j,i)=(S.L0928.sedlog(j,i)/tot_mass)*100;
    end
    S.L0928.D10(i) = xlsread([long_gradstat_dir 'GRADISTAT_longshore28.xlsm'],'Multiple Sample Statistics',[char(letters(i)) '40']);
    S.L0928.D50(i) = xlsread([long_gradstat_dir 'GRADISTAT_longshore28.xlsm'],'Multiple Sample Statistics',[char(letters(i)) '41']);
    S.L0928.D90(i) = xlsread([long_gradstat_dir 'GRADISTAT_longshore28.xlsm'],'Multiple Sample Statistics',[char(letters(i)) '42']);
    S.L0928.sort(i) = xlsread([long_gradstat_dir 'GRADISTAT_longshore28.xlsm'],'Multiple Sample Statistics',[char(letters(i)) '23']);
end

% %% Load and process data - Pilot
% % 12/02
% S.P1202.sieve = xlsread([pilot_dir1202 'GS_2020-12-02.xlsm'],'Multiple Sample Data Input','B11:B36');
% [names raw]  = xlsread([pilot_dir1202 'GS_2020-12-02.xlsm'],'Multiple Sample Data Input','C7:AG7');
% letters = {'C','D', 'E' ,'F' ,'G', 'H', 'I','J' ,'K' ,'L', 'M', 'N','O' ,'P' ,'Q' ,'R' ,'S', 'T' ,'U', 'V', 'W', 'X', 'Y', 'Z', 'AA', 'AB', 'AC', 'AD', 'AE', 'AF' ,'AG'};
% for i=1:length(raw)
%     S.P1202.names(i) = raw(i);
%     S.P1202.sedlog(:,i) = xlsread([pilot_dir1202 'GS_2020-12-02.xlsm'],'Multiple Sample Data Input',[char(letters(i)) '11:' char(letters(i)) '36']);
%     tot_mass = sum(S.P1202.sedlog(:,i));
%     for j=1:length(S.P1202.sieve)
%         S.P1202.per(j,i)=(S.P1202.sedlog(j,i)/tot_mass)*100;
%     end
%     S.P1202.D10(i) = xlsread([pilot_dir1202 'GS_2020-12-02.xlsm'],'Multiple Sample Statistics',[char(letters(i)) '40']);
%     S.P1202.D50(i) = xlsread([pilot_dir1202 'GS_2020-12-02.xlsm'],'Multiple Sample Statistics',[char(letters(i)) '41']);
%     S.P1202.D90(i) = xlsread([pilot_dir1202 'GS_2020-12-02.xlsm'],'Multiple Sample Statistics',[char(letters(i)) '42']);
%     S.P1202.sort(i) = xlsread([pilot_dir1202 'GS_2020-12-02.xlsm'],'Multiple Sample Statistics',[char(letters(i)) '23']);
% 
% end
% 
% % 12/03
% S.P1203.sieve = xlsread([pilot_dir1203 'GS_2020-12-03.xlsm'],'Multiple Sample Data Input','B11:B36');
% [names raw]  = xlsread([pilot_dir1203 'GS_2020-12-03.xlsm'],'Multiple Sample Data Input','C7:L7');
% letters = {'C','D', 'E' ,'F' ,'G', 'H', 'I','J' ,'K' ,'L'};
% for i=1:length(raw)
%     S.P1203.names(i) = raw(i);
%     S.P1203.sedlog(:,i) = xlsread([pilot_dir1203 'GS_2020-12-03.xlsm'],'Multiple Sample Data Input',[char(letters(i)) '11:' char(letters(i)) '36']);
%     tot_mass = sum(S.P1203.sedlog(:,i));
%     for j=1:length(S.P1203.sieve)
%         S.P1203.per(j,i)=(S.P1203.sedlog(j,i)/tot_mass)*100;
%     end
%     S.P1203.D10(i) = xlsread([pilot_dir1203 'GS_2020-12-03.xlsm'],'Multiple Sample Statistics',[char(letters(i)) '40']);
%     S.P1203.D50(i) = xlsread([pilot_dir1203 'GS_2020-12-03.xlsm'],'Multiple Sample Statistics',[char(letters(i)) '41']);
%     S.P1203.D90(i) = xlsread([pilot_dir1203 'GS_2020-12-03.xlsm'],'Multiple Sample Statistics',[char(letters(i)) '42']);
%     S.P1203.sort(i) = xlsread([pilot_dir1203 'GS_2020-12-03.xlsm'],'Multiple Sample Statistics',[char(letters(i)) '23']);
% 
% end

% Save structure
% save('sieve_data','S')