% Plots the earth borders, latitude, and longitude lines. (THIS FUNCTION IS NOT MADE BY ME)
% Code below done by Chad Greene
% https://www.mathworks.com/matlabcentral/answers/350195-how-can-you-plot-lines-of-latitude-and-longitude-on-a-globe-without-using-the-mapping-toolbox

function plotEarth(ax,earthRadius)
	latspacing = 10;
	lonspacing = 20;

	% lines of longitude: 
	[lon1,lat1] = meshgrid(-180:lonspacing:180,linspace(-90,90,300)); 
	[x1,y1,z1] = sph2cart(lon1*pi/180,lat1*pi/180,earthRadius); 
	plot3(ax,x1,y1,z1,'-','color',0.5*[1,1,1]);
	
	% lines of latitude: 
	[lat2,lon2] = meshgrid(-90:latspacing:90,linspace(-180,180,300)); 
	[x2,y2,z2] = sph2cart(lon2*pi/180,lat2*pi/180,earthRadius); 
	plot3(ax,x2,y2,z2,'-','color',0.5*[1,1,1]);
	
	[X,Y,Z] = sphere(100); 
	surf(ax,X*earthRadius*.999,Y*earthRadius*.999,Z*earthRadius*.999,'facecolor','w','edgecolor','none');

	C = load('borderdata.mat');
	for k = 1:246
		[xtmp,ytmp,ztmp] = sph2cart(deg2rad(C.lon{k}),deg2rad(C.lat{k}),earthRadius);
		plot3(ax,xtmp,ytmp,ztmp,'k');
	end
end