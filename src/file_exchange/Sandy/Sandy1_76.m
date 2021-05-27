function Sandy1_75
% _____________________________________________________
%% 
% SANDY
%
% Instructions:
% 1. SANDY© requires two input parameters for computing the sediment size 
%    distribution: nominal sieve openings and cumulative mass of material
%    retained on each sieve. This information is provided to the program 
%    through a plain text file (*.txt) arranged in two columns, which 
%    should be separated by a tab space and must be located in subfolder. 
%    This subfolder should be in the same folder where the SANDY© script is. 
%    The data in the first column correspond to the nominal sieve openings 
%    (in mm) and the second column must refer to the cumulative mass of 
%    material retained on each sieve (in grams). The data must be sorted 
%    in descending order, following the nominal sieve openings.
% 2. In order to perform the sieve analysis of one or several samples of sand,
%    it is necessary to create a folder; this is the main folder for the 
%    program. For each sediment sample that requires analysis, a subfolder 
%    of the sample should be created and the input file should be within 
%    this subfolder. The main folder should contain the SANDY© program and 
%    one or more subfolders. When the program starts, the main folder is 
%    reviewed to determine whether one subfolder (“a sample”) should be 
%    analysed or several subfolders (multiple analyses).
% 3.	To run SANDY, in Matlab Command Window should write the command:
% run('Sandy')
%
% Reference:
% Ruiz-Martinez, G., Rivillas-Ospina, D., Mariño-Tapia, I. and
% Posada-Vanegas, G. (2016). SANDY: a Matlab tool to estimate the sediment 
% size distribution from a sieve analysis. Computers & Geosciences, 96, July, pp. 104-116 
% DOI: 10.1016/j.cageo.2016.04.010 
% https://github.com/cageo/Ruiz-Martinez-2016.git

%
% The routine is provided "as is", without warranty of any kind, express or implied, 
% including but not limited to the warranties of merchantability, fitness for a particular 
% purpose and noninfringement. In no event shall the authors or copyright holders be liable
% for any claim, damages or other liability, whether in an action of contract, tort or otherwise, 
% arising from, out of or in connection with the software or the use or other dealings in the software.
%
% Copyright, 2010, Gabriel Ruiz-Martinez.
%
% Last modification : 01-02-17. v_1_75
% Please, report any bug to matgarlab@yahoo.com
% _____________________________________________________

tstart = tic;

sieves = [ 125; 112; 106; 100; 90; 80; 75; 71; 63; 56; 53; 50; 45; 40; 37.5; 35.5; ...
           31.5; 28.0; 26.5; 25; 22.4; 20; 19; 18; 16; 14; 13.2; 12.5; 11.2; 10; 9.5; ...
           9.0; 8.0; 7.1; 6.7; 6.3; 5.6; 5; 4.75; 4.5; 4; 3.55; 3.35; 3.15; 2.8; 2.5; ...
           2.36; 2.24; 2; 1.8; 1.7; 1.6; 1.4; 1.25; 1.18; 1.12; 1; 0.9; 0.85; 0.8; ...
           0.71; 0.63; 0.6; 0.56; 0.5; 0.45; 0.425; 0.4; 0.355; 0.315; 0.3; 0.28; ...
           0.25; 0.224; 0.212; 0.2; 0.18; 0.16; 0.15; 0.14; 0.125; 0.112; 0.106; 0.1; ...
           0.09; 0.08; 0.075; 0.071; 0.063; 0.056; 0.053; 0.05; 0.045; 0.04; 0.038; ...
           0.036; 0.032; 0.025; 0.02];
foldercur = pwd;
dircarac = dir(pwd);
subfol = [dircarac(:).isdir];
namesubfol = {dircarac(subfol).name};
namesubfol(ismember(namesubfol,{'.','..'})) = [];
nfol = length(namesubfol);
fecha = datestr(datevec(now),'dd/mm/yyyy HH:MM:SS');
fid = fopen('diag_Sandy.log','w');
fprintf(fid,'***********************************************************\r\n');
fprintf(fid,'*                                                         *\r\n');
fprintf(fid,'*            Sandy, Version 1_75 Feb 01 2017              *\r\n');
fprintf(fid,'*                  date: %19s              *\r\n',fecha);
fprintf(fid,'*                                                         *\r\n');
fprintf(fid,'*                       Diagnostic file                   *\r\n');
fprintf(fid,'*                                                         *\r\n');
fprintf(fid,'***********************************************************\r\n');
fprintf(fid,'\r\n');
if nfol >= 2
   esta = zeros(nfol,5); 
   fprintf('***********************************************************\n');
   fprintf('* Sandy has recognized several folders, for this reason a *\n');
   fprintf('*                  "multi-analysis" will run.             *\n');
   fprintf('***********************************************************\n');
   fprintf('\n');
   fprintf(fid,'***********************************************************\r\n');
   fprintf(fid,'* Sandy has recognized several folders, for this reason a *\r\n');
   fprintf(fid,'*                  "multi-analysis" will run.             *\r\n');
   fprintf(fid,'***********************************************************\r\n');
   fprintf(fid,'\r\n');
else
   fprintf('***********************************************************\n');
   fprintf('*   Sandy has recognized a one sample to its analysis     *\n');
   fprintf('***********************************************************\n');
   fprintf('\n');
   fprintf(fid,'\r\n');
   fprintf(fid,'->->-> Sandy has recognized a one sample to its analysis     \r\n');
   fprintf(fid,'\r\n');
   fprintf(fid,'\r\n');
end
fprintf('->->Checking the folders...\n');
for co = 1 : nfol
    folderrew = cell2mat(namesubfol(co)); 
    fprintf('Reviewing if the folder %s has one txt file (input file)...\n',folderrew);
    fprintf(fid,'->->-> Reviewing if the folder %s has one txt file (input file)...\r\n',folderrew);
    cd(folderrew);
    casos = dir('*.txt');
    if length(casos) >= 2
           fprintf('One problem was found in the folder %s\n',folderrew);
           fprintf('Analysis will not done because Sandy recognized\n');
           fprintf('two o more .txt files on the folder. Which is the input file? \n');
           fprintf('Please delete any .txt file that is not been the input file \n\n');
           fprintf(fid,'->->-> One problem was found in the folder %s \r\n',folderrew);
           fprintf(fid,'       Analysis will not done because Sandy recognized \r\n');
           fprintf(fid,'       two o more .txt files on the folder. Which is the input file? \r\n');
           fprintf(fid,'       Please delete any .txt file that is not been the input file \n\r\n');
           idp(co) = 2;
    elseif length(casos) == 0
           fprintf('One problem was found in the folder %s\n',folderrew);
           fprintf('Analysis will not done because Sandy could not find\n');
           fprintf('the input file. \n\n');
           fprintf(fid,'->->-> One problem was found in the folder %s \r\n',folderrew);
           fprintf(fid,'       Analysis will not done because Sandy could not find \r\n');
           fprintf(fid,'       the input file. \n\r\n');
           fprintf('One problem was found in the folder %s\n',folderrew);
           fprintf('Analysis will not done because Sandy could not find\n');
           fprintf('the input file. \n\n');
           fprintf(fid,'->->-> One problem was found in the folder %s \r\n',folderrew);
           fprintf(fid,'       Analysis will not done because Sandy could not find \r\n');
           fprintf(fid,'       the input file. \n\r\n');
           idp(co) = 1;
    else
           fprintf('->->-> Ok!!\n');
           idp(co) = 0;
           fprintf('Reviewing if the input file into folder %s has the ASTM and BSI sieve sizes ...\n',folderrew);
           fprintf(fid,'->->-> Reviewing if the input file into folder %s has the ASTM and BSI sieve sizes ...\r\n',folderrew);
           data = load(casos.name, '-ascii');
           meshes = data(:,1);
           if length(sieves(ismember(sieves,meshes))) == length(meshes)
               fprintf('Ok!!\n\n');
               fprintf(fid,'->->-> Ok!!\n\r\n');
               idp(co) = 0;
           else
               fprintf('Wow! Check the input sieve sizes, because one of \n');
               fprintf('them is not recognized into ASTM and BSI sizes! \n\n');
               fprintf(fid,'->->-> Wow! Check the input sieve sizes, because one of \r\n');
               fprintf(fid,'->->-> them is not recognized into ASTM and BSI sizes! \n\r\n');
               idp(co) = 3;
           end
		   if ( meshes(end) <= 0.02 ) 
               fprintf('Wow! Wow! Into folder %s...\n',folderrew);
		       fprintf('You are using a non standard sieve size (<= 0.02 mm), SANDY can not \n');
               fprintf('compute the sample by moments method. Sorry! Aborting the execution\n\n');
			   idp(co) = 4;
		   end 
           clear data meshes
    end
    cd(foldercur);
end
wer = find(idp==2);
wert = find(idp==1);
werty = find(idp==3);
wertyy = find(idp==4);
if isempty(wer) ~= 0 && isempty(wert) ~= 0 && isempty(werty) ~= 0 && isempty(wertyy) ~= 0
    for i = 1 : nfol
        carpeta = cell2mat(namesubfol(i));
        cd(carpeta);
        fprintf('Analyzing folder: %s\n',num2str(i));
        fprintf(fid,'->->-> Analyzing folder: %s \r\n',num2str(i));
        [q50,result] = Sandym(carpeta,sieves);
        if nfol >= 2
            close all 
            esta(i,1) = q50;
            esta(i,2) = result.Media_Folk_Ward_en_mm;
            esta(i,3) = result.SD_Folk_Ward_en_mm;
            esta(i,4) = result.Sesgo_Folk_Ward_adim;
            esta(i,5) = result.Kurtosis_Folk_Ward_adim;
            esta(i,6) = result.Yab;
            esta(i,7) = result.Ysa;
            esta(i,8) = result.Yds;
            esta(i,9) = result.Yft;
            esta(i,10) = result.ks;
            esta(i,11) = result.z0;
			esta(i,12) = result.one_percentile_mm;
        end
    
        cd(foldercur);
    end
    if nfol >= 2
            finalplots(nfol,esta,foldercur);
			
% 			fid1 = fopen('Summary.txt','w');
%             fprintf(fid1,'D50(mm)\t Mean(phi)\t SD(mm)\t Skw\t Kur\t Yab\t Ysa\t Yds\t Yft\t ks\t z0\t 1p(microns)\t Mean(microns)\r\n');
%             for s1 = 1 : nfol
%               fprintf(fid1,'%6.4f\t %6.3f\t %6.3f\t %6.3f\t %6.3f\t %6.4f\t %6.4f\t %6.4f\t %6.4f\t %6.4f\t %6.4f\t %6.4f\t %6.4f\r\n',...
%                       esta(s1,1), -log2(esta(s1,2)), -log2(esta(s1,3)), esta(s1,4), esta(s1,5), esta(s1,6), esta(s1,7),...
%                       esta(s1,8), esta(s1,9),esta(s1,10), esta(s1,11), esta(s1,12)*1000, esta(s1,2)*1000);
%             end
    end
end
tend = toc(tstart);
fprintf('Processing time: %8.3f seg\n',tend);
fprintf(fid,'\r\n');
fprintf(fid,'\r\n');
fprintf(fid,'***********************************************************\r\n');
fprintf(fid,'* ...                                                     *\r\n');
fprintf(fid,'*    ... Finished  Sandy                                  *\r\n');
fprintf(fid,'*                  date: %19s              *\r\n',fecha);
fprintf(fid,'*                                                         *\r\n');
fprintf(fid,'***********************************************************\r\n');
fprintf(fid,'\r\n');
close all
fclose('all');
end

