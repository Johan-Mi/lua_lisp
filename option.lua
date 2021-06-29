M = {}

require 'result'

function M.map(self, func)
    if self == nil then
        return nil
    else
        return func(self)
    end
end

function M.filter(self, predicate)
    if self ~= nil and predicate(self) then
        return self
    else
        return nil
    end
end

function M.or_else(self, func)
    if self == nil then
        return func()
    else
        return self
    end
end

function M.ok_or(self, default)
    return M.map(self, Ok):or_else(function()
        return Err(default)
    end)
end

return M
