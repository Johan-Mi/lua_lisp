require 'option'

local function parse_integer(tokens, start)
    local num = tokens[start]
    if num == nil or num.kind ~= 'ident' then
        return None
    end

    num = tonumber(num.data)
    if num == nil then
        return None
    else
        return Some { data = num, start = start + 1 }
    end
end

local function parse_symbol(tokens, start)
    local token = tokens[start]
    if token == nil or token.kind ~= 'ident' then
        return None
    end

    local symbol = Symbol.parse(token.data)
    return symbol:map(function(s)
        return { data = s, start = start + 1 }
    end)
end

local function parser_for_token_kind(kind)
    return function(tokens, start)
        local token = tokens[start]
        if token == nil or token.kind ~= kind then
            return None
        end

        return Some { start = start + 1 }
    end
end

local parse_lparen = parser_for_token_kind 'lparen'