function [D_50,statisand] = Sandym(a,sieves)
screen = get(0, 'screensize');     
nombre = a;
casos = dir('*.txt');
data = load(casos.name, '-ascii');
[lGra,cgra] = size(data);
if cgra == 2 || isempty(data) == 0
        WB = data(:,2);
        [d0,n0] = find(WB==0);
        WB(d0) = 1E-6;
        milimeters = data(:,1);
        milimeter = data(:,1);
        r = length(milimeters);
        format short g
        for i = 1 : r 
            Worksheet_sieve_data{1,1}(i) = WB(i);
        end
        Sum_Col_1 = sum( Worksheet_sieve_data{1,1} );
           
        for i = 1: r 
            Worksheet_sieve_data{1,2}(i) = (Worksheet_sieve_data{1,1}(i)/Sum_Col_1)*100;
            if i == 1 
                 Worksheet_sieve_data{1,3}(i) = Worksheet_sieve_data{1,2}(i);
                 Worksheet_sieve_data{1,4}(i) = 100;
            else  
                 Worksheet_sieve_data{1,3}(i) = Worksheet_sieve_data{1,2}(i)+Worksheet_sieve_data{1,3}(i-1);
                 Worksheet_sieve_data{1,4}(i) = Worksheet_sieve_data{1,4}(1)-Worksheet_sieve_data{1,3}(i);
            end  
            tablagranu(i,1) = Worksheet_sieve_data{1,1}(i);    
            tablagranu(i,2) = Worksheet_sieve_data{1,2}(i);   
            tablagranu(i,3) = Worksheet_sieve_data{1,3}(i); 
            tablagranu(i,4) = Worksheet_sieve_data{1,4}(i);
        end        
         diamX = Worksheet_sieve_data{1,4} ;
         diamX = diamX';
         diamY = milimeter;
		 % Percentile list (for UC)
		 for i = 1:100
		    perce(i) = interp1(diamX, diamY, i, 'pchip');
		 end
         D_5 = interp1(diamX, diamY, 5, 'pchip');
         D_10 = interp1(diamX, diamY, 10, 'pchip');
         D_16 = interp1(diamX, diamY, 16, 'pchip');
         D_25 = interp1(diamX, diamY, 25, 'pchip');
         D_30 = interp1(diamX, diamY, 30, 'pchip');
         D_50 = interp1(diamX, diamY, 50, 'pchip');  
         D_60 = interp1(diamX, diamY, 60, 'pchip');
         D_75 = interp1(diamX, diamY, 75, 'pchip');
         D_84 = interp1(diamX, diamY, 84, 'pchip');
         D_90 = interp1(diamX, diamY, 90, 'pchip');
         D_95 = interp1(diamX, diamY, 95, 'pchip');
         D_99 = interp1(diamX, diamY, 99, 'pchip');
         D_5phi = -log2(D_5);     
         D_10phi = -log2(D_10);
         D_16phi = -log2(D_16);
         D_25phi = -log2(D_25);
         D_30phi = -log2(D_30);
         D_50phi = -log2(D_50);  
         D_60phi = -log2(D_60);
         D_75phi = -log2(D_75);
         D_84phi = -log2(D_84);
         D_90phi = -log2(D_90);
         D_95phi = -log2(D_95);
         
         statisand.one_percentile_mm = D_99;
         
