Quoted = {
    -- _inner: Value
}

function Quoted.new(inner) ---> Quoted
    self = { _inner = inner }
    setmetatable(self, Quoted)
    return self
end

function Quoted:__tostring() ---> string
    return "'" .. tostring(self._inner)
end
