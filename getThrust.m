function thrustVector = getThrust(thrustData,time)
	if isempty(thrustData)
		thrustVector = [0;0;0];
		return;
	end
	if time < thrustData(1,end)
		timeLower = floor(time*10+1);
		timeUpper = floor(time*10+2);
		% thrust
		thrustLower = thrustData(2,timeLower);
		thrustUpper = thrustData(2,timeUpper);
		thrust = interp1([timeLower,timeUpper],[thrustLower,thrustUpper],time*10+1);
		% tilt angle
		angleLower = thrustData(3,timeLower);
		angleUpper = thrustData(3,timeUpper);
		angle = interp1([timeLower,timeUpper],[angleLower,angleUpper],time*10+1);
		% direction
		directionLower = thrustData(4,timeLower);
		directionUpper = thrustData(4,timeUpper);
		direction = interp1([timeLower,timeUpper],[directionLower,directionUpper],time*10+1);
		thrustVector = flip(sphericalToCartesion([thrust;direction;angle]));
	else
		thrustVector = [0;0;0];
	end
end