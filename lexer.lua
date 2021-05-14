Token = {}

function Token.new(obj)
    setmetatable(obj, Token)
    return obj
end

function Token:__tostring()
    if self.kind == 'ident' then
        return 'ident ' .. self.name
    else
        return self.kind
    end
end

function lex(s)
    local ret = {}

    local string_buffer = ''

    function push_current()
        if #string_buffer ~= 0 then
            table.insert(ret, Token.new { kind = 'ident', name = string_buffer })
            string_buffer = ''
        end
    end

    for c in s:gmatch '.' do
        if c == '(' then
            push_current()
            table.insert(ret, Token.new { kind = 'lparen' })
        elseif c == ')' then
            push_current()
            table.insert(ret, Token.new { kind = 'rparen' })
        elseif c == "'" then
            push_current()
            table.insert(ret, Token.new { kind = 'quote' })
        elseif c == ' ' or c == '\t' or c == '\n' then
            push_current()
        else
            string_buffer = string_buffer .. c
        end
    end

    push_current()

    return ret
end
