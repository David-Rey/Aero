% Returns a unit vector exuding any NaN from the norm function

function unitVector = getUnitVector(vector)
	unitVector = vector / norm(vector);
	if isnan(unitVector)
		unitVector = vector;
	end
end