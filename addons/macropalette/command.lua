
require('common');
local libs2config = require('org_github_arosecra/config');
local macrorunner = require('org_github_arosecra/macros/macrorunner');
local macros_configuration = require('org_github_arosecra/macros/macros_configuration');

local macrolocator = require('macrolocator');

local command = {};

command.help = function()

end

command.set_tab = function(runtime_config, tab_number)
    local tab_names = libs2config.get_string_table(addon.name, "settings", "tabs.names");
	runtime_config.tab = string.trim(tab_names[tab_number]);
	runtime_config.tab_type = string.trim(tab_names[tab_number]);
end

command.run_macro = function(runtime_config, row_number, column_number)
	local rows = libs2config.get_string_table(addon.name, "settings", "rows.names");
	local macro_ids = macrolocator.get_active_macro_ids(runtime_config, rows[row_number]);
	local macro_id = macro_ids[column_number];
	local macro = macros_configuration.get_macro_by_id(macro_id)
	macrorunner.run_macro(macro, { Name = runtime_config.tab});
end

return command;