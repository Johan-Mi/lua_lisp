Value = {
    -- _value: any
}
Value.__index = Value

local opt = require 'option'
require 'result'
require 'error'

function Value:__tostring() ---> string
    return tostring(self._value)
end

function Value.new(inner) ---> Value
    obj = { _value = inner }
    setmetatable(obj, Value)
    return obj
end

function Value:is_cons() ---> boolean
    return getmetatable(self._value) == Cons
end

function Value:as_cons() ---> Cons?
    if self:is_cons() then
        return self._value
    else
        return nil
    end
end

function Value:car() ---> Result Value Error
    return opt.ok_or(opt.map(self:as_cons(), Cons.car),
                     Error.new "tried to get `car` of non-cons value")
end

function Value:cdr()
    return opt.ok_or(opt.map(self:as_cons(), Cons.cdr),
                     Error.new "tried to get `cdr` of non-cons value")
end
