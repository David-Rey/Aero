function plotPointGUI(lonGUIPoint,latGUIPoint,pointGUI,h)
	point = sphericalToCartesion([1+(h/6371000);deg2rad(lonGUIPoint);deg2rad(90-latGUIPoint)]); % gets the point
	set(pointGUI,'XData',point(1),'YData',point(2),'ZData',point(3)); %https://www.mathworks.com/matlabcentral/answers/119402-how-to-set-a-marker-at-one-specific-point-on-a-plot-look-at-the-picture
end