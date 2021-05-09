Option = {}

require 'result'

None = {}
setmetatable(None, Option)

function Some(inner)
    self = { _value = inner }
    setmetatable(self, Option)
    return self
end

function Option:is_some()
    return self._value ~= nil
end

function Option:is_none()
    return self._value == nil
end

function Option:map(func)
    if self:is_some() then
        return Some(func(self._value))
    else
        return None
    end
end

function Option:filter(predicate)
    if self:is_some() and predicate(self._value) then
        return self
    else
        return None
    end
end

function Option:or_else(func)
    if self:is_some() then
        return self
    else
        return func()
    end
end

function Option:ok_or(func)
    return self.map(Ok):or_else(function()
        return Err(default)
    end)
end
