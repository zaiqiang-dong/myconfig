"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" vim base config
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set nu
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

set cursorline
set colorcolumn=81


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" auto cmd
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

if has("autocmd")
    au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$")
       \| exe "normal g'\"" | endif
endif

"autocmd VimEnter * PlugUpdate 
"autocmd VimEnter * CocUpdate 
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" leader and map
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let mapleader = ","

"delete all front char
nmap dp d^
"delete all after char
nmap da d$

"open left tagbar
nmap <leader>t :TagbarToggle<CR>

"open right file list
nmap <C-n> :NERDTreeToggle<CR>
"open right file list and find curent file
nmap <C-f> :NERDTreeFind<CR>

"switch window
" nmap ww <C-w>w

"cscope config
nmap cs :cs find s <C-R>=expand("<cword>")<CR><CR>
nmap cg :cs find g <C-R>=expand("<cword>")<CR><CR>
nmap cc :cs find c <C-R>=expand("<cword>")<CR><CR>
nmap ct :cs find t <C-R>=expand("<cword>")<CR><CR>
nmap ce :cs find e <C-R>=expand("<cword>")<CR><CR>
nmap cf :cs find f <C-R>=expand("<cfile>")<CR><CR>
nmap ci :cs find i <C-R>=expand("<cfile>")<CR>$<CR>
nmap cd :cs find d <C-R>=expand("<cword>")<CR><CR>

"map for CocList command
nmap <Space>g :CocList grep<CR>
nmap <Space>f :CocList files<CR>
nmap <Space>w :CocList words<CR>


nmap <F2> :call CreateCTag()<CR>
nmap <F3> :call CreatePythonTag()<CR>


"for format code ,use astyle
nmap ffl :call FormatC()<CR>
nmap ffn :call FormatCPP()<CR>
nmap ffj :call FormatJAVA()<CR>
nmap ffp :call FormatPYTHON()<CR>

"map for highlight

nmap <Space>h : set hlsearch<CR>
nmap <Space>c : set nohlsearch<CR>

"tagbar show
nmap <F8> : TagbarToggle<CR>

"copy selected code
vmap <C-c> "+y

"highlight Functions
syn match cFunctions "\<[a-zA-Z_][a-zA-Z_0-9]*\>[^()]*)("me=e-2
syn match cFunctions "\<[a-zA-Z_][a-zA-Z_0-9]*\>\s*("me=e-1
hi cFunctions guifg=#ffbf00 guibg=NONE guisp=NONE gui=bold ctermfg=200 ctermbg=NONE cterm=bold


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" function setting
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

func FormatC()
	if &filetype == 'c' || &filetype == 'h'
		exec "!astyle --style=linux --suffix=none  --indent=force-tab=4 --pad-comma --align-reference=name --break-blocks %"
	endif
endfunc

func FormatCPP()
	if &filetype == 'cpp' || &filetype == 'h'
		exec "!astyle --style=google --suffix=none %"
	endif
endfunc

func FormatJAVA()
	if &filetype == 'java'
		exec "!astyle --style=google --suffix=none  %"
	endif
endfunc

func FormatPYTHON()
	if &filetype == 'python'
		exec "!yapf -p --style='{based_on_style: chromium, indent_width: 4}' -i %"
	endif
endfunc


func CreatePythonTag()
	silent exec "!find  . -name \*.py | xargs ~/.config/nvim/ptags "
	set tags=tags;
endfunc


