

addon.name      = 'macropalette';
addon.author    = 'arosecra';
addon.version   = '1.0';
addon.desc      = 'A small macropalette always on screen';
addon.link      = 'tbd';

local imgui = require('imgui');
local common = require('common');

local macros = require('macros');
local macrorunner = require('macrorunner');
local macrolocator = require('macrolocator');

local macropalette_window = {
    is_open                 = { true }
};

local runtime_config = {
	current_row = 1,
	tab                     = "Combat",
	tab_type                = "Macros"
};

local macropalette_config = {
	settings = {
		x = 0,
		y = 0,
		defaulttab = "Combat",
		buttonsperrow = 8,
		buttonslabel = "              L         U         D          R         X         Y         A         B",
		rows = {
			size = 0,
			names=T{
				"MBox", 
				"Specktr", 
				"Sternaru", 
				"Sillyaru", 
				"Shyaru", 
				"Sassyaru", 
				"Sadaru"
			}
		}, 
		tabs = {
			size=0,
			names= T{ 
				"JobStngs", 
				"AdnStngs", 
				"Combat", 
				"NonCmbt", 
				"Actns3", 
				"Twn",
				"Buffs", 
				"Items"
			},
			types= {
				JobStngs = "JobSettings",
				AdnStngs = "Macros",
				Combat = "Macros",
				NonCmbt = "Macros",
				Actns3 = "Macros",
				Twn = "Macros",
				Buffs = "Macros",
				Items = "Macros"
			},
			layouts={
				Combat_MBox = T{ "follon", "follof", "", "warp2me", "", "", "", ""}
			}
		}
	},
	macros = {
		follon = {
			Name="follon"
		},
		follof = {
			Name="follof"
		},
		warp2me={
			Name="warp2me"
		}
	}
};

ashita.events.register('load', 'macropalette_load_cb', function ()
    print("[Example] 'load' event was called.");
	local configManager = AshitaCore:GetConfigurationManager();
	local config = configManager:Load('macropalette', 'macropalette\\macropalette.ini')
	
	
end);

ashita.events.register('key', 'key_callback1', function (e)
    --[[ Valid Arguments
        e.wparam     - (ReadOnly) The wparam of the event.
        e.lparam     - (ReadOnly) The lparam of the event.
        e.blocked    - Flag that states if the key has been, or should be, blocked.
        See the following article for how to process and use wparam/lparam values:
        https://docs.microsoft.com/en-us/previous-versions/windows/desktop/legacy/ms644984(v=vs.85)
        Note: Key codes used here are considered 'virtual key codes'.
    --]]

    --[[ Note
            The game uses WNDPROC keyboard information to process keyboard input for chat and other
            user-inputted text prompts. (Bazaar comment, search comment, etc.)
            Blocking a press here will only block it during inputs of those types. It will not block
            in-game button handling for things such as movement, menu interactions, etc.
    --]]

    -- Block left-arrow key presses.. (Blocks in chat input.)
    --print("[Example] 'load' event was called." .. e.wparam );
    --if (e.wparam == 17) then
    --    e.blocked = true;
    --end
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

local last_check = 0

ashita.events.register('d3d_present', 'macropalette_present_cb', function ()

	--if last_check == 0 then
	--	local target = AshitaCore:GetMemoryManager():GetTarget()
	--	if target ~= nil then
	--		print(target:GetIsMenuOpen())
	--	else
	--		print("Target was nil")
	--	end
	--	last_check = last_check + 1
	--else
	--	last_check = last_check + 1
	--	if last_check == 300 then
	--		last_check = 0
	--	end
	--end
	
    if (imgui.Begin('macropalette', macropalette_window.is_open)) then
        
		imgui.Text("Pages      ")
		imgui.SameLine();
		imgui.Spacing();
		imgui.SameLine();
		
		macropalette_config.settings.tabs.names:each(function(tab, tab_index) 
			local displayTab = tab .. string.rep(' ', 8 - #tab)
			if imgui.SmallButton(displayTab) then
				runtime_config.tab = string.trim(displayTab)
				runtime_config.tab_type = macropalette_config.settings.tabs.types[string.trim(displayTab)]
			end
			imgui.SameLine();
		end);
		
		
		imgui.NewLine();
		imgui.Text(runtime_config.tab);
		
		imgui.SameLine();
		imgui.Text(macropalette_config.settings.buttonslabel);
		if runtime_config.tab_type == "JobSettings" then
			
		elseif runtime_config.tab_type == "Macros" then
			macros.draw_tab(runtime_config, macropalette_config, runtime_config)
		end
		
	end
    imgui.End();
end);