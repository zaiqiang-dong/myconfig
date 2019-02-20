"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Vim config manage by github.
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set nu
set tabstop=4
set softtabstop=4
set shiftwidth=4

set autoindent
set smartindent

set foldenable
set foldmethod=marker
set cursorline  
filetype plugin indent on 
syntax enable
colorscheme tt_vim
if has("autocmd")
    au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$")
       \| exe "normal g'\"" | endif
endif

nmap dp d^
nmap da d$

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" leader setting
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let mapleader = "."

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" cscope setting
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if has("cscope")
   set csprg=/usr/bin/cscope
   set csto=1
   set cst
   set nocsverb
" add any database in current directory
if filereadable("cscope.out")
	cs add cscope.out
endif
	set csverb
endif
nmap cs :cs find s <C-R>=expand("<cword>")<CR><CR>
nmap cg :cs find g <C-R>=expand("<cword>")<CR><CR>
nmap cc :cs find c <C-R>=expand("<cword>")<CR><CR>
nmap ct :cs find t <C-R>=expand("<cword>")<CR><CR>
nmap ce :cs find e <C-R>=expand("<cword>")<CR><CR>
nmap cf :cs find f <C-R>=expand("<cfile>")<CR><CR>
nmap ci :cs find i <C-R>=expand("<cfile>")<CR>$<CR>
nmap cd :cs find d <C-R>=expand("<cword>")<CR><CR>
vmap <c-c> "+y
let Tlist_Show_One_File=1
let Tlist_Exit_OnlyWindow=1
let Tlist_Ctags_Cmd="/usr/bin/ctags"
let Tlist_Auto_Open=1


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"nerdcommenter
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let NERDSpaceDelims=1
let NERDCompactSexyComs=1
let g:NERDDefaultAlign = 'left'

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"mru
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
nmap <leader>r :MRU<cr>
let g:MRU_Window_Height=30
let g:MRU_Max_Menu_Entries=20

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"nredtree
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
map <C-n> :NERDTreeToggle<CR>
let g:NERDTreeWinSize=100
let g:NERDTreeWinPos='right'
let g:NERDTreeQuitOnOpen=1
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

map <C-f> :call FormatCode()<CR>
func FormatCode()
	if &filetype == 'c' || &filetype == 'h' || &filetype == 'cpp' || &filetype == 'cc' || &filetype == 'hpp'
		exec "!astyle --style=linux --suffix=none %"
	elseif &filetype == 'java'
		exec "!astyle --style=java --suffix=none %"
	endif
endfunc


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"rianbow
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:rainbow_active = 1
	let g:rainbow_conf = {
	\	'guifgs': ['magenta', 'cyan', 'red', 'brown'],
	\	'ctermfgs': ['magenta', 'cyan', 'red', 'brown'],
	\	'operators': '_,_',
	\	'parentheses': ['start=/(/ end=/)/ fold', 'start=/\[/ end=/\]/ fold', 'start=/{/ end=/}/ fold'],
	\}
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"better_whitespace
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:better_whitespace_enabled=1
