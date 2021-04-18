% Update object parameters for GUI input.

function updateObjectValues(~,~,objectListPopup,mass,area,volume,dragCof)
	%[mass area volume drag; object2; objec3; ...]
	dataArr = [10 .01 .02 .5;   % point mass
			   100 .1 .04 0.1;  % Missile
			   120000 360 0 .7; % Starship
			   3.5 0.01227 0.001022, .5]; % bolling ball
		   
	objectIndex = get(objectListPopup,'value');
	set(mass, 'String', dataArr(objectIndex,1))
	set(area, 'String', dataArr(objectIndex,2))
	set(volume, 'String', dataArr(objectIndex,3))
	set(dragCof, 'String', dataArr(objectIndex,4))
end