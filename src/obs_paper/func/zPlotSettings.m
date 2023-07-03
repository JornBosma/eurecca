function [] = zPlotSettings(fontsize, xl, yl)

% ta = annotation('textarrow', [.48 .48], [.75 .78], 'String', 'N');
% ta.FontSize = fontsize;
% ta.Interpreter = 'latex';
% ta.LineWidth = 6;
% ta.HeadStyle = 'hypocycloid';
% ta.HeadWidth = 30;
% ta.HeadLength = 30;

colormap((brewermap([], '*RdBu')))

cb = colorbar;
cb.Label.String = 'm +NAP';
cb.Label.Interpreter = 'latex';
cb.TickLabelInterpreter = 'latex';
cb.FontSize = fontsize;

xlabel('easting - RD (m)')
ylabel('northing - RD (m)')

clim([-5, 5])

axis([xl(1), xl(2), yl(1), yl(2)]) 
axis('equal')
axis('off')

return
