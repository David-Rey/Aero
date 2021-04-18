% Converts point from spherical to cartesian coordinate. 

function cartesion = sphericalToCartesion(spherical)
	r = spherical(1);
	phi = spherical(2);
	theta = spherical(3);

	cartesion = [r*sin(theta)*cos(phi)
				 r*sin(theta)*sin(phi)
				 r*cos(theta)];
end