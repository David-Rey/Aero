% UIcontrol update for the GUI interface.

function staticEnvUpdate(~,~,density,temprature,windDir,windSpeed,loc)
	set(density,'enable','on');
	set(temprature,'enable','on');
	set(windDir,'enable','on');
	set(windSpeed,'enable','on');
	set(loc,'enable','off')
end