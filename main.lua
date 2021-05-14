#!/usr/bin/lua

require 'lexer'
require 'parser'

local src = '(1 2 . 3)'

local lexed = lex(src)

print('Tokens:')
for _, token in pairs(lexed) do
    print(token)
end

local exprs = parse_expressions(lexed):unwrap()

if exprs == nil then
    print 'Error: could not parse input'
else
    print('\nExpressions:')
    for _, e in pairs(exprs) do
        print(e)
    end
end
