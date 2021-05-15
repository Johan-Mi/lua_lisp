Result = {
    -- _ok?: any
    -- _err?: any
}

function Ok(inner) ---> Result
    self = { _ok = inner }
    setmetatable(self, Result)
    return self
end

function Err(inner) ---> Result
    self = { _err = inner }
    setmetatable(self, Result)
    return self
end
