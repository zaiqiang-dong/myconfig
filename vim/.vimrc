"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Vim config manage by github.
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set nu
set autoindent
set cindent
set tabstop=4
set softtabstop=4
set shiftwidth=4
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
let Tlist_Show_One_File=1     "不同时显示多个文件的tag，只显示当前文件的  
let Tlist_Exit_OnlyWindow=1   "如果taglist窗口是最后一个窗口，则退出vim 
let Tlist_Ctags_Cmd="/usr/bin/ctags" "将taglist与ctags关联
let Tlist_Auto_Open=1
