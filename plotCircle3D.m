% Plots circle in 3D space. Used in 3D simulation.

function cir = plotCircle3D(ax,center,normal,radius,color,earthRadius)
	% Funciton done by Christian Reinbacher, slight modifcations done by David Reynolds
	% https://www.mathworks.com/matlabcentral/fileexchange/26588-plot-circle-in-3d
	theta=0:0.02:2*pi;
	v=null(normal);
	points=repmat(center',1,size(theta,2))+radius*(v(:,1)*cos(theta)+v(:,2)*sin(theta));
	for i=1:315
		if norm(points(:,i)) < earthRadius
			points(:,i) = NaN;
		end
	end
	cir = plot3(ax,points(1,:),points(2,:),points(3,:),color);
end
