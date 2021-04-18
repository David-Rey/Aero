% UIcontrol update for the GUI interface.

function zoomEarth(src,~,ax)
	% zoom 0: canva = 6.6086
	% zoom 1: canva = 1
	defaultZoom = 6.6086;
	zoom = get(src,'Value') * -(defaultZoom-.1);
	camva(ax,zoom+defaultZoom);
end
