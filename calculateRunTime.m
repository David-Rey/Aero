% This calculates the runtime in the output figure when the user clicks
% “Calculate Runtime”.

function calculateRunTime(~,~,FPSText,iterationPerFrameText,nIterations,runTimeText)
	FPS = str2double(get(FPSText,'String'));
	iterationPerFrame = str2double(get(iterationPerFrameText,'String'));
	if  or(isnan(FPS), isnan(iterationPerFrame))
		return;
	end
	if or(~isreal(FPS), ~isreal(iterationPerFrame))
		return;
	end
	runTime = nIterations / FPS / iterationPerFrame;
	set(runTimeText,'String',sprintf('Run Time (s): %.2f',runTime))
end
