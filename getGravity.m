% Gets gravity given height.

function g = getGravity(h,gravitybool,gravityValue)
	if gravitybool
		g = gravityValue;
		return;
	end
	re = 6371000;
	g = 9.80665 * (re / (re + h))^2;
end
