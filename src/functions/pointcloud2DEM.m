function DEM = pointcloud2DEM(PC,Xlim,Ylim,res)

%POINTCLOUD2DEM: Compute digital elevation model from point cloud
%
% A digital elevation model is a typical product derived from a point
% cloud. It comprises elevation Z values on a regular (horizontal) X and
% Y grid. This unction uses a local averaging to compute elevation at a
% pre-described mesh of X and Y values. The radius of the circle to search
% points to be averaged equals the grid resolution. This is a typical
% approach, see, for example, https://opentopography.org/otsoftware/points2grid 
%
% This function makes use of the rangesearch function in the Statistics
% and Machine Learning Toolbox. The nearest neighbour search algorithm is
% k-d tree and the distance metric is euclidian. Both are default for
% rangesearch (Matlab R2021a), but are specified anyhow.
%
% Holes in the DEM are not filled. This is a post-processing step and can,
% for example, be performed with the TopoToolbox.
%
% INPUT
%   PC: the point cloud, [Npoints x 3] with X,Y,Z as the three columns 
%   Xlim: [1x2] matrix with [Xmin, Xmax]
%   Ylim: [1x2] matrix with [Ymin, Ymax]
%   res: resolution and radius of search circle
%
% OUTPUT
%   DEM: a structure with the following fields
%        - X, mesh for X coordinate
%        - Y, mesh for Y coordinate
%        - Z, average value of Z values within search circle
%        - S, standard deviation of Z values within search circle
%        - D, point density (points / area)
%   All fields are of size NY x NX, where NY and NX are the number of 
%   Y- and X-coordinates of the mesh.
%
% Xlim and Ylim are taken as corner points. For example, the lower left
% corner = [Xlim(1) Ylim(1)]. All fields in DEM are computed at the center
% coordinates of each grid cell. The lower left center coordinate is [Xlim
% (1) + res/2, Ylim(1) + res/2].
%
% This function replaces earlier functions (I wrote) that aimed to compute
% a DEM from a pointcloud, such as DPC2DEM and DPC2DEMFast. The present
% function is hugely more effective for large point clouds. It does require
% the Statistics and Machine Learning Toolbox.
% 
% Gerben Ruessink, v1, 23 December 2021

% Filter all points outside area of interest
select = (PC(:,1) < (Xlim(1)-res) | PC(:,1) > (Xlim(2)+res) | ...
          PC(:,2) < (Ylim(1)-res) | PC(:,2) > (Ylim(2)+res));
PC = PC(~select,:);

% Make the X and Y matrices with center points
xAxis = Xlim(1)+res/2:res:Xlim(2)-res/2;
yAxis = Ylim(1)+res/2:res:Ylim(2)-res/2;
[X,Y] = meshgrid(xAxis,yAxis);

% Find the indices in the point cloud for each grid point
idGridCells = rangesearch(PC(:,1:2),[X(:), Y(:)],res, ...
              'NSMethod','kdtree','Distance','euclidean');

% Prepare fields of DEM
Z = NaN(size(X));
S = Z; D = Z;
area = pi*res^2;

% Compute DEM fields Z, D and S
for i = 1:length(idGridCells)
    if ~isempty(idGridCells{i})
        Z(i) = mean(PC(idGridCells{i},3));  % Mean elevation
        S(i) = std(PC(idGridCells{i},3));   % Standard deviation
        D(i) = length(idGridCells{i})/area; % Density = number points/area
    end
end

% Store everything in DEM
DEM.X = X;
DEM.Y = Y;
DEM.Z = Z;
DEM.S = S;
DEM.D = D;

% Done!