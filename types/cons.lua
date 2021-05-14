Cons = {}
Cons.__index = Cons

function Cons.new(car, cdr)
    self = { _car = car, _cdr = cdr }
    setmetatable(self, Cons)
    return self
end

function Cons:car()
    return self._car
end

function Cons:cdr()
    return self._cdr
end

function Cons:__tostring()
    function to_cons_string(obj)
        local cons = obj:as_cons():unwrap()
        if cons ~= nil then
            if cons:car() == nil then
                return ''
            else
                return string.format(' %s%s', cons:car(),
                                     to_cons_string(cons:cdr()))
            end
        end

        return string.format(' . %s', obj)
    end

    if self:car() == nil then
        return '()'
    else
        return string.format('(%s%s)', self:car(), to_cons_string(self:cdr()))
    end
end
