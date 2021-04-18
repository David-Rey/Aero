% Gets atmospheric data at a specific height. 

function [density,pressure,temperature,SoS,windDir,windSpeed] = getAtmosphereAtHeight...
	(h,weather,weatherID,available,reliable,staticDensity,staticTemp,staticWindDir,staticWindSpeed)
	% waether ID 1 == at locaiton, ID == 2 Standard, ID == 3 static
	% [density, pressure, temperature, speed of sound, wind dir., wind speed]
	if h < 1
		h = 1;
	end
	h = floor(h + 1);
	if h > 86000
		%https://www.mathworks.com/matlabcentral/answers/414731-how-to-set-multiple-variables-at-once
		[density,pressure,temperature,SoS,windDir,windSpeed] = deal(0,0,NaN,NaN,NaN,NaN); % deal or no deal?
		return;
	end
	
	if weatherID == '1' && available == 1 && reliable == 1
		density = weather(7,h);
		pressure = weather(2,h);
		temperature = weather(3,h);
		SoS = weather(8,h);
		windDir = weather(5,h);
		windSpeed = weather(6,h);
	elseif weatherID == '1' || weatherID == '2'
		[pressure,density,temperature] = getStandardATM(h);
		SoS = sqrt(1.401*8.3145*(temperature+273.15)/28.9647*1000); % speed of sound (m/s)
		windDir = 0;
		windSpeed = 0;
	else % 'STATIC'
		density = staticDensity;
		pressure = 100000;
		temperature = staticTemp;
		SoS = sqrt(1.401*8.3145*(temperature+273.15)/28.9647*1000);
		windDir = staticWindDir;
		windSpeed = staticWindSpeed;
	end
end