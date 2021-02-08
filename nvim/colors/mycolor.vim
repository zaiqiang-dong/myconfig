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

hi Comment 		ctermfg=081 ctermbg=NONE cterm=bold

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" \2 \n
hi SpecialChar 		ctermfg=051 ctermbg=NONE cterm=bold
hi Pmenu         	ctermfg=039 ctermbg=234 cterm=bold
hi PmenuSel 		ctermfg=000 ctermbg=214 cterm=bold
hi PmenuSbar 		ctermfg=197 ctermbg=NONE cterm=bold
hi PmenuThumb 		ctermfg=202 ctermbg=NONE cterm=bold

hi TabLineSel 		ctermfg=000 ctermbg=214 cterm=bold
hi Search 		ctermfg=123 ctermbg=NONE cterm=bold
hi TagbarHighlight 	ctermfg=197 ctermbg=NONE cterm=bold

hi ModeMsg 		ctermfg=039 ctermbg=NONE cterm=bold
hi Title 		ctermfg=197 ctermbg=NONE cterm=bold
hi StatusLine 		ctermfg=197 ctermbg=NONE cterm=bold
hi CursorLine 		ctermfg=NONE ctermbg=239 cterm=bold
hi MatchParen 		ctermfg=NONE ctermbg=NONE cterm=bold
hi CursorLineNr 	ctermfg=197 ctermbg=NONE cterm=bold
hi LineNr 		ctermfg=239 ctermbg=NONE cterm=bold
hi VertSplit 		ctermfg=239 ctermbg=239 cterm=bold

hi Normal 		ctermfg=148 ctermbg=NONE cterm=bold
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"for c/c++ language
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
hi cStatement 		ctermfg=198 ctermbg=NONE cterm=bold
hi cppStatement 	ctermfg=198 ctermbg=NONE cterm=bold
hi cLabel 		ctermfg=198 ctermbg=NONE cterm=bold
hi cConditional 	ctermfg=198 ctermbg=NONE cterm=bold
hi cRepeat 		ctermfg=198 ctermbg=NONE cterm=bold



hi cTodo 		ctermfg=001 ctermbg=238 cterm=bold

hi cNumber 		ctermfg=208 ctermbg=NONE cterm=bold
hi cFloat 		ctermfg=208 ctermbg=NONE cterm=bold
hi cOctal 		ctermfg=208 ctermbg=NONE cterm=bold
hi cOctalZero 		ctermfg=208 ctermbg=NONE cterm=bold


hi cType 		ctermfg=202 ctermbg=NONE cterm=bold
hi cppType 		ctermfg=202 ctermbg=NONE cterm=bold
hi cppBoolean 		ctermfg=226 ctermbg=NONE cterm=bold
hi cStructure 		ctermfg=202 ctermbg=NONE cterm=bold
hi cppStructure 	ctermfg=202 ctermbg=NONE cterm=bold


hi cStorageClass 	ctermfg=049 ctermbg=NONE cterm=bold
hi cppStorageClass 	ctermfg=049 ctermbg=NONE cterm=bold
hi cppModifier 		ctermfg=049 ctermbg=NONE cterm=bold

hi cppAccess 		ctermfg=226 ctermbg=NONE cterm=bold

hi cppOperator 		ctermfg=218 ctermbg=NONE cterm=bold
hi cOperator 		ctermfg=218 ctermbg=NONE cterm=bold

hi dOperator 		ctermfg=201 ctermbg=NONE cterm=bold
hi dClasss 		ctermfg=201 ctermbg=NONE cterm=bold

hi cInclude 		ctermfg=226 ctermbg=NONE cterm=bold
hi cDefine 		ctermfg=226 ctermbg=NONE cterm=bold
hi cPreCondit 		ctermfg=226 ctermbg=NONE cterm=bold
hi cConstant 		ctermfg=226 ctermbg=NONE cterm=bold
hi cppConstant 		ctermfg=226 ctermbg=NONE cterm=bold
" %s %d
hi cFormat 		ctermfg=046 ctermbg=NONE cterm=bold
hi cString 		ctermfg=201 ctermbg=NONE cterm=bold

hi cUserLabel 		ctermfg=201 ctermbg=NONE cterm=bold
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

hi pythonOperator 	ctermfg=201 ctermbg=NONE cterm=bold
hi pythonInclude 	ctermfg=198 ctermbg=NONE cterm=bold


hi pythonNumber 	ctermfg=208 ctermbg=NONE cterm=bold
hi pythonBuiltin 	ctermfg=208 ctermbg=NONE cterm=bold
hi pythonFunction 	ctermfg=226 ctermbg=NONE cterm=bold
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""


