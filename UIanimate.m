% Animates the GUI input.

function UIanimate(uiObj,text,t)
	uiPos = getpixelposition(uiObj,true);
	xPos = uiPos(1);
	yPos = uiPos(2);
	y = xPos + 630 - t;
	lagTime = 300;
	if y < yPos
		set(uiObj,'Visible','on');
		try
			deltaSpace = yPos - y;
			percentShown = min(deltaSpace/lagTime,1);
			textLength = strlength(text);
			charsToShow = floor(percentShown*textLength)+1;
			set(uiObj,'String',extractBefore(text,charsToShow));
		end
	end
end