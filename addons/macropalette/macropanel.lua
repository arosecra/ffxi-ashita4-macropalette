
local common = require('common');
local imgui = require('imgui');
local macrolocator = require('macrolocator');
local libs2config = require('org_github_arosecra/config');
local macros_configuration = require('org_github_arosecra/macros/macros_configuration');
local macrorunner = require('org_github_arosecra/macros/macrorunner');

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
			local macro_id = macro_ids[i];
			local show_timer = false;
			if runtime_config.timers[row_name] ~= nil and
			   runtime_config.timers[row_name][macro_id] ~= nil then
				
				if os.time() > runtime_config.timers[row_name][macro_id] then
					runtime_config.timers[row_name][macro_id] = nil
				else
					show_timer = true;
				end
			end

			if macro_id ~= nil and macro_id ~= "" then
				local macro = macros_configuration.get_macro_by_id(macro_id)
				if macro.macro_name ~= nil then
					if show_timer then
						macropanel.draw_timer(runtime_config, macro, row_name)
					else
						macropanel.draw_button(runtime_config, macro, row_name);
					end
				end
			end

			imgui.TableNextColumn();
		end
		imgui.TableNextRow(0,0);
	end);
end

macropanel.draw_button = function(runtime_config, macro, row_name)
	local label = macro.macro_name
	if #label > 12 then
		label = string.sub(label,1,8) .. '..';
	else
		label = label .. string.rep(' ', 8 - #label);
	end
	imgui.PushID(row_name .. macro.macro_id)
	if (imgui.SmallButton(label)) then
		macrorunner.run_macro(macro, { Name = row_name});
		if macro.recast ~= nil then
			if runtime_config.timers[row_name] == nil then
				runtime_config.timers[row_name] = {};
			end
			runtime_config.timers[row_name][macro.macro_id] = os.time() + tonumber(macro.recast);
		end
	end
	imgui.PopID(row_name .. macro.macro_id);
end

macropanel.draw_timer = function(runtime_config, macro, row_name)
	local end_time = runtime_config.timers[row_name][macro.macro_id]
	local total_time = macro.recast;
	local start_time = end_time - total_time;
	local current_time = os.time();
	local time_spent = current_time - start_time;
	local time_remaining = total_time - time_spent;

	local percentage = ( time_spent / total_time ) ;

	local style = imgui.GetStyle();
	local framePaddingYBackup = style.FramePadding.y;
	style.FramePadding.y = 0;
	imgui.ProgressBar(percentage, {-1.0, 0.0}, tostring(time_remaining));
	style.FramePadding.y = framePaddingYBackup;
end

macropanel.draw_after_table = function(runtime_config)

end

return macropanel;