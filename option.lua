Option = {
    -- _value?: any
}
Option.__index = Option

require 'result'

None = {}
setmetatable(None, Option)

function Some(inner) ---> Option
    self = { _value = inner }
    setmetatable(self, Option)
    return self
end

function Option:is_some() ---> boolean
    return self._value ~= nil
end

function Option:is_none() ---> boolean
    return self._value == nil
end

function Option:map(func) ---> Option
    if self:is_some() then
        return Some(func(self._value))
    else
        return None
    end
end

function Option:and_then(func) ---> Option
    if self:is_some() then
        return func(self._value)
    else
        return None
    end
end

function Option:filter(predicate) ---> Option
    if self:is_some() and predicate(self._value) then
        return self
    else
        return None
    end
end

function Option:or_else(func) ---> Option
    if self:is_some() then
        return self
    else
        return func()
    end
end

function Option:ok_or(func) ---> Option
    return self.map(Ok):or_else(function()
        return Err(default)
    end)
end

function Option:unwrap() ---> any
    return self._value
end
