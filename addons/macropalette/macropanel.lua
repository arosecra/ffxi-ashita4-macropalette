
local common = require('common');
local imgui = require('imgui');
local macrolocator = require('macrolocator');
local libs2config = require('org_github_arosecra/config');
local macros_configuration = require('org_github_arosecra/macros/macros_configuration');

local macropanel = {}

macropanel.draw_table = function(runtime_config)
	libs2config.get_string_table(addon.name, "settings", "rows.names"):each(function(row_name, row_index)

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

		local macro_ids = macrolocator.get_active_macro_ids(runtime_config, row_name)

		for i=1,8 do
			local macro = macros_configuration.get_macro_by_id(macro_ids[i])
			local label = string.rep(' ', 8)
			if macro.spacer == nil then
				label = macro.name
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

			elseif macro.spacer ~= nil then
				imgui.Text("")
			end

			imgui.TableNextColumn();
		end
		imgui.TableNextRow(0,0);
	end);
end

macropanel.draw_after_table = function(runtime_config)

end

return macropanel;