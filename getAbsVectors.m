% Get vectors in absolute coordinates. 

function absVectors = getAbsVectors(localVectors, theta, phi)
	k = [sin(theta)*cos(phi), cos(theta)*cos(phi), -sin(phi); % from spherical to cartesion
		  sin(theta)*sin(phi), cos(theta)*sin(phi), cos(phi);
		  cos(theta), -sin(theta), 0];

	absVectors = k * localVectors;
end