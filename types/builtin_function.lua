BuiltinFunction = {}

function BuiltinFunction.new(inner)
    self = { _inner = inner }
    setmetatable(self, BuiltinFunction)
    return self
end

function BuiltinFunction:__tostring()
    return "(builtin-function)"
end
