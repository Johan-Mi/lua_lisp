Quoted = {}

function Quoted.new(inner)
    self = { _inner = inner }
    setmetatable(self, Quoted)
    return self
end

function Quoted:__tostring()
    return "'" .. tostring(self._inner)
end
