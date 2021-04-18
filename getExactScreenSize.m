% Gets the exact screen size in pixels. (THIS FUNCTION IS NOT MADE BY ME)
% funciton done by Ulrik
% https://www.mathworks.com/matlabcentral/answers/312738-how-to-get-real-screen-size
function MonitorPositions = getExactScreenSize()
	ScreenPixelsPerInch = java.awt.Toolkit.getDefaultToolkit().getScreenResolution();
	ScreenDevices = java.awt.GraphicsEnvironment.getLocalGraphicsEnvironment().getScreenDevices();
	MainScreen = java.awt.GraphicsEnvironment.getLocalGraphicsEnvironment().getDefaultScreenDevice().getScreen()+1;
	MainBounds = ScreenDevices(MainScreen).getDefaultConfiguration().getBounds();
	MonitorPositions = zeros(numel(ScreenDevices),4);
	for n = 1:numel(ScreenDevices)
	    Bounds = ScreenDevices(n).getDefaultConfiguration().getBounds();
	    MonitorPositions(n,:) = [Bounds.getLocation().getX() + 1,-Bounds.getLocation().getY() + 1 - Bounds.getHeight() + MainBounds.getHeight(),Bounds.getWidth(),Bounds.getHeight()];
	end
	MonitorPositions = MonitorPositions(1,[3,4]);
end
