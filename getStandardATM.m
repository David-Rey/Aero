
%clc;
%clear;

%https://en.wikipedia.org/wiki/Barometric_formula
%https://www.digitaldutch.com/atmoscalc/
%getStandardATM(86000);

function [pressure,density,temperature] = getStandardATM(height)
	% constants
	R = 8.3144598;
	g0 = 9.80665;
	M = 0.0289644;

	% [height MSL, pressure, density, temperature, temperature lapse rate]
	table = [0,101325.00,1.2250,288.15,-0.0065;
			 11000,22632.10,0.36391,216.65,0;
			 20000,5474.89,0.08803,216.65,0.001;
			 32000,868.02,0.01322,228.65,0.0028;
			 47000,110.91,0.00143,270.65,0;
			 51000,66.94,0.00086,270.65,-0.0028;
			 71000,3.96,0.000064,214.65,-0.002
			 86000,NaN,NaN,NaN,NaN];
		 
	subscriptB = 1;
	while table(subscriptB,1) < height && subscriptB <= 7
		subscriptB = subscriptB + 1;
	end
	subscriptB = max(subscriptB - 1,1);
	if table(subscriptB,5) == 0 % if lapes rate is zero
		mainTerm = exp(-g0*M*(height-table(subscriptB,1))/(R*table(subscriptB,4)));
		pressure = table(subscriptB,2)*mainTerm;
		density = table(subscriptB,3)*mainTerm;
		temperature = table(subscriptB,4);
	else % if lapes rate is NOT zero
		exponetPart = (-g0*M)/(R*table(subscriptB,5));
		temperature = table(subscriptB,4)+table(subscriptB,5)*(height-table(subscriptB,1));
		pressure = table(subscriptB,2)*(temperature/table(subscriptB,4))^(exponetPart);
		density = table(subscriptB,3)*(table(subscriptB,4)/temperature)^(1-exponetPart);
	end
end

