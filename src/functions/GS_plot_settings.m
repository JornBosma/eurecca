function [] = GS_plot_settings(ax1, ax2, fontsize, xl, yl)

ax2.SortMethod = 'childorder';

ta = annotation('textarrow', [.48 .48], [.75 .78], 'String', 'N');
ta.FontSize = fontsize;
ta.Interpreter = 'latex';
ta.LineWidth = 6;
ta.HeadStyle = 'hypocycloid';
ta.HeadWidth = 30;
ta.HeadLength = 30;

linkaxes([ax1, ax2])

ax2.Visible = 'off';
ax2.XTick = [];
ax2.YTick = [];

colormap(ax1, gray)
colormap(ax2, flipud(hot))

set([ax1, ax2], 'Position', [.17 .11 .685 .815]);
cb1 = colorbar(ax1, 'Position', [.27 .62 .02 .2]);
cb2 = colorbar(ax2, 'Position', [.37 .62 .02 .2]);

cb1.Label.String = 'm +NAP';
cb1.Label.Interpreter = 'latex';
cb1.TickLabelInterpreter = 'latex';
cb1.FontSize = fontsize;

cb2.Label.String = 'D$_{50}$ (mm)';
cb2.Label.Interpreter = 'latex';
cb2.TickLabelInterpreter = 'latex';
cb2.FontSize = fontsize;

xlabel([ax1, ax2], 'easting - RD (m)')
ylabel([ax1, ax2], 'northing - RD (m)')

clim(ax1, [-5, 5])
clim(ax2, [0.3, 1.0])
% clim(ax2, [0, 0.1]) % black

axis([ax1, ax2], [xl(1), xl(2), yl(1), yl(2)]) 
axis([ax1, ax2], 'equal')
axis([ax1, ax2], 'off')
set([ax1, ax2], 'Color', [.8 .8 .8])

return
