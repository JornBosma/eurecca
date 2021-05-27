# Sandy
Sandy is a Matlab script to compute the sediment sizes distribution from a sediment sample. The sediment sample has values from the sieve technique.

SANDY requires two input parameters for computing the sediment size distribution: nominal sieve openings and cumulative mass of material retained on each sieve. This information is provided to the program through a plain text file (*.txt) arranged in two columns, which should be separated by a tab space and must be located in subfolder. This subfolder should be in the same folder where the SANDY© script is. The data in the first column correspond to the nominal sieve openings (in mm) and the second column must refer to the cumulative mass of material retained on each sieve (in grams). The data must be sorted in descending order, following the nominal sieve openings. 

In order to perform the sieve analysis of one or several samples of sand, it is necessary to create a folder; this is the main folder for the program. For each sediment sample that requires analysis, a subfolder of the sample should be created and the input file should be within this subfolder. The main folder should contain the SANDY© program and one or more subfolders. When the program starts, the main folder is reviewed to determine whether one subfolder (“a sample”) should be analysed or several subfolders (multiple analyses).

To run SANDY, in Matlab Command Window should write the command: run('Sandy1_75')

Reference: Ruiz-Martinez, G., Rivillas-Ospina, D., Mariño-Tapia, I. and  Posada-Vanegas, G. (2016). SANDY: a Matlab tool to estimate the sediment size distribution from a sieve analysis. Computers & Geosciences, 96, July, pp. 104-116. DOI: 10.1016/j.cageo.2016.04.010

https://github.com/garm005/Sandy
