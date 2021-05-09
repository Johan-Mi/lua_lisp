Symbol = {}

require 'option'

local function is_initial(c)
    return
        ('abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ!$%&*/:<=>?^_~'):find(
            c) ~= nil
end

local function is_subsequent(c)
    return is_initial(c) or ('0123456789+.@-'):find(c) ~= nil
end

local function is_valid_symbol(name)
    if name == '+' or name == '-' or name == '...' then
        return true
    else
        if not is_initial(name.sub(1, 1)) then
            return false
        end

        for c in name.sub(2):gmatch '.' do
            if not is_subsequent(c) then
                return false
            end
        end
    end
end

function Symbol.parse(name)
    if is_valid_symbol(name) then
        self = { _name = name }
        setmetatable(self, Symbol)
        return Some(self)
    else
        return None
    end
end
