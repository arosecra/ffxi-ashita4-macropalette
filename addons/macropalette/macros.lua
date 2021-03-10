
local common = require('common');
local imgui = require('imgui');
local macrorunner = require('macrorunner');
local macrolocator = require('macrolocator');

local macros = {}

macros.draw_table = function(macropalette_window, macropalette_config, runtime_config) 
	macropalette_config.settings.rows.names:each(function(row_name, row_index)

		imgui.TableNextColumn();
		local row_label = ""
		if tonumber(row_index) == tonumber(runtime_config.current_row) then
			row_label = "(*) " .. row_name
		else
			row_label = "( ) " .. row_name
		end
		row_label = row_label .. string.rep(" ", 8-#row_name)
		
		imgui.Text(row_label);
		imgui.TableNextColumn();
		
		local macro_ids = macrolocator.get_active_macro_ids(macropalette_config, runtime_config, row_name)
		
		for i=1,macropalette_config.settings.buttonsperrow do
			local macro = macrolocator.get_macro_by_id(macropalette_config, macro_ids[i])
			local label = string.rep(' ', 8)
			if macro.Spacer == nil then
				label = macro.Name
				if #label > 12 then
					label = string.sub(label,1,8) .. '..'
				else
					label = label .. string.rep(' ', 8 - #label)
				end
			
				imgui.PushID(macro_ids[i])
				if (imgui.SmallButton(label)) then 
					print(label)
				end	
				imgui.PopID(macro_ids[i])
				
			elseif macro.Spacer ~= nil then
				if (imgui.SmallButton(label)) then 
					print(label)
				end	
			end
			
			imgui.TableNextColumn();			
		end
		imgui.TableNextRow(0,0);
		
	end);
end

macros.draw_after_table = function(macropalette_window, macropalette_config, runtime_config) 
end


macros.draw_row = function() 



end

return macros;