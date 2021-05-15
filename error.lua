Error = {
    -- _message: string
}

function Error.new(message) ---> Error
    obj = { _message = message }
    setmetatable(obj, Error)
    return obj
end

function Error:__tostring() ---> string
    return 'Error: ' .. self._message
end
