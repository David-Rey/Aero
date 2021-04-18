% This plots the output after the computation.

function plotOutput(data)
	fprintf('Plotting Trajectory.\n');
	fig = figure('Position',[200,150,1080,800],'Name','Output Plots');
	
	trajectory = data{1};
	weather = data{3};
	weatherType = data{6};
	machData = data{7};
	thrustData = data{8};

	dataPointsPerPlot = 200;
	if dataPointsPerPlot <= length(trajectory)
		arrayIndexes = floor(linspace(1,length(trajectory)-1,dataPointsPerPlot));
		simplifiedTrajectory = NaN(13,dataPointsPerPlot);
		for i=1:length(arrayIndexes)
			simplifiedTrajectory(1:6,i) = trajectory(1:6,arrayIndexes(i));
		end
	else
		simplifiedTrajectory = trajectory;
	end

	maxTime = trajectory(1,end);
	maxHeight = max(trajectory(2,:));
	maxDispHeight = min(maxHeight,86000);
	nIterations = length(trajectory)+1;
	
	% https://www.mathworks.com/help/matlab/ref/nexttile.html#mw_532c8b2a-58a1-4e2d-93cd-a52bbab8df70
	plotLayout = tiledlayout(4,3,'TileSpacing','compact','Padding','compact');
	nexttile(1);
	plot(simplifiedTrajectory(1,:),simplifiedTrajectory(2,:),'k'); %<SM:PLOT> 
	grid on
	xlabel('Time (s)');
	ylabel('Altitude (m)');
	xlim([0,maxTime]);
	
	nexttile(2);
	plot(simplifiedTrajectory(3,:),simplifiedTrajectory(2,:),'k');
	grid on
	xlabel('Speed (m/s)');
	ylabel('Altitude (m)');
	
	nexttile(4);
	plot(simplifiedTrajectory(1,:),simplifiedTrajectory(3,:),'k');
	grid on
	xlabel('Time (s)');
	ylabel('Speed (m/s)');
	xlim([0,maxTime]);
	
	nexttile(5);
	plot(simplifiedTrajectory(1,:),simplifiedTrajectory(4,:),'k');
	grid on
	xlabel('Time (s)')
	ylabel('Acceleration (m/s^2)');
	xlim([0,maxTime]);
	
	nexttile(7); % mach vs CD or time vs mach
	if ~isempty(machData)
		plot(machData(1,:),machData(2,:),'k');
		xlabel('Mach')
		ylabel('Drag coefficient');
	else
		plot(simplifiedTrajectory(1,:),simplifiedTrajectory(6,:),'k');
		xlabel('Time (s)');
		ylabel('Mach')
	end
	grid on
	
	nexttile(8);
	if ~isempty(thrustData) % time vs thrust data or acceleration vs altitude
		plot(thrustData(1,:),thrustData(2,:),'k');
		xlabel('Time (s)');
		ylabel('Thrust (N)');
	else
		plot(simplifiedTrajectory(4,:),simplifiedTrajectory(2,:),'k')
		xlabel('Acceleration (m/s^2)');
		ylabel('Altitude (m)');
	end
	grid on
	
	nexttile(3,[4,1]);
	ylabel('Altitude (m)');
	if ~isempty(weather) && strcmp(weatherType,'1')
		height = weather(1,:);
		density = weather(7,:);
		temp = weather(3,:);
		relHumidty = weather(9,:);
	else % plots STND ATM
		height = zeros(1,860);
		density = zeros(1,860);
		temp = zeros(1,860);
		for i=0:860
			h = i*100 + 1;
			height(i+1) = h;
			[~,density(i+1),temp(i+1)] = getStandardATM(h);
		end
	end
	grid on 
	ylim([0,maxDispHeight]); % https://www.mathworks.com/help/matlab/creating_plots/graph-with-multiple-x-axes-and-y-axes.html
	densityLine = line(density,height,'Color','b','LineWidth',1.5);
	ax1 = gca; % current axes
	ax1_pos = ax1.Position; % position of first axes
		
	ax2 = axes('Position',ax1_pos,'XAxisLocation','top','Color','none','YTick',[]);
	ylim([0,maxDispHeight]);
	tempLine = line(temp,height,'Parent',ax2,'Color','r','LineWidth',1.5);
	if ~isempty(weather) && strcmp(weatherType,'1')
		ax3 = axes('Position',ax1_pos,'Color','none','YTick',[],'XTickLabel',[]);
		ylim([0,maxDispHeight]);
		xlim([0,100]);
		relHumidityLine = line(weather(9,:),weather(1,:),'Parent',ax3,'Color','c','LineWidth',1.5,'LineStyle','--');
		legend([densityLine;tempLine;relHumidityLine],{'Density (kg/m^3)','Temperature (K)','Rel. Humidity (%)'},'FontSize',11);
	else
		legend([densityLine;tempLine],{'Density (kg/m^3)','Temperature (K)'},'FontSize',11);
	end
	
	Dfps = 40;
	targetRunTime = log2(nIterations+1)+2;
	DiterPerFrame = ceil(nIterations/targetRunTime/Dfps);
	runTime = nIterations/(Dfps*DiterPerFrame);
	
	textPanel = uipanel('Units','pixels','Position',[60 40 640 160]);
	simulationButton = uicontrol(textPanel,'Style','togglebutton','Position',[440,20,170,120],'String','3D Simulation',...
		'BackgroundColor',[0 1 .2],'FontSize',14,'FontWeight','bold');
	%%% info about flight %%%
	% total time
	maxTimeText = uicontrol(textPanel,'Style','text','Position',[0,120,180,20],'String',...
		sprintf('Total Time(s): %.1f',trajectory(1,end)),'HorizontalAlignment','right');
	% number of iterations
	numIterText = uicontrol(textPanel,'Style','text','Position',[0,100,180,20],'String',...
		sprintf('Number of Iterations: %.f',nIterations),'HorizontalAlignment','right');
	% max height
	maxHeightText = uicontrol(textPanel,'Style','text','Position',[0,80,180,20],'String',...
		sprintf('Max Height(m): %.f',max(trajectory(2,:))),'HorizontalAlignment','right');
	% speed on impact
	speedOnImpactText = uicontrol(textPanel,'Style','text','Position',[0,60,180,20],'String',...
		sprintf('Speed on impact (m/s): %.1f',trajectory(3,end)),'HorizontalAlignment','right');
	% max speed
	maxSpeedText = uicontrol(textPanel,'Style','text','Position',[0,40,180,20],'String',...
		sprintf('Max Speed (m/s): %.f',max(trajectory(3,:))),'HorizontalAlignment','right');
	% max acceleration
	maxAccText = uicontrol(textPanel,'Style','text','Position',[0,20,180,20],'String',...
		sprintf('Max Acceleration (m/s^2): %.1f',max(trajectory(4,:))),'HorizontalAlignment','right');
	% weatherType
	if weatherType == '1'
		weatherString = 'The weather data was gathered by NOAA.';
	elseif weatherType == '2'
		weatherString = 'Atmospheric conditions were standard.';
	else
		weatherString = 'Atmospheric conditions were static.';
	end
	weatherText = uicontrol(textPanel,'Style','text','Position',[5,0,400,20],'String',...
		weatherString,'HorizontalAlignment','left');
	%%% options to cahnge %%%
	% show text (check)
	textCheckBox = uicontrol(textPanel,'Style','checkbox','Position',[240,130,100,20],'String','Show Text','Value',1);
	% show hoops (check)
	hoopCheckBox = uicontrol(textPanel,'Style','checkbox','Position',[340,130,100,20],'String','Show Hoops','Value',1);
	% track object
	trackCheckBox = uicontrol(textPanel,'Style','checkbox','Position',[240,110,100,20],'String','Track Object','Value',1);
	% end animation
	endCheckBox = uicontrol(textPanel,'Style','checkbox','Position',[340,110,100,20],'String','End Animation','Value',1);
	% max FPS (text box)
	FPSText = uicontrol(textPanel,'Style','text','Position',[220,80,100,20],'String','frames/s (hz)');
	FPSTextBox = uicontrol(textPanel,'Style','edit','Position',[320,82,100,20],'String',num2str(Dfps));
	% iterations per frame (text box)
	skipFrameText = uicontrol(textPanel,'Style','text','Position',[220,50,100,20],'String','Iterations/frame');
	skipFrameTextBox = uicontrol(textPanel,'Style','edit','Position',[320,52,100,20],'String',num2str(DiterPerFrame));
	% output: estimated run time in seconds
	runTimeText = uicontrol(textPanel,'Style','text','Position',[310,17,120,20],'String',...
		sprintf('Run Time (s): %.2f',runTime));
	% calculate runtime button
	calculateRuntimeButton =  uicontrol(textPanel,'Style','pushbutton','Position',[210,15,100,30],'String',...
		'Calculate Runtime','CallBack',{@calculateRunTime,FPSTextBox,skipFrameTextBox,nIterations,runTimeText});
	
	while(simulationButton.Value ~= 1)
		pause(.01);
	end
	simulationButton.Value = 0;
	
	dataIsValid = false;
	while ~dataIsValid 
		if simulationButton.Value ~= 1
			FPS = str2double(get(FPSTextBox,'String')); % do error checking
			iterationsPerFrame = str2double(get(skipFrameTextBox,'String'));
			textCheck = get(textCheckBox,'Value');
			hoopCheck = get(hoopCheckBox,'Value');
			trackCheck = get(trackCheckBox,'Value');
			endCheck = get(endCheckBox,'Value');
			
			dataIsValid = true;
			if isnan(FPS) || isnan(iterationsPerFrame)
				dataIsValid = false;
			end
			if ~isreal(FPS) || ~isreal(iterationsPerFrame)
				dataIsValid = false;
			end
			FPS = round(FPS);
			iterationsPerFrame = round(iterationsPerFrame);
			if FPS <= 1 || iterationsPerFrame < 1
				dataIsValid = false;
			end 
			if dataIsValid == false
				errorText = uicontrol(textPanel,'Style','text','Position',[460,0,200,20],'String','Invalid Arguments',...
				'FontSize',12,'HorizontalAlignment','left','ForegroundColor',[1 0 0]);
			end
			simulationButton.Value = 1;
		end
		pause(0.01);
	end
	close(fig);
	run3DSimulation(data{1},data{2},FPS,iterationsPerFrame,textCheck,hoopCheck,trackCheck,endCheck);
end