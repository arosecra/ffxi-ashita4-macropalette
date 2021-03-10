
local common = require('common');
local helper = require('helper');


local macrolocator = {}

macrolocator.get_active_macro_ids = function(runtime_config, row_name)
	local macro_names = T{}
	local combined_name = runtime_config.tab .. "." .. row_name
	local row_layout = helper.get_string_table(addon.name, "macro.tabs.layout", "tabs." .. combined_name)
	
	for i=1,8 do
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


macrolocator.get_macro_by_id = function(macro_id)
	local macro = {
		spacer = true
	} 
	local macro_name = AshitaCore:GetConfigurationManager():GetString(addon.name, "macros", macro_id .. ".name");
	if macro_name ~= nil then
		macro.name = macro_name
		macro.command = AshitaCore:GetConfigurationManager():GetString(addon.name, "macros", macro_id .. ".command");
		macro.cycle = AshitaCore:GetConfigurationManager():GetString(addon.name, "macros", macro_id .. ".cycle");
		macro.script = AshitaCore:GetConfigurationManager():GetString(addon.name, "macros", macro_id .. ".script");
		macro.send_to = AshitaCore:GetConfigurationManager():GetString(addon.name, "macros", macro_id .. ".send_to");
		macro.send_target = AshitaCore:GetConfigurationManager():GetString(addon.name, "macros", macro_id .. ".send_target");
		macro.spacer = AshitaCore:GetConfigurationManager():GetString(addon.name, "macros", macro_id .. ".spacer");
	end
	
	return macro
end

return macrolocator