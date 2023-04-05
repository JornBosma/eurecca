function [] = Narrow(fontsize)

% North arrow
ta = annotation('textarrow', [.78 .80], [.595 .615], 'String', 'N');
ta.FontSize = fontsize/1.3;
ta.Interpreter = 'latex';
ta.LineWidth = 6;
ta.HeadStyle = 'hypocycloid';
ta.HeadWidth = 30;
ta.HeadLength = 30;
an = annotation('ellipse', [.765 .575 .04 .05]);
an.LineWidth = 2;

end