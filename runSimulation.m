function output = runSimulation(input)
	%%% Projectile Parameters %%%
	mass = input{1};
	area = input{2};
	volume = input{3};
	staticCD = input{4};
	objectType = input{5};
	dynamicCD = input{6};
	dynamicThrust = input{7};
	
	%%% Environment Parameters %%%
	staticDensity = input{8};
	staticTemp = input{9};
	staticWindDir = input{10};
	staticWindSpeed = input{11};
	weatherType = input{12};
	rotatingEarth = input{13};
	staticGravityBool = input{14};
	staticGravityValue = input{15};
	locationID = input{16};
	
	%%% weather and NOAA data %%%
	fprintf('Getting weather data from NOAA. This may take a few seconds if running for the first time today.\n');
	[NOAAavailable,NOAAreliable,weather] = getAtmosphere(locationID);
	fprintf('NOAA data received.\n');
	
	%%% Starting Condidtion %%%
	latitude = input{17};
	longitude = input{18};
	currectHeight = input{19}; % start height
	launchDirection = input{20};
	launchAngle = input{21};
	launchVelocity = input{22};
	
	%%% Simulation Settings %%%
	dtInATM = input{23};
	dtInSpace = input{24};
	maxIterations = input{25} * 1000;
	maxComputeTime = input{26};
	
	%%% drag coefficient %%%
	machData = [];
	if dynamicCD
		deltaMach = 0:.01:4;
		%xlsMachData = xlsread('CDdata.xlsx',1,'A2:B10')';
		xlsMachData = xlsread('CDdata.xlsx',1)';
		machData = [deltaMach;makima(xlsMachData(1,:),xlsMachData(2,:),deltaMach)];
	end
	%%% thrust data %%%
	thrustData = [];
	if dynamicThrust
		xlsthrustData = xlsread('ThrustData.xlsx',1,'A2:D10');
		thrustdt = 0:0.1:xlsthrustData(end,1);
		xlsthrustData(:,3) = deg2rad(xlsthrustData(:,3));
		xlsthrustData(:,4) = deg2rad(xlsthrustData(:,4)-90);
		thrustData = [thrustdt; interp1(xlsthrustData(:,1),xlsthrustData(:,2),thrustdt);...
					  makima(xlsthrustData(:,1),xlsthrustData(:,3),thrustdt);
					  makima(xlsthrustData(:,1),xlsthrustData(:,4),thrustdt)];
	end
	%%% Constants %%%
	earthRadius = 6371000;
	time = 0.0;
	maxTime = 90000;
	iteration = 1;
	earthRadPerSec = 0;
	if rotatingEarth
		earthRadPerSec = -7.2921159e-5; % rad/s
	end
	latitude = deg2rad(90 - latitude);
	longitude = deg2rad(longitude);
	launchDirection = deg2rad(launchDirection - 90);
	launchAngle = deg2rad(90 - launchAngle);
	tanVelocity = earthRadPerSec * (earthRadius + currectHeight) * sin(latitude);
	
	% sphericalPosition is the position using spherical cordinates (height;longitude;latitude)
	sphericalPosition = [earthRadius + currectHeight; longitude; latitude];
	% rotPosition rotinal position is the same as sphericalPosition but takes into account earth rotion
	rotationalPosition = sphericalPosition;
	% position relitive to the main 3D cordinate system
	absPosition = sphericalToCartesion(sphericalPosition);
	% groundVelocity is the velcoty relitive to the ground [+/-](up/down;south/north;east/west)
	groundVelocity = flip(sphericalToCartesion([launchVelocity; launchDirection; launchAngle]));
	% localVelocity is the velocty relitive to the ground IF the earth is not rotating
	% [+/-](up/down;south/north;east/west)
	localVelocity = groundVelocity + [0; 0; -tanVelocity];
	% absVelocty is the velocity relitive to the main 3D cordinate system
	absVelocty = getAbsVectors(localVelocity, sphericalPosition(3), sphericalPosition(2));

	fprintf('Allocating Memory.\n');
	scalerData = NaN(17,maxIterations);
	vectorData = NaN(15,3,maxIterations);
	fprintf('Starting Simulation.\n');
	frameEndTime = -1;
	pauseTime = -1;
	simStartTime = tic;
	%    3
	%   2
	%  1
	% LAUNCH!!!!
	while sphericalPosition(1) >= earthRadius && iteration < maxIterations && sphericalPosition(1) <= earthRadius * 4 && toc(simStartTime) < maxComputeTime %<SM:BOP>
		%frameStartTime = tic; % starts a timer for the iteration
	
		[density,pressure,temperature,SoS,windDir,windSpeed] = getAtmosphereAtHeight... % Gets Atmospheric data
			(currectHeight,weather,weatherType,NOAAavailable,NOAAreliable);
	
		windVelocity = groundVelocity + [0;windSpeed*-cos(windDir);windSpeed*sin(windDir)]; 
		speedInWind = norm(windVelocity); %<SM:NEWFUN>
		speed = norm(groundVelocity);
		staticEarthSpeed = norm(localVelocity);
		mach = speedInWind / SoS;
		dragCoefficient = getCD(machData,mach,staticCD);
		gravity = -getGravity(currectHeight,staticGravityBool,staticGravityValue);
	
		if currectHeight > 86000 % is in space 
			dt = dtInSpace;
			dragForce = [0;0;0];
			isInSpace = 'Yes';
		else
			dt = dtInATM;
			dragForce =  -0.5 * density * speedInWind^2 * dragCoefficient * area * getUnitVector(windVelocity);
			isInSpace = 'No';
		end
		
		buoyancyForce = [density * volume * -gravity;0;0];
		gravityForce = [mass * gravity;0;0];
		applyedForce = getThrust(thrustData,time);
		sphericalAppForce = cartesionToSpherical(applyedForce);
		totalLocalForce = dragForce + buoyancyForce + gravityForce + applyedForce;

		localAcceleration = totalLocalForce / mass;
		absAcceleration = getAbsVectors(localAcceleration, sphericalPosition(3), sphericalPosition(2));
		absVelocty = absVelocty + absAcceleration * dt;
		absPosition = absPosition + absVelocty * dt;
		%%% ^^^ this is where the magic happens :)
		
		localVelocity = getLocalVectors(absVelocty, sphericalPosition(3), sphericalPosition(2));
		tanVelocity = earthRadPerSec * (earthRadius + currectHeight) * sin(sphericalPosition(3));
		groundVelocity = localVelocity - [0; 0; -tanVelocity];
		
		magAcceleration = norm(absAcceleration);
		sphericalPosition = cartesionToSpherical(absPosition);
		rotationalPosition = [sphericalPosition(1);sphericalPosition(2)+(time*earthRadPerSec);sphericalPosition(3)];
		absRotPosition = sphericalToCartesion(rotationalPosition);
		currectHeight = sphericalPosition(1) - earthRadius;
		
		time = time + dt;
		%%% appending to array %%%
		scalersToAppend = [time,currectHeight,speed,magAcceleration,SoS,mach,norm(applyedForce),...
			dragCoefficient,density,temperature,pressure,windDir,windSpeed,speedInWind,tanVelocity,...
			gravity,norm(dragForce),staticEarthSpeed,dt];
		for i=1:length(scalersToAppend)
			scalerData(i,iteration) = scalersToAppend(i); %<SM:REF> 
		end
		vectorsToAppend = [absPosition,sphericalPosition,rotationalPosition,absRotPosition,absVelocty,... %1-5
			groundVelocity,localVelocity,windVelocity,absAcceleration,localAcceleration,... %6-10
			buoyancyForce,gravityForce,dragForce,applyedForce,sphericalAppForce,totalLocalForce]; %11-16
		for i=1:length(vectorsToAppend)
			vectorData(i,:,iteration) = vectorsToAppend(:,i);
		end
		iteration = iteration + 1;
	end
	simEndTime = toc(simStartTime);
	scalerData = scalerData(:,1:iteration-1);
	vectorData = vectorData(:,:,1:iteration-1);
	
	fprintf('Simulation Complete.\n');
	fprintf('%.f Iterations computed in %.2f seconds.\n',iteration,simEndTime);
	
	output = {scalerData,vectorData,weather,NOAAavailable,NOAAreliable,weatherType,machData,thrustData};
end