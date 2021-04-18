% This functioning displays the Graphical User Interface.

function data = GUIinput(varargin)
	clc;
	close all;
	
	%%% get data from xls sheet %%%
	fprintf('gathering data from xlsx sheets.\n');
	filename = 'inData.xlsx'; 
	[inData,~,~] = xlsread(filename,1,'B1:B18'); %<SM:READ> 
	
	vis = 'on';
	ani = false;
	try
		if varargin{1}
			vis = 'off';
			ani = true;
		end
	end
	
	%%% sets up figure and panels %%%
	fig = figure('Position',[200,200,1080,630],'Name','EGR115 Final Project'); % sets position of window
	
	GUItitle = 'Ballistic Trajectory Calculator';
	
	mainText = uicontrol('Style','text','Position',[20,590,600,30],'String',GUItitle,...
		'FontSize',16,'FontWeight','bold','HorizontalAlignment','left','Visible',vis);
	objectPanel = uipanel('Units','pixels','Position',[20 240 300 340]); % sets up the object panel
	environmentPanel = uipanel('Units','pixels','Position',[340 240 300 340]); % sets up the environment panel
	earthPanel = uipanel('Units','pixels','Position',[660 20 400 560]); % sets up the earth panel
	computePanel = uipanel('Units','pixels','Position',[20 20 620 200]); % sets up the compute panel
	
	%%% Object Parameters %%%
	objectParametersText = uicontrol(objectPanel,'Style','text','Position',[50,275,300,40],'String','Object Parameters',...
	'FontSize',16,'FontWeight','bold','Visible',vis,'HorizontalAlignment','left');
	% mass
	massText = uicontrol(objectPanel,'Style','text','Position',[0,240,70,20],'String','Mass (kg)','HorizontalAlignment','right','Visible',vis);
	massTextBox = uicontrol(objectPanel,'Style','edit','Position',[80,242,60,20],'String',num2str(inData(1)),'Visible',vis); %<SM:STRING>
	% area
	areaText = uicontrol(objectPanel,'Style','text','Position',[0,200,70,20],'String','Area (m^2)','HorizontalAlignment','right','Visible',vis);
	areaTextBox = uicontrol(objectPanel,'Style','edit','Position',[80,202,60,20],'String',num2str(inData(2)),'Visible',vis);
	% volume
	volumeText = uicontrol(objectPanel,'Style','text','Position',[150,240,70,20],'String','Volume (m^3)','HorizontalAlignment','right','Visible',vis);
	volumeTextBox = uicontrol(objectPanel,'Style','edit','Position',[230,242,60,20],'String',num2str(inData(3)),'Visible',vis);
	% drag coefficient
	dragCoefText = uicontrol(objectPanel,'Style','text','Position',[150,200,70,20],'String','Drag Cof.','HorizontalAlignment','right','Visible',vis);
	dragCoefTextBox = uicontrol(objectPanel,'Style','edit','Position',[230,202,60,20],'String',num2str(inData(4)),'enable','off','Visible',vis);
	% object list
	objectList = {'Point Mass','Missile','Starship','Bowling Ball'};
	objectListText = uicontrol(objectPanel,'Style','text','Position',[0,156,50,20],'String','Object: ','HorizontalAlignment','right','Visible',vis);
	objectListPopup = uicontrol(objectPanel,'Style','PopupMenu','String',objectList,'Position',[60,160,90,20],'Visible',vis);
	% update button for object drop down
	updateButton = uicontrol(objectPanel,'Style','pushbutton','Position',[180,158,110,22],'String','update',...
	'CallBack',{@updateObjectValues,objectListPopup,massTextBox,areaTextBox,volumeTextBox,dragCoefTextBox},'Visible',vis);
	% dynamic drag coefficient check box
	CDCheckBox = uicontrol(objectPanel,'Style','checkbox','Position',[20,120,160,20],'String','Dynamic Drag Coefficient',...
	'Value', 1,'CallBack',{@CDUpdate,dragCoefTextBox},'Visible',vis);
	% dynamic thrust check box
	ThrustCurveCheckBox = uicontrol(objectPanel,'Style','checkbox','Position',[20,90,170,20],'String','Dynamic Thrust Curve','Visible',vis);
	% random value genoratior
	generateRandomValBox =  uicontrol(objectPanel,'Style','text','Position',[0,40,150,20],'String','Generate Random Values:','HorizontalAlignment','right','Visible',vis);
	generateRandomValBoxButton = uicontrol(objectPanel,'Style','pushbutton','Position',[180,32,110,42],'String','Randomize',...
	'CallBack',{@generateRandomValues,massTextBox,areaTextBox,volumeTextBox,dragCoefTextBox},'Visible',vis);	

	%%% Environment Parameters %%%
	environmentParametersText = uicontrol(environmentPanel,'Style','text','Position',[25,275,300,40],'String','Environment Parameters',...
	'FontSize',16,'FontWeight','bold','Visible',vis,'HorizontalAlignment','left');
	% density 
	densityText = uicontrol(environmentPanel,'Style','text','Position',[0,240,70,20],'String','Den. (kg/m^3)','HorizontalAlignment','right','Visible',vis);
	densityTextBox = uicontrol(environmentPanel,'Style','edit','Position',[80,242,60,20],'String',num2str(inData(5)),'enable','off','Visible',vis);
	% temprature
	tempratureText = uicontrol(environmentPanel,'Style','text','Position',[0,200,70,20],'String','Temp. (C)','HorizontalAlignment','right','Visible',vis);
	tempratureTextBox = uicontrol(environmentPanel,'Style','edit','Position',[80,202,60,20],'String',num2str(inData(6)),'enable','off','Visible',vis);
	% wind direction
	windDirText = uicontrol(environmentPanel,'Style','text','Position',[150,240,74,20],'String','Wind Dir. (deg)','HorizontalAlignment','right','Visible',vis);
	windDirTextBox = uicontrol(environmentPanel,'Style','edit','Position',[230,242,60,20],'String',num2str(inData(7)),'enable','off','Visible',vis);
	% wind speed
	windSpeedText = uicontrol(environmentPanel,'Style','text','Position',[150,200,70,20],'String','Wind(m/s)','HorizontalAlignment','right','Visible',vis);
	windSpeedTextBox = uicontrol(environmentPanel,'Style','edit','Position',[230,202,60,20],'String',num2str(inData(8)),'enable','off','Visible',vis);
	% rotate earth
	rotateCheckBox = uicontrol(environmentPanel,'Style','checkbox','Position',[170,160,100,20],'String','Rotating Earth','value',1,'Visible',vis);
	% gravity
	staticGravityText = uicontrol(environmentPanel,'Style','text','Position',[160,100,100,20],'String','Gravity (m/s^2)','Visible',vis);
	staticGravityTextBox = uicontrol(environmentPanel,'Style','edit','Position',[160,72,100,20],'String','9.8','enable','off','Visible',vis);
	staticGravityCheckBox = uicontrol(environmentPanel,'Style','checkbox','Position',[170,130,100,20],'String','Static Gravity','Visible',vis,...
	'CallBack',{@updateGravityCheckBox,staticGravityTextBox});
	% location ID
	LocationIDText = uicontrol(environmentPanel,'Style','text','Position',[70,30,80,20],'String','Location ID: ','Visible',vis);
	LocationIDTextBox = uicontrol(environmentPanel,'Style','edit','Position',[160,32,100,20],'String','JAX','enable','off','Visible',vis);
	% radio buttions for atmosphere
	radioGroup = uibuttongroup(environmentPanel,'Units','pixels','Position',[30 70 110 110],'Visible',vis);
	standardATMRadioButton = uicontrol(radioGroup,'Style','radiobutton','Position',[10 40 100 30],'String','Standard',...
	'CallBack',{@standardATMUpdate,densityTextBox,tempratureTextBox,windDirTextBox,windSpeedTextBox,LocationIDTextBox},'Visible',vis);
	staticEnvRadioButton = uicontrol(radioGroup,'Style','radiobutton','Position',[10 70 100 30],'String','Staic',...
	'CallBack',{@staticEnvUpdate,densityTextBox,tempratureTextBox,windDirTextBox,windSpeedTextBox,LocationIDTextBox},'Visible',vis);
	locationRadioButton = uicontrol(radioGroup,'Style','radiobutton','Position',[10 10 100 30],'String','Location',...
	'CallBack',{@locationUpdate,densityTextBox,tempratureTextBox,windDirTextBox,windSpeedTextBox,LocationIDTextBox},'Visible',vis);

	%%% Sets up earth in Starting Condition Panel %%%
	ax = axes(earthPanel); % sets up position of earth in earthPanel
	ax.Units = 'pixels';  % uses pixels as units for ax
	ax.Position = [60 190 300 300]; % location of figure [x,y,sizeX,sizeY]

	axis equal vis3d tight off % makes graph look good
	hold on % makes graph look good
	rotate3d on % rotation pre selcted
	plotEarth(ax,1); %plots earth
	latStartPoint = inData(9);
	lonStartPoint = inData(10);
	view([90+lonStartPoint,latStartPoint]); % sets view at lon and lat
	point = sphericalToCartesion([1+(inData(11)/6371000);deg2rad(lonStartPoint);deg2rad(90-latStartPoint)]); % gets the point
	pointGUI = plot3(point(1),point(2),point(3),'r*','MarkerSize',12); % plots the point and sets it was a varible
	
	%%% Starting Condition %%%
	startingConditionText = uicontrol(earthPanel,'Style','text','Position',[100,495,400,40],'String','Starting Condition',...
	'FontSize',16,'FontWeight','bold','Visible',vis,'HorizontalAlignment','left');
	% latitude
	latText = uicontrol(earthPanel,'Style','text','Position',[0,140,80,20],'String','Latitude','Visible',vis);
	latTextBox = uicontrol(earthPanel,'Style','edit','Position',[80,142,80,20],'String',num2str(latStartPoint),'Visible',vis);
	% longitude
	lonText = uicontrol(earthPanel,'Style','text','Position',[0,110,80,20],'String','Longitude','Visible',vis);
	lonTextBox = uicontrol(earthPanel,'Style','edit','Position',[80,112,80,20],'String',num2str(lonStartPoint),'Visible',vis);
	% height
	heightText = uicontrol(earthPanel,'Style','text','Position',[0,80,80,20],'String','Height (m)','Visible',vis);
	heightTextBox = uicontrol(earthPanel,'Style','edit','Position',[80,82,80,20],'String',num2str(inData(11)),'Visible',vis);
	% direction
	directionText = uicontrol(earthPanel,'Style','text','Position',[180,140,100,20],'String','Direction (deg)','Visible',vis);
	directionTextBox = uicontrol(earthPanel,'Style','edit','Position',[280,142,80,20],'String',num2str(inData(12)),'Visible',vis);
	% angle
	angleText = uicontrol(earthPanel,'Style','text','Position',[180,110,100,20],'String','Angle (deg)','Visible',vis);
	angleTextBox = uicontrol(earthPanel,'Style','edit','Position',[280,112,80,20],'String',num2str(inData(13)),'Visible',vis);
	% velocty
	VelText = uicontrol(earthPanel,'Style','text','Position',[180,80,100,20],'String','Velocity (m/s)','Visible',vis);
	VelTextBox = uicontrol(earthPanel,'Style','edit','Position',[280,82,80,20],'String',num2str(inData(14)),'Visible',vis);
	% update buttion 
	latlonButton = uicontrol(earthPanel,'Style','pushbutton','Position',[80,20,80,30],'String','update',...
	'CallBack',{@updateLonLat,lonTextBox,latTextBox,heightTextBox,ax,pointGUI},'Visible',vis);
	% note:
	ConditionText = uicontrol(earthPanel,'Style','text','Position',[180,10,200,40],'String',...
	'Note: direction(90) = east, direction(270) = west, angle = launch angle','Visible',vis);
	% zoom slider
	zoomSlider = uicontrol(earthPanel,'Style','slider','Position',[10,190,20,300],...
	'CallBack',{@zoomEarth,ax},'Visible',vis);

	%%% Simulation Settings %%% 
	computeText =  uicontrol(computePanel,'Style','text','Position',[10,150,620,40],'String','Simulation Settings',...
	'FontSize',16,'FontWeight','bold','HorizontalAlignment','left','Visible',vis);
	% dt
	deltaTimeText = uicontrol(computePanel,'Style','text','Position',[0,120,100,20],'String','Delta Time (s)','Visible',vis);
	deltaTimeTextBox = uicontrol(computePanel,'Style','edit','Position',[100,122,100,20],'String',num2str(inData(15)),'Visible',vis);
	% dt in space
	deltaTimeInSpaceText = uicontrol(computePanel,'Style','text','Position',[0,90,100,20],'String','dt in space (s)','Visible',vis);
	deltaTimeInSpaceTextBox = uicontrol(computePanel,'Style','edit','Position',[100,92,100,20],'String',num2str(inData(16)),'Visible',vis);
	% max iteration (10^3)
	maxIterationText = uicontrol(computePanel,'Style','text','Position',[200,120,120,20],'String','Max Iteration (10^3)','Visible',vis);
	maxIterationTextBox = uicontrol(computePanel,'Style','edit','Position',[320,122,100,20],'String',num2str(inData(17)),'Visible',vis);
	% max compute time (s)
	maxComputeText = uicontrol(computePanel,'Style','text','Position',[200,90,120,20],'String','Max Compute time(s)','Visible',vis);
	maxComputeTextBox = uicontrol(computePanel,'Style','edit','Position',[320,92,100,20],'String',num2str(inData(18)),'Visible',vis);
	% description
	description = ['The following is a program developed by David Reynolds. This program calculates the trajectories of ballistic ',... 
		'objects and objects under thrust. This program takes into account drag, the rotation of the earth, change in gravity, ',...
		'atmospheric properties as a function of height and change in drag coefficient as a function of mach number. ©'];
	descriptionText = uicontrol(computePanel,'Style','text','Position',[10,0,400,80],'String',description,'HorizontalAlignment','left','Visible',vis);
	% run simulation buttin
	runSimulationButton = uicontrol(computePanel,'Style','togglebutton','Position',[440,20,160,160],'String','LAUNCH',...
	'BackgroundColor',[1 .2 .2],'FontSize',15,'FontWeight','bold','Visible',vis);

	% Ok here is the deal, you can't return stuff when you call a function with
	% GUI so figure out how to get stuck in a inf loop and when the user clicks
	% lauch contune and run the simulation. Future me here, yea I did that, thx
	
	if ani
		fprintf('Starting GUI Animation.\n');
		uiObjectsArray = [objectParametersText,massText,massTextBox,areaText,areaTextBox,volumeText,volumeTextBox,...
		dragCoefText,dragCoefTextBox,objectListText,objectListPopup,updateButton,CDCheckBox,ThrustCurveCheckBox,...
		generateRandomValBox,generateRandomValBoxButton,environmentParametersText,densityText,densityTextBox,...
		tempratureText,tempratureTextBox,windDirText,windDirTextBox,windSpeedText,windSpeedTextBox,rotateCheckBox,...
		staticGravityText,staticGravityTextBox,staticGravityCheckBox,LocationIDText,LocationIDTextBox,radioGroup,...
		standardATMRadioButton,staticEnvRadioButton,locationRadioButton,startingConditionText,latText,latTextBox,...
		lonText,lonTextBox,heightText,heightTextBox,directionText,directionTextBox,angleText,angleTextBox,VelText,...
		VelTextBox,latlonButton,ConditionText,zoomSlider,computeText,deltaTimeText,deltaTimeTextBox,deltaTimeInSpaceText,...
		deltaTimeInSpaceTextBox,maxIterationText,maxIterationTextBox,maxComputeText,maxComputeTextBox,descriptionText,...
		runSimulationButton,mainText]; % one long boi
	
		nObjects = length(uiObjectsArray);
	    stringUIobj = strings(1,nObjects);
	    for i=1:nObjects
			try
				stringUIobj(i) = get(uiObjectsArray(i),'String');
			end
		end
		stringUIobj(11) = 'Point Mass';
		animationLength = 4;
		clock = tic;
		time = toc(clock);
		while time < animationLength
			time = toc(clock);
			t = 1800 / animationLength * time; % 1710 is width + height of window
			for i=1:nObjects
				UIanimate(uiObjectsArray(i),stringUIobj(i),t);
			end
			shg;
		end
		fprintf('Animation Done.\n');
	end
	
	while(runSimulationButton.Value ~= 1)
		pause(.01);
	end
	runSimulationButton.Value = 0;
	
	dataIsValid = false;
	while ~dataIsValid %<SM:WHILE>
		if runSimulationButton.Value ~= 1 %<SM:IF> %<SM:ROP> 
			%%% object data
			mass = str2double(get(massTextBox,'String'));
			area = str2double(get(areaTextBox,'String'));
			volume = str2double(get(volumeTextBox,'String'));
			CD = str2double(get(dragCoefTextBox,'String'));
			objectIndex = get(objectListPopup,'value');
			dynamicCD = get(CDCheckBox,'Value');
			dynamicThrust = get(ThrustCurveCheckBox,'Value');
			objectData = {mass, area, volume, CD, objectIndex, dynamicCD, dynamicThrust};

			%%% Envirment
			density = str2double(get(densityTextBox,'String'));
			temperature = str2double(get(tempratureTextBox,'String'));
			windDir = str2double(get(windDirTextBox,'String'));
			windSpeed = str2double(get(windSpeedTextBox,'String'));
			if get(staticEnvRadioButton,'Value') == 1
				weatherType = '3';
			elseif get(standardATMRadioButton,'Value') == 1
				weatherType = '2';
			else
				weatherType = '1';
			end
			rotatingEarth = get(rotateCheckBox,'Value');
			staticGravityCheck = get(staticGravityCheckBox,'Value');
			staticGravityValue = str2double(get(staticGravityTextBox,'String'));
			locationID = get(LocationIDTextBox,'String');
			environmentData = {density, temperature, windDir, windSpeed, weatherType, rotatingEarth,...
				staticGravityCheck, staticGravityValue, locationID};

			%%% Starting Condition
			latitude = str2double(get(latTextBox,'String'));
			longitude = str2double(get(lonTextBox,'String'));
			height = str2double(get(heightTextBox,'String'));
			direction = str2double(get(directionTextBox,'String'));
			angle = str2double(get(angleTextBox,'String'));
			velocity = str2double(get(VelTextBox,'String'));
			startingCondition = {latitude, longitude, height, direction, angle, velocity};

			%%% simulation Settings
			dt = str2double(get(deltaTimeTextBox,'String'));
			dtInSpace = str2double(get(deltaTimeInSpaceTextBox,'String'));
			maxIteration = str2double(get(maxIterationTextBox,'String'));
			maxComputeTime = str2double(get(maxComputeTextBox,'String'));
			
			maxComputeTime = max(maxComputeTime,1);
			simulationSettings = {dt, dtInSpace, maxIteration, maxComputeTime};

			data = horzcat(objectData, environmentData, startingCondition, simulationSettings); %<SM:AUG> 
			
			dataIsValid = true;
			for i=1:length(data) %<SM:FOR> 
				if isnan(data{i}) %<SM:NEST> 
					dataIsValid = false;
				end
			end
			for i=1:length(data)
				if ~isreal(data{i}) 
					dataIsValid = false;
				end
			end
			if height < 0
				dataIsValid = false;
			end
			if dataIsValid == false
			invalidText =  uicontrol(computePanel,'Style','text','Position',[220,150,200,40],'String','Invalid Arguments',...
				'FontSize',14,'HorizontalAlignment','left','ForegroundColor',[1 0 0]);
			end
			runSimulationButton.Value = 1;
		end
		pause(0.01);
	end
	%%% save input data back to in data %%%
	saveArray = {mass,area,volume,CD,density,temperature,windDir,windSpeed,latitude,...
		longitude,height,direction,angle,velocity,dt,dtInSpace,maxIteration,maxComputeTime}';
	xlswrite(filename,saveArray,'B1:B19');
	close(fig);
end