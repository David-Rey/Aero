function unitVector = getUnitVector(vector)
	unitVector = vector / norm(vector);
	if isnan(unitVector)
		unitVector = vector;
	end
end