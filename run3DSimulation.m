% This runs the 3D simulation when the user clicks the “3D simulation” button.

function run3DSimulation(scalerData,vectorData,framesPerSecond,iterationsPerFrame,textCheck,hoopCheck,trackCheck,endCheck)
	figure;
	axis equal tight vis3d off
	camproj('orthographic');
	set(gcf, 'Position', get(0, 'Screensize'));
	set(gcf,'units','pixels');
	set(gcf,'WindowState','Maximized');
	hold on
	rotate3d on % rotation pre selcted
	mainAx = gca; % current axes
	mainAxPos = mainAx.Position; % position of first axes
	axHidden = axes('Units','pixels','Visible','off','hittest','off','Position',mainAxPos);
	fprintf('Running 3D Simulation.\n');
	
	earthRadius = 6371000;
	[~,numIteration] = size(scalerData);
	numFrames = floor(numIteration/iterationsPerFrame);
	frame = 1;
	iteration = 1;
	
	%%% plot line %%%
	absRotPosition = reshape(vectorData(4,:,:),[3,numIteration]);
	sphericalPosition = vectorData(2,:,1);
	trajectoryData = reshape(vectorData(4,:,:),[3,numIteration]);
	
	trajectoryLineFut = plot3(mainAx,absRotPosition(1,:),absRotPosition(2,:),absRotPosition(3,:),'color',[0.7,0.7,0.7]);
	trajectoryLinePast = plot3(mainAx,absRotPosition(1,1),absRotPosition(2,1),absRotPosition(3,1),'b');
	absPositionOnEarth = sphericalToCartesion([earthRadius,sphericalPosition(2),sphericalPosition(3)]);	
	downLine = line(mainAx,[absRotPosition(1,1),absPositionOnEarth(1)],[absRotPosition(2,1),absPositionOnEarth(2)],[absRotPosition(3,1),absPositionOnEarth(3)]);
	pointMarker3D = plot3(mainAx,absRotPosition(1),absRotPosition(2),absRotPosition(3),'r.');
	
	%%% plot hoops %%%
	nHoops = round(numIteration/70)/iterationsPerFrame;
	if (numIteration > nHoops) && hoopCheck
		hoopIndexArr = linspace(1,numIteration,nHoops);
		for i=1:nHoops
			hoopIndex = floor(hoopIndexArr(i));
			absRotPosition = vectorData(4,:,hoopIndex)';
			rotPosition = vectorData(3,:,hoopIndex);
			groundVelocity = vectorData(6,:,hoopIndex);
			speed = scalerData(3,hoopIndex);
			if speed < 900
				hoopSize = 120;
			elseif speed < 5000
				hoopSize = 2000;
			else
				hoopSize = 90000;
			end
			plotCircle3D(mainAx,absRotPosition',getAbsVectors(groundVelocity',rotPosition(3),rotPosition(2))',hoopSize,'g-',earthRadius);
		end
	end
	
	%%% Text Init %%%
	windowPos = get(gcf,'Position');
	windowPos = getExactScreenSize;
	windowWidth = windowPos(1);
	windowHeight = windowPos(2);
	
	deltaYtext = 15;
	startXtext = 8;
	startYtext = 14;
	bottomLeftTextLength = 18;
	bottomRightTextLength = 14;
	topRightTextLength = 9;
	topLeftTextLength = 13;
	screenOffset = 165;

	for i=0:bottomLeftTextLength-1
		telemetry(i+1) = text(axHidden,startXtext,...
		startYtext+deltaYtext*(bottomLeftTextLength-i-1),'');
	end
	lengthSoFar = bottomLeftTextLength;
	for i=0:bottomRightTextLength-1
		telemetry(lengthSoFar+i+1) = text(axHidden,windowWidth-startXtext,...
		startYtext+deltaYtext*(bottomRightTextLength-i-1),'');
	end
	set(telemetry(lengthSoFar+1:lengthSoFar+bottomRightTextLength),'HorizontalAlignment','right');
	lengthSoFar = lengthSoFar+bottomRightTextLength;
	for i=0:topRightTextLength-1
		telemetry(lengthSoFar+i+1) = text(axHidden,windowWidth-startXtext,...
		windowHeight-screenOffset-startYtext+deltaYtext*-i,'');
	end
	set(telemetry(lengthSoFar+1:lengthSoFar+topRightTextLength),'HorizontalAlignment','right');
	lengthSoFar = lengthSoFar+topRightTextLength;
	for i=0:topLeftTextLength-1
		telemetry(lengthSoFar+i+1) = text(axHidden,startXtext,...
		windowHeight-screenOffset-startYtext+deltaYtext*-i,'');
	end
	
	linePos = [];
	frameEndTime = -1;
	pauseTime = -1;
	FPS = -1;
	sumOfFPS = 0;
	simStartTime = tic;
	plotEarth(mainAx,earthRadius);
	camup('manual');
	while iteration < numIteration
		frameStartTime = tic; % starts a timer for the iteration
		
		speed = scalerData(3,iteration);
		currectHeight = scalerData(2,iteration);
		absRotPosition = vectorData(4,:,iteration)';
		rotPosition = vectorData(3,:,iteration);
		groundVelocity = vectorData(6,:,iteration);
		absPositionOnEarth = sphericalToCartesion([earthRadius,rotPosition(2),rotPosition(3)]);
		
		camDistance = speed^2 + currectHeight + 5000;
		%upScaleFactor = log2((currectHeight/earthRadius)+1)+1;
		upScaleFactor = 1.1;
		cameraPos = getAbsVectors([camDistance*upScaleFactor;camDistance;0],rotPosition(3),rotPosition(2));
		if trackCheck
			camup(mainAx,absRotPosition);
			campos(mainAx,absRotPosition + cameraPos);
			camtarget(mainAx,absRotPosition);
		end
		
		if currectHeight > 86000
			isInSpace = 'Yes';
			pointColor = 'cyan';
		else
			isInSpace = 'No';
			pointColor = 'red';
		end
		if speed < 900
			hoopSize = 120;
		elseif speed < 5000
			hoopSize = 2000;
		else
			hoopSize = 90000;
		end
		
		set(pointMarker3D,'XData',absRotPosition(1),'YData',absRotPosition(2),'ZData',absRotPosition(3),'color',pointColor);
		set(downLine,'XData',[absRotPosition(1),absPositionOnEarth(1)],...
					 'YData',[absRotPosition(2),absPositionOnEarth(2)],...
					 'ZData',[absRotPosition(3),absPositionOnEarth(3)]);
	
		set(trajectoryLineFut,'XData',trajectoryData(1,iteration:end),'YData',trajectoryData(2,iteration:end),'ZData',trajectoryData(3,iteration:end));
		set(trajectoryLinePast,'XData',trajectoryData(1,1:iteration),'YData',trajectoryData(2,1:iteration),'ZData',trajectoryData(3,1:iteration)); 
		
		if textCheck
			bottomLeftText = {sprintf('height (m): %.1f',currectHeight),... %<SM:STRING>
			sprintf('longitude (deg): %.5f',rad2deg(rotPosition(2))),...
			sprintf('latitude (deg): %.5f',90-rad2deg(rotPosition(3))),...
			sprintf('tanVelocity (m/s): %.1f',abs(scalerData(15,iteration))),...
			sprintf('sphericalPosition1: %.f',vectorData(2,1,iteration)),...
			sprintf('sphericalPosition2 (deg): %.5f',rad2deg(vectorData(2,2,iteration))),...
			sprintf('sphericalPosition3 (deg): %.5f',90-rad2deg(vectorData(2,3,iteration))),...
			sprintf('groundVelocity (u/d): %.1f',vectorData(6,1,iteration)),...
			sprintf('groundVelocity (s/n): %.1f',vectorData(6,2,iteration)),...
			sprintf('groundVelocity (e/w): %.1f',vectorData(6,3,iteration)),...
			sprintf('localvelocity (u/d): %.1f',vectorData(7,1,iteration)),...
			sprintf('localvelocity (s/n): %.1f',vectorData(7,2,iteration)),...
			sprintf('localvelocity (e/w): %.1f',vectorData(7,3,iteration)),...
			sprintf('windVelcoty (s/n): %.1f',vectorData(8,2,iteration)),...
			sprintf('windVelcoty (e/w): %.1f',vectorData(8,3,iteration)),...
			sprintf('localAcc (u/d): %.2f',vectorData(10,1,iteration)),...
			sprintf('localAcc (s/n): %.2f',vectorData(10,2,iteration)),...
			sprintf('localAcc (e/w): %.2f',vectorData(10,3,iteration))};

			bottomRightText = {sprintf('In Space: %s',isInSpace),...
			sprintf('Density (kg/m^3): %.5f',scalerData(9,iteration)),...
			sprintf('Pressure (Pa): %.f',scalerData(11,iteration)),...
			sprintf('Temperature (K): %.2f',scalerData(10,iteration)),...
			sprintf('SpeedOfSound (m/s): %.2f',scalerData(5,iteration)),...
			sprintf('windDir (deg): %.2f',rad2deg(scalerData(12,iteration))),...
			sprintf('windSpeed (m/s): %.2f',scalerData(13,iteration)),...
			sprintf('speedInWind (m/s): %.2f',scalerData(14,iteration)),...
			sprintf('gravity (m/s^2): %.5f',scalerData(16,iteration)),...
			sprintf('mach: %.2f',scalerData(6,iteration)),...
			sprintf('speed (m/s): %.3f',scalerData(3,iteration)),...
			sprintf('dragCof: %.3f',scalerData(8,iteration)),...
			sprintf('staticEarthSpeed (m/s): %.2f',scalerData(18,iteration)),...
			sprintf('magAcceleration (m/s^2): %.3f',scalerData(4,iteration))};
			
			topRightText = {sprintf('Time (s): %.2f',scalerData(1,iteration)),...
			sprintf('dt (s): %.3f',scalerData(19,iteration)),...
			sprintf('frame: %.f',frame),...
			sprintf('iteration: %.f',iteration),...
			sprintf('renderTime (ms): %.2f',frameEndTime*1000),...
			sprintf('FPS (Hz): %.2f',FPS),...
			sprintf('runTime (s): %.2f',toc(simStartTime)),...
			sprintf('framesLeft: %1.f',numFrames-frame),...
			sprintf('hoopRadius (m): %.f',hoopSize)};
			
			topLeftText = {sprintf('magDragForce (N) %.3f',scalerData(7,iteration)),...
			sprintf('dragForce1 (N) %.3f',vectorData(13,1,iteration)),...
			sprintf('dragForce2 (N) %.3f',vectorData(13,2,iteration)),...
			sprintf('dragForce3 (N) %.3f',vectorData(13,3,iteration)),...
			sprintf('buoyancyForce (N) %.3f',vectorData(11,1,iteration)),...
			sprintf('gravityForce (N) %.3f',vectorData(12,1,iteration)),...
			sprintf('magTotalLocalForce (N) %.3f',norm(vectorData(16,:,iteration))),...
			sprintf('totalLocalForce1 (N) %.3f',vectorData(16,1,iteration)),...
			sprintf('totalLocalForce2 (N) %.3f',vectorData(16,2,iteration)),...
			sprintf('totalLocalForce3 (N) %.3f',vectorData(16,3,iteration)),...
			sprintf('Thrust (N) %.3f',vectorData(15,1,iteration)),...
			sprintf('trustDir (deg) %.3f',90+rad2deg(vectorData(15,3,iteration))),...
			sprintf('thrustAngle (deg) %.3f',rad2deg(vectorData(15,2,iteration)))};
			
			mainText = horzcat(bottomLeftText,bottomRightText,topRightText,topLeftText);
		
			for i=1:length(mainText)
				set(telemetry(i),'String',mainText{i});
			end	
		end
		pauseTime = (1/framesPerSecond) - frameEndTime;
		if frameEndTime < 1/framesPerSecond
			pause(pauseTime);
			FPS = framesPerSecond;
		else
			drawnow;
			FPS = 1/frameEndTime;
		end
		sumOfFPS = sumOfFPS + FPS;
		frameEndTime = toc(frameStartTime);
		iteration = iteration + iterationsPerFrame;
		frame = frame + 1;
	end
	fprintf('3D Simulation Complete.\n');
	%%% end animation %%%
	avgFPS = max(sumOfFPS / frame,10);
	endAnimationTime = 5;
	nFrames = floor(avgFPS * endAnimationTime);
	
	startCameraPoint = cartesionToSpherical(absRotPosition + cameraPos);
	startCameraTarget = absRotPosition;
	startLonitude = rad2deg(startCameraPoint(2));
	startLatitude = rad2deg(startCameraPoint(3)); % acutal latitude is 90-latitude
	s = 18;
	k = 2;
	if endCheck
		fprintf('Starting End Animation.\n');
		for i=-nFrames:0.3:0
			t = (2*exp(i/s)-exp(2*i/s)-2*exp((-nFrames)/s)-exp(2*(-nFrames)/s))/(1-2*exp((-nFrames)/s)-exp(2*(-nFrames)/s)); % this is what magic looks like
			b = (exp(k*(t-1))-exp(-k))/(1-exp(-k)); % more magic. I gave up on variable names btw
			cameraHeight = startCameraPoint(1)*(1-b) + earthRadius*17*b;
			lonitude = deg2rad((t/4*nFrames)+startLonitude);
			latitude = deg2rad((90-startLatitude)*t+startLatitude);
			cameraPoint = sphericalToCartesion([cameraHeight,lonitude,latitude]);
			camreaTarget = startCameraTarget*(1-b);
			camupVector = (cameraPoint'/norm(cameraPoint))*(1-b) + [0,0,1]*b;
			
			camtarget(mainAx,camreaTarget);
			campos(mainAx,cameraPoint);
			camup(mainAx,camupVector);
			drawnow;
		end
	end
	fprintf('Program End.\n');
end
