Result = {}

function Ok(inner)
    self = { _ok = inner }
    setmetatable(self, Result)
    return self
end

function Err(inner)
    self = { _err = inner }
    setmetatable(self, Result)
    return self
end
