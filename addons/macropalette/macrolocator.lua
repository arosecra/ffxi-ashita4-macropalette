
require('common');
local libs2config = require('org_github_arosecra/config');


local macrolocator = {}

macrolocator.get_active_macro_ids = function(runtime_config, row_name)
	local macro_names = T{}
	local combined_name = runtime_config.tab .. "." .. row_name
	local row_layout = libs2config.get_string_table(addon.name, "macro.tabs.layout", "tabs." .. combined_name)
	
	for i=1,8 do
		if row_layout ~= nil 
			and row_layout[i] ~= nil 
			and row_layout[i] ~= "" 
			and row_layout[i] ~= "job"  then
			macro_names:append(row_layout[i])
		elseif row_layout ~= nil 
			and row_layout[i] ~= nil
			and row_layout[i] == "job" then
		
			local job = runtime_config[row_name .. '.MainJob']
			local subjob = runtime_config[row_name .. '.SubJob']
			
			if job ~= nil and subjob ~= nil then
				local job_macros = libs2config.get_string_table(addon.name, "macro.tabs.layout", "tabs.job." .. job .. "." .. runtime_config.tab);
				local job_subjob_macros = libs2config.get_string_table(addon.name, "macro.tabs.layout", "tabs.job." .. job .. "_" .. subjob .. "." .. runtime_config.tab)

				if job_subjob_macros ~= nil
				  and job_subjob_macros[i] ~= nil then
					macro_names:append(job_subjob_macros[i])
				elseif job_macros ~= nil
				  and job_macros[i] ~= nil then
					macro_names:append(job_macros[i])
				else
					macro_names:append("")
				end
			else
				macro_names:append("")
			end
		else
			macro_names:append("")
		end
	end
	

	return macro_names
end


return macrolocator