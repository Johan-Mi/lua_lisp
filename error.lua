Error = {}

function Error.new(message)
    obj = { _message = message }
    setmetatable(obj, Error)
    return obj
end

function Error:__tostring()
    return 'Error: ' .. self._message
end
