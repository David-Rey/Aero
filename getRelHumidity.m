
%%% Inputs %%%
%Temp: temperature
%dewPoint: dew point

%%% Output %%%
%Rel: relative humidity in %

function rel = getRelHumidity(temp, dewPoint)
	c = 6.11.*10.^(7.5.*temp./(237.7+temp));
	d = 6.11.*10.^(7.5.*dewPoint./(237.7+dewPoint));
	rel = d./c.*100;
end

%https://www.wpc.ncep.noaa.gov/html/dewrh.shtml