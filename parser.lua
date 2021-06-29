local opt = require 'option'
require 'types.value'
require 'types.symbol'
require 'types.cons'
require 'types.quoted'

local function parse_number(tokens, start) ---> { data: number, start: number }?
    local num = tokens[start]
    if num == nil or num.kind ~= 'ident' then
        return nil
    end

    num = tonumber(num.name)
    if num == nil then
        return nil
    else
        return { data = num, start = start + 1 }
    end
end

local function parse_symbol(tokens, start) ---> { data: Symbol, start: number }?
    local token = tokens[start]
    if token == nil or token.kind ~= 'ident' then
        return nil
    end

    local symbol = Symbol.parse(token.name)
    return opt.map(symbol, function(s)
        return { data = s, start = start + 1 }
    end)
end

local function parser_for_token_kind(kind) ---> function(tokens, start) -> { start: number }?
    return function(tokens, start)
        local token = tokens[start]
        if token == nil or token.kind ~= kind then
            return nil
        end

        return { start = start + 1 }
    end
end

local parse_lparen = parser_for_token_kind 'lparen'
local parse_rparen = parser_for_token_kind 'rparen'
local parse_quote = parser_for_token_kind 'quote'

local function parse_dot(tokens, start) ---> { start: number }?
    local token = tokens[start]
    if token == nil or token.kind ~= 'ident' or token.name ~= '.' then
        return nil
    end

    return { start = start + 1 }
end

local function parse_quoted_expression(tokens, start) ---> { data: Quoted, start: number }?
    return opt.map(opt.map(parse_quote(tokens, start), function(a)
        return parse_expression(tokens, a.start)
    end, Quoted.new))
end

local function parse_cons_helper(tokens, start) ---> { data: Cons, start: number }?
    local parsed = parse_rparen(tokens, start)
    if parsed ~= nil then
        return { data = Cons.new(), start = parsed.start }
    end

    local parsed = parse_expression(tokens, start)
    if parsed == nil then
        return nil
    end
    start = parsed.start
    local first_expr = parsed.data

    local parsed = parse_dot(tokens, start)
    if parsed ~= nil then
        start = parsed.start

        local parsed = parse_expression(tokens, start)
        if parsed == nil then
            return nil
        end
        start = parsed.start
        local last_expr = parsed.data

        local parsed = parse_rparen(tokens, start)
        if parsed == nil then
            return nil
        end
        start = parsed.start

        return { data = Cons.new(first_expr, last_expr), start = start }
    end

    local parsed = parse_cons_helper(tokens, start)
    if parsed == nil then
        return nil
    end
    start = parsed.start
    local rest = parsed.data

    return { data = Cons.new(first_expr, Value.new(rest)), start = start }
end

local function parse_cons(tokens, start) ---> { data: Cons, start: number }?
    local parsed = parse_lparen(tokens, start)
    if parsed == nil then
        return nil
    end
    start = parsed.start
    return parse_cons_helper(tokens, start)
end

function parse_expression(tokens, start) ---> { data: Value, start: number }?
    for _, parser in pairs {
        parse_cons,
        parse_quoted_expression,
        parse_number,
        parse_symbol,
    } do
        local parsed = parser(tokens, start)
        if parsed ~= nil then
            return { data = Value.new(parsed.data), start = parsed.start }
        end
    end

    return nil
end

function parse_expressions(tokens, start) ---> { Value }?
    if start == nil then
        start = 1
    end

    local ret = {}

    while true do
        local parsed = parse_expression(tokens, start)

        if parsed == nil then
            if tokens[start] == nil then
                return ret
            else
                return nil
            end
        end

        start = parsed.start
        table.insert(ret, parsed.data)
    end
end
