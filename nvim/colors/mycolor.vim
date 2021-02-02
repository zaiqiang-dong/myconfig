set background=dark
if version > 580
	hi clear
	if exists("syntax_on")
		syntax reset
	endif
endif

set t_Co=256
let g:colors_name = "mycolor_modified"


"for c/c++ language
hi Normal 		ctermfg=112 ctermbg=NONE cterm=bold
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

hi cComment 		ctermfg=081 ctermbg=NONE cterm=bold

hi cType 		ctermfg=198 ctermbg=NONE cterm=bold
hi cppType 		ctermfg=198 ctermbg=NONE cterm=bold
hi cppBoolean 		ctermfg=226 ctermbg=NONE cterm=bold
hi cStructure 		ctermfg=198 ctermbg=NONE cterm=bold
hi cppStructure 	ctermfg=198 ctermbg=NONE cterm=bold


hi cStorageClass 	ctermfg=049 ctermbg=NONE cterm=bold
hi cppStorageClass 	ctermfg=049 ctermbg=NONE cterm=bold
hi cppModifier 		ctermfg=049 ctermbg=NONE cterm=bold

hi cppAccess 		ctermfg=226 ctermbg=NONE cterm=bold

hi cppOperator 		ctermfg=218 ctermbg=NONE cterm=bold
hi cOperator 		ctermfg=218 ctermbg=NONE cterm=bold

hi dOperator 		ctermfg=201 ctermbg=NONE cterm=bold
hi dClasss 		ctermfg=198 ctermbg=NONE cterm=bold

hi cInclude 		ctermfg=226 ctermbg=NONE cterm=bold
hi cDefine 		ctermfg=226 ctermbg=NONE cterm=bold
hi cPreCondit 		ctermfg=226 ctermbg=NONE cterm=bold
hi cConstant 		ctermfg=226 ctermbg=NONE cterm=bold
hi cppConstant 		ctermfg=226 ctermbg=NONE cterm=bold

hi cFormat 		ctermfg=226 ctermbg=NONE cterm=bold
hi cString 		ctermfg=201 ctermbg=NONE cterm=bold

hi cUserLabel 		ctermfg=201 ctermbg=NONE cterm=bold
hi cLabel 		ctermfg=201 ctermbg=NONE cterm=bold
hi cUserCont 		ctermfg=123 ctermbg=NONE cterm=bold






"global config
hi Pmenu         	ctermfg=039 ctermbg=234 cterm=bold
hi PmenuSel 		ctermfg=000 ctermbg=214 cterm=bold
hi PmenuSbar 		ctermfg=112 ctermbg=NONE cterm=bold
hi PmenuThumb 		ctermfg=112 ctermbg=NONE cterm=bold

hi TabLineSel 		ctermfg=000 ctermbg=214 cterm=bold
hi Search 		ctermfg=123 ctermbg=NONE cterm=bold
hi TagbarHighlight 	ctermfg=197 ctermbg=NONE cterm=bold

hi ModeMsg 		ctermfg=039 ctermbg=NONE cterm=bold
hi Title 		ctermfg=197 ctermbg=NONE cterm=bold
hi StatusLine 		ctermfg=197 ctermbg=NONE cterm=bold
hi CursorLine 		ctermfg=NONE ctermbg=239 cterm=bold
hi MatchParen 		ctermfg=NONE ctermbg=NONE cterm=bold

