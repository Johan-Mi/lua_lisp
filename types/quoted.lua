Quoted = {}

function Quoted.new(inner)
    self = { _inner = inner }
    setmetatable(self, Quoted)
    return self
end
