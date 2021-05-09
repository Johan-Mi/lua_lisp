function lex(s)
    local ret = {}

    local string_buffer = ''

    function push_current()
        if #string_buffer ~= 0 then
            table.insert(ret, { kind = 'ident', name = string_buffer })
            string_buffer = ''
        end
    end

    for c in s:gmatch '.' do
        if c == '(' then
            push_current()
            table.insert(ret, { kind = 'lparen' })
        elseif c == ')' then
            push_current()
            table.insert(ret, { kind = 'rparen' })
        elseif c == "'" then
            push_current()
            table.insert(ret, { kind = 'quote' })
        elseif c == ' ' or c == '\t' or c == '\n' then
            push_current()
        else
            string_buffer = string_buffer .. c
        end
    end
end
