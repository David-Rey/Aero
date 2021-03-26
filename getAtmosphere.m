
%%% Output %%%
%interpWeather: 2D weather array containing all interpolated data
%NOAAdataAvailable: boolean value of if NOAA data is available
%NOAAdataReliable: boolean value of if NOAA data is reliable
%currectLocationID: 3 charter string of location 
%dateID: returns date from data
%URL: returns URL as string

% interpWeather: height 1, pressure 2, temp 3, dewpoint 4, wind dir 5,
% wind speed (kt) 6 ,density 7, speed of sound 8, rel. humidity 9

function [NOAAdataAvailable,NOAAdataReliable,finalWeather] = getAtmosphere(currectLocationID)
	warning('off');
	NOAAdataAvailable = false;
	NOAAdataReliable = false;
	finalWeather = [];

	date = string(datetime('now','Format','yyMMdd')); % gets currecnt date
	URL = 'https://www.spc.noaa.gov/exper/soundings/'; % first half of the URL
	URL = strcat(URL,date,'00_OBS/',currectLocationID,'.txt'); % combines to get valid URL
	fileName = 'weatherData.txt'; % name of the file where data is located
	try
		websave(fileName,URL); % attemps to open file (may result in error however in try)
		NOAAdataAvailable = true; % no error therfore data is available
		
		%%% scanning file & get data %%%
		fileID = fopen(fileName); % opens the file
		weatherData = textscan(fileID, '%s'); % scans data so data is one long string
		weatherData = string(weatherData{1}); 
		indexStart = find(weatherData == '%RAW%'); % elements after '%RAW%' is where the data is at %<SM:SEARCH> 
		indexEnd = find(weatherData == '%END%'); % elements before '%END%' is where the data is at
		weatherData = weatherData(indexStart+1:indexEnd-1); % removes unessay data
		linesOfData = (indexEnd - indexStart - 1) / 6; % number of lines of data
		weatherArray = str2double(reshape(weatherData,[6,linesOfData])); % reshapes and makes all data doubles
		if ismember(-9999,weatherArray(1:4,:)) == 0 % if there are any -9999 is the first 3 col. then data is unreliable
			NOAAdataReliable = true; % if statment is true then data is reliable

			weatherArray(weatherArray == -9999) = NaN; % removes all -9999 values
			weatherArray(5,:) = deg2rad(weatherArray(5,:)); % deg 2 rad for wind
			maxAltitudeWData = round(weatherArray(2,linesOfData)); % the highest altitude the data goes to
			for i=5:6 %<SM:SEARCH> This for loop finds the last element that is not NaN and sets it to the last element for row 5 and 6
				lastWindDir = find(~isnan(weatherArray(i,:))); % last value wind dir to the last available data
				weatherArray(i,end) = weatherArray(i,lastWindDir(end)); % sets last value wind dir to the last available data
			end

			%%% Extending ATM %%%
			maxAltitude = 86000; % highest alt. that the stnadard ATM goes up to
			leftOver = maxAltitude - maxAltitudeWData; % diffrance between max altitude (86000m) to max alt. w/ data
			leadPeriod = 2000; % the amount of altitude from when the data ATM to STAN ATM
			dh = 0:maxAltitude; % array from 1 to max altitude
			
			extraArr = zeros(4,(floor((86000-leadPeriod)/leadPeriod))); % adds array that goes beyond the data
			index = 1; % sets index = 1
			
			for h=maxAltitudeWData+leadPeriod:500:86000
				[pressure,~,temprature] = getStandardATM(h); % get data from STND ATM
				extraArr(1,index) = h;
				extraArr(2,index) = pressure/100;
				extraArr(3,index) = temprature-273;
				index = index + 1;
            end
			finalWeather(1,:) = dh; % height (m)
			finalWeather(2,:) = makima([weatherArray(2,:),extraArr(1,:)],[weatherArray(1,:),extraArr(2,:)],dh)*100; % pressure (Pa)
			finalWeather(3,:) = makima([weatherArray(2,:),extraArr(1,:)],[weatherArray(3,:),extraArr(3,:)],dh)+273.15; % temp. (K)
			finalWeather(4,:) = [makima(weatherArray(2,:),weatherArray(4,:),0:maxAltitudeWData),NaN(1,leftOver)]; % dewpoint (C)
			finalWeather(5,:) = [makima(weatherArray(2,:),weatherArray(5,:),0:maxAltitudeWData),zeros(1,leftOver)]; % wind dir (rad)
			finalWeather(6,:) = [makima(weatherArray(2,:),weatherArray(6,:),0:maxAltitudeWData),zeros(1,leftOver)]*0.514444; % wind speed (m/s)
			finalWeather(7,:) = finalWeather(2,:)./287./(finalWeather(3,:)); % density (kg/m^3)
			finalWeather(8,:) = sqrt(1.401*8.3145*(finalWeather(3,:)+273.15)/28.9647*1000); % speed of sound (m/s)
			finalWeather(9,:) = getRelHumidity(finalWeather(3,:)-273.15,finalWeather(4,:)); % rel. humidity (%)
			finalWeather(9,:) = min(finalWeather(9,:),100); % rel. humidity must be between 0 and 100
			finalWeather(9,:) = max(finalWeather(9,:),0);
			finalWeather(9,maxAltitudeWData:end) = NaN; % rel, humidity higher than where there is data is NaN
		end
	end
end
