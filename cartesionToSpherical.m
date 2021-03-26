function spherical = cartesionToSpherical(cartesion)
	x = cartesion(1);
	y = cartesion(2);
	z = cartesion(3);
	
	spherical = [sqrt(x^2+y^2+z^2)
				 atan2(y,x)
				 acos(z/sqrt(x^2+y^2+z^2))];
end