function updateGravityCheckBox(src,~,textBox)
	if get(src,'Value')
		set(textBox,'Enable','on');
	else
		set(textBox,'Enable','off');
	end
end