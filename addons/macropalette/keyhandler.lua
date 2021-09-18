
require('common');

local keyhandler = {}

local LEFT_ALT		= 56 ;
local RIGHT_ALT		= 184;
local WIN			= 219;
local LEFT_CONTROL	= 29 ;
local RIGHT_CONTROL	= 157;
local MENU			= 221;
local LEFT_SHIFT	= 42 ;
local RIGHT_SHIFT	= 54 ;

local BREAK = 69
local INSERT = 210

local NUMPAD_0		= 82 ;
local NUMPAD_1		= 79 ;
local NUMPAD_2		= 80 ;
local NUMPAD_3		= 81 ;
local NUMPAD_4		= 75 ;
local NUMPAD_5		= 76 ;
local NUMPAD_6		= 77 ;
local NUMPAD_7		= 71 ;
local NUMPAD_8		= 72 ;
local NUMPAD_9		= 73 ;

keyhandler.control_key_states = {
	[LEFT_ALT]		 = false,
	[RIGHT_ALT]		 = false,
	[INSERT]		 = false,
	[LEFT_CONTROL]	 = false,
	[RIGHT_CONTROL]	 = false,
	[BREAK]			 = false,
	[LEFT_SHIFT]	 = false,
	[RIGHT_SHIFT]	 = false,
}
keyhandler.control_key_sections = {
	[LEFT_SHIFT]	 = 1,
	[LEFT_CONTROL]	 = 2,
	[RIGHT_SHIFT]	 = 3,
	[BREAK]		     = 4,
	[RIGHT_ALT]		 = 5,
	[MENU]			 = 6,
	[RIGHT_CONTROL]	 = 7,
	[INSERT]	     = 8,
}

keyhandler.key_state = function(e)
    local ffi = require('ffi');
    local ptr = ffi.cast('uint8_t*', e.data_raw);

    -- Block left-arrow key presses.. (Blocks game input; repeating.)
    if (ptr[LEFT_CONTROL] ~= 0) then
        ptr[LEFT_CONTROL] = 0;
    end
    if (ptr[RIGHT_ALT] ~= 0) then
        ptr[RIGHT_ALT] = 0;
    end
    if (ptr[LEFT_ALT] ~= 0) then
        ptr[LEFT_ALT] = 0;
    end
    if (ptr[RIGHT_CONTROL] ~= 0) then
        ptr[RIGHT_CONTROL] = 0;
    end
end

keyhandler.key_data = function(e)
    if e.key == LEFT_CONTROL or 
       e.key == LEFT_ALT or 
       e.key == RIGHT_CONTROL or 
       e.key == RIGHT_ALT then
        e.blocked = true;
    end

    if e.key == LEFT_ALT or 
       e.key == RIGHT_ALT or
       e.key == LEFT_CONTROL or 
       e.key == RIGHT_CONTROL or
       e.key == LEFT_SHIFT or
       e.key == RIGHT_SHIFT or
       e.key == WIN or 
       e.key == MENU or
       e.key == INSERT or
       e.key == BREAK
    then
        if e.down then
            --print("key down " .. key)
            keyhandler.control_key_states[e.key] = true
        else
            --print("key up " .. key)
            keyhandler.control_key_states[e.key] = false
        end
        return true;
    end
end

keyhandler.get_current_row_number = function() 
	local row_number = 0
	for i,j in pairs(keyhandler.control_key_states) do 
		if j then
			row_number = keyhandler.control_key_sections[i]
			break
		end
	end
	return row_number
end

return keyhandler;