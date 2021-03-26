function localVectors = getLocalVectors(absVectors, theta, phi)
	k = [sin(theta)*cos(phi), sin(theta)*sin(phi),  cos(theta); % from cartesion to spherical
		  cos(theta)*cos(phi), cos(theta)*sin(phi), -sin(theta); 
		  -sin(phi), cos(phi), 0];

	localVectors = k * absVectors;
end