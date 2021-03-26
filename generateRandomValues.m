function generateRandomValues(~,~,mass,area,volume,dragCof)
	set(mass, 'String', rand*100+10); %<SM:RANDGEN> %<SM:RANDUSE>
	set(area, 'String', rand+.1);
	set(volume, 'String', rand*2);
	set(dragCof, 'String', rand*1.5);
end