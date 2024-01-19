function Options = CurrentRoseOptions(fontsize)

mycolormap = crameri('-roma');
% mycolormap = colormap(hsv(6));
% mycolormap = [0 0 1; 0 1 1; 0 1 0; .5 .2 .1; 1 1 0; 1 0 0];

Options.axes = gca;

Options.AngleNorth     = 0;
Options.AngleEast      = 90;
Options.Labels         = {'N','NE','E','SE','S','SW','W','NW'};
Options.LegendType     = 0;
Options.LegendPosition = 'westoutside';
Options.FreqLabelAngle = 100;
Options.MaxFrequency   = 50;
Options.nFreq          = 5;
Options.nDirections    = 16;
Options.min_radius     = .1;
Options.vWinds         = linspace(0, .5, 6);
% Options.nSpeeds        = 6;

Options.TextFontname   = 'Arial';
Options.TitleString    = [];
Options.LabLegend      = 'U (m s^{-1})';
Options.LegendVariable = 'u';
Options.CMap           = mycolormap;
Options.Gap            = .2;
Options.EdgeColor      = 'none';

% Options.FrequencyFontColor = 'r';
% Options.FrequencyFontWeight = 'bold';
% Options.FrequencyFontName = 'Comic Sans MS';
Options.FrequencyFontSize = fontsize*.6;
Options.FrequencyFontAngle = 'italic';

% Options.AxesFontColor = 'b';
Options.AxesFontWeight = 'bold';
% Options.AxesFontName = 'Rockwell Extra Bold';
Options.AxesFontSize = fontsize*.6;
Options.AxesFontAngle = 'normal';

% Options.TitleColor = [1 0.7 0.7];
Options.TitleFontSize = fontsize*.6;
Options.TitleFontWeight = 'normal';
% Options.TitleFontName = 'Jokerman';

% Options.LegendColor = [1 0.4 0];
Options.LegendFontSize = fontsize;
Options.LegendFontWeight = 'normal';
% Options.LegendFontName = 'Calibri';
Options.LegendFontAngle = 'italic';

% Options.LegendBarColor = [0 0.8 0];
Options.LegendBarFontSize = fontsize;
Options.LegendBarFontWeight = 'demi';
Options.LegendBarFontAngle = 'normal';
% Options.LegendBarFontName = 'Gill Sans Ultra Bold Condensed';

end