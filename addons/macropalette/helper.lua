

local common = require('common');

local helper = {};


helper.get_string_table = function(alias, section, key)
	local result = T{}
	local configManager = AshitaCore:GetConfigurationManager();
	local size = configManager:GetUInt16(alias, section, key .. ".size", 0);
	if size ~= 0 then
		for i=1,size do
			local s = configManager:GetString(alias, section, key .. "[" .. i .. "]")
			result = result:append(s)
		end
	else
		local s = configManager:GetString(alias, section, key)
		if s ~= nil then
			s = s:slice(2, #s-1);
			local parts = s:split(",", 0, false)
			for i,k in pairs(parts) do
				if k ~= nil then
					local trimmed = string.trim(k)
					result[i]=trimmed
				else
					result[i] = k
				end
			end
		end
	end
	return result
end



return helper;