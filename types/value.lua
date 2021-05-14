Value = {}
Value.__index = Value

require 'option'
require 'result'
require 'error'

function Value:__tostring()
    return tostring(self._value)
end

function Value.new(inner)
    obj = { _value = inner }
    setmetatable(obj, Value)
    return obj
end

function Value:is_cons()
    return getmetatable(self._value) == Cons
end

function Value:as_cons()
    if self:is_cons() then
        return Some(self._value)
    else
        return None
    end
end

function Value:car()
    return self:as_cons():map(Cons.car):ok_or(
               Error.new "tried to get `car` of non-cons value")
end

function Value:cdr()
    return self:as_cons():map(Cons.cdr):ok_or(
               Error.new "tried to get `cdr` of non-cons value")
end
