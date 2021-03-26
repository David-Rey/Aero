function updateLonLat(~,~,lonUI,latUI,hUI,ax,pointGUI)
	try
		lon = str2double(get(lonUI, 'String')); %<SM:STRING>
		lat = str2double(get(latUI, 'String'));
		h = str2double(get(hUI, 'String'));
		if isnan(h) || h < 0
			h=0;
			throw;
		end
		view(ax,[90+lon,lat]);
		plotPointGUI(lon,lat,pointGUI,h);
		lonStartPoint = lon;
		latStartPoint = lat;
	catch
		fprintf('Invalid Arguments\n');
	end
	set(lonUI, 'String', lon);
	set(latUI, 'String', lat);
	set(hUI, 'String', h);
end