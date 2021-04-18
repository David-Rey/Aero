% UIcontrol update for the GUI interface.

function locationUpdate(~,~,density,temprature,windDir,windSpeed,loc)
	set(density,'enable','off');
	set(temprature,'enable','off');
	set(windDir,'enable','off');
	set(windSpeed,'enable','off');
	set(loc,'enable','on')
end