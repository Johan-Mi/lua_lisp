Function = {}

function Function.new(obj)
    assert obj.parameters ~= nil
    assert obj.body ~= nil

    setmetatable(obj, Function)
    return obj
end

function Function:__tostring()
    return string.format('function %s => %s', self.parameters, self.body)
end
