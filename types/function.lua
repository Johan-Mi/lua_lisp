Function = {
    -- parameters: Cons
    -- body: Value
}

function Function.new(obj) ---> Function
    assert obj.parameters ~= nil
    assert obj.body ~= nil

    setmetatable(obj, Function)
    return obj
end

function Function:__tostring() ---> string
    return string.format('function %s => %s', self.parameters, self.body)
end
