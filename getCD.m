function CD = getCD(machData, mach, staticCD)
	if isempty(machData)
		CD = staticCD;
		return;
	end
	if isnan(mach)
		CD = NaN;
		return;
	end
	if mach < machData(1,end)
		mach = max(0,mach);
		machLower = floor(mach*100+1); % don't change the 100
		machUpper = floor(mach*100+2);
		CDlower = machData(2,machLower);
		CDupper = machData(2,machUpper);
		CD = interp1([machLower,machUpper],[CDlower,CDupper],mach*100+1);
	else
		CD = machData(2,end);
	end
end