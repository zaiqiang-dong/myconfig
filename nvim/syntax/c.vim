
runtime! syntax/op.vim

function! s:setVarColor()
py3 << EOF
import re
import vim

keywords = set()
regexes = [re.compile(p) for p in ["(.*)struct( +)([a-zA-Z0-9_]+)( +\**)([a-zA-Z0-9_\*]+)([ ,;\)\[]+)(.*)",
				   "(.*)enum( +)([a-zA-Z0-9_]+)( +\**)([a-zA-Z0-9_\*]+)([ ,;\)\[]+)(.*)",
				   "(.*)union( +)([a-zA-Z0-9_]+)( +\**)([a-zA-Z0-9_\*]+)([ ,;\)\[]+)(.*)"]]
for line in vim.current.buffer:
    for rg in regexes:
        matchObj = re.match(rg, line)
        if matchObj:
            keywords.add(matchObj.group(5))
            break

for s in keywords:
    vim.command("syn keyword structVar " + s)

keyMacros = set()

for line in vim.current.buffer:
    print("*"*20)
    matchObj = re.match( r'([^\\|*].*[ |\(]([A-Z]+[A-Z_]*)(.*))', line)
    if matchObj:
        keyMacros.add(matchObj.group(2))

for s in keyMacros:
    vim.command("syn keyword macroDef " + s)
EOF
endfunction
call s:setVarColor()

syn keyword cppType       u8 u16 u32 u64
syn keyword cType       u8 u16 u32 u64

syn match cFunctions "\<[a-zA-Z_][a-zA-Z_0-9]*\>[^()]*)("me=e-2
syn match cFunctions "\<[a-zA-Z_][a-zA-Z_0-9]*\>\s*("me=e-1

syn match classPre "\<[a-zA-Z_][a-zA-Z_0-9]*\>[^ ()\[\]:<]*::"me=e-2

syn match classObject "\<[a-zA-Z_][a-zA-Z_0-9]*\>[^ ()\[\]:<]*\."me=e-1
syn match classObject "\<[a-zA-Z_][a-zA-Z_0-9]*\>[^ ()\[\]:<]*->"me=e-2
" syn match classObject "\*\<[a-zA-Z_][a-zA-Z_0-9]*\>*"ms=s+1
" syn match classObject "\*\*\<[a-zA-Z_][a-zA-Z_0-9]*\>*"ms=s+2
" syn match classObject "\*\*\*\<[a-zA-Z_][a-zA-Z_0-9]*\>*"ms=s+3

