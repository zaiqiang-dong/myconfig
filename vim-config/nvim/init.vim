"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" vim base config
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set nu
set enc=utf-8
set fenc=utf-8
set fencs=utf-8
set mouse=nv

autocmd FileType c,sh setlocal noexpandtab tabstop=4
autocmd FileType cc,cpp,java,python,javascript setlocal expandtab tabstop=4
set smartindent
set shiftwidth=4

set foldenable
set foldmethod=marker
filetype plugin indent on
syntax enable
colorscheme mycolor

set cursorline

autocmd FileType cc,c,cpp,java,python,javascript setlocal colorcolumn=81

if has("autocmd")
    au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$")
       \| exe "normal g'\"" | endif
endif

augroup helpfiles
  au!
  au BufRead,BufEnter */doc/* wincmd H
augroup END

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" leader and map
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let mapleader = ","

"delete all front char
nmap dp d^
"delete all after char
nmap da d$

"open right file list
nmap <leader>n :NERDTreeToggle<CR>

nmap <F2> :call CreateCTag()<CR>
nmap <F3> :call CreatePythonTag()<CR>
map <F5> :call CompileAndRun()<CR>

"for format code ,use astyle
nmap ffl :call FormatC()<CR>
nmap ffn :call FormatCPP()<CR>
nmap ffj :call FormatJAVA()<CR>
nmap ffp :call FormatPYTHON()<CR>

"map for highlight
nmap <Space>h : set hlsearch<CR>
nmap <Space>c : set nohlsearch<CR>

"copy selected code
vmap <C-c> "+y

"copy a word
nmap vw ve

nmap ma mA
nmap mb mB
nmap mc mC
nmap md mD
nmap me mE
nmap mf mF
nmap mg mG
nmap mh mH
nmap mj mJ
nmap mk mK
nmap ml mL
nmap mm mM
nmap mn mN

nmap 'a 'A
nmap 'b 'B
nmap 'c 'C
nmap 'd 'D
nmap 'e 'E
nmap 'f 'F
nmap 'g 'G
nmap 'h 'H
nmap 'j 'J
nmap 'k 'K
nmap 'l 'L
nmap 'm 'M
nmap 'n 'N

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" function define
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
func! CompileGcc()
    let compilecmd="!gcc "
    let compileflag="-o %< "
    if search("mpi\.h") != 0
        let compilecmd = "!mpicc "
    endif
    if search("glut\.h") != 0
        let compileflag .= " -lglut -lGLU -lGL "
    endif
    if search("cv\.h") != 0
        let compileflag .= " -lcv -lhighgui -lcvaux "
    endif
    if search("omp\.h") != 0
        let compileflag .= " -fopenmp "
    endif
    if search("math\.h") != 0
        let compileflag .= " -lm "
    endif
    if search("pthread\.h") != 0
        let compileflag .= " -lpthread "
    endif
    exec compilecmd." % ".compileflag
endfunc
func! CompileGpp()
    let compilecmd="!g++ "
    let compileflag="--std=c++14 -o %< "
    if search("mpi\.h") != 0
        let compilecmd = "!mpic++ "
    endif
    if search("glut\.h") != 0
        let compileflag .= " -lglut -lGLU -lGL "
    endif
    if search("cv\.h") != 0
        let compileflag .= " -lcv -lhighgui -lcvaux "
    endif
    if search("omp\.h") != 0
        let compileflag .= " -fopenmp "
    endif
    if search("math\.h") != 0
        let compileflag .= " -lm "
    endif
    if search("pthread\.h") != 0
        let compileflag .= " -lpthread "
    endif
    exec compilecmd." % ".compileflag
endfunc

func! RunPython()
        exec "!python3 %"
endfunc
func! CompileJava()
    exec "!javac %"
endfunc


func! CompileCode()
        if &filetype == "cpp" || &filetype == "cc"
                exec "call CompileGpp()"
        elseif &filetype == "c"
                exec "call CompileGcc()"
        elseif &filetype == "java"
                exec "call CompileJava()"
        endif
endfunc

func! RunResult()
        if search("mpi\.h") != 0
            exec "!mpirun -np 4 ./%<"
        elseif &filetype == "cpp"
            exec "! ./%<"
        elseif &filetype == "c"
            exec "! ./%<"
        elseif &filetype == "python"
            exec "call RunPython()"
        elseif &filetype == "java"
            exec "!java %<"
        endif

        if &filetype == "cpp" || &filetype == "cc"
	    exec "!rm %<"
        elseif &filetype == "c"
	    exec "!rm %<"
        elseif &filetype == "java"
	    exec "!rm %<"
        endif
endfunc

func! CompileAndRun()
	exec "w"
	exec "call CompileCode()"
	exec "call RunResult()"
endfunc



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
	silent exec "!find -iname \*.c -o  -iname \*.cpp -o -iname \*.cc -o -iname \*.h -o -iname \*.hpp -o -iname \*.java -o -iname \*.S -o -iname \*.s > cscope.files"
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


nmap cs :cs find s <C-R>=expand("<cword>")<CR><CR>
nmap cg :cs find g <C-R>=expand("<cword>")<CR><CR>
nmap cc :cs find c <C-R>=expand("<cword>")<CR><CR>
nmap ct :cs find t <C-R>=expand("<cword>")<CR><CR>
nmap ce :cs find e <C-R>=expand("<cword>")<CR><CR>
nmap cf :cs find f <C-R>=expand("<cfile>")<CR><CR>
nmap ci :cs find i <C-R>=expand("<cfile>")<CR>$<CR>
nmap cd :cs find d <C-R>=expand("<cword>")<CR><CR>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"nredtree
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:NERDTreeShowLineNumbers=1
let g:NERDTreeAutoCenter=1
let g:NERDTreeWinSize=60
let g:NERDTreeWinPos='right'
let g:NERDTreeQuitOnOpen=1
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"rianbow
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:rainbow_active = 1
let g:rainbow_conf = {
\	'guifgs': ['magenta', 'cyan', 'red', 'brown'],
\	'ctermfgs': ['198', '070', '208', '177'],
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
let g:tagbar_width=24
autocmd VimEnter * nested :call tagbar#autoopen(1)

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" coc-nvim
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:coc_global_extensions=['coc-tsserver','coc-lists','coc-java',
	    \		     'coc-python', 'coc-snippets', 'coc-pairs',
	    \		     'coc-git', 'coc-word','coc-clangd' ]

nnoremap <silent> H :<C-u>execute "!pydoc3 " . expand("<cword>")<CR>

nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

nmap rn <Plug>(coc-rename)
nmap rr <Plug>(coc-refactor)

let g:coc_disable_startup_warning = 1


" Use <C-l> for trigger snippet expand.
imap <C-l> <Plug>(coc-snippets-expand)

" Use <C-j> for select text for visual placeholder of snippet.
" vmap <C-j> <Plug>(coc-snippets-select)

" Use <C-j> for jump to next placeholder, it's default of coc.nvim
let g:coc_list_next = '<C-j>'

" Use <C-k> for jump to previous placeholder, it's default of coc.nvim
let g:coc_list_prev = '<C-k>'

inoremap <silent><expr> <TAB>
      \ pumvisible() ? coc#_select_confirm() :
      \ coc#expandableOrJumpable() ? "\<C-r>=coc#rpc#request('doKeymap', ['snippets-expand-jump',''])\<CR>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

let g:coc_snippet_next = '<tab>'

inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"

"{} <CR>
"
"{
"    insert
"}
inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
				\: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

"coc list config
nnoremap <silent> <space>w  :exe 'CocList -I --normal --input='.expand('<cword>').' words'<CR>
nnoremap <silent> <space>g  :exe 'CocList -I --normal --input='.expand('<cword>').' grep'<CR>
nmap <Space>f :CocList files<CR>

" Formatting selected code.
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" vim-man
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
map <leader>v <Plug>(Vman)
map <leader>k <Plug>(Man)

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" indentline
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
autocmd FileType json,markdown let g:indentLine_conceallevel=0
autocmd FileType javascript,python,c,cc,cpp,java,vim,shell let g:indentLine_conceallevel=2


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" preview-markdown.vim
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"let g:preview_markdown_vertical=1

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" vim-markdown
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:vim_markdown_folding_disabled = 1
let g:vim_markdown_math = 1

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" airline
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:airline_theme='bubblegum'

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" smoothie
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" markdown preview
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:mkdp_auto_close = 0
nmap <C-s> <Plug>MarkdownPreview

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" vim-table-mode
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
map <leader>tm : TableModeEnable

function! s:isAtStartOfLine(mapping)
  let text_before_cursor = getline('.')[0 : col('.')-1]
  let mapping_pattern = '\V' . escape(a:mapping, '\')
  let comment_pattern = '\V' . escape(substitute(&l:commentstring, '%s.*$', '', ''), '\')
  return (text_before_cursor =~? '^' . ('\v(' . comment_pattern . '\v)?') . '\s*\v' . mapping_pattern . '\v$')
endfunction

inoreabbrev <expr> <bar><bar>
          \ <SID>isAtStartOfLine('\|\|') ?
          \ '<c-o>:TableModeEnable<cr><bar><space><bar><left><left>' : '<bar><bar>'
inoreabbrev <expr> __
          \ <SID>isAtStartOfLine('__') ?
          \ '<c-o>:silent! TableModeDisable<cr>' : '__'

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" vim-translator
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
nmap <silent> <Leader>t <Plug>TranslateW
vmap <silent> <Leader>t <Plug>TranslateWV
let g:translator_default_engines=["haici"]

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" nerdcommenter
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Create default mappings
let g:NERDCreateDefaultMappings = 1

" Add spaces after comment delimiters by default
let g:NERDSpaceDelims = 1

" Use compact syntax for prettified multi-line comments
let g:NERDCompactSexyComs = 1

" Align line-wise comment delimiters flush left instead of following code indentation
let g:NERDDefaultAlign = 'left'

" Set a language to use its alternate delimiters by default
let g:NERDAltDelims_java = 1

" Add your own custom formats or override the defaults
let g:NERDCustomDelimiters = { 'c': { 'left': '/*','right': '*/' },'cpp': { 'left': '/*','right': '*/' }, 'cc': { 'left': '/*','right': '*/' }, 'python': {'left' : '#', 'right': ''}}

