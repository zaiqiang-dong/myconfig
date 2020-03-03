"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Vim config manage by github.
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set nu
" set expandtab
" set tabstop=4
"set smartindent

set enc=utf-8
set fenc=utf-8
set fencs=utf-8

autocmd FileType c setlocal noexpandtab tabstop=4
autocmd FileType cpp,java,python,javascript setlocal expandtab tabstop=4
set autoindent
set shiftwidth=4

set foldenable
set foldmethod=marker
filetype plugin indent on
syntax enable
colorscheme mycolor
if has("autocmd")
    au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$")
       \| exe "normal g'\"" | endif
endif

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" leader setting
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let mapleader = ","

nmap dp d^
nmap da d$

nmap <leader>h : set hlsearch<CR>
nmap <leader>c : set nohlsearch<CR>

nmap ww <C-w>w

nmap ffl :call FormatC()<CR>
func FormatC()
	if &filetype == 'c' || &filetype == 'h'
		exec "!astyle --style=linux --suffix=none  --indent=force-tab=4 --pad-comma --align-reference=name --break-blocks %"
	endif
endfunc
nmap ffn :call FormatCPP()<CR>
func FormatCPP()
	if &filetype == 'cpp' || &filetype == 'h'
		exec "!astyle --style=google --suffix=none %"
	endif
endfunc
nmap ffj :call FormatJAVA()<CR>:
func FormatJAVA()
	if &filetype == 'java'
		exec "!astyle --style=google --suffix=none  %"
	endif
endfunc

nmap ffp :call FormatPYTHON()<CR>:
func FormatPYTHON()
	if &filetype == 'python'
		exec "!yapf -p --style='{based_on_style: chromium, indent_width: 4}' -i %"
	endif
endfunc



"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" cscope setting
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if has("cscope")
   set csprg=/usr/bin/cscope
   set csto=1
   set cst
   set nocsverb
" add any database in current directory

set tags=tags;
if filereadable("cscope.out")
	cs add cscope.out
else
	let cscope_file=findfile("cscope.out",".;")
	let cscope_pre=matchstr(cscope_file,".*/")
	if !empty(cscope_file)&&filereadable(cscope_file)
	       exe "cs add" cscope_file  cscope_pre
	endif
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
vmap <C-c> "+y
let Tlist_Show_One_File=1
let Tlist_Exit_OnlyWindow=1
let Tlist_Ctags_Cmd="/usr/bin/ctags"
let Tlist_Auto_Open=1
"set cscopequickfix=s-,c-,d-,i-,t-,e-


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"nredtree
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
map <C-n> :NERDTreeToggle<CR>
map <C-f> :NERDTreeFind<CR>
let g:NERDTreeWinSize=60
let g:NERDTreeWinPos='right'
let g:NERDTreeQuitOnOpen=1
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"ctrlp
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" let g:ctrlp_custom_ignore = '\v[\/]\.(git|hg|svn)$'
" let g:ctrlp_custom_ignore = {
"   \ 'dir':  '\v[\/]\.(git|hg|svn)$',
"   \ 'file': '\v\.(exe|so|dll)$',
"   \ 'link': 'some_bad_symbolic_links',
"   \ }

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

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"tagbar
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
nmap <leader>t :TagbarToggle<CR>
let g:tagbar_left=1
autocmd VimEnter * nested :call tagbar#autoopen(1)

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"deoplete.nvim
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

let g:deoplete#enable_at_startup = 1
set completeopt-=preview

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"python-mode
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

let g:pymode = 1
let g:pymode_warnings = 1
let g:pymode_trim_whitespaces = 1
let g:pymode_options = 1
let g:pymode_options_colorcolumn = 0
let g:pymode_quickfix_minheight = 3
let g:pymode_quickfix_maxheight = 10
let g:pymode_python = 'python3'
let g:pymode_indent = 1
let g:pymode_doc = 1
let g:pymode_doc_bind = 'K'
let g:pymode_virtualenv = 1
let g:pymode_run = 0
let g:pymode_breakpoint = 0
let g:pymode_lint = 1
let g:pymode_lint_on_write = 1
let g:pymode_lint_on_fly = 0
let g:pymode_lint_checkers = ['pyflakes', 'pep8']
let g:pymode_lint_cwindow = 0
let g:pymode_lint_signs = 1
let g:pymode_lint_todo_symbol = 'WW'
let g:pymode_lint_comment_symbol = 'CC'
let g:pymode_lint_visual_symbol = 'RR'
let g:pymode_lint_error_symbol = 'EE'
let g:pymode_lint_info_symbol = 'II'
let g:pymode_lint_pyflakes_symbol = 'FF'
let g:pymode_rope = 1
let g:pymode_rope_lookup_project = 0
let g:pymode_rope_show_doc_bind = '<C-c>d'
let g:pymode_rope_regenerate_on_write = 1
let g:pymode_rope_completion = 1
let g:pymode_rope_complete_on_dot = 1
let g:pymode_rope_completion_bind = '<C-n>'
let g:pymode_rope_goto_definition_bind = '<C-]>'
let g:pymode_rope_goto_definition_cmd = 'e'
let g:pymode_rope_rename_bind = '<C-c>rr'
let g:pymode_rope_rename_module_bind = '<C-c>r1r'
let g:pymode_syntax = 1
let g:pymode_syntax_all = 1
let g:pymode_syntax_indent_errors = g:pymode_syntax_all
let g:pymode_syntax_space_errors = g:pymode_syntax_all

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" vim-plug
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
call plug#begin('~/.vim/plugged')
Plug 'mhinz/vim-startify'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'yggdroot/indentline'
Plug 'scrooloose/nerdtree'
" Plug 'ctrlpvim/ctrlp.vim'
Plug 'majutsushi/tagbar'

" if has('nvim')
"   Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
" else
"   Plug 'Shougo/deoplete.nvim'
"   Plug 'roxma/nvim-yarp'
"   Plug 'roxma/vim-hug-neovim-rpc'
" endif

Plug 'tpope/vim-commentary'
Plug 'luochen1990/rainbow'
Plug 'python-mode/python-mode', { 'for': 'python', 'branch': 'develop' }
" Plug 'deoplete-plugins/deoplete-jedi'
Plug 'neoclide/coc.nvim', {'branch': 'release'}

call plug#end()

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

