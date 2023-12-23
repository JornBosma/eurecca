function fig = figureRH()
    % Get the screen size
    screenSize = get(0, 'ScreenSize');

    % Calculate the position for the figure to cover the right half
    figureWidth = screenSize(3) / 2;  % Half of the screen width
    figureHeight = screenSize(4);     % Full screen height
    figureX = screenSize(3) / 2;      % X position to start at the right half
    figureY = 1;                      % Y position (starting from the top)

    % Create a new figure and set its properties
    fig = figure;
    set(fig, 'Position', [figureX, figureY, figureWidth, figureHeight]);

    % You can further customize your figure, plot data, add labels, etc.
end
