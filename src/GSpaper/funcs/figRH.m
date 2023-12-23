function newFig = figRH(margin)
    % Set the screen number to always use the second screen
    screenNumber = 2;

    % Set the default margin value if not provided
    if nargin < 1
        margin = 60; % Default margin in pixels
    end

    % Get the screen size of the specified screen
    screens = get(0, 'MonitorPositions');
    
    % Check if the specified screen exists
    if screenNumber > size(screens, 1)
        error('Specified screen does not exist.');
        return;
    end

    % Get the position of the specified screen
    screenPosition = screens(screenNumber, :);
    
    % Calculate the position for the new figure with margin
    figureWidth = (screenPosition(3) / 2) - 2 * margin;
    figureHeight = screenPosition(4) - 2 * margin;
    figurePosition = [screenPosition(1) + screenPosition(3) / 2 + margin, screenPosition(2) + margin, figureWidth, figureHeight];
    
    % Create a new figure and set its position
    newFig = figure('Position', figurePosition);
    
    % You can add more customization to the new figure here if needed
    % For example, setting the title, labels, etc.
    
    % Return the handle to the new figure (optional)
    if nargout > 0
        varargout{1} = newFig;
    end
end
