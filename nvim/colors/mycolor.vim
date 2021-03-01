set background=dark
if version > 580
	hi clear
	if exists("syntax_on")
		syntax reset
	endif
endif

set t_Co=256
let g:colors_name = "mycolor_modified"


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"global config
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

hi Comment 		ctermfg=024 ctermbg=NONE cterm=bold
hi Normal 		ctermfg=248 ctermbg=NONE cterm=bold

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"hi let
hi Statement		ctermfg=161 ctermbg=NONE cterm=bold
" \2 \n
hi SpecialChar 		ctermfg=031 ctermbg=NONE cterm=bold
hi Pmenu         	ctermfg=031 ctermbg=234 cterm=bold
hi PmenuSel 		ctermfg=232 ctermbg=136 cterm=bold
hi PmenuSbar 		ctermfg=132 ctermbg=NONE cterm=bold
hi PmenuThumb 		ctermfg=202 ctermbg=NONE cterm=bold

hi Type 		ctermfg=035 ctermbg=NONE cterm=bold

hi TabLineSel 		ctermfg=232 ctermbg=214 cterm=bold
" / find
hi Search 		ctermfg=123 ctermbg=NONE cterm=bold

" TagbarHighlight
hi TagbarHighlight 	ctermfg=161 ctermbg=NONE cterm=bold
hi TagbarType 		ctermfg=172 ctermbg=NONE cterm=bold
hi TagbarKind 		ctermfg=070 ctermbg=NONE cterm=bold
hi TagbarFoldIcon 	ctermfg=161 ctermbg=NONE cterm=bold
hi TagbarAccessPublic 	ctermfg=070 ctermbg=NONE cterm=bold
hi TagbarAccessProtected ctermfg=132 ctermbg=NONE cterm=bold
hi TagbarAccessPravate 	ctermfg=161 ctermbg=NONE cterm=bold
" coc
hi CocSelectedText 	ctermfg=161 ctermbg=NONE cterm=bold
hi CocListFgMagenta 	ctermfg=161 ctermbg=NONE cterm=bold
hi CocListFgGreen 	ctermfg=106 ctermbg=NONE cterm=bold


" cscope pop msg
hi ModeMsg 		ctermfg=031 ctermbg=NONE cterm=bold
hi MoreMsg 		ctermfg=006 ctermbg=NONE cterm=bold
hi Title 		ctermfg=161 ctermbg=NONE cterm=bold

hi StatusLine 		ctermfg=132 ctermbg=NONE cterm=bold
hi CursorLine 		ctermfg=NONE ctermbg=234 cterm=bold
hi CursorColumn 	ctermfg=NONE ctermbg=NONE cterm=bold
hi SignColumn 		ctermfg=NONE ctermbg=234 cterm=bold
hi MatchParen 		ctermfg=NONE ctermbg=NONE cterm=bold

hi CursorLineNr 	ctermfg=161 ctermbg=NONE cterm=bold
hi LineNr 		ctermfg=239 ctermbg=NONE cterm=bold
hi VertSplit 		ctermfg=234 ctermbg=234 cterm=bold

hi Identifier 		ctermfg=070 ctermbg=NONE cterm=bold

hi DiffChange 		ctermfg=044 ctermbg=234 cterm=bold
hi DiffAdd 		ctermfg=113 ctermbg=234 cterm=bold
hi DiffDelete 		ctermfg=198 ctermbg=234 cterm=bold
hi ErrorMsg 		ctermfg=250 ctermbg=NONE cterm=bold
hi Error 		ctermfg=250 ctermbg=NONE cterm=bold
" true false
hi Constant 		ctermfg=179 ctermbg=NONE cterm=bold
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" diy
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
hi dOperator 		ctermfg=211 ctermbg=NONE cterm=bold
hi dClasss 		ctermfg=211 ctermbg=NONE cterm=bold
hi cFunctions 		ctermfg=035 ctermbg=NONE cterm=bold
hi classPre		ctermfg=037 ctermbg=NONE cterm=bold
hi classObject		ctermfg=142 ctermbg=NONE cterm=bold

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"for c/c++ language
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" if else return
hi cStatement 		ctermfg=161 ctermbg=NONE cterm=bold
hi cppStatement 	ctermfg=161 ctermbg=NONE cterm=bold
hi cLabel 		ctermfg=161 ctermbg=NONE cterm=bold
hi cConditional 	ctermfg=161 ctermbg=NONE cterm=bold
hi cRepeat 		ctermfg=161 ctermbg=NONE cterm=bold

hi cTodo 		ctermfg=001 ctermbg=238 cterm=bold

hi cNumber 		ctermfg=172 ctermbg=NONE cterm=bold
hi cFloat 		ctermfg=172 ctermbg=NONE cterm=bold
hi cOctal 		ctermfg=172 ctermbg=NONE cterm=bold
hi cOctalZero 		ctermfg=172 ctermbg=NONE cterm=bold


hi cType 		ctermfg=172 ctermbg=NONE cterm=bold
hi cppType 		ctermfg=172 ctermbg=NONE cterm=bold
hi cStructure 		ctermfg=172 ctermbg=NONE cterm=bold
"class namespace
hi cppStructure 	ctermfg=070 ctermbg=NONE cterm=bold
"const
hi cStorageClass 	ctermfg=070 ctermbg=NONE cterm=bold
hi cppStorageClass 	ctermfg=070 ctermbg=NONE cterm=bold
hi cppModifier 		ctermfg=070 ctermbg=NONE cterm=bold
hi cppCast 		ctermfg=070 ctermbg=NONE cterm=bold
" public protected private
hi cppAccess 		ctermfg=161 ctermbg=NONE cterm=bold


hi cInclude 		ctermfg=100 ctermbg=NONE cterm=bold
" define
hi cDefine 		ctermfg=149 ctermbg=NONE cterm=bold
" #ifdef
hi cPreCondit 		ctermfg=168 ctermbg=NONE cterm=bold

" NULL ENOMEM
hi cConstant 		ctermfg=142 ctermbg=NONE cterm=bold
hi cppConstant 		ctermfg=142 ctermbg=NONE cterm=bold

" %s %d
hi cFormat 		ctermfg=042 ctermbg=NONE cterm=bold

hi cString 		ctermfg=175 ctermbg=NONE cterm=bold

"goto label
hi cUserLabel 		ctermfg=133 ctermbg=NONE cterm=bold
hi cUserCont 		ctermfg=123 ctermbg=NONE cterm=bold


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" for python
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""


hi pythonStatement 	ctermfg=198 ctermbg=NONE cterm=bold
hi pythonRepeat 	ctermfg=198 ctermbg=NONE cterm=bold
hi pythonConditional 	ctermfg=198 ctermbg=NONE cterm=bold
hi pythonException 	ctermfg=198 ctermbg=NONE cterm=bold
hi pythonAsync 		ctermfg=198 ctermbg=NONE cterm=bold

hi pythonOperator 	ctermfg=048 ctermbg=NONE cterm=bold
hi pythonInclude 	ctermfg=198 ctermbg=NONE cterm=bold


hi pythonNumber 	ctermfg=208 ctermbg=NONE cterm=bold
hi pythonBuiltin 	ctermfg=148 ctermbg=NONE cterm=bold
hi pythonFunction 	ctermfg=148 ctermbg=NONE cterm=bold
hi pythonComment 	ctermfg=044 ctermbg=NONE cterm=bold

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""


