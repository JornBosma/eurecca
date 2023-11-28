function pgons = getPgons()

a = [114850; 557860];
b = [115108; 557772];
c = [115500; 557700];
d = [118060; 560044];
e = [118062; 560520];
f = [116950; 560526];
g = [115450; 558000];
h = [114960; 558000];
i = [115090; 558000];
j = [117090; 560526];
% k = [115690; 558750];
l = [115675; 558750];
m = [116370; 559510];
n = [117400; 560340];
o = [117590; 560250]; 
p = [117420; 559890];
q = [115780; 558600];
r = [115280; 558000];
s = [115020; 557970];
t = [115610; 558730];
u = [116340; 559500];
v = [117410; 560340];
w = [117660; 560120];
x = [115720; 558550];
y = [117280; 560010];
z = [115310; 558000];
A = [115020; 558000];
B = [115640; 558800];
C = [117160; 560120];
D = [116090; 559075];
E = [115950; 559180];
F = [117000; 560500];
G = [117420; 560500];
% H = [117410; 560530];
% I = [117400; 560320];
J = [117970; 560440];
K = [118000; 560500];
L = [115960; 559120];
M = [116050; 559030];
N = [117410; 560100];
O = [117410; 560460];
P = [116600; 559960];
Q = [118060; 560520];
R = [115418; 557782];
S = [115552; 557776];
T = [116030; 558646];
U = [118060; 560214];
V = [118060; 560282];
W = [115984; 558702];
X = [115440; 557970];
Y = [115432; 557960];
% Z = [];


%% Study site

% study site (complete area)
site = [a b c d e f]';

% NIOZ harbour
harbour = [a b c g h]';

% area of interest (without harbour)
scope = [h g c d e f]';


%% Supratidal zone

% dune row
dune = [h i j f]';

% entire spit
spit = [l m n o p q]';

% north beach
NW_beach = [l B F K o n m]';


%% Intertidal zone

% spit + south beach
beach_sea = [r s t u v w x]';

% seaward side of spit
spit_sea = [y l q p]';

% southern beach between harbour and spit
south_beach = [z A B q]';

% spit hook (accretive part)
hook = [p y C n o]';

% lagoon with surrounding beaches
lagoon = [n C y D E F G]';

% Ceres beach
ceres = [G n o J K]';

% beach gate entrance area
gate = [B l D E]';


%% Subtidal zone

% lagoon bathy
lagoon_bathy = [L M N O P]';

% subtidal platform without lagoon
platform = [M N O Q V W g i L]';

% Texelstroom channel wall (stones)
chanwall = [R S T U V W X Y]';


%% Store

% Create the structure with field names
pgons = struct('site',[], 'harbour',[], 'scope',[],...
    'dune',[], 'spit',[], 'NW_beach',[],...
    'beach_sea',[], 'spit_sea',[], 'south_beach',[], 'hook',[], 'lagoon',[], 'ceres',[], 'gate',[],...
    'lagoon_bathy',[], 'platform',[], 'chanwall',[]);

% Assign values to the matrices within the structure
pgons.site = site;
pgons.harbour = harbour;
pgons.scope = scope;
pgons.dune = dune;
pgons.spit = spit;
pgons.NW_beach = NW_beach;
pgons.beach_sea = beach_sea;
pgons.spit_sea = spit_sea;
pgons.south_beach = south_beach;
pgons.hook = hook;
pgons.lagoon = lagoon;
pgons.ceres = ceres;
pgons.gate = gate;
pgons.lagoon_bathy = lagoon_bathy;
pgons.platform = platform;
pgons.chanwall = chanwall;

end