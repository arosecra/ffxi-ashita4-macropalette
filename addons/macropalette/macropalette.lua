
addon.name      = 'macropalette';
addon.author    = 'arosecra';
addon.version   = '1.0';
addon.desc      = 'A small macropalette always on screen';
addon.link      = 'https://github.com/arosecra/ffxi-ashita4-macropalette';

local imgui = require('imgui');
local common = require('common');

local macros = require('macros');
local macrorunner = require('macrorunner');
local macrolocator = require('macrolocator');
local helper = require('helper');
local jobs = require('res/jobs');

local macropalette_window = {
    is_open                 = { true }
};

local runtime_config = {
	current_row = 1,
	tab                     = "Combat",
	tab_type                = "Macros"
};

ashita.events.register('load', 'macropalette_load_cb', function ()
    print("[Example] 'load' event was called.");
	AshitaCore:GetConfigurationManager():Load(addon.name, 'macropalette\\macropalette.ini');
	runtime_config.tab = AshitaCore:GetConfigurationManager():GetString(addon.name, "settings", "defaulttab");
	runtime_config.tab_type = AshitaCore:GetConfigurationManager():GetString(addon.name, "settings", "tabs.type." .. runtime_config.tab);
end);

ashita.events.register('command', 'macropalette_command_cb', function (e)
    if (not e.command:startswith('/macropalette') and not e.command:startswith('/mp')) then
		return;
    end
    print("[Example] Blocking '/mp' command!");
    e.blocked = true;
end);

ashita.events.register('plugin_event', 'macropalette_plugin_event_cb', function (e)
    if (not e.name:startswith('/macropalette') and not e.name:startswith('/mp')) then
		return;
    end
    print("[Example] Blocking '/mp' command!");
    e.blocked = true;
end);

ashita.events.register('d3d_beginscene', 'd3d_beginscene_callback1', function (isRenderingBackBuffer)

	--reset the runtime_config so that we drop old class data
	runtime_config = {
		current_row = runtime_config.current_row,
		tab = runtime_config.tab,
		tab_type = runtime_config.tab_type
	}

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

	local buttonsperrow = tonumber(AshitaCore:GetConfigurationManager():GetString(addon.name, "settings", "buttonsperrow"));
    if imgui.Begin(addon.name, macropalette_window.is_open) then
		if imgui.BeginTable(addon.name, 8+1, ImGuiTableFlags_SizingFixedFit, 0, 0) then
			imgui.TableNextColumn();
			imgui.Text("Pages");
			imgui.TableNextColumn();
			
			helper.get_string_table(addon.name, "settings", "tabs.names"):each(function(tab, tab_index) 
				local displayTab = tab .. string.rep(' ', 8 - #tab)
				if imgui.SmallButton(displayTab) then
					runtime_config.tab = string.trim(displayTab)
					runtime_config.tab_type = AshitaCore:GetConfigurationManager():GetString(addon.name, "settings", "tabs.type." .. string.trim(displayTab));
				end
				imgui.TableNextColumn();
			end);
			
			imgui.TableNextRow(0,0);
			--imgui.Text(runtime_config.tab);
			imgui.TableNextColumn();
			imgui.TableNextColumn();
			
			helper.get_string_table(addon.name, "settings", "buttonslabel"):each(function(label, label_index)
			
				imgui.Text(label);
				imgui.TableNextColumn();
			
			end);
			imgui.TableNextRow(0,0);
			
			if runtime_config.tab_type == "JobSettings" then
				
			elseif runtime_config.tab_type == "Macros" then
				macros.draw_table(runtime_config)
			end
			
			
			if runtime_config.tab_type == "JobSettings" then
				
			elseif runtime_config.tab_type == "Macros" then
				macros.draw_after_table(runtime_config)
			end
			
			imgui.EndTable();
		end
		
	end
    imgui.End();
end);