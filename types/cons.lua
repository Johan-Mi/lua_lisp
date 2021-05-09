Cons = {}

function Cons.new(car, cdr)
    obj = { car = car, cdr = cdr }
    setmetatable(obj, Cons)
    return obj
end

function Cons:car()
    return self.car
end

function Cons:cdr()
    return self.cdr
end