func CreateCTag()
	silent exec "!find -iname \*.c -o  -iname \*.cpp -o -iname \*.h -o -iname \*.hpp -o -iname \*.java -o -iname \*.S -o -iname \*.s > cscope.files"
	silent exec "!cscope -Rbqk"
	silent exec "!ctags -R;"
	if filereadable("cscope.out")
	    set nocscopeverbose
	    cs add cscope.out
	endif
	set tags=tags
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
let Tlist_Show_One_File=1
let Tlist_Exit_OnlyWindow=1
let Tlist_Ctags_Cmd="/usr/bin/ctags"
let Tlist_Auto_Open=1
"set cscopequickfix=s-,c-,d-,i-,t-,e-


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"nredtree
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
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
let g:tagbar_left=1
let g:tagbar_width=30
autocmd VimEnter * nested :call tagbar#autoopen(1)

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"deoplete.nvim
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" let g:deoplete#enable_at_startup = 1
" set completeopt-=preview

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"python-mode
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"let g:pymode = 1
"let g:pymode_warnings = 1
"let g:pymode_trim_whitespaces = 1
"let g:pymode_options = 1
"let g:pymode_options_colorcolumn = 0
"let g:pymode_quickfix_minheight = 3
"let g:pymode_quickfix_maxheight = 10
"let g:pymode_python = 'python3'
"let g:pymode_indent = 1
"let g:pymode_doc = 1
"let g:pymode_doc_bind = 'K'
"let g:pymode_virtualenv = 1
"let g:pymode_run = 0
"let g:pymode_breakpoint = 0
"let g:pymode_lint = 1
"let g:pymode_lint_on_write = 1
"let g:pymode_lint_on_fly = 0
"let g:pymode_lint_checkers = ['pyflakes', 'pep8']
"let g:pymode_lint_cwindow = 0
"let g:pymode_lint_signs = 1
"let g:pymode_lint_todo_symbol = 'WW'
"let g:pymode_lint_comment_symbol = 'CC'
"let g:pymode_lint_visual_symbol = 'RR'
"let g:pymode_lint_error_symbol = 'EE'
"let g:pymode_lint_info_symbol = 'II'
"let g:pymode_lint_pyflakes_symbol = 'FF'
"let g:pymode_rope = 1
"let g:pymode_rope_lookup_project = 0
"let g:pymode_rope_show_doc_bind = '<C-c>d'
"let g:pymode_rope_regenerate_on_write = 1
"let g:pymode_rope_completion = 1
"let g:pymode_rope_complete_on_dot = 1
"let g:pymode_rope_completion_bind = '<C-n>'
"let g:pymode_rope_goto_definition_bind = '<C-]>'
"let g:pymode_rope_goto_definition_cmd = 'e'
"let g:pymode_rope_rename_bind = '<C-c>rr'
"let g:pymode_rope_rename_module_bind = '<C-c>r1r'
"let g:pymode_syntax = 1
"let g:pymode_syntax_all = 1
"let g:pymode_syntax_indent_errors = g:pymode_syntax_all
"let g:pymode_syntax_space_errors = g:pymode_syntax_all
"

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" coc-nvim
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:coc_global_extensions=['coc-tsserver','coc-lists','coc-java',
	    \		     'coc-python', 'coc-snippets', 'coc-pairs',
	    \		     'coc-git', 'coc-ultisnips', 'coc-word',
	    \		     'coc-neosnippet','coc-clangd']

" nnoremap <silent> K :call <SID>show_documentation()<CR>

" function! s:show_documentation()
"   if (index(['vim','help'], &filetype) >= 0)
"     execute 'h '.expand('<cword>')
"   else
"     call CocAction('doHover')
"   endif
" endfunction
nnoremap <buffer> H :<C-u>execute "!pydoc3 " . expand("<cword>")<CR>

nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

nmap rn <Plug>(coc-rename)
nmap rr <Plug>(coc-refactor)

let g:coc_disable_startup_warning = 1

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" coc-nvim
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Echo translation in the cmdline
nmap <silent> <Leader>t <Plug>Translate
vmap <silent> <Leader>t <Plug>TranslateV
" Display translation in a window
nmap <silent> <Leader>w <Plug>TranslateW
vmap <silent> <Leader>w <Plug>TranslateWV
" Replace the text with translation
nmap <silent> <Leader>r <Plug>TranslateR
vmap <silent> <Leader>r <Plug>TranslateRV

" Use <C-l> for trigger snippet expand.
imap <C-l> <Plug>(coc-snippets-expand)

" Use <C-j> for select text for visual placeholder of snippet.
vmap <C-j> <Plug>(coc-snippets-select)

" Use <C-j> for jump to next placeholder, it's default of coc.nvim
let g:coc_snippet_next = '<c-j>'

" Use <C-k> for jump to previous placeholder, it's default of coc.nvim
let g:coc_snippet_prev = '<c-k>'

" Use <C-j> for both expand and jump (make expand higher priority.)
imap <C-j> <Plug>(coc-snippets-expand-jump)

inoremap <silent><expr> <TAB>
      \ pumvisible() ? coc#_select_confirm() :
      \ coc#expandableOrJumpable() ? "\<C-r>=coc#rpc#request('doKeymap', ['snippets-expand-jump',''])\<TAB>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

let g:coc_snippet_next = '<tab>'

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
"Plug 'python-mode/python-mode', { 'for': 'python', 'branch': 'develop' }
"Plug 'deoplete-plugins/deoplete-jedi'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'wsdjeg/FlyGrep.vim'
Plug 'ntpeters/vim-better-whitespace'
Plug 'voldikss/vim-translator'
Plug 'rafalbromirski/vim-aurora'
Plug 'srcery-colors/srcery-vim'

call plug#end()

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Formatting selected code.
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)
