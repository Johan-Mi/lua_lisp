BuiltinFunction = {
    -- _inner: function
}

function BuiltinFunction.new(inner) ---> BuiltinFunction
    self = { _inner = inner }
    setmetatable(self, BuiltinFunction)
    return self
end

function BuiltinFunction:__tostring() ---> string
    return "(builtin-function)"
end
