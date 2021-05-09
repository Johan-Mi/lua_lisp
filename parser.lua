require 'option'

function parse_integer(tokens, start)
    local num = tonumber(tokens[start])

    if num == nil then
        return None
    else
        return Some { data = num, tokens = tokens, start = start + 1 }
    end
end
