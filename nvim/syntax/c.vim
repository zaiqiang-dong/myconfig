runtime! syntax/op.vim
syn match cFunctions "\<[a-zA-Z_][a-zA-Z_0-9]*\>[^()]*)("me=e-2
syn match cFunctions "\<[a-zA-Z_][a-zA-Z_0-9]*\>\s*("me=e-1

syn match classPre "\<[a-zA-Z_][a-zA-Z_0-9]*\>[^ ()\[\]:<]*::"me=e-2
syn match classObject "\<[a-zA-Z_][a-zA-Z_0-9]*\>[^ ()\[\]:<]*\."me=e-1
syn match classObject "\<[a-zA-Z_][a-zA-Z_0-9]*\>[^ ()\[\]:<]*->"me=e-2
