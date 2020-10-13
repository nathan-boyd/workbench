
set autoread
set autowrite
set backspace=indent,eol,start
set cmdheight=1
set clipboard=unnamed,unnamedplus
set completeopt+=noinsert,noselect,longest,menuone
set completeopt-=preview
set conceallevel=0
set cursorline
set diffopt+=vertical
set fillchars+=vert:┃
set foldenable
set hidden
set history=1000
set hlsearch
set ignorecase
set incsearch
set iskeyword-=#
set iskeyword-=-
set iskeyword-=.
set laststatus=2
set lazyredraw
set linespace=0
set list
set listchars=tab:›\ ,trail:•,extends:#,nbsp:.
set noerrorbells
set novisualbell
set number
set omnifunc=syntaxcomplete#Complete
set re=1
set scrolljump=5
set scrolloff=3
set shell=/usr/bin/zsh
set shortmess+=c
set shortmess+=filmnrxoOtT
set showcmd
set showmatch
set signcolumn=yes
set smartcase
set synmaxcol=128
set t_vb=
set termguicolors
set ttyfast
set updatetime=100
set viewoptions=folds,options,cursor,unix,slash
set virtualedit=onemore
set whichwrap=b,s,h,l,<,>,[,]
set wildignore+=*/tmp/*,*.so,*.swp,*.zip,*.pyc,*.db,*.sqlite
set wildignorecase
set wildmenu
set wildmode=list:full
set winminheight=0

syntax on
autocmd BufEnter * :syn sync maxlines=500
scriptencoding utf-8
filetype plugin indent on

highlight clear SignColumn
highlight clear LineNr

let g:loaded_python_provider = 1
let g:python_host_skip_check=1

let g:python3_host_prog = '/usr/bin/python3'

let g:matchparen_timeout = 1
let g:matchparen_insert_timeout = 1

" go to last cursor position in file
if has("autocmd")
  au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal! g`\"" | endif
endif

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Configure Backups
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" maintain undo history between sessions
set undodir=~/.config/.vim/undodir
set undofile

set nobackup
set nowritebackup

set noswapfile
set dir=~/tmp

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Configure spelling
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

set spell spelllang=en_us
syn match myExCapitalWords +\<\w*[_0-9A-Z-]\w*\>+ contains=@NoSpell " Ignore CamelCase words when spell checking

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Configure Text Formatting
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

set autoindent    " Indent at the same level of the previous line
set nojoinspaces  " Prevents inserting two spaces after punctuation on a join (J)
set splitright    " Puts new vsplit windows to the right of the current
set splitbelow    " Puts new split windows to the bottom of the current

set tabstop=4     " An indentation every 8 columns
set softtabstop=0 " let backspace delete tabs
set expandtab     " tabs are spaces not tabs
set shiftwidth=4  " Use indents of 4 spaces

set smarttab
set modelines=1

set wrap "nolinebreak nolist

" wrapped lines goes down/up to next row, rather than next line in file.
noremap j gj
noremap k gk

" don't use arrowkeys
inoremap <Up> <NOP>
inoremap <Down> <NOP>
inoremap <Left> <NOP>
inoremap <Right> <NOP>

" shift key fixes
if has("user_commands")
    command! -bang -nargs=* -complete=file E e<bang> <args>
    command! -bang -nargs=* -complete=file W w<bang> <args>
    command! -bang -nargs=* -complete=file Wq wq<bang> <args>
    command! -bang -nargs=* -complete=file WQ wq<bang> <args>
    command! -bang -nargs=* -complete=file Vs vs <args>
    command! -bang Wa wa<bang>
    command! -bang WA wa<bang>
    command! -bang Q q<bang>
    command! -bang QA qa<bang>
    command! -bang Qa qa<bang>
endif

" one file per tab
cmap eabe tabe

" Yank from the cursor to the end of the line, to be consistent with C and D.
noremap Y y$

" really write the file.
cmap w!! w !sudo tee % >/dev/null

" line folding
set foldenable          " enable folding
set foldmethod=syntax   " fold based on indent level
set foldlevel=99        " add fold level
set foldnestmax=5       " max 5 depth
set foldlevelstart=10   " start with fold level of 1
set foldcolumn=0        " dont show fold column numbers
nnoremap <space> za     " Enable folding with the spacebar

function RememberFolds()
  if @% !~ "NERD"
      mkview
  endif
endfunction

function RestoreFolds()
  if @% !~ "NERD"
      loadview
  endif
endfunction

augroup manage_folds
  autocmd!
  autocmd BufWinLeave * silent! call RememberFolds()
  autocmd BufWinEnter * silent! call RestoreFolds()
augroup END

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Configure Leader Key and Non Plugin Mappings
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" set leader key to spacebar
let mapleader=" "
let maplocalleader = ","

" config edit / load
nnoremap <leader>sv :source $MYVIMRC<CR>
nnoremap <leader>ev :e! $MYVIMRC<CR>

" Find merge conflict markers
map <leader>fc /\v^[<\|=>]{7}( .*\|$)<CR>

nnoremap <ESC><ESC> :call ClearSearch()<CR>
function ClearSearch()
  :nohlsearch
  :let @/ = ""
endfunction

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" close quickfix when entering new buffer
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

autocmd BufWinEnter quickfix nnoremap <silent> <buffer>
    \ q :cclose<cr>:lclose<cr>
autocmd BufEnter * if (winnr('$') == 1 && &buftype ==# 'quickfix' ) |
    \ bd|
    \ q | endif

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" configure json files handling
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

augroup json_autocmd
  autocmd!
  autocmd FileType json set conceallevel=0
  autocmd FileType json set autoindent
  autocmd FileType json set formatoptions=tcq2l
  autocmd FileType json set shiftwidth=2
  autocmd FileType json set softtabstop=2 tabstop=8
  autocmd FileType json set expandtab
augroup END

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" configure yaml file handling
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" configure aliases file types
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

autocmd BufNewFile,BufRead *.tpl set filetype=yaml
autocmd BufNewFile,BufRead *.manifest set filetype=json

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Searching
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" redirects to pagable output
function! Redir(cmd, rng, start, end)
	for win in range(1, winnr('$'))
		if getwinvar(win, 'scratch')
			execute win . 'windo close'
		endif
	endfor
	if a:cmd =~ '^!'
		let cmd = a:cmd =~' %'
			\ ? matchstr(substitute(a:cmd, ' %', ' ' . expand('%:p'), ''), '^!\zs.*')
			\ : matchstr(a:cmd, '^!\zs.*')
		if a:rng == 0
			let output = systemlist(cmd)
		else
			let joined_lines = join(getline(a:start, a:end), '\n')
			let cleaned_lines = substitute(shellescape(joined_lines), "'\\\\''", "\\\\'", 'g')
			let output = systemlist(cmd . " <<< $" . cleaned_lines)
		endif
	else
		redir => output
		execute a:cmd
		redir END
		let output = split(output, "\n")
	endif
	vnew
	let w:scratch = 1
	setlocal buftype=nofile bufhidden=wipe nobuflisted noswapfile
	call setline(1, output)
endfunction

command! -nargs=1 -complete=command -bar -range Redir silent call Redir(<q-args>, <range>, <line1>, <line2>)

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Install Plugins
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

let g:plug_threads=1

call plug#begin('~/.config/.vim/plugged')

Plug 'fatih/vim-go'                                                " go support
Plug 'vim-airline/vim-airline'                                     " modeline
Plug 'vim-airline/vim-airline-themes'                              " modeline theme
Plug 'sainnhe/gruvbox-material'                                    " theme
Plug 'easymotion/vim-easymotion'                                   " ace movements
Plug 'tpope/vim-fugitive'                                          " git tooling
Plug 'junegunn/gv.vim'
Plug 'airblade/vim-gitgutter'                                      " dirty indicators
Plug 'w0rp/ale'                                                    " syntax highlighting
Plug 'Yggdroot/indentLine'                                         " vertical alignment markers
Plug 'SirVer/ultisnips'                                            " snippets engine
Plug 'honza/vim-snippets'                                          " snippets
Plug 'junegunn/vim-easy-align'                                     " column alignment on characters
Plug 'ekalinin/Dockerfile.vim'                                     " dockerfile syntax highlighting
Plug 'romainl/vim-qf'                                              " quick fix / location window config
Plug 'neoclide/coc.nvim', {'branch': 'release'}                    " language server
Plug 'christoomey/vim-tmux-navigator'                              " window navigation that integrates with tmux
Plug 'Raimondi/delimitMate'                                        " delimiter auto completion
Plug 'junegunn/fzf'                                                " fuzzy searching
Plug 'junegunn/fzf.vim'                                            " also require for fuzzy searching
Plug 'preservim/nerdcommenter'
Plug 'OmniSharp/omnisharp-vim'
Plug 'liuchengxu/vista.vim'
Plug 'majutsushi/tagbar'                                           " tag visualization
Plug 'python-mode/python-mode', { 'for': 'python', 'branch': 'develop' }
Plug 'scrooloose/nerdtree'                                         " file explorer

" turning off until "endif" issue is resolved
"Plug 'Xuyuanp/nerdtree-git-plugin'                                 " show git status in nerdtree

call plug#end()

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Configure easy motion
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

let g:EasyMotion_do_mapping = 0 " Disable default mappings
let g:EasyMotion_smartcase = 1

" f{char}{char} to move to {char}{char}
map  <Leader>f <Plug>(easymotion-bd-f2)
nmap <Leader>f <Plug>(easymotion-overwin-f2)

" Move to line
map <Leader>L <Plug>(easymotion-bd-jk)
nmap <Leader>L <Plug>(easymotion-overwin-line)

" Move to word
map  <Leader>w <Plug>(easymotion-bd-w)
nmap <Leader>w <Plug>(easymotion-overwin-w)

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Configure NERDTree
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

let g:NERDTreeAutoDeleteBuffer = 1
let g:NERDTreeShowHidden = 1
let g:NERDTreeWinSize = 50
let g:NERDTreeQuitOnOpen = 1
let g:NERDTreeMinimalUI = 1
let g:NERDTreeDirArrows = 1
let g:NERDTREE_TABS_FOCUS_ON_FILES = 1
let g:NERDTreeIgnore = [
    \ 'obj$',
    \ 'bin$',
    \ 'vendor',
    \ '\.git$',
    \ '\.rbc$',
    \ '\~$',
    \ '\.pyc$',
    \ '\.sqlite$',
    \ '__pycache__',
    \ '.DS_Store',
    \ 'node_modules'
\]
let g:NERDTreeBookmarksFile = $HOME ."/.vim/bundle/nerdtree/bookmarks"

function OpenClose()
  if exists("g:NERDTree") && g:NERDTree.IsOpen()
    NERDTreeToggle
  else
    NERDTree
  endif
endfunction

nnoremap - :call OpenClose()<CR>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Configure tmux-navigator
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

let g:tmux_navigator_save_on_switch = 1
let g:tmux_navigator_no_mappings = 1

nnoremap <silent> <C-h> :TmuxNavigateLeft<cr>
nnoremap <silent> <C-j> :TmuxNavigateDown<cr>
nnoremap <silent> <C-k> :TmuxNavigateUp<cr>
nnoremap <silent> <C-l> :TmuxNavigateRight<cr>
nnoremap <silent> <C-p> :TmuxNavigatePrevious<cr>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Configure Vim-Qf
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

let g:qf_loclist_window_bottom=0

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Configure Tagbar
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" install exuberant tags with `brew install ctags-exuberant`
let g:Tlist_Ctags_Cmd='/usr/local/Cellar/ctags/5.8_1/bin/ctags'

let g:tagbar_type_go = {
	\ 'ctagstype' : 'go',
	\ 'kinds'     : [
		\ 'p:package',
		\ 'i:imports:1',
		\ 'c:constants',
		\ 'v:variables',
		\ 't:types',
		\ 'n:interfaces',
		\ 'w:fields',
		\ 'e:embedded',
		\ 'm:methods',
		\ 'r:constructor',
		\ 'f:functions'
	\ ],
	\ 'sro' : '.',
	\ 'kind2scope' : {
		\ 't' : 'ctype',
		\ 'n' : 'ntype'
	\ },
	\ 'scope2kind' : {
		\ 'ctype' : 't',
		\ 'ntype' : 'n'
	\ },
	\ 'ctagsbin'  : 'gotags',
	\ 'ctagsargs' : '-sort -silent'
\ }

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Configure gitgutter
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" don't change gutter highlights
let g:gitgutter_override_sign_column_highlight = 0
let g:gitgutter_max_signs = 100

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Configure COC
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

let g:coc_node_path = '/usr/bin/node'

let g:coc_global_extensions = [
    \'coc-json',
    \'coc-lists',
    \'coc-snippets',
    \'coc-tag',
    \'coc-yaml',
    \'coc-python',
\]

" coc-omnisharp plugin not ready for use yet

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

nmap <silent> gE <Plug>(coc-diagnostic-prev-error)
nmap <silent> ge <Plug>(coc-diagnostic-next-error)
nmap <silent> rn <Plug>(coc-rename)

" use <c-space>for trigger completion
inoremap <silent><expr> <c-space> coc#refresh()

" mappings using CoCList:
" show all diagnostics.
nnoremap <silent> <leader>a :<C-u>CocList diagnostics<CR>

" manage extensions.
nnoremap <silent> <leader>e :<C-u>CocList extensions<CR><CR>

" show commands.
nnoremap <silent> <leader>l :<C-u>CocList commands<CR>

" find symbol of current document.
nnoremap <silent> <leader>o :<C-u>CocList outline<CR>

" search workleader symbols.
nnoremap <silent> <leader>s :<C-u>CocList -I symbols<CR>

" do default action for next item.
nnoremap <silent> <leader>j :<C-u>CocNext<CR>

" do default action for previous item.
nnoremap <silent> <leader>k :<C-u>CocPrev<CR>

" resume latest coc list.
nnoremap <silent> <leader>lr :<C-u>CocListResume<CR>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Configure Fugitive
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" open gstatus in vertical split and switch to it
nnoremap <silent> <leader>gs :Gstatus<CR><C-W>t<C-W>H<C-W><Right>

nnoremap <silent> <leader>gdf :Gdiff<CR>
nnoremap <silent> <leader>gc :Gcommit<CR>
nnoremap <silent> <leader>gb :Gblame<CR>
nnoremap <silent> <leader>gl :Glog<CR>
nnoremap <silent> <leader>gp :Git push<CR>
nnoremap <silent> <leader>gr :Gread<CR>
nnoremap <silent> <leader>gw :Gwrite<CR>
nnoremap <silent> <leader>ge :Gedit<CR>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Configure Python
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

let python_highlight_all=1

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Configure Vim-go
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

autocmd InsertLeave go :write

" the following are handled by the language client / server
let g:go_fmt_experimental = 1 " fixes opening folds on save

let g:go_autodetect_gopath = 1
let g:go_fmt_autosave = 1
let g:go_get_update = 0

let g:go_auto_type_info = 1
let g:go_highlight_extra_types = 1
let g:go_highlight_types = 1
let g:go_highlight_fields = 1
let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_operators = 1
let g:go_highlight_structs = 1
let g:go_highlight_types = 1
let g:go_highlight_function_parameters = 1
let g:go_highlight_function_calls = 1
let g:go_highlight_variable_declarations = 1
let g:go_highlight_variable_assignments = 1
let g:go_highlight_build_constraints = 1
let g:go_highlight_extra_types = 1
let g:go_highlight_fields = 1
let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_operators = 1
let g:go_highlight_structs = 1
let g:go_highlight_types = 1

let g:go_decls_mode = 'fzf'
let g:go_fmt_command = "goimports"
let g:go_def_mode='gopls'
let g:go_info_mode='gopls'
let g:go_list_type = "quickfix"
let g:go_snippet_engine = "ultisnips"
let g:go_debug_break_point_symbol='>>'

let $GINKGO_EDITOR_INTEGRATION = "true" " uses ginkgo for tests

au FileType go nmap <leader>gd <Plug>(go-definition)
au FileType go nmap <leader>bp <Plug>(go-build)
au FileType go nmap <leader>tt <Plug>(go-test)
au FileType go nmap <leader>cv <Plug>(go-coverage)
au FileType go nmap <leader>rn <Plug>(go-rename)
au FileType go nmap <leader>rf <Plug>(go-referrers)
au FileType go nmap <leader>df <Plug>(go-def)

" swap between tests and code
au FileType go nmap <leader>ae <Plug>(go-alternate-edit)
au Filetype go nmap <leader>aev <Plug>(go-alternate-vertical)

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Configure Ale
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

let g:ale_list_window_size = 1
let g:ale_sign_column_always = 1
let g:ale_keep_list_window_open = 0
let g:ale_set_hightlights = 1
let g:ale_open_list = 1
let g:ale_set_signs = 1
let g:ale_sign_column_always = 1
let g:ale_sign_error = '✖'
let g:ale_sign_warning = '⚠'
let g:ale_warn_about_trailing_whitespace = 0

let g:ale_linters_explicit = 1
let g:ale_linters = {
    \ 'javascript': ['eslint'],
    \ 'python': ['yapf', 'pylint'],
\}

"    \ 'cs': ['OmniSharp'],
"    \ 'go': ['gopls'],

let g:ale_fix_on_save=1
let g:ale_fixers = {
\ '*':['remove_trailing_lines','trim_whitespace'],
\  'javascript': ['eslint'],
\  'python': ['yapf'],
\}

" nmap <silent> <C-k> <Plug>(ale_previous_wrap)
" nmap <silent> <C-j> <Plug>(ale_next_wrap)

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Configure IndentLine
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

let g:indentLine_enabled = 0
let g:vim_json_syntax_conceal = 0

let g:indentLine_bufTypeExclude = ['help', 'terminal']
let g:indentLine_bufNameExclude = ['_.*', 'NERD_tree.*']

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Configure Gruvbox & Airline Plugins
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Enable integration with airline.
let g:airline#extensions#ale#enabled = 0
let g:airline#extensions#tabline#show_tabs = 0

" improves performace
let g:airline_highlighting_cache=1

let g:airline_powerline_fonts = 1
let g:airline_extensions = []
let g:airline_skip_empty_sections = 1

if !exists('g:airline_symbols')
    let g:airline_symbols = {}
endif

let g:tmuxline_preset = 'powerline'

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Configure EditorConfig Plugins
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

let g:EditorConfig_exclude_patterns = ['fugitive://.*', 'scp://.*']
let g:EditorConfig_exec_path = '/usr/local/bin/editorconfig'
let g:EditorConfig_core_mode = 'external_command'
let g:EditorConfig_verbose = 1

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Configure FZF
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! RipgrepFzf(query, fullscreen)
  let command_fmt = 'rg --column --line-number --no-heading --color=always --smart-case -- %s || true'
  let initial_command = printf(command_fmt, shellescape(a:query))
  let reload_command = printf(command_fmt, '{q}')
  let spec = {'options': ['--phony', '--query', a:query, '--bind', 'change:reload:'.reload_command]}
  call fzf#vim#grep(initial_command, 1, fzf#vim#with_preview(spec), a:fullscreen)
endfunction

command! -nargs=* -bang Rg call RipgrepFzf(<q-args>, <bang>0)

autocmd! FileType fzf set laststatus=0 noshowmode noruler
  \| autocmd BufLeave <buffer> set laststatus=2 showmode ruler

" Keymaps
nnoremap <leader>ff :Files <CR>
nnoremap <leader>bb :Buffers <CR>
nnoremap <leader>gf :GFiles <CR>
nnoremap <leader>rg :Rg <CR>
nnoremap <leader>ll :Lines <CR>
nnoremap <leader>mp :Maps <CR>
nnoremap <leader>hh :History <CR>

" Mapping selecting mappings
nmap <leader><tab> <plug>(fzf-maps-n)
xmap <leader><tab> <plug>(fzf-maps-x)
omap <leader><tab> <plug>(fzf-maps-o)

" Insert mode completion
imap <c-x><c-k> <plug>(fzf-complete-word)
imap <c-x><c-f> <plug>(fzf-complete-path)
imap <c-x><c-j> <plug>(fzf-complete-file-ag)
imap <c-x><c-l> <plug>(fzf-complete-line)

" This is the default extra key bindings
let g:fzf_action = {
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-x': 'split',
  \ 'ctrl-v': 'vsplit' }

" Default fzf layout
" - down / up / left / right
let g:fzf_layout = { 'down': '~40%' }

" In Neovim, you can set up fzf window using a Vim command
let g:fzf_layout = { 'window': 'enew' }
let g:fzf_layout = { 'window': '-tabnew' }
let g:fzf_layout = { 'window': '10new' }

" Customize fzf colors to match your color scheme
let g:fzf_colors = {
  \ 'fg':      ['fg', 'Normal'],
  \ 'bg':      ['bg', 'Normal'],
  \ 'hl':      ['fg', 'Comment'],
  \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
  \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
  \ 'hl+':     ['fg', 'Statement'],
  \ 'info':    ['fg', 'PreProc'],
  \ 'border':  ['fg', 'Ignore'],
  \ 'prompt':  ['fg', 'Conditional'],
  \ 'pointer': ['fg', 'Exception'],
  \ 'marker':  ['fg', 'Keyword'],
  \ 'spinner': ['fg', 'Label'],
  \ 'header':  ['fg', 'Comment'],
\ }

" Enable per-command history.
" CTRL-N and CTRL-P will be automatically bound to next-history and
" previous-history instead of down and up. If you don't like the change,
" explicitly bind the keys to down and up in your $FZF_DEFAULT_OPTS.
let g:fzf_history_dir = '~/.local/share/fzf-history'

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Configure Yankstack Plugin
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

nmap <leader>p <Plug>yankstack_substitute_older_paste
nmap <leader>P <Plug>yankstack_substitute_newer_paste

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Configure UltiSnips Plugin
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

let g:UltiSnipsExpandTrigger = "<tab>"
let g:UltiSnipsJumpForwardTrigger = "<c-j>"
let g:UltiSnipsJumpBackwardTrigger = "<c-k>"

let g:UltiSnipsSnippetDirectories = [$HOME . '/.vim/UltiSnip']

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Configure EasyMotion Plugin
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Turn on case-insensitive feature
let g:EasyMotion_smartcase = 1

" JK motions: Line motions
map <Leader>j <Plug>(easymotion-j)
map <Leader>k <Plug>(easymotion-k)

" <Leader>f{char} to move to {char}
map  <Leader>f <Plug>(easymotion-bd-f)
nmap <Leader>f <Plug>(easymotion-overwin-f)

" s{char}{char} to move to {char}{char}
nmap s <Plug>(easymotion-overwin-f2)

" Move to line
map <Leader>L <Plug>(easymotion-bd-jk)
nmap <Leader>L <Plug>(easymotion-overwin-line)

" Move to word
map  <Leader>w <Plug>(easymotion-bd-w)
nmap <Leader>w <Plug>(easymotion-overwin-w)


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Easy Align
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

nmap ga <Plug>(EasyAlign)
xmap ga <Plug>(EasyAlign)

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" OmniSharp
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

let g:OmniSharp_server_type = 'roslyn'
let g:OmniSharp_selector_ui = 'fzf'

let g:ale_linters = { 'cs': ['OmniSharp'] } " Tell ALE to use OmniSharp for linting C# files, and no other linters.
let g:OmniSharp_server_stdio = 1            " Use the stdio OmniSharp-roslyn server
let g:OmniSharp_timeout = 5                 " Timeout in seconds to wait for a response from the server
let g:OmniSharp_highlight_types = 1         " Fetch semantic type/interface/identifier names on BufEnter and highlight them
let g:OmniSharp_want_snippet=1              " Enable snippet completion

augroup omnisharp_commands
  autocmd!

  " Show type information automatically when the cursor stops moving.
  " Note that the type is echoed to the Vim command line, and will overwrite
  " any other messages in this space including e.g. ALE linting messages.
  autocmd CursorHold *.cs OmniSharpTypeLookup

  " The following commands are contextual, based on the cursor position.
  autocmd FileType cs nmap <silent> <buffer> gd <Plug>(omnisharp_go_to_definition)
  autocmd FileType cs nmap <silent> <buffer> <Leader>osfu <Plug>(omnisharp_find_usages)
  autocmd FileType cs nmap <silent> <buffer> <Leader>osfi <Plug>(omnisharp_find_implementations)
  autocmd FileType cs nmap <silent> <buffer> <Leader>ospd <Plug>(omnisharp_preview_definition)
  autocmd FileType cs nmap <silent> <buffer> <Leader>ospi <Plug>(omnisharp_preview_implementations)
  autocmd FileType cs nmap <silent> <buffer> <Leader>ost <Plug>(omnisharp_type_lookup)
  autocmd FileType cs nmap <silent> <buffer> <Leader>osd <Plug>(omnisharp_documentation)
  autocmd FileType cs nmap <silent> <buffer> <Leader>osfs <Plug>(omnisharp_find_symbol)
  autocmd FileType cs nmap <silent> <buffer> <Leader>osfx <Plug>(omnisharp_fix_usings)
  autocmd FileType cs nmap <silent> <buffer> <C-\> <Plug>(omnisharp_signature_help)
  autocmd FileType cs imap <silent> <buffer> <C-\> <Plug>(omnisharp_signature_help)

  " Navigate up and down by method/property/field
  autocmd FileType cs nmap <silent> <buffer> [[ <Plug>(omnisharp_navigate_up)
  autocmd FileType cs nmap <silent> <buffer> ]] <Plug>(omnisharp_navigate_down)
  " Find all code errors/warnings for the current solution and populate the quickfix window
  autocmd FileType cs nmap <silent> <buffer> <Leader>osgcc <Plug>(omnisharp_global_code_check)
  " Contextual code actions (uses fzf, CtrlP or unite.vim when available)
  autocmd FileType cs nmap <silent> <buffer> <Leader>osca <Plug>(omnisharp_code_actions)
  autocmd FileType cs xmap <silent> <buffer> <Leader>osca <Plug>(omnisharp_code_actions)

  autocmd FileType cs nmap <silent> <buffer> <Leader>os= <Plug>(omnisharp_code_format)

  autocmd FileType cs nmap <silent> <buffer> <Leader>osnm <Plug>(omnisharp_rename)

  autocmd FileType cs nmap <silent> <buffer> <Leader>osre <Plug>(omnisharp_restart_server)
  autocmd FileType cs nmap <silent> <buffer> <Leader>osst <Plug>(omnisharp_start_server)
  autocmd FileType cs nmap <silent> <buffer> <Leader>ossp <Plug>(omnisharp_stop_server)
augroup END

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Colors and styling
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" change color of quick fix line
hi QuickFixLine term=reverse ctermfg=224

let g:airline_theme = 'gruvbox_material'
silent! colorscheme gruvbox-material

if $ITERM_PROFILE == 'dark'
  set background=dark
endif

if $ITERM_PROFILE == 'light'
  set background=light
endif

"Use 24-bit (true-color) mode in Vim/Neovim when outside tmux.
"(see < http://sunaku.github.io/tmux-24bit-color.html#usage > for more information.)
if (has("nvim"))
  let $NVIM_TUI_ENABLE_TRUE_COLOR=1
endif

if (has("termguicolors"))
  set termguicolors
endif

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Custom functions
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

function StartProfile()
    profile start profile.log
    profile func *
    profile file *
endfunction

function StopProfile()
    profile pause
    noautocmd qall!
endfunction

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Automatically save sessions
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" create session directory if not exists
let g:SessionDirectory = $HOME . '/.config/nvim/sessions' . getcwd()
let g:SessionFile = SessionDirectory . '/.session.vim'
if !isdirectory(g:SessionDirectory)
    call mkdir(g:SessionDirectory, "p")
endif

function IsGitCommit()
  return @% == '.git/COMMIT_EDITMSG'
endfunction

function SaveSess()
  if IsGitCommit() | return | endif
  NERDTreeClose
  execute 'mksession! ' . g:SessionFile
  echo "saved session"
endfunction

function RestoreSess()

  if IsGitCommit() | return | endif
  if len(argv()) != 1 | return | endif
  if !isdirectory(argv()[0]) | return | endif

  if filereadable(g:SessionFile)
    execute 'so ' . g:SessionFile
      if bufexists(1)
        for l in range(1, bufnr('$'))
            if bufwinnr(l) == -1
                exec 'sbuffer ' . l
            endif
        endfor
      endif
    echo 'restoring session'
  endif
endfunction

autocmd VimLeave * call SaveSess()
autocmd VimEnter * nested call RestoreSess()