%          asup = find(diamX>84.13);
%          ainf = find(diamX<84.13);
%          limpcte = [diamX(asup(end)); diamX(ainf(1,1))];
%          limmm = [diamY(asup(end)); diamY(ainf(1,1))];
%          Zgauss = norminv(limpcte./100,0,1);
%          coefst = Zgauss(1)-Zgauss(2);
%          xsd = limmm(1)/limmm(2);
%          stdoc = xsd^(1/coefst);
%          d5084 = limmm(1)*stdoc^Zgauss(1);
%          D8413 = d5084*stdoc^1;
%          bsup = find(diamX>15.87);
%          binf = find(diamX<15.87);
%          limpcteb = [diamX(bsup(end)); diamX(binf(1,1))];
%          limmmb = [diamY(bsup(end)); diamY(binf(1,1))];
%          Zgaussb = norminv(limpcteb./100,0,1);
%          coefstb = Zgaussb(1)+Zgaussb(2);
%          xsdb = limmmb(1)/limmmb(2);
%          stdocb = xsdb^(1/coefstb);
%          d5015 = limmmb(1)*stdocb^Zgaussb(1);
%          D1587 = d5015*stdoc^1;
%          D50t =sqrt(D1587*D8413);
%          Dia = [5 10 16 25 30 50 60 75 84 90 95];
%          stdt = sqrt(D8413/D1587);
%          Zt = norminv((Dia./100),0,1);
%          d = D50t.*stdt.^Zt;
         for k = 1 : r 
            Worksheet_sieve_data2{1,1}(k) = WB(k);
            Worksheet_sieve_data3{1,1}(k) = WB(k);
            Worksheet_sieve_data4{1,1}(k) = WB(k);
         end
         Sum_Col_12 = sum( Worksheet_sieve_data2{1,1} );
         Sum_Col_13 = sum( Worksheet_sieve_data3{1,1} );
         Sum_Col_14 = sum( Worksheet_sieve_data4{1,1} );
         con = 1;
         con2 = 1;
         while con ~= r + 3
            if con ~= r + 1 && con <= r + 1
                if milimeters(con,1) == sieves(con2,1) 
                    con = con + 1;
                else
                    con2 = con2 + 1;
                end
                Worksheet_sieve_data2{1,2} = milimeters;
                Worksheet_sieve_data3{1,2} = milimeters;
                Worksheet_sieve_data4{1,2} = milimeters;
            else
                Worksheet_sieve_data2{1,2}(con) = sieves(con2+1,1);
                Worksheet_sieve_data3{1,2}(con) = sieves(con2+1,1);
                Worksheet_sieve_data4{1,2}(con) = sieves(con2+1,1);
                con = con + 1;
                con2 = con2 + 1;
            end
         end
         Worksheet_sieve_data4{1,2} = -log(Worksheet_sieve_data4{1,2}) / log(2);
         u = 1;
         while u ~= r + 1                                                                                             
              Worksheet_sieve_data2{1,3}(u) = Worksheet_sieve_data2{1,2}(u+1) + Worksheet_sieve_data2{1,2}(u+2);
              Worksheet_sieve_data2{1,4}(u) = ( Worksheet_sieve_data2{1,1}(u) / Sum_Col_12 ) * 100;
              Worksheet_sieve_data2{1,5}(u) = Worksheet_sieve_data2{1,3}(u) * Worksheet_sieve_data2{1,4}(u);
              Worksheet_sieve_data3{1,3}(u) = log(Worksheet_sieve_data3{1,2}(u+1) + Worksheet_sieve_data3{1,2}(u+2) );
              Worksheet_sieve_data3{1,4}(u) = ( Worksheet_sieve_data3{1,1}(u) / Sum_Col_13 ) * 100;
              Worksheet_sieve_data3{1,5}(u) = Worksheet_sieve_data3{1,3}(u) * Worksheet_sieve_data3{1,4}(u);
              Worksheet_sieve_data4{1,3}(u) = Worksheet_sieve_data4{1,2}(u+1) + Worksheet_sieve_data4{1,2}(u+2);
              Worksheet_sieve_data4{1,4}(u) = ( Worksheet_sieve_data4{1,1}(u) / Sum_Col_14 ) * 100;
              Worksheet_sieve_data4{1,5}(u) = Worksheet_sieve_data4{1,3}(u) * Worksheet_sieve_data4{1,4}(u);
              u = u + 1;
         end 
         statisand.Media_Arit_Mom_en_mm = sum(Worksheet_sieve_data2{1,5})/100;   
         statisand.Media_Geom_Mom_en_mm = exp( sum(Worksheet_sieve_data3{1,5})/100 );
         statisand.Media_Log_Mom_en_phi = sum(Worksheet_sieve_data4{1,5})/100;
         z = 1;
         while z ~= r + 1                                                                                             
              Worksheet_sieve_data2{1,6}(z) = ( Worksheet_sieve_data2{1,3}(z) - statisand.Media_Arit_Mom_en_mm )^2 * ...
                                              Worksheet_sieve_data2{1,4}(z);
              Worksheet_sieve_data2{1,7}(z) = ( Worksheet_sieve_data2{1,3}(z) - statisand.Media_Arit_Mom_en_mm )^3 * ...
                                              Worksheet_sieve_data2{1,4}(z);
              Worksheet_sieve_data2{1,8}(z) = ( Worksheet_sieve_data2{1,3}(z) - statisand.Media_Arit_Mom_en_mm )^4 * ...
                                              Worksheet_sieve_data2{1,4}(z);
              Worksheet_sieve_data3{1,6}(z) = ( (Worksheet_sieve_data3{1,3}(z)) - log(statisand.Media_Geom_Mom_en_mm) )^2 * ...
                                              Worksheet_sieve_data3{1,4}(z);
              Worksheet_sieve_data3{1,7}(z) = ( (Worksheet_sieve_data3{1,3}(z)) - log(statisand.Media_Geom_Mom_en_mm) )^3 * ...
                                              Worksheet_sieve_data3{1,4}(z);
              Worksheet_sieve_data3{1,8}(z) = ( (Worksheet_sieve_data3{1,3}(z)) - log(statisand.Media_Geom_Mom_en_mm) )^4 * ...
                                              Worksheet_sieve_data3{1,4}(z); 
              Worksheet_sieve_data4{1,6}(z) = ( Worksheet_sieve_data4{1,3}(z) - statisand.Media_Log_Mom_en_phi )^2 * ...
                                              Worksheet_sieve_data4{1,4}(z);
              Worksheet_sieve_data4{1,7}(z) = ( Worksheet_sieve_data4{1,3}(z) - statisand.Media_Log_Mom_en_phi )^3 * ...
                                              Worksheet_sieve_data4{1,4}(z);
              Worksheet_sieve_data4{1,8}(z) = ( Worksheet_sieve_data4{1,3}(z) - statisand.Media_Log_Mom_en_phi )^4 * ...
                                              Worksheet_sieve_data4{1,4}(z);
              z = z + 1;
         end
        Sum_2Mo = sum( Worksheet_sieve_data2{1,6} );
        Sum_3Mo = sum( Worksheet_sieve_data2{1,7} );
        Sum_4Mo = sum( Worksheet_sieve_data2{1,8} );
        Sum_2Mo2 = sum( Worksheet_sieve_data3{1,6} );
        Sum_3Mo2 = sum( Worksheet_sieve_data3{1,7} );
        Sum_4Mo2 = sum( Worksheet_sieve_data3{1,8} );
        Sum_2Mo3 = sum( Worksheet_sieve_data4{1,6} );
        Sum_3Mo3 = sum( Worksheet_sieve_data4{1,7} );
        Sum_4Mo3 = sum( Worksheet_sieve_data4{1,8} );
		statisand.Media_enesima_raiz_en_mm = sqrt(D_16*D_84);
		statisand.Media_Trask_en_mm = (D_25+D_75)/2;
        statisand.Media_Imnan_en_mm = 2^-((D_16phi+D_84phi)/2);
		statisand.Media_Folk_Ward_en_mm = 2^-((D_16phi + D_50phi + D_84phi)/3);
	    resulchar.Tamano_Medio = num2str(statisand.Media_Folk_Ward_en_mm);
        statisand.Media_Folk_Ward_Geo_en_mm = exp((log(D_16)+log(D_50)+log(D_84))/3);
        Mean_grain_size_mm = statisand.Media_Folk_Ward_en_mm;
        if Mean_grain_size_mm <= 0.075
                    resulchar.Clasif_ASTM = 'Fine Soil';
            elseif Mean_grain_size_mm >= 0.076 && Mean_grain_size_mm < 0.426
                    resulchar.Clasif_ASTM = 'Fine Sand';
            elseif Mean_grain_size_mm >= 0.426 && Mean_grain_size_mm < 2.1
                    resulchar.Clasif_ASTM = 'Medium sand';            
            elseif Mean_grain_size_mm >= 2.1 && Mean_grain_size_mm < 4.76
                    resulchar.Clasif_ASTM = 'Coarse sand';   
            elseif Mean_grain_size_mm >= 4.76 && Mean_grain_size_mm < 19.1
                    resulchar.Clasif_ASTM = 'Fine gravel'; 
            elseif Mean_grain_size_mm >= 19.1 && Mean_grain_size_mm <= 75
                    resulchar.Clasif_ASTM = 'Coarse gravel';
            else
                    resulchar.Clasif_ASTM = 'Out of the range';
        end
        if Mean_grain_size_mm >= 0.0625 && Mean_grain_size_mm < 0.126
                    resulchar.Clasif_Wentworth = 'Very fine sand';
            elseif Mean_grain_size_mm >= 0.126 && Mean_grain_size_mm < 0.251
                    resulchar.Clasif_Wentworth = 'Fine sand';
            elseif Mean_grain_size_mm >= 0.251 && Mean_grain_size_mm < 0.51
                    resulchar.Clasif_Wentworth = 'Medium sand';            
            elseif Mean_grain_size_mm >= 0.51 && Mean_grain_size_mm < 1
                    resulchar.Clasif_Wentworth = 'Coarse sand';   
            elseif Mean_grain_size_mm >= 1 && Mean_grain_size_mm < 2
                    resulchar.Clasif_Wentworth = 'Very coarse sand'; 
            elseif Mean_grain_size_mm >= 2 && Mean_grain_size_mm < 4.77
                    resulchar.Clasif_Wentworth = 'Granule';  
            elseif Mean_grain_size_mm >= 4.77 && Mean_grain_size_mm < 8
                    resulchar.Clasif_Wentworth = 'Small pebble';             
            elseif Mean_grain_size_mm >= 8 && Mean_grain_size_mm < 16
                    resulchar.Clasif_Wentworth = 'Cantos medios'; 
            elseif Mean_grain_size_mm >= 16 && Mean_grain_size_mm <= 19.03
                    resulchar.Clasif_Wentworth = 'Large pebble';
             else
                    resulchar.Clasif_Wentworth = 'Out of the range';
        end
        gravel(r,1) = 0;     
        for i = 1 : r  
            if milimeter(i,1) <= 75 && milimeter(i,1) >= 4.75
                gravel(i,1) = Worksheet_sieve_data{1,2}(i);
            end
        end
        Gravel = sum(gravel(:,1));
        resulchar.Pcte_Grava = num2str(Gravel);
        sand(r,1) = 0;     
        for i = 1 : r  
            if milimeter(i,1) <= 4.74 && milimeter(i,1) >= 0.075
                    sand(i,1) = Worksheet_sieve_data{1,2}(i);
            end
        end
        Sand = sum(sand(:,1));
        resulchar.Pcte_arena = num2str(Sand);
        fine(r,1) = 0;        
        for i = 1 : r  
            if milimeter(i,1) <= 0.074
                    fine(i,1) = Worksheet_sieve_data{1,2}(i);
            end
        end
        Fine = sum(fine(:,1));
        resulchar.Pcte_fino =num2str(Fine);
        Muestrapor = [ Gravel Sand Fine ];
		statisand.SD_Arit_Mom_en_mm = sqrt(Sum_2Mo/100);
        statisand.SD_Geom_Mom_en_mm = exp(sqrt(Sum_2Mo2/100));
        statisand.SD_Log_Mom_en_phi = sqrt(Sum_2Mo3/100);
		statisand.SD_enesima_raiz_en_mm = sqrt(D_84/D_16);
        statisand.SD_Trask_en_mm = sqrt(D_25/D_75);
        statisand.SD_Imnan_en_mm = 2^-((D_84phi-D_16phi)/2);
        statisand.SD_Folk_Ward_en_mm = 2^-(((D_84phi-D_16phi)/4)+((D_95phi-D_5phi)/6.6));
        resulchar.Desviacion_Estandar = num2str(statisand.SD_Folk_Ward_en_mm);
        statisand.SD_Folk_Ward_Geo_en_mm = exp(((log(D_16)-log(D_84))/4)+((log(D_5)-log(D_95))/6.6));
        Standard_Deviation = abs(((D_84phi-D_16phi)/4)+((D_95phi-D_5phi)/6.6));
        if Standard_Deviation < 0.34
                    resulchar.Clasif_SD = 'Very well sorted';
            elseif Standard_Deviation >= 0.35 && Standard_Deviation < 0.50
                    resulchar.Clasif_SD = 'Well sorted';
            elseif Standard_Deviation >= 0.50 && Standard_Deviation < 0.72
                    resulchar.Clasif_SD = 'Moderately well sorted';
            elseif Standard_Deviation >= 0.72 && Standard_Deviation < 1
                    resulchar.Clasif_SD = 'Moderately sorted';
            elseif Standard_Deviation >= 1 && Standard_Deviation < 2
                    resulchar.Clasif_SD = 'Poorly sorted';
            elseif Standard_Deviation >= 2 && Standard_Deviation < 4
                    resulchar.Clasif_SD = 'Very poorly sorted';
            elseif Standard_Deviation >= 4.00 
                    resulchar.Clasif_SD = 'Extremely poorly sorted';
            else
                    resulchar.Clasif_SD = 'Out of the classification';
        end
		statisand.Sesgo_Arit_Mom_adim = Sum_3Mo/(100*(statisand.SD_Arit_Mom_en_mm)^3 );
		statisand.Sesgo_Geom_Mom_adim = Sum_3Mo2/(100*log(statisand.SD_Geom_Mom_en_mm)^3 );
        statisand.Sesgo_Log_Mom_adim = Sum_3Mo3/(100*(statisand.SD_Log_Mom_en_phi)^3 );
		statisand.Sesgo_enesima_raiz_adim = sqrt((D_16*D_84)/(D_75/D_25));
		statisand.Sesgo_Trask_adim = (D_25*D_75)/D_50^2;
        statisand.Sesgo_Imnan_adim = (((D_84phi+D_16phi)-(2*D_50phi))/(D_84phi-D_16phi));
        statisand.Sesgo_Folk_Ward_adim = ((D_16phi+D_84phi-(2*D_50phi))/(2*(D_84phi-D_16phi)))+ ...   
                              ((D_5phi+D_95phi-(2*D_50phi))/(2*(D_95phi-D_5phi)));
        resulchar.Sesgo = num2str(statisand.Sesgo_Folk_Ward_adim);
        statisand.Sesgo_Folk_Ward_Geo_adim = ((log(D_16)+log(D_84)-2*log(D_50))/(2*(log(D_84)-log(D_16))))+ ...
                                              ((log(D_5)+log(D_95)-2*log(D_50))/(2*(log(D_25)-log(D_5))));                  
		Skewness = ((D_16phi+D_84phi-(2*D_50phi))/(2*(D_84phi-D_16phi)))+ ...   
                              ((D_5phi+D_95phi-(2*D_50phi))/(2*(D_95phi-D_5phi)));
        if Skewness < -0.29
                    resulchar.Clasif_Sesgo = 'Very coarse skewed';
            elseif Skewness >= -0.30 && Skewness < -0.1
                    resulchar.Clasif_Sesgo = 'Coarse skewed';
            elseif Skewness >= -0.1 && Skewness < 0.1
                    resulchar.Clasif_Sesgo = 'Near symmetrical';
            elseif Skewness >= 0.1 && Skewness < 0.3
                    resulchar.Clasif_Sesgo = 'Fine skewed';
            elseif Skewness >= 0.3
                    resulchar.Clasif_Sesgo = 'Very fine skewed';
            else
                    resulchar.Clasif_Sesgo = 'Ouf of the classification';
        end
		statisand.Kurtosis_Arit_Mom_adim = Sum_4Mo/(100*(statisand.SD_Arit_Mom_en_mm)^4);
        statisand.Kurtosis_Geom_Mom_adim = Sum_4Mo2/(100*log(statisand.SD_Geom_Mom_en_mm^4));
        statisand.Kurtosis_Log_Mom_adim = Sum_4Mo3/(100*(statisand.SD_Log_Mom_en_phi)^4);
		statisand.Kurtosis_enesima_raiz_adim = sqrt((D_16/D_84)/(D_75/D_25));
		statisand.Kurtosis_Trask_adim =(D_75-D_25)/(2*(D_90-D_10));
        statisand.Kurtosis_Imnan_adim = (((0.5*(D_95phi-D_5phi))-((D_84phi-D_16phi)/2))/(D_84phi-D_16phi)/2);
		statisand.Kurtosis_Folk_Ward_adim = ((D_95phi-D_5phi)/(2.44*(D_75phi-D_25phi)));
        resulchar.Kurtosis = num2str(statisand.Kurtosis_Folk_Ward_adim);
        statisand.Kurtosis_Folk_Ward_Geo_adim = (log(D_5)-log(D_84))/(2.44*(log(D_25)-log(D_75)));
        Kurtosis = ((D_95phi-D_5phi)/(2.44*(D_75phi-D_25phi)));
        if Kurtosis < 0.64
                    resulchar.Clasif_kurtosis = 'Very platykurtic';
            elseif Kurtosis >= 0.65 && Kurtosis < 0.9
                    resulchar.Clasif_kurtosis = 'Platykurtic';
            elseif Kurtosis >= 0.9 && Kurtosis < 1.1
                    resulchar.Clasif_kurtosis = 'Mesokurtic';
            elseif Kurtosis >= 1.1 && Kurtosis < 1.5
                    resulchar.Clasif_kurtosis = 'Leptokurtic (peaked)';
            elseif Kurtosis >= 1.5 && Kurtosis < 3
                    resulchar.Clasif_kurtosis = 'Very leptokuritc';
            elseif Kurtosis >= 3
                    resulchar.Clasif_kurtosis = 'Extremely leptokurtic';
            else
                    resulchar.Clasif_kurtosis = 'Ouf of the classification';
        end
        Cc_Dispersal = D_30 ^ 2 / ( D_10 * D_60 ) ;
        resulchar.CC_adim = num2str(Cc_Dispersal);
        Cu_Hazen_uniformity = D_60 / D_10;
        resulchar.Cu_adim =num2str(Cu_Hazen_uniformity);
        if Cu_Hazen_uniformity >= 6 && ( ( Cc_Dispersal >= 1 ) && ( Cc_Dispersal <= 3 ) )
                    resulchar.Clasif_SUCS = 'SW';
        else
                    resulchar.Clasif_SUCS = 'SP';
        end
        poro = 0.255*(1+0.83^Cu_Hazen_uniformity);
        resulchar.poro =num2str(poro);
        rv = poro/(1-poro);
        resulchar.rv = num2str(rv);
        Tw = 20;
        rhow = (3.1e-8*Tw^3) - (7e-6*Tw^2) + (4.19e-5*Tw) + 0.99985;
        dinvisw = (7e-8*Tw^3) + (1.002e-5*Tw^2) - (5.7e-4*Tw) + 0.0178;
        kivis = dinvisw/rhow;
        K = (980/kivis)*0.083*(poro^3/(1-poro^2))*(D_10*0.1)^2;
        resulchar.K =num2str(K);
        D90dD10 = D_90/D_10;
        resulchar.D90dD10 = num2str(D90dD10);
        D90mD10 = D_90-D_10;
        resulchar.D90mD10 = num2str(D90mD10);
        D75dD25 = D_75/D_25;
        resulchar.D75dD25 = num2str(D75dD25);
        D75mD25 = D_75-D_25;
        resulchar.D75mD25 = num2str(D75mD25);
        resulchar.d_5_en_mm = num2str(D_5);
        resulchar.d_10_en_mm = num2str(D_10);
        resulchar.d_16_en_mm = num2str(D_16);
        resulchar.d_25_en_mm = num2str(D_25); 
        resulchar.d_30_en_mm = num2str(D_30); 
        resulchar.d_50_en_mm = num2str(D_50);
        resulchar.d_60_en_mm = num2str(D_60); 
        resulchar.d_75_en_mm = num2str(D_75); 
        resulchar.d_84_en_mm = num2str(D_84);
        resulchar.d_90_en_mm = num2str(D_90); 
        resulchar.d_95_en_mm = num2str(D_95); 
        med = (D_16phi + D_50phi + D_84phi)/3;
        des = ((D_84phi-D_16phi)/4)+((D_95phi-D_5phi)/6.6);
        ses = statisand.Sesgo_Folk_Ward_adim;
        cur = statisand.Kurtosis_Folk_Ward_adim;
        statisand.Yab = (-3.5688 * med) + (3.7016 * des^2) - (2.0766 * ses) + (3.1135 * cur);
        statisand.Ysa = (15.6534 * med) + (65.7091 * des^2) + (18.1071 * ses) + (18.5043 * cur);
        statisand.Yds = (0.2852 * med) - (8.7604 * des^2) - (4.8932 * ses) + (0.0482 * cur);
        statisand.Yft = (0.7215 * med) + (0.403 * des^2) + (6.7322 * ses) + (5.2927 * cur);
        if statisand.Yab <= -2.7411
            resulchar.Yab_eti = 'Aeolian deposition';
        elseif statisand.Yab > -2.7411
            resulchar.Yab_eti = 'Beach environment';
        end
        if statisand.Ysa <= 65.3650
            resulchar.Ysa_eti = 'Beach deposition';
        elseif statisand.Ysa > 63.3650
            resulchar.Ysa_eti = 'Shallow agitated marine environment';
        end
        if statisand.Yds <= -7.419
            resulchar.Yds_eti = 'Deltaic deposition';
        elseif statisand.Yds > -7.419
            resulchar.Yds_eti = 'Shallow marine deposit';
        end
        if statisand.Yft <= 10
            resulchar.Yft_eti = 'Fluvial environment';
        elseif statisand.Yft > 10
            resulchar.Yft_eti = 'Turbidity environment';
        end
        Acomp = [ 0.3786 0.5864 0.7332 0.8321];
        Bcomp = [ 0.145 0.107 0.075 0.087];
        Patra = Acomp.*D_50.^-(Bcomp);
        statisand.ks = 2.5*D_50;
        statisand.z0 = D_50/12;
        save valoutputSA.mat -struct resulchar;
        save valoutputSAE.mat -struct statisand; 
        filetxt = horzcat('Results_',nombre,'.txt');
        fid = fopen(filetxt,'w');
        fecha = datestr(datevec(now),'dd/mm/yyyy HH:MM:SS');
        fprintf(fid,'              S A N D \r\n');
        fprintf(fid,'             S I E V E  \r\n');
        fprintf(fid,'          A N A L Y S I S \r\n');
        fprintf(fid,'            R E S U L T S \r\n');
        fprintf(fid,'\r\n'); 
        fprintf(fid,' SSSSSSS    AAAAAA    N      N   DDDDDDD     Y       Y \r\n');
        fprintf(fid,'S          A      A   NN     N   D      D     Y     Y \r\n');
        fprintf(fid,'S          A      A   N N    N   D       D     Y   Y \r\n');
        fprintf(fid,' SSSSSS    A      A   N  N   N   D       D      Y Y \r\n');
        fprintf(fid,'       S   AAAAAAAA   N   N  N   D       D       Y \r\n');
        fprintf(fid,'       S   A      A   N    N N   D      D        Y \r\n');
        fprintf(fid,'SSSSSSS    A      A   N     NN   DDDDDDD         Y \r\n');
        fprintf(fid,'\r\n');
        fprintf(fid,'*************************************** \r\n');
        fprintf(fid,'*           Sample                    * \r\n');
        fprintf(fid,'*************************************** \r\n');
        fprintf(fid,'Sample: %30s \r\n',nombre);
        fprintf(fid,'Date: %19s \r\n',fecha);
        fprintf(fid,'_______________________________________ \r\n');
        fprintf(fid,'\r\n');
        fprintf(fid,'*************************************** \r\n');
        fprintf(fid,'* Sieve (mm) Wrete (g)\t  Wrete pcte. * \r\n');
        fprintf(fid,'*************************************** \r\n');
        for conta = 1: length(WB)
           fprintf(fid,'   %4.3f\t %7.3f\t %9.4f\t \r\n',milimeters(conta),WB(conta),tablagranu(conta,3));
        end
        fprintf(fid,'_______________________________________ \r\n');
        fprintf(fid,'\r\n');
        fprintf(fid,'*************************************** \r\n');
        fprintf(fid,'*           Size Distribution         * \r\n');
        fprintf(fid,'*************************************** \r\n');
        fprintf(fid,'       in mm:\t     in phi units: \r\n');
        fprintf(fid,'D5  = %6.3f\t\t %6.3f \r\n',D_5,D_5phi);
        fprintf(fid,'D10 = %6.3f\t\t %6.3f \r\n',D_10,D_10phi);
        fprintf(fid,'D16 = %6.3f\t\t %6.3f \r\n',D_16,D_16phi);
        fprintf(fid,'D25 = %6.3f\t\t %6.3f \r\n',D_25,D_25phi);
        fprintf(fid,'D30 = %6.3f\t\t %6.3f \r\n',D_30,D_30phi);
        fprintf(fid,'D50 = %6.3f\t\t %6.3f \r\n',D_50,D_50phi);
        fprintf(fid,'D60 = %6.3f\t\t %6.3f \r\n',D_60,D_60phi);
        fprintf(fid,'D75 = %6.3f\t\t %6.3f \r\n',D_75,D_75phi);
        fprintf(fid,'D84 = %6.3f\t\t %6.3f \r\n',D_84,D_84phi);
        fprintf(fid,'D90 = %6.3f\t\t %6.3f \r\n',D_90,D_90phi);
        fprintf(fid,'D95 = %6.3f\t\t %6.3f \r\n',D_95,D_95phi);
        fprintf(fid,'\r\n');
        fprintf(fid,'D90/D10 in mm = %7.3f \r\n',D90dD10);
        fprintf(fid,'D90-D10 in mm = %7.3f \r\n',D90mD10);
        fprintf(fid,'D75/D25 in mm = %7.3f \r\n',D75dD25);
        fprintf(fid,'D75-D25 in mm = %7.3f \r\n',D75mD25);
        fprintf(fid,'_______________________________________ \r\n');
        fprintf(fid,'\r\n');
        fprintf(fid,'Material distribution, percent: \r\n');
        fprintf(fid,'   Gravel =\t\t\t %7.3f \r\n',Gravel);
        fprintf(fid,'     Sand =\t\t\t %7.3f \r\n',Sand);
        fprintf(fid,'Very fine =\t\t\t %7.3f \r\n',Fine);
        fprintf(fid,'\r\n');
        fprintf(fid,'Particle classification: \r\n');
        fprintf(fid,'SUCS:      %30s \r\n',resulchar.Clasif_SUCS);
        fprintf(fid,'ASTM:      %30s \r\n',resulchar.Clasif_ASTM);
        fprintf(fid,'Wentworth: %30s \r\n',resulchar.Clasif_Wentworth);
        fprintf(fid,'\r\n');
        fprintf(fid,'*************************************** \r\n');
        fprintf(fid,'*     Sample statistical parameters   * \r\n');
        fprintf(fid,'*************************************** \r\n');
        fprintf(fid,'Method:\t\t\t\t\t Mean (mm)   SD (mm)    Skewness    Kurtosis\r\n'    );
        fprintf(fid,'Arithmetic moments     = %6.3f\t\t %6.3f\t\t %6.3f\t\t %6.3f \r\n',statisand.Media_Arit_Mom_en_mm,statisand.SD_Arit_Mom_en_mm,statisand.Sesgo_Arit_Mom_adim,statisand.Kurtosis_Arit_Mom_adim);
        fprintf(fid,'Geometric moments      = %6.3f\t\t %6.3f\t\t %6.3f\t\t %6.3f \r\n',statisand.Media_Geom_Mom_en_mm,statisand.SD_Geom_Mom_en_mm,statisand.Sesgo_Geom_Mom_adim,statisand.Kurtosis_Geom_Mom_adim);
        fprintf(fid,'N-root                 = %6.3f\t\t %6.3f\t\t %6.3f\t\t %6.3f \r\n',statisand.Media_enesima_raiz_en_mm,statisand.SD_enesima_raiz_en_mm,statisand.Sesgo_enesima_raiz_adim,statisand.Kurtosis_enesima_raiz_adim);
        fprintf(fid,'Trask                  = %6.3f\t\t %6.3f\t\t %6.3f\t\t %6.3f \r\n',statisand.Media_Trask_en_mm,statisand.SD_Trask_en_mm,statisand.Sesgo_Trask_adim,statisand.Kurtosis_Trask_adim);
        fprintf(fid,'Inman                  = %6.3f\t\t %6.3f\t\t %6.3f\t\t %6.3f \r\n',statisand.Media_Imnan_en_mm,statisand.SD_Imnan_en_mm,statisand.Sesgo_Imnan_adim,statisand.Kurtosis_Imnan_adim);
        fprintf(fid,'Log. Folk and Ward     = %6.3f\t\t %6.3f\t\t %6.3f\t\t %6.3f \r\n',statisand.Media_Folk_Ward_en_mm,statisand.SD_Folk_Ward_en_mm,statisand.Sesgo_Folk_Ward_adim,statisand.Kurtosis_Folk_Ward_adim);
        fprintf(fid,'Geom. Folk and Ward    = %6.3f\t\t %6.3f\t\t %6.3f\t\t %6.3f \r\n',statisand.Media_Folk_Ward_Geo_en_mm,statisand.SD_Folk_Ward_Geo_en_mm,statisand.Sesgo_Folk_Ward_Geo_adim,statisand.Kurtosis_Folk_Ward_Geo_adim);
        fprintf(fid,'\t\t\t(phi units) \r\n');
        fprintf(fid,'Logarithmic moments    = %6.3f\t\t %6.3f\t\t %6.3f\t\t %6.3f \r\n',statisand.Media_Log_Mom_en_phi,statisand.SD_Log_Mom_en_phi,statisand.Sesgo_Log_Mom_adim,statisand.Kurtosis_Log_Mom_adim);
        fprintf(fid,'\r\n');
        fprintf(fid,'Geom. Folk and Ward statistical parameters classification\r\n');
        fprintf(fid,'Standard deviation: %40s\t (%6.3f) \r\n',resulchar.Clasif_SD,Standard_Deviation);
        fprintf(fid,'          Skewness: %40s\t (%6.3f) \r\n',resulchar.Clasif_Sesgo,Skewness);
        fprintf(fid,'          Kurtosis: %40s\t (%6.3f) \r\n',resulchar.Clasif_kurtosis,Kurtosis);
        fprintf(fid,'_______________________________________ \r\n');
        fprintf(fid,'\r\n');
        fprintf(fid,'***************************************************** \r\n');
        fprintf(fid,'* Discriminant Function Analysis, adim (Sahu, 1964) * \r\n');
        fprintf(fid,'***************************************************** \r\n');
        fprintf(fid,'\t\t\t\t\t Depositional environment: \r\n');
        fprintf(fid,'Y1 = %7.3f -> %35s \r\n',statisand.Yab,resulchar.Yab_eti);
        fprintf(fid,'Y2 = %7.3f -> %35s \r\n',statisand.Ysa,resulchar.Ysa_eti);
        fprintf(fid,'Y3 = %7.3f -> %35s \r\n',statisand.Yds,resulchar.Yds_eti);
        fprintf(fid,'Y4 = %7.3f -> %35s \r\n',statisand.Yft,resulchar.Yft_eti);
        fprintf(fid,'_____________________________________________________ \r\n');
        fprintf(fid,'\r\n');
        fprintf(fid,'***************************************** \r\n');
        fprintf(fid,'*         Roughness of the bed          * \r\n');
        fprintf(fid,'***************************************** \r\n');
        fprintf(fid,' Nikuradse roughness, in mm = %6.4f \r\n',statisand.ks);
        fprintf(fid,'Bed roughness length, in mm = %7.4f \r\n',statisand.z0);
        fprintf(fid,'_________________________________________ \r\n');
        fprintf(fid,'\r\n');
        fprintf(fid,'***************************************** \r\n');
        fprintf(fid,'* Measures for sediment-water mixtures  * \r\n');
        fprintf(fid,'***************************************** \r\n');
        fprintf(fid,'Porosity, adim (Vukovic and Soro, 1992) = %6.4f \r\n',poro);
        fprintf(fid,'Voids ratio, adim = %6.4f \r\n',rv);
        fprintf(fid,'_________________________________________ \r\n');
        fprintf(fid,'\r\n');
        fprintf(fid,'************************************ \r\n');
        fprintf(fid,'* Permeability (Carrier III, 2003) * \r\n');
        fprintf(fid,'************************************ \r\n');
        fprintf(fid,'Hazen uniformity coefficient, adim =  %5.3f \r\n',Cu_Hazen_uniformity);
        fprintf(fid,'    Coefficient of curvature, adim =  %5.3f \r\n',Cc_Dispersal);
        fprintf(fid,'Hydraulic conductivity or permeability, in cm/s = %7.3f \r\n',K');
        fprintf(fid,'____________________________________ \r\n');
        fprintf(fid,'\r\n');
        fprintf(fid,'******************************************************************************* \r\n');
        fprintf(fid,'* Relative Density at max. dry unit weight of compaction (Patra et al., 2011) * \r\n');
        fprintf(fid,'******************************************************************************* \r\n');
        fprintf(fid,'Reduce Standard Proctor (E = 360 kN-m/m3) = %7.3f\r\n',Patra(1));
        fprintf(fid,'       Standard Proctor (E = 600 kN-m/m3) = %7.3f\r\n',Patra(2));
        fprintf(fid,'Reduce Modified Proctor (E = 1300 kN-m/m3) = %6.3f\r\n',Patra(3));
        fprintf(fid,'       Modified Proctor (E = 2700 kN-m/m3) = %6.3f\r\n',Patra(4));
        fprintf(fid,'_______________________________________________________________________________ \r\n');
        fprintf(fid,'\r\n');
        fprintf(fid,'\r\n');
        fprintf(fid,'SANDY, copyright, 2010.');
        fclose(fid);
        %uni_can(nombre,fecha,perce)
else
    fprintf('It is found a problem with the input file... \n');
    fprintf('Check the data columns or maybe the file \n');
    fprintf('is empty or the file has more than 2 columns, etc. \n');
end
figure(3);
figsize = [676 500];
xs = ceil((screen(3)-figsize(1))/2);
ys = ceil((screen(4)-figsize(2))/2);
set(figure(3),'MenuBar','none',...
                'Units','Pixels',...
                'NumberTitle','Off',...
                'Resize','off',...
                'Name','1.Sandy. - Histogram',...
                'Color' , [1 1 1],...
                'Position',[xs ys figsize(1) figsize(2)]);    
histo_h =bar(milimeter,Worksheet_sieve_data{1,2}, 'group');
hold on;
plot(milimeter, Worksheet_sieve_data{1,2},'-','Color',[0.15 0.23 0.37],...
    'Linewidth',2.5);
colormap hsv;
xlabel('Grain size (in mm)','Fontsize' , 10, 'FontWeight','bold'); 
ylabel('Percent finer by weight (%)','Fontsize' , 10, 'FontWeight','bold');
set(histo_h,'FaceColor', [0.23 0.44 0.34]);
set(gca,'XLim', [min(milimeter) max(milimeter)],...
                'Xgrid','on',...
                'Ygrid' ,'on',...
                'Xcolor',[0 0 0.37],...
                'Ycolor',[0 0 0.37],...
                'Box','off' ,...
                'FontWeight','bold',...
                'FontSize', 10,...
                'FontAngle','Oblique',...
                'XMinorTick','on',...
                'YMinorTick','on');
LinkTopAxisData(get(gca,'XTick'),-log2(get(gca,'XTick')));
nameg1 = horzcat('Bar_',nombre,'.emf');
saveas(gcf,nameg1);         
figure(5);
figsize = [676 500];
xs = ceil((screen(3)-figsize(1))/2);
ys = ceil((screen(4)-figsize(2))/2);
set(figure(5),'Units','Pixels',...
                'NumberTitle','Off',...
                'Resize','off',...
                'Color',[1 1 1],...
                'Position',[xs ys figsize(1) figsize(2)],...
                'MenuBar','none',...
                'name','2.Sandy. - Cumulative Arithmetic Curve');  
plot(milimeter, Worksheet_sieve_data{1,3},'-','Color',[0 0.5 0],'Linewidth' , 2.5);
xlabel('Grain size (in mm)','Fontsize' , 10, 'FontWeight','bold'); 
ylabel('Percent finer by weight (%)','Fontsize' , 10, 'FontWeight','bold');
set(gca,'XLim', [min(milimeter) max(milimeter)],'YLim',[0 100],...
                'Xgrid','on',...
                'Ygrid','on',...
                'Xcolor',[0 0 0.37],...
                'Ycolor',[0 0 0.37],...
                'Box','off',...
                'FontWeight','bold',...
                'FontSize',10,...
                'FontAngle','Oblique',...
                'XMinorTick','on',...
                'YMinorTick','on');
LinkTopAxisData(get(gca,'XTick'),-log2(get(gca,'XTick')));            
nameg3 = horzcat('Cumulative_Arithmetic_',nombre,'.emf');
saveas(gcf,nameg3);     
figure(6);
figsize = [676 500];
xs = ceil((screen(3)-figsize(1))/2);
ys = ceil((screen(4)-figsize(2))/2);
set(figure(6),'Units','Pixels',...
                'NumberTitle','Off',...
                'Resize','off',...
                'Color',[1 1 1],...
                'Position',[xs ys figsize(1) figsize(2)],...
                'MenuBar','none',...
                'name','3.Sandy. - Cumulative Probability Arithmetic Curve');   
plot(milimeter, Worksheet_sieve_data{1,4},'-','Color',[1 0.5 0],'Linewidth',2.5);
xlabel('Grain size (in mm)','Fontsize' , 10, 'FontWeight','bold'); 
ylabel('Percent finer by weight (%)','Fontsize' , 10, 'FontWeight','bold');
set(gca,'XLim', [min(milimeter) max(milimeter)],'YLim',[0 100],...
                'Xgrid','on',...
                'Ygrid','on',...
                'Xcolor',[0 0 0.37],...
                'Ycolor',[0 0 0.37],...
                'Box','off',...
                'FontWeight','bold',...
                'FontSize',10,...
                'FontAngle','Oblique',...
                'XMinorTick','on',...
                'YMinorTick','on');
LinkTopAxisData(get(gca,'XTick'),-log2(get(gca,'XTick'))); 
nameg4 = horzcat('Cumulative_Probability_',nombre,'.emf');
saveas(gcf,nameg4);
figure(7);
figsize = [676 500];
xs = ceil((screen(3)-figsize(1))/2);
ys = ceil((screen(4)-figsize(2))/2);
set(figure(7),'Units','Pixels',...
                 'NumberTitle','Off',...
                 'Resize','off',...
                 'Color',[1 1 1],...
                 'Position',[xs ys figsize(1) figsize(2)],...
                 'MenuBar','none',... 
                 'name','4.Sandy. - Cumulative Probability Semi-Log Curve'); 
semilogx(milimeter, Worksheet_sieve_data{1,4},...
                 '-o',...
                 'Color',[0 0 0.5],...
                 'Linewidth',2.5,'MarkerFaceColor',[0 0 0.5],...
                 'MarkerSize',2, ...
                 'MarkerEdgeColor',[ 0 0.5 0.5]);
axis tight;
xlabel('Grain size (in mm)','Fontsize' , 10, 'FontWeight','bold'); 
ylabel('Percent finer by weight (%)','Fontsize' , 10, 'FontWeight','bold');
set(gca,'Xgrid','on',...
                  'Ygrid','on',...
                  'Xcolor',[0 0 0.37],...
                  'Ycolor',[0 0 0.37],...
                  'Box','off',...
                  'XDir','normal', ...
                  'FontWeight','bold',...
                  'FontSize',10,...
                  'FontAngle','Oblique',...
                  'XMinorTick','on',...
                  'YMinorTick','on', ...
                  'Xlim',[0.01 10],...
                  'XTickLabel',{'0.01';'0.1';'1';'10'}) ; 
dimark = [0.074 4.76];
hold on;
escalY = get(gca,'YLim');
escalY = [ 0 escalY(1,2) ];
lenmark = length(dimark);
xmark = reshape([dimark;dimark;ones(1,lenmark)*nan;],lenmark*3,1);
ymark = repmat([escalY nan],1,lenmark);
plot(xmark,ymark, 'r', 'LineWidth', 2 , 'LineSmoothing','on'); 
tfinos = text(0.011,95,'Fine'); 
        set(tfinos,...
                 'FontSize',8,...
                 'FontWeight','bold');
tsand = text(0.085,95,'Sand'); 
set(tsand,'FontSize',8,...
                  'FontWeight','bold');
tgrav = text(5,95,'Gravel'); 
set(tgrav,...
                  'FontSize',8,...
                  'FontWeight','bold');
LinkTopAxisData([0.01 0.1 1 10],-log2([0.01 0.1 1 10]));
nameg5 = horzcat('Semilog_Cumulative_Probability_',nombre,'.emf');
saveas(gcf,nameg5);                
figure(8);
figsize = [676 500];
xs = ceil((screen(3)-figsize(1))/2);
ys = ceil((screen(4)-figsize(2))/2);
set(figure(8),'Units','Pixels',...
                'NumberTitle','Off',...
                'Resize','off',...
                'Color',[1 1 1],...
                'Position',[xs ys figsize(1) figsize(2)],...
                'MenuBar','none',... 
                'name','5.Sandy. - Cumulative Probability Logarithmic');   
loglog(milimeter, Worksheet_sieve_data{1,4},'-','Color',[0.5 0 0.5],'Linewidth',2.5);
xlabel('Grain size (in mm)','Fontsize' , 10, 'FontWeight','bold'); 
ylabel('Percent finer by weight (%)','Fontsize' , 10, 'FontWeight','bold');
set(gca,'XLim', [min(milimeter) max(milimeter)],'YLim',[0 100],...
                'Xgrid','on',...
                'Ygrid','on',...
                'Xcolor',[0 0 0.37],...
                'Ycolor',[0 0 0.37],...
                'Box','off',...
                'FontWeight','bold',...
                'FontSize',10,...
                'FontAngle','Oblique',...
                'XMinorTick','on',...
                'YMinorTick','on');
LinkTopAxisData(get(gca,'XTick'),-log2(get(gca,'XTick')));
clc;
nameg6 = horzcat('Cumulative Probability_',nombre,'.emf');
saveas(gcf,nameg6); 
figure(9);
figsize = [676 500];
xs = ceil((screen(3)-figsize(1))/2);
ys = ceil((screen(4)-figsize(2))/2);
set(figure(9),'Units','Pixels',...
                'NumberTitle','Off',...
                'Resize','off',...
                'Color',[1 1 1],...
                'Position',[xs ys figsize(1) figsize(2)],...
                'MenuBar','none',... 
                'name','6.Sandy. - Percentage of sand');
xtiname = {'Gravel' 'Sand' 'Fine'};
bcolor{1} = [0.9 0.1 0.14];
bcolor{2} = [0.2 0.71 0.3];
bcolor{3} = [0.25 0.55 0.79];
for bi = 1:3
    hdlleg(bi) = bar(bi,Muestrapor(bi));
    set(hdlleg(bi),'FaceColor',bcolor{bi});
    txbar = sprintf(horzcat('%5.3f ','%'),Muestrapor(bi));
    txbarh = text(bi,Muestrapor(bi)+3,txbar);
    set(txbarh,'FontSize',8);
    hold on;
end   
ylim([0 max(Muestrapor)+5]);
set(gca,'xTickLabel',[],...
                'Xcolor',[0 0 0],...
                'Ycolor',[0 0 0],...
                'FontWeight','bold',...
                'FontSize',10,...
                'FontAngle','Oblique',...
                'XMinorTick','on',...
                'YMinorTick','on');
lege = legend(xtiname);
set(lege,'box','on',...
         'Orientation','horizontal',...
         'location','southoutside');
ylabel('% of sediment'); 
xlabel('Sediment');
nameg6 = horzcat('Sediment_pcte_',nombre,'.emf');
saveas(gcf,nameg6);
Arena = Muestrapor(1,2);
Arcilla = Muestrapor(1,3);
Limo = 0;
Folk_S_Classification(Arena,Arcilla,Limo,screen);
nameg7 = horzcat('T_AAL_',nombre,'.emf');
saveas(gcf,nameg7);
Arena2 = Muestrapor(1,2);
Arcilla2 = Muestrapor(1,3);
Limo2 = 0;
Shepard(Arena2,Arcilla2,Limo2,screen);
nameg8 = horzcat('T_AAL2_',nombre,'.emf');
saveas(gcf,nameg8);               
clc;
delete('valoutputSA.mat', 'valoutputSAE.mat');
end

function Folk_S_Classification(Sand,Silt,Clay,screen)
% This script is a modification of the TERNPLOT 
% script by Carl Sandrock (20020827),
% and the 'Schlee.m' written by Matt Arsenault..
%         Sand
%         / \
%        /   \
%     Clay--- Silt
%
% Modified by: Matt Arsenault 20060222
[g_left(1), g_left(2)] = frac2xy(.10,.90); 
[g_right(1), g_right(2)] = frac2xy(0,.90);
[g_cent(1), g_cent(2)] = frac2xy(.06,.90);
[g_frac(1),g_frac(2)] = frac2xy(.03,.90);
[g_leftthirty(1),g_leftthirty(2)] = frac2xy(.5,.5);
[g_rightthirty(1),g_rightthirty(2)] = frac2xy(0,.5);
[g_leftfive(1), g_leftfive(2)] = frac2xy(.90,.10);
[g_rightfive(1), g_rightfive(2)] = frac2xy(0,.10);
[mud_onetone(1), mud_onetone(2)] = frac2xy(.66,.0);
[mud_ninetone(1), mud_ninetone(2)] = frac2xy(.33,.0);
A = Clay;
B = Silt;
C = Sand;
xoffset = 0.04;
yoffset = 0.02;
majors = 4;
Total = (A+B+C);
fA = A./Total;
fB = B./Total;
fC = 1-(fA+fB);
y = fC*sin(((2*pi)/360)*60);
x = 1 - fA - y*cot(((2*pi)/360)*60);
[x, i] = sort(x);
y = y(i);
fol = figure;
cax = newplot;
next = lower(get(cax,'NextPlot'));
hold_state = ishold;
tc = get(cax,'xcolor');
ls = get(cax,'gridlinestyle');
fAngle  = get(cax, 'DefaultTextFontAngle');
fName   = get(cax, 'DefaultTextFontName');
fSize   = get(cax, 'DefaultTextFontSize');
fWeight = get(cax, 'DefaultTextFontWeight');
fUnits  = get(cax, 'DefaultTextUnits');
set(cax, 'DefaultTextFontAngle',  get(cax, 'FontAngle'), ...
    'DefaultTextFontName',   get(cax, 'FontName'), ...
    'DefaultTextFontSize',   get(cax, 'FontSize'), ...
    'DefaultTextFontWeight', get(cax, 'FontWeight'), ...
    'DefaultTextUnits','data')
if ~hold_state
	hold on;
    plot ([0 1 0.5 0],[0 0 sin(1/3*pi) 0], 'color', 'k', 'linewidth',1,...
                   'handlevisibility','off');
	set(gca, 'visible', 'off');
    if ~isstr(get(cax,'color')),
       patch('xdata', [0 1 0.5 0], 'ydata', [0 0 sin(1/3*pi) 0], ...
             'edgecolor',tc,'facecolor',get(gca,'color'),...
             'handlevisibility','off');
    end
    majorticks = linspace(0, 1, majors + 1);
    majorticks = majorticks(3);
	labels = num2str(majorticks'*100);
	
	zerocomp = zeros(1, length(majorticks));

	[lxa, lya] = frac2xy(majorticks, 1-majorticks);
	text(lxa-xoffset, lya, labels,'FontSize',7,'FontName','Helvetica');
end;
set(cax, 'DefaultTextFontAngle', fAngle , ...
    'DefaultTextFontName',   fName , ...
    'DefaultTextFontSize',   fSize, ...
    'DefaultTextFontWeight', fWeight, ...
    'DefaultTextUnits',fUnits );
plot([g_left(1) g_right(1)],[g_left(2) g_right(2)], 'color', 'k', 'linewidth',1,'handlevisibility','off');
plot([g_leftthirty(1) g_rightthirty(1)],[g_leftthirty(2) g_rightthirty(2)], 'color', 'k', 'linewidth',1,...
                   'handlevisibility','off');
plot([g_leftfive(1) g_rightfive(1)],[g_leftfive(2) g_rightfive(2)], 'color', 'k', 'linewidth',1,...
                   'handlevisibility','off');
plot([mud_onetone(1) g_cent(1)],[mud_onetone(2) g_cent(2)], 'color', 'k', 'linewidth',1,...
                   'handlevisibility','off');
plot([g_frac(1) mud_ninetone(1)],[g_frac(2) mud_ninetone(2)], 'color', 'k', 'linewidth',1,...
                   'handlevisibility','off');
sandlocation = [0.168581 0.481926 12.052];
sandlabel = text(sandlocation(1), sandlocation(2), 'Percent of Sand (%)');
set(sandlabel,'FontName','Helvica','FontSize',10,'FontWeight','bold','Rotation',60,'HorizontalAlignment','center');
siltlocation = [0.506579 -0.0776316 12.052];
siltlabel = text(siltlocation(1), siltlocation(2), 'Clay : Silt Ratio');
set(siltlabel,'FontName','Helvica','FontSize',10,'FontWeight','bold','HorizontalAlignment','center');
twooneratiolocation = [0.33 -0.025 12.052];
twooneratiolabel = text(twooneratiolocation(1), twooneratiolocation(2), '2:1');
set(twooneratiolabel,'FontName','Helvica','FontSize',10,'FontWeight','bold','HorizontalAlignment','center');
onetworatiolocation = [0.66 -0.025 12.052];
onetworatiolabel = text(onetworatiolocation(1), onetworatiolocation(2), '1:2');
set(onetworatiolabel,'FontName','Helvica','FontSize',10,'FontWeight','bold','HorizontalAlignment','center');
claylocation = [0.832 0.481926 12.052];
claylabel = text(claylocation(1), claylocation(2), '');
set(claylabel,'FontName','Helvica','FontSize',10,'Rotation',-60,'FontWeight','bold','HorizontalAlignment','center');
apex_clay_location = [0.056579 -0.0376316 12.052];
apex_clay_label = text(apex_clay_location(1), apex_clay_location(2), 'Clay');
set(apex_clay_label,'FontName','Helvica','FontSize',10,'FontWeight','bold','HorizontalAlignment','center');
apex_silt_location = [0.945 -0.0376316 12.052];
apex_silt_label = text(apex_silt_location(1), apex_silt_location(2), 'Silt');
set(apex_silt_label,'FontName','Helvica','FontSize',10,'FontWeight','bold','HorizontalAlignment','center');
apex_sand_location = [0.508581 0.901926 12.052];
apex_sand_label = text(apex_sand_location(1), apex_sand_location(2), 'Sand');
set(apex_sand_label,'FontName','Helvica','FontSize',10,'FontWeight','bold','HorizontalAlignment','center');
sandonlylocation = [.5 .81];
sandonly = text(sandonlylocation(1), sandonlylocation(2),'S');
set(sandonly,'FontName','Helvica','FontSize',10,'FontWeight','bold','HorizontalAlignment','center');
sandyclaylocation = [.35 .5];
sactext(1) = {'A'};
sandyclay = text(sandyclaylocation(1),sandyclaylocation(2),sactext);
set(sandyclay,'FontName','Helvica','FontSize',10,'FontWeight','bold','HorizontalAlignment','center');
muddysandlocation = [.5 sandyclaylocation(2)];
mstext(1) = {'mS'};
muddysand = text(muddysandlocation(1), muddysandlocation(2),mstext);
set(muddysand,'FontName','Helvica','FontSize',10,'FontWeight','bold','HorizontalAlignment','center');
zslocation = [.65 sandyclaylocation(2)];
sctext(1) = {'zS'};
zs = text(zslocation(1), zslocation(2),sctext);
set(zs,'FontName','Helvica','FontSize',10,'FontWeight','bold','HorizontalAlignment','center');
sandyclaylocation = [.25 .25];
scatext(1) = {'sC'};
sandyclay = text(sandyclaylocation(1), sandyclaylocation(2), scatext);
set(sandyclay,'FontName','Helvica','FontSize',10,'FontWeight','bold','HorizontalAlignment','center');
clayeysiltlocation = [.75 sandyclaylocation(2)];
cstext(1) = {'sZ'};
clayeysilt = text(clayeysiltlocation(1), clayeysiltlocation(2), cstext);
set(clayeysilt,'FontName','Helvica','FontSize',10,'FontWeight','bold','HorizontalAlignment','center');
muddysandtext(5) = {'sM'};
muddysand = text(.5, .28, muddysandtext);
set(muddysand,'FontName','Helvica','FontSize',10,'FontWeight','bold','HorizontalAlignment','center');
clayonlylocation = [.18 .04];
clayonly = text(clayonlylocation(1),clayonlylocation(2),'C');
set(clayonly,'FontName','Helvica','FontSize',10,'FontWeight','bold','HorizontalAlignment','center');
siltysandlocation = [.5 .08];
ssatext(2) = {'M'};
siltysand = text(siltysandlocation(1), siltysandlocation(2),ssatext);
set(siltysand,'FontName','Helvica','FontSize',10,'FontWeight','bold','HorizontalAlignment','center');
siltonlylocation = [.84 .04];
siltonly = text(siltonlylocation(1),siltonlylocation(2),'Z');
set(siltonly,'FontName','Helvica','FontSize',10,'FontWeight','bold','HorizontalAlignment','center');
q = plot(x, y,'o','MarkerEdgeColor','b',...
                   'MarkerFaceColor','b');
if nargout > 0
    hpol = q;
end
if ~hold_state
    set(gca,'dataaspectratio',[1 1 1]), axis off; set(cax,'NextPlot',next);
end
figsize = [676 500];
xs = ceil((screen(3)-figsize(1))/2);
ys = ceil((screen(4)-figsize(2))/2);
set(fol, 'Units','Pixels',...
                'NumberTitle','Off',...
                'Resize','off',...
                'Color',[1 1 1],...
                'Position',[xs ys figsize(1) figsize(2)],...
                'MenuBar','none',...
                'name','7.Sandy. - Ternary Diagram');
end

function Shepard(Sand,Silt,Clay,screen)
% Author: Carl Sandrock 20020827
[c_sac(1), c_sac(2)] = frac2xy(.25,.75);
[c_sc(1), c_sc(2)] = frac2xy(0,.75);
[sa_csa(1), sa_csa(2)] = frac2xy(.75,.25);
[sa_ssa(1), sa_ssa(2)] = frac2xy(.75,0);
[s_cs(1), s_cs(2)] = frac2xy(0,.25);
[s_sas(1), s_sas(2)] = frac2xy(.25,0);
[c(1), c(2)] = frac2xy(.125,.75);
[sa(1), sa(2)] = frac2xy(.75, .125);
[s(1), s(2)] = frac2xy(.125,.125);
[sasc_c(1), sasc_c(2)] = frac2xy(.2,.6);
[sasc_csa(1), sasc_csa(2)] = frac2xy(.4,.4);
[sasc_sa(1), sasc_sa(2)] = frac2xy(.6,.2);
[sasc_sas(1),sasc_sas(2)] = frac2xy(.4,.2);
[sasc_s(1), sasc_s(2)] = frac2xy(.2,.2);
[sasc_cs(1), sasc_cs(2)] = frac2xy(.2,.4);
[sac_csa(1),sac_csa(2)] = frac2xy(.5,.5);
[ssa_sas(1),ssa_sas(2)] = frac2xy(.5,0);
[cs_sc(1),cs_sc(2)] = frac2xy(0,.5);
A = Sand;
B = Silt;
C = Clay;
xoffset = 0.04;
yoffset = 0.02;
majors = 4;
Total = (A+B+C);
fA = A./Total;
fB = B./Total;
fC = 1-(fA+fB);
radia = ((2*pi)/360)*60;
y = fC*sin(radia);
x = 1 - fA - y*cot(radia);
[x, i] = sort(x);
y = y(i);
shep = figure;
cax = newplot;
next = lower(get(cax,'NextPlot'));
hold_state = ishold;
tc = get(cax,'xcolor');
ls = get(cax,'gridlinestyle');
fAngle  = get(cax, 'DefaultTextFontAngle');
fName   = get(cax, 'DefaultTextFontName');
fSize   = get(cax, 'DefaultTextFontSize');
fWeight = get(cax, 'DefaultTextFontWeight');
fUnits  = get(cax, 'DefaultTextUnits');
set(cax, 'DefaultTextFontAngle',  get(cax, 'FontAngle'), ...
    'DefaultTextFontName',   get(cax, 'FontName'), ...
    'DefaultTextFontSize',   get(cax, 'FontSize'), ...
    'DefaultTextFontWeight', get(cax, 'FontWeight'), ...
    'DefaultTextUnits','data')
if ~hold_state
	hold on;
    plot ([0 1 0.5 0],[0 0 sin(1/3*pi) 0], 'color', 'k', 'linewidth',1,...
                   'handlevisibility','off');
	set(gca, 'visible', 'off');
    if ~isstr(get(cax,'color')),
       patch('xdata', [0 1 0.5 0], 'ydata', [0 0 sin(1/3*pi) 0], ...
             'edgecolor','k','facecolor',get(gca,'color'),...
             'handlevisibility','off');
    end
	majorticks = linspace(0, 1, majors + 1);
	majorticks = majorticks(2:end-1);
	labels = num2str(majorticks'*100);
	
	zerocomp = zeros(1, length(majorticks));
	[lxc, lyc] = frac2xy(zerocomp, majorticks);
	text(lxc, lyc, [repmat('  ', length(labels), 1) labels],'FontSize',7,'FontName','Helvetica','FontWeight','bold');
	[lxb, lyb] = frac2xy(1-majorticks, zerocomp); % fA = 1-fB
	text(lxb, lyb, labels, 'VerticalAlignment', 'Top','FontSize',7,'FontName','Helvetica','FontWeight','bold');
	[lxa, lya] = frac2xy(majorticks, 1-majorticks);
	text(lxa-xoffset, lya, labels,'FontSize',7,'FontName','Helvetica','FontWeight','bold');
end;
set(cax, 'DefaultTextFontAngle', fAngle , ...
    'DefaultTextFontName',   fName , ...
    'DefaultTextFontSize',   fSize, ...
    'DefaultTextFontWeight', fWeight, ...
    'DefaultTextUnits',fUnits );
plot([c_sac(1) c_sc(1)],[c_sac(2) c_sc(2)], 'color', 'k', 'linewidth',1,...
                   'handlevisibility','off');
plot([sa_csa(1) sa_ssa(1)],[sa_csa(2) sa_ssa(2)], 'color', 'k', 'linewidth',1,...
                   'handlevisibility','off');
plot([s_sas(1) s_cs(1)],[s_sas(2) s_cs(2)], 'color', 'k', 'linewidth',1,...
                   'handlevisibility','off');
plot([sasc_c(1) c(1)],[sasc_c(2) c(2)], 'color', 'k', 'linewidth',1,...
                   'handlevisibility','off');
plot([sac_csa(1) sasc_csa(1)],[sac_csa(2) sasc_csa(2)], 'color', 'k', 'linewidth',1,...
                   'handlevisibility','off');
plot([sasc_sa(1) sa(1)],[sasc_sa(2) sa(2)], 'color', 'k', 'linewidth',1,...
                   'handlevisibility','off');
plot([ssa_sas(1) sasc_sas(1)],[ssa_sas(2) sasc_sas(2)], 'color', 'k', 'linewidth',1,...
                   'handlevisibility','off');
plot([sasc_s(1) s(1)],[sasc_s(2) s(2)], 'color', 'k', 'linewidth',1,...
                   'handlevisibility','off');
plot([cs_sc(1) sasc_cs(1)],[cs_sc(2) sasc_cs(2)], 'color', 'k', 'linewidth',1,...
                   'handlevisibility','off');
plot([sasc_c(1) sasc_sa(1)],[sasc_c(2) sasc_sa(2)], 'color', 'k', 'linewidth',1,...
                   'handlevisibility','off');
plot([sasc_sa(1) sasc_s(1)],[sasc_sa(2) sasc_s(2)], 'color', 'k', 'linewidth',1,...
                   'handlevisibility','off');
plot([sasc_s(1) sasc_c(1)],[sasc_s(2) sasc_c(2)], 'color', 'k', 'linewidth',1,...
                   'handlevisibility','off');
sandlocation = [0.168581 0.481926 12.052];
sandlabel = text(sandlocation(1), sandlocation(2), 'Sand Content (%)');
set(sandlabel,'FontName','Helvica','FontSize',12,'FontWeight','bold','Rotation',60,'HorizontalAlignment','center');
siltlocation = [0.506579 -0.0776316 12.052];
siltlabel = text(siltlocation(1), siltlocation(2), 'Silt Content (%)');
set(siltlabel,'FontName','Helvica','FontSize',12,'FontWeight','bold','HorizontalAlignment','center');
claylocation = [0.832 0.481926 12.052];
claylabel = text(claylocation(1), claylocation(2), 'Clay content(%)');
set(claylabel,'FontName','Helvica','FontSize',12,'FontWeight','bold','Rotation',-60,'HorizontalAlignment','center');
clayonlylocation = [.5 .73];
clayonly = text(clayonlylocation(1), clayonlylocation(2),'Clay');
set(clayonly,'FontName','Helvica','FontSize',8,'FontWeight','bold','HorizontalAlignment','center');
sandyclaylocation = [.4 .5];
sactext(1) = {'Sandy'};
sactext(2) = {'Clay'};
sandyclay = text(sandyclaylocation(1),sandyclaylocation(2),sactext);
set(sandyclay,'FontName','Helvica','FontSize',8,'FontWeight','bold','HorizontalAlignment','center');
siltyclaylocation = [.6 sandyclaylocation(2)];
sctext(1) = {'Silty'};
sctext(2) = {'Clay'};
siltyclay = text(siltyclaylocation(1), siltyclaylocation(2),sctext);
set(siltyclay,'FontName','Helvica','FontSize',8,'FontWeight','bold','HorizontalAlignment','center');
clayeysandlocation = [.25 .25];
csatext(1) = {'Clayey'};
csatext(2) = {'Sand'};
clayeysand = text(clayeysandlocation(1), clayeysandlocation(2), csatext);
set(clayeysand,'FontName','Helvica','FontSize',8,'FontWeight','bold','HorizontalAlignment','center');
clayeysiltlocation = [.75 clayeysandlocation(2)];
cstext(1) = {'Clavey'};
cstext(2) = {'Silt'};
clayeysilt = text(clayeysiltlocation(1), clayeysiltlocation(2), cstext);
set(clayeysilt,'FontName','Helvica','FontSize',8,'FontWeight','bold','HorizontalAlignment','center');
homogenouslocation = [clayonlylocation(1) .3];
homtext(1) = {'Sand'};
homtext(2) = {'+'};
homtext(3) = {'Silt'};
homtext(4) = {'+'};
homtext(5) = {'Clay'};
homogeneous = text(homogenouslocation(1), homogenouslocation(2), homtext);
set(homogeneous,'FontName','Helvica','FontSize',8,'FontWeight','bold','HorizontalAlignment','center');
sandonlylocation = [.12 .08];
sandonly = text(sandonlylocation(1),sandonlylocation(2),'Sand');
set(sandonly,'FontName','Helvica','FontSize',8,'FontWeight','bold','HorizontalAlignment','center');
siltysandlocation = [sandyclaylocation(1), sandonlylocation(2)];
ssatext(1) = {'Silty'};
ssatext(2) = {'Sand'};
siltysand = text(siltysandlocation(1), siltysandlocation(2),ssatext);
set(siltysand,'FontName','Helvica','FontSize',8,'FontWeight','bold','HorizontalAlignment','center');
sandysiltlocation = [siltyclaylocation(1), sandonlylocation(2)];
sastext(1) = {'Sandy'};
sastext(2) = {'Silt'};
sandysilt = text(sandysiltlocation(1), sandysiltlocation(2),sastext);
set(sandysilt,'FontName','Helvica','FontSize',8,'FontWeight','bold','HorizontalAlignment','center');
siltonlylocation = [.88 sandonlylocation(2)];
siltonly = text(siltonlylocation(1),siltonlylocation(2),'Silt');
set(siltonly,'FontName','Helvica','FontSize',8,'FontWeight','bold','HorizontalAlignment','center');
q = plot(x, y,'o','MarkerEdgeColor','b',...
                   'MarkerFaceColor','b',...
                   'MarkerSize',8);
if nargout > 0
    hpol = q;
end
if ~hold_state
    set(gca,'dataaspectratio',[1 1 1]), axis off; set(cax,'NextPlot',next);
end
figsize = [676 500];
xs = ceil((screen(3)-figsize(1))/2);
ys = ceil((screen(4)-figsize(2))/2);
      set(shep, 'Units','Pixels',...
                'NumberTitle','Off',...
                'Resize','off',...
                'Color',[1 1 1],...
                'Position',[xs ys figsize(1) figsize(2)],...
                'MenuBar','none',...
                'name','8.Sandy. - Ternary Diagram (2)');
end

function [x, y] = frac2xy(fA, fC)
y = fC*sin(radians(60));
x = 1 - fA - y*cot(radians(60));
end

function radians = radians(degrees)
radians = ((2*pi)/360)*degrees;
end

function [newAxis] = LinkTopAxisData (TopTickPositions,TopTickLabels)
% Tim Richards.
% http://www.mathworks.com/matlabcentral/fileexchange/12131-linktopaxisdata
temp=[TopTickPositions(:), TopTickLabels(:)]; 
temp=real(temp);
temp = sortrows(temp); 
temp(diff(temp(:,1))==0,:) = []; 
oldAxis=gca;
set(get(oldAxis,'Title'),'Units','Normalized','Position',[0.5 1.05 0]);
newAxis = axes('position', get(oldAxis, 'position'));
set(newAxis,'xaxisLocation','top',...
            'Color',get(oldAxis,'Color'));
set(oldAxis,'xaxislocation','bottom',...
            'Color','none');
xlabel('Grain Size (in \phi units)',...
            'FontWeight','bold',...
            'FontSize',10);
set(newAxis,'yTickLabel',[],...
            'yGrid', 'off',...
            'xGrid', 'off',...
            'YAxisLocation', 'right',...
            'YScale', get(oldAxis, 'YScale'),...
            'YTick', get(oldAxis, 'YTick'),...
            'XScale', get(oldAxis, 'XScale'),...
            'XTick', get(oldAxis, 'XTick'));
set(oldAxis,'box','off',...
            'YAxisLocation','left');
linkaxes([oldAxis newAxis],'xy');
hlink = linkprop([newAxis, oldAxis], {'Position','YTick','XScale','YScale','YMinorTick'});
setappdata(newAxis,'Axis_Linkage',hlink);  
set(newAxis,'XTick',temp(:,1),...
            'XTickLabel',num2str(temp(:,2)),...
            'FontWeight','bold',...
            'FontSize',10,...
            'FontAngle','Oblique');   
temp=get(gcf,'Children');
i=temp==newAxis;
j=temp==oldAxis;
temp(i)=oldAxis;
temp(j)=newAxis;
set(gcf,'Children',temp);
axis(oldAxis);
end

function finalplots(nfol,esta,foldercur)
   figure; 
   bar(1:1:nfol,esta(:,1))
   xlabel('sample');
   ylabel('D_5_0 (mm)');
   set(findobj(gca,'Type','patch'),'EdgeColor','w');
   saveas(gcf,'Comparison_D50.fig');
   figure;
   bar(1:1:nfol,esta(:,2))
   xlabel('Sample');
   ylabel('Mean (mm)');
   set(findobj(gca,'Type','patch'),'EdgeColor','w');
   saveas(gcf,'Comparison_Mean.fig');
   figure;
   bar(1:1:nfol,esta(:,3))
   xlabel('Sample');
   ylabel('Sorting (mm)');
   set(findobj(gca,'Type','patch'),'EdgeColor','w');
   saveas(gcf,'Comparison_Sorting.fig');
   figure;
   bar(1:1:nfol,esta(:,4))
   xlabel('Sample');
   ylabel('Skewness');
   set(findobj(gca,'Type','patch'),'EdgeColor','w');
   saveas(gcf,'Comparison_Skewness.fig');
   figure;
   bar(1:1:nfol,esta(:,5))
   xlabel('Sample');
   ylabel('Kurtosis');
   set(findobj(gca,'Type','patch'),'EdgeColor','w');
   saveas(gcf,'Comparison_Kurtosis.fig');
   figure;
   bar(1:1:nfol,esta(:,10))
   xlabel('Sample');
   ylabel('ks (mm)');
   set(findobj(gca,'Type','patch'),'EdgeColor','w');
   saveas(gcf,'Comparison_ks.fig');
   figure;
   bar(1:1:nfol,esta(:,11))
   xlabel('Sample');
   ylabel('z0 (m)');
   set(findobj(gca,'Type','patch'),'EdgeColor','w');
   saveas(gcf,'Comparison_ks.fig');
   figure;
   plot(esta(:,2),esta(:,3),...
                'LineStyle','none',...
                'Marker','.',...
                'MarkerEdgeColor','b',...
                'MarkerFaceColor','b',...
                'MarkerSize',25);
   xlabel('Mean grain size (mm)');
   ylabel('Sorting (mm)');
   saveas(gcf,'Mean_vs_Sorting.fig');
   figure;
   plot(esta(:,2),esta(:,4),...
                'LineStyle','none',...
                'Marker','.',...
                'MarkerEdgeColor','b',...
                'MarkerFaceColor','b',...
                'MarkerSize',25);
   xlabel('Mean grain size (mm)');
   ylabel('Skewness');
   saveas(gcf,'Mean_vs_Skewness.fig');
   figure;
   plot(esta(:,2),esta(:,5),...
                'LineStyle','none',...
                'Marker','.',...
                'MarkerEdgeColor','b',...
                'MarkerFaceColor','b',...
                'MarkerSize',25);
   xlabel('Mean grain size (mm)');
   ylabel('Kurtosis');
   saveas(gcf,'Mean_vs_Kurtosis.fig');
   figure;
   plot(esta(:,4),esta(:,3),...
                'LineStyle','none',...
                'Marker','.',...
                'MarkerEdgeColor','b',...
                'MarkerFaceColor','b',...
                'MarkerSize',25);
   xlabel('Skewness');
   ylabel('Sorting (mm)');
   saveas(gcf,'Skewness_vs_Sorting.fig');
   figure;
   plot(esta(:,6),esta(:,7),...
                'LineStyle','none',...
                'Marker','.',...
                'MarkerEdgeColor','b',...
                'MarkerFaceColor','b',...
                'MarkerSize',25);
   xlabel('Y_{aeolian depo/beach environ}');
   ylabel('Y_{beach depo/shallow marine environ}');
   saveas(gcf,'Y1_Y2.fig');
   figure;
   plot(esta(:,8),esta(:,9),...
                'LineStyle','none',...
                'Marker','.',...
                'MarkerEdgeColor','b',...
                'MarkerFaceColor','b',...
                'MarkerSize',25);
   xlabel('Y_{deltaic depo/marine depo}');
   ylabel('Y_{fluvial environ/turbidity environ}');
   saveas(gcf,'Y3_Y4.fig');
   figure;
   loglog(esta(:,2)*1000,esta(:,12)*1000,...
                'LineStyle','none',...
                'Marker','.',...
                'MarkerEdgeColor','b',...
                'MarkerFaceColor','b',...
                'MarkerSize',15);
   set(gca,'XLim', [10 1000],'YLim',[20 10000],...
                'XTick',[0 10 15 20 40 60 80 100 200 400 600 800 1000],...
                'YTick',[20,40,60,80,100,200,400,600,800,1000,2000,4000,6000,8000,10000],...
                'Xgrid','off',...
                'Ygrid','off',...
                'Xcolor',[0 0 0.37],...
                'Ycolor',[0 0 0.37],...
                'Box','off',...
                'FontWeight','bold',...
                'FontSize',10,...
                'FontAngle','Oblique',...
                'XMinorTick','on',...
                'YMinorTick','on');
   xlabel('Median (microns)');
   ylabel('One percentil (microns)');
   title('C-M Diagram');
   patch([20;1000;1000],[20;1000;20],'white','LineStyle','none');
   line([20,1000],[20,1000],'color','red','LineWidth',3);
   line([15,15],[20,10000],'color','black','LineWidth',2);
   line([100,100],[100,10000],'color','black','LineWidth',2);
   line([200,200],[200,10000],'color','black','LineWidth',2);
   line([10,1000],[1000,1000],'color','black','LineWidth',2);
   line([10,250],[250,250],'color','black','LineStyle','--','LineWidth',2);
   line([10,420],[420,420],'color','black','LineStyle','--','LineWidth',2);
   text(11,3100,'IX');
   text(40,3100,'III');
   text(140,3100,'II');
   text(450,3100,'I');
   text(11,600,'VII');
   text(40,600,'VII');
   text(140,600,'V');
   text(400,600,'IV');
   text(50,150,'VI');
   text(120,80,'C = M','color','red','FontWeight','bold','Rotation',30,...
       'FontSize',12)
   text(280,240,'Cu');
   text(480,410,'Cs');
   saveas(gcf,'CM-Dia.fig');
   close all;
      [s,mess,messid] = mkdir('final_output');
   if isempty(mess) ~= 1
       mess;
   end
   movefile('*.fig',horzcat(foldercur,'\','final_output'));
end

function uni_can(nombre,fecha,perce)
filetxt1 = horzcat('Percentiles_',nombre,'.txt');
fid1 = fopen(filetxt1,'w');
fprintf(fid1,'              S A N D \r\n');
fprintf(fid1,'             S I E V E  \r\n');
fprintf(fid1,'          A N A L Y S I S \r\n');
fprintf(fid1,'            R E S U L T S \r\n');
fprintf(fid1,'\r\n'); 
fprintf(fid1,' SSSSSSS    AAAAAA    N      N   DDDDDDD     Y       Y \r\n');
fprintf(fid1,'S          A      A   NN     N   D      D     Y     Y \r\n');
fprintf(fid1,'S          A      A   N N    N   D       D     Y   Y \r\n');
fprintf(fid1,' SSSSSS    A      A   N  N   N   D       D      Y Y \r\n');
fprintf(fid1,'       S   AAAAAAAA   N   N  N   D       D       Y \r\n');
fprintf(fid1,'       S   A      A   N    N N   D      D        Y \r\n');
fprintf(fid1,'SSSSSSS    A      A   N     NN   DDDDDDD         Y \r\n');
fprintf(fid1,'\r\n');
fprintf(fid1,'*************************************** \r\n');
fprintf(fid1,'*           Sample                    * \r\n');
fprintf(fid1,'*************************************** \r\n');
fprintf(fid1,'Sample: %30s \r\n',nombre);
fprintf(fid1,'Date: %19s \r\n',fecha);
fprintf(fid1,'_______________________________________ \r\n');
fprintf(fid1,'\r\n');
fprintf(fid1,'*************************************** \r\n');
fprintf(fid1,'*Percentile\t Grain_Size(mm)          * \r\n');
fprintf(fid1,'*************************************** \r\n');
for i = 1 : 100
    fprintf(fid1,'%3.0d\t\t\t %8.5f\r\n',i,perce(i));
end
fprintf(fid1,'\r\n');
fprintf(fid1,'---------------------------\r\n');
fprintf(fid1,'SANDY, copyright, 2010.');
fclose(fid1)
end