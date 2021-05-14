require 'option'

local function parse_number(tokens, start)
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
local parse_rparen = parser_for_token_kind 'rparen'
local parse_quote = parser_for_token_kind 'quote'

local function parse_dot(tokens, start)
    local token = tokens[start]
    if token == nil or token.kind ~= 'ident' or token.data ~= '.' then
        return None
    end

    return Some { start = start + 1 }
end

local function parse_quoted_expression(tokens, start)
    return parse_quote(tokens, start):and_then(
               function(a)
            return parse_expression(tokens, a.start)
        end):map(Quoted.new)
end

local function parse_cons(tokens, start)
    start = parse_lparen(tokens, start):map(
                function(parsed)
            return parsed.start
        end):unwrap()
    if parsed == nil then
        return None
    end

    local function parse_cons_helper(start)
        local parsed = parse_rparen(tokens, start):unwrap()
        if parsed ~= nil then
            return Some { data = Cons.new(), start = parsed.start }
        end

        local parsed = parse_expression(tokens, start):unwrap()
        if parsed == nil then
            return None
        end
        start = parsed.start
        local first_expr = parsed.data

        local parsed = parse_dot(tokens, start):unwrap()
        if parsed ~= nil then
            start = parsed.start

            local parsed = parse_expression(tokens, start):unwrap()
            if parsed == nil then
                return None
            end
            start = parsed.start
            local last_expr = parsed.data

            local parsed = parse_rparen(tokens, start):unwrap()
            if parsed == nil then
                return None
            end
            start = parsed.start

            return
                Some { data = Cons.new(first_expr, last_expr), start = start }
        end

        local parsed = parse_cons_helper(start):unwrap()
        if parsed == nil then
            return None
        end
        start = parsed.start
        local rest = parsed.data

        return Some { data = Cons.new(first_expr, rest), start = start }
    end

    return parse_cons_helper(start)
end

local function parse_expression(tokens, start)
    for _, parser in pairs {
        parse_cons,
        parse_quoted_expression,
        parse_number,
        parse_symbol,
    } do
        local parsed = parser(tokens, start):unwrap()
        if parsed ~= nil then
            return Some { data = Value.new(parsed.data), start = parsed.start }
        end
    end
end

function parse_expressions(tokens, start)
    local ret = {}

    while true do
        local parsed = parse_expression(tokens, start):unwrap()

        if parsed == nil then
            if tokens[start] == nil then
                return Some(ret)
            else
                return None
            end
        end

        start = parsed.start
        table.insert(ret, start.data)
    end
end
