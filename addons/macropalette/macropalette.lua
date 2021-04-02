
addon.name      = 'macropalette';
addon.author    = 'arosecra';
addon.version   = '1.0';
addon.desc      = 'A small macropalette always on screen';
addon.link      = 'https://github.com/arosecra/ffxi-ashita4-macropalette';

local imgui = require('imgui');
local common = require('common');

local macropanel = require('macropanel');
local libs2imgui = require('org_github_arosecra/imgui');
local libs2config = require('org_github_arosecra/config');
local jobs = require('org_github_arosecra/jobs');
local macros_configuration = require('org_github_arosecra/macros/macros_configuration');

local macropalette_window = {
    is_open                 = { true }
};

local runtime_config = {
	current_row = 1,
	tab                     = "Combat",
	tab_type                = "Macros",
	timers                  = {}
};

ashita.events.register('load', 'macropalette_load_cb', function ()
    print("[macropalette] 'load' event was called.");
	AshitaCore:GetConfigurationManager():Load(addon.name, 'macropalette\\macropalette.ini');
	macros_configuration.load();
	runtime_config.tab = AshitaCore:GetConfigurationManager():GetString(addon.name, "settings", "defaulttab");
	runtime_config.tab_type = AshitaCore:GetConfigurationManager():GetString(addon.name, "settings", "tabs.type." .. runtime_config.tab);
end);

ashita.events.register('command', 'macropalette_command_cb', function (e)
    if (not e.command:startswith('/macropalette') and not e.command:startswith('/mp')) then
		return;
    end
    print("[macropalette] Blocking '/mp' command!");
    e.blocked = true;
end);

ashita.events.register('plugin_event', 'macropalette_plugin_event_cb', function (e)
    if (not e.name:startswith('/macropalette') and not e.name:startswith('/mp')) then
		return;
    end
    print("[macropalette] Blocking '/mp' command!");
    e.blocked = true;
end);

ashita.events.register('key_data', 'key_data_callback1', function (e)
    --print(e.key)
    if (e.key == 29 or e.key == 56 or e.key == 157 or e.key == 184) then
        e.blocked = true;
    end
end);

ashita.events.register('key_state', 'key_state_callback1', function (e)
    local ffi = require('ffi');
    local ptr = ffi.cast('uint8_t*', e.data_raw);

    -- Block left-arrow key presses.. (Blocks game input; repeating.)
    if (ptr[29] ~= 0) then
        ptr[29] = 0;
    end
    if (ptr[184] ~= 0) then
        ptr[184] = 0;
    end
    if (ptr[56] ~= 0) then
        ptr[56] = 0;
    end
    if (ptr[157] ~= 0) then
        ptr[157] = 0;
    end
end);


ashita.events.register('d3d_beginscene', 'd3d_beginscene_callback1', function (isRenderingBackBuffer)

	--reset the runtime_config so that we drop old class data
	runtime_config = {
		current_row = runtime_config.current_row,
		tab = runtime_config.tab,
		tab_type = runtime_config.tab_type,
		timers = runtime_config.timers
	};

    local memoryManager = AshitaCore:GetMemoryManager();
	local resourceManager = AshitaCore:GetResourceManager();
	local player = memoryManager:GetPlayer();
	local party = memoryManager:GetParty();

	for i=0,5 do
		local mainjob = jobs[party:GetMemberMainJob(i)];
		local subjob = jobs[party:GetMemberSubJob(i)];
		local name = party:GetMemberName(i);
		runtime_config[name .. ".MainJob"] = mainjob;
		runtime_config[name .. ".SubJob"] = subjob;
	end

end);

ashita.events.register('d3d_present', 'macropalette_present_cb', function ()

	local playerEntity = GetPlayerEntity();
	if playerEntity == nil then
		return;
	end

	local windowStyleFlags = libs2imgui.gui_style_table_to_var("imguistyle", addon.name, "window.style");
	local tableStyleFlags = libs2imgui.gui_style_table_to_var("imguistyle", addon.name, "table.style");
	libs2imgui.imgui_set_window(addon.name);

	local buttonsperrow = tonumber(AshitaCore:GetConfigurationManager():GetString(addon.name, "settings", "buttonsperrow"));
    if imgui.Begin(addon.name, macropalette_window.is_open, windowStyleFlags) then
		if imgui.BeginTable("addon.name", 8+1, tableStyleFlags, 0, 0) then
			imgui.TableNextColumn();
			imgui.Text("Pages");
			imgui.TableNextColumn();

			libs2config.get_string_table(addon.name, "settings", "tabs.names"):each(function(tab, tab_index) 
				local displayTab = tab .. string.rep(' ', 8 - #tab)
				if imgui.SmallButton(displayTab) then
					runtime_config.tab = string.trim(displayTab)
					runtime_config.tab_type = AshitaCore:GetConfigurationManager():GetString(addon.name, "settings", "tabs.type." .. string.trim(displayTab));
				end
				imgui.TableNextColumn();
			end);

			imgui.TableNextRow(0,0);
			imgui.TableNextColumn();
			imgui.Text(runtime_config.tab);
			imgui.TableNextColumn();

			libs2config.get_string_table(addon.name, "settings", "buttonslabel"):each(function(label, label_index)
				imgui.Text(label);
				imgui.TableNextColumn();
			end);
			imgui.TableNextRow(0,0);

			if runtime_config.tab_type == "Macros" then
				macropanel.draw_table(runtime_config)
			end

			if runtime_config.tab_type == "Macros" then
				macropanel.draw_after_table(runtime_config)
			end

			imgui.EndTable();
		end

	end
    imgui.End();
end);