
runtime! syntax/op.vim

syn keyword cppType       u8 u16 u32 u64
syn keyword cType       u8 u16 u32 u64
syn keyword cConstant     __FUNCTION__

syn match cFunctions "\<[a-zA-Z_][a-zA-Z_0-9]*\>[^()]*)("me=e-2
syn match cFunctions "\<[a-zA-Z_][a-zA-Z_0-9]*\>\s*("me=e-1

syn match classPre "\<[a-zA-Z_][a-zA-Z_0-9]*\>[^ ()\[\]:<]*::"me=e-2

" syn match classObject "\<[a-zA-Z_][a-zA-Z_0-9]*\>[^ ()\[\]:<]*\."me=e-1
" syn match classObject "\<[a-zA-Z_][a-zA-Z_0-9]*\>[^ ()\[\]:<]*->"me=e-2
" syn match classObject "\*\<[a-zA-Z_][a-zA-Z_0-9]*\>*"ms=s+1
" syn match classObject "\*\*\<[a-zA-Z_][a-zA-Z_0-9]*\>*"ms=s+2
" syn match classObject "\*\*\*\<[a-zA-Z_][a-zA-Z_0-9]*\>*"ms=s+3

