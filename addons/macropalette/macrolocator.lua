
local common = require('common');
local macrolocator = {}


macrolocator.get_active_macro_ids = function(macropalette_config, runtime_config, row_name)
	local macro_names = T{}
	local combined_name = runtime_config.tab .. "_" .. row_name
	local row_layout = macropalette_config.settings.tabs.layouts[combined_name]
	
	for i=1,macropalette_config.settings.buttonsperrow do
		if row_layout ~= nil 
			and row_layout[i] ~= nil 
			and row_layout[i] ~= "" 
			and row_layout[i] ~= "job"  then
			macro_names:append(row_layout[i])
		else 
			macro_names:append("")
		end
	end
	

	return macro_names
end


macrolocator.get_macro_by_id = function(macropalette_config, macro_id)
	local macro = {
		Spacer = true
	}
	
	if macropalette_config.macros[macro_id] ~= nil then
		macro = macropalette_config.macros[macro_id]
	end
	
	return macro
end

return macrolocator