" Allow commenting and inverting empty lines (useful when commenting a region)
let g:NERDCommentEmptyLines = 1

" Enable trimming of trailing whitespace when uncommenting
let g:NERDTrimTrailingWhitespace = 1

" Enable NERDCommenterToggle to check all selected lines is commented or not
let g:NERDToggleCheckAllLines = 1

imap <C-k> <plug>NERDCommenterInsert










"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" vim-plug
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
call plug#begin('~/.config/nvim/pluged')
Plug 'mhinz/vim-startify'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'yggdroot/indentline'
Plug 'scrooloose/nerdtree'
Plug 'majutsushi/tagbar'
Plug 'tpope/vim-commentary'
Plug 'preservim/nerdcommenter'
Plug 'luochen1990/rainbow'
Plug 'honza/vim-snippets'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'wsdjeg/FlyGrep.vim'
Plug 'ntpeters/vim-better-whitespace'
Plug 'voldikss/vim-translator'
Plug 'rafalbromirski/vim-aurora'
Plug 'srcery-colors/srcery-vim'

Plug 'iamcco/mathjax-support-for-mkdp'
"Plug 'iamcco/markdown-preview.vim'
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app & yarn install'  }

Plug 'vim-utils/vim-man'
Plug 'godlygeek/tabular'
Plug 'plasticboy/vim-markdown'
Plug 'psliwka/vim-smoothie'

"plantuml
Plug 'tyru/open-browser.vim'
Plug 'aklt/plantuml-syntax'
Plug 'weirongxu/plantuml-previewer.vim'
Plug 'dhruvasagar/vim-table-mode'
"Plug 'kshenoy/vim-signature'
Plug 'zaiqiang-dong/vim-colorful'

call plug#end()

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"vim-plug end
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
