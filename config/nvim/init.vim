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
" Configure relative line numbers
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

set so=999
set number relativenumber
augroup numbertoggle
  autocmd!
  autocmd BufEnter,FocusGained,InsertLeave * set relativenumber
  autocmd BufLeave,FocusLost,InsertEnter   * set norelativenumber
augroup END

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
" Install Plugins
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

call plug#begin('~/.config/.vim/plugged')

Plug 'Raimondi/delimitMate'                                              " delimiter auto completion
Plug 'SirVer/ultisnips'                                                  " snippets engine
Plug 'Vimjas/vim-python-pep8-indent'
Plug 'Xuyuanp/nerdtree-git-plugin'                                       " show git status in nerdtree
Plug 'airblade/vim-gitgutter'                                            " dirty indicators
Plug 'christoomey/vim-tmux-navigator'                                    " window navigation that integrates with tmux
Plug 'easymotion/vim-easymotion'                                         " ace movements
Plug 'ekalinin/Dockerfile.vim'                                           " dockerfile syntax highlighting
Plug 'fatih/vim-go'
Plug 'honza/vim-snippets'                                                " snippets
Plug 'junegunn/fzf'                                                      " fuzzy searching
Plug 'junegunn/fzf.vim'                                                  " also require for fuzzy searching
Plug 'junegunn/gv.vim'
Plug 'junegunn/vim-easy-align'                                           " column alignment on characters
Plug 'liuchengxu/vim-which-key', { 'on': ['WhichKey', 'WhichKey!'] }
Plug 'liuchengxu/vista.vim'
Plug 'majutsushi/tagbar'                                                 " tag visualization
Plug 'neoclide/coc.nvim', {'do': 'yarn install --frozen-lockfile'}
Plug 'preservim/nerdcommenter'
Plug 'preservim/nerdtree'
Plug 'python-mode/python-mode', { 'for': 'python', 'branch': 'develop' }
Plug 'romainl/vim-qf'                                                    " quick fix / location window config
Plug 'sainnhe/gruvbox-material'                                          " theme
Plug 'tpope/vim-fugitive'                                                " git tooling
Plug 'vim-airline/vim-airline'                                           " modeline
Plug 'vim-airline/vim-airline-themes'                                    " modeline theme
Plug 'w0rp/ale'                                                          " syntax highlighting
Plug 'glench/vim-jinja2-syntax'

call plug#end()

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Configure Vim-Go
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

autocmd InsertLeave go :write

" the following are handled by the language client / server
let g:go_fmt_experimental = 1 " fixes opening folds on save

let g:go_autodetect_gopath = 1
let g:go_fmt_autosave = 1
let g:go_get_update = 0

let g:go_auto_type_info = 1
let g:go_highlight_build_constraints = 1
let g:go_highlight_extra_types = 1
let g:go_highlight_fields = 1
let g:go_highlight_function_calls = 1
let g:go_highlight_function_parameters = 1
let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_operators = 1
let g:go_highlight_structs = 1
let g:go_highlight_types = 1
let g:go_highlight_variable_assignments = 1
let g:go_highlight_variable_declarations = 1

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

" set height of location list window
let g:go_list_height = 10
let g:go_list_type = "quickfix"

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Configure Python
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let python_highlight_all=1

let g:pymode = 1
let g:pymode_lint = 0
let g:pymode_syntax = 1
let g:pymode_syntax_all = 1
let g:pymode_indent = 0

autocmd Filetype python setlocal shiftwidth=2 softtabstop=2 expandtab
autocmd FileType python set colorcolumn=120

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Configure WhichKey
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"nnoremap <silent> <leader> :WhichKey '<Space>'<CR>
nnoremap <silent> <leader>      :<c-u>WhichKey '<Space>'<CR>
nnoremap <silent> <localleader> :<c-u>WhichKey  ','<CR>

" Time in milliseconds to wait for a mapped sequence to complete.
set timeoutlen=500

" Define prefix dictionary
let g:which_key_map =  {}

let g:which_key_map['w'] = {
      \ 'name' : '+windows' ,
      \ 'w' : ['<C-W>w'     , 'other-window']          ,
      \ 'd' : ['<C-W>c'     , 'delete-window']         ,
      \ '-' : ['<C-W>s'     , 'split-window-below']    ,
      \ '|' : ['<C-W>v'     , 'split-window-right']    ,
      \ '2' : ['<C-W>v'     , 'layout-double-columns'] ,
      \ 'h' : ['<C-W>h'     , 'window-left']           ,
      \ 'j' : ['<C-W>j'     , 'window-below']          ,
      \ 'l' : ['<C-W>l'     , 'window-right']          ,
      \ 'k' : ['<C-W>k'     , 'window-up']             ,
      \ 'H' : ['<C-W>5<'    , 'expand-window-left']    ,
      \ 'J' : [':resize +5' , 'expand-window-below']   ,
      \ 'L' : ['<C-W>5>'    , 'expand-window-right']   ,
      \ 'K' : [':resize -5' , 'expand-window-up']      ,
      \ '=' : ['<C-W>='     , 'balance-window']        ,
      \ 's' : ['<C-W>s'     , 'split-window-below']    ,
      \ 'v' : ['<C-W>v'     , 'split-window-below']    ,
      \ '?' : ['Windows'    , 'fzf-window']            ,
      \ }

let g:which_key_map.f = { 'name' : '+file' }

nnoremap <silent> <leader>fs :update<CR>
let g:which_key_map.f.s = 'save-file'

nnoremap <silent> <leader>fd :e $MYVIMRC<CR>
let g:which_key_map.f.d = 'open-vimrc'

nnoremap <silent> <leader>oq  :copen<CR>
nnoremap <silent> <leader>ol  :lopen<CR>

let g:which_key_map.o = {
      \ 'name' : '+open',
      \ 'q' : 'open-quickfix'    ,
      \ 'l' : 'open-locationlist',
      \ }

let g:which_key_map.b = {
      \ 'name' : '+buffer' ,
      \ '1' : ['b1'        , 'buffer 1']        ,
      \ '2' : ['b2'        , 'buffer 2']        ,
      \ 'd' : ['bd'        , 'delete-buffer']   ,
      \ 'f' : ['bfirst'    , 'first-buffer']    ,
      \ 'h' : ['Startify'  , 'home-buffer']     ,
      \ 'l' : ['blast'     , 'last-buffer']     ,
      \ 'n' : ['bnext'     , 'next-buffer']     ,
      \ 'p' : ['bprevious' , 'previous-buffer'] ,
      \ '?' : ['Buffers'   , 'fzf-buffer']      ,
      \ }

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Configure easy motion
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

let g:EasyMotion_do_mapping = 0
let g:EasyMotion_smartcase = 1

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

let g:NERDTreeBookmarksFile = $HOME . "/.local/share/nerdtree_bookmarks/.NERDTreeBookmarks"

function NERDOpenClose()
  if @% =~ "NERD"
    NERDTreeToggle
  else
    NERDTreeFind
  endif
endfunction

nnoremap - :call NERDOpenClose()<CR>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Configure NerdCommenter
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Create default mappings
let g:NERDCreateDefaultMappings = 1

" Align line-wise comment delimiters flush left instead of following code indentation
let g:NERDDefaultAlign = 'left'

" Allow commenting and inverting empty lines (useful when commenting a region)
let g:NERDCommentEmptyLines = 1

" Enable trimming of trailing whitespace when uncommenting
let g:NERDTrimTrailingWhitespace = 1

" Enable NERDCommenterToggle to check all selected lines is commented or not
let g:NERDToggleCheckAllLines = 1

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
    \'coc-pyright'
\]

" if hidden is not set, TextEdit might fail.
set hidden

" Smaller updatetime for CursorHold & CursorHoldI
set updatetime=300

" don't give |ins-completion-menu| messages.
set shortmess+=c

" always show signcolumns
set signcolumn=yes

" Use tab for trigger completion with characters ahead and navigate.
" Use command ':verbose imap <tab>' to make sure tab is not mapped by other plugin.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()

" Use `[c` and `]c` to navigate diagnostics
nmap <silent> [c <Plug>(coc-diagnostic-prev)
nmap <silent> ]c <Plug>(coc-diagnostic-next)

" Remap keys for gotos
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use U to show documentation in preview window
nnoremap <silent> U :call <SID>show_documentation()<CR>

" Remap for rename current word
nmap <leader>rn <Plug>(coc-rename)

" Remap for format selected region
vmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

" Show all diagnostics
nnoremap <silent> <space>a  :<C-u>CocList diagnostics<cr>

" Manage extensions
nnoremap <silent> <space>e  :<C-u>CocList extensions<cr>

" Show commands
nnoremap <silent> <space>c  :<C-u>CocList commands<cr>

" Find symbol of current document
nnoremap <silent> <space>o  :<C-u>CocList outline<cr>

" Search workspace symbols
nnoremap <silent> <space>s  :<C-u>CocList -I symbols<cr>

" Do default action for next item.
nnoremap <silent> <space>j  :<C-u>CocNext<CR>

" Do default action for previous item.
nnoremap <silent> <space>k  :<C-u>CocPrev<CR>

" Resume latest coc list
nnoremap <silent> <space>p  :<C-u>CocListResume<CR>

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

let g:ale_linters = {
    \ 'javascript': ['eslint'],
    \ 'python': ['pylint']
\}

"    \ 'python': ['yapf', 'pylint'],
"    \ 'cs': ['OmniSharp'],
"    \ 'go': ['gopls'],

let g:ale_fix_on_save=1
let g:ale_fixers = {
\ '*':['remove_trailing_lines','trim_whitespace'],
\  'javascript': ['eslint'],
\  'python': ['yapf'],
\}

nmap <silent> <C-n> <Plug>(ale_next_wrap)
nmap <silent> <C-p> <Plug>(ale_previous_wrap)

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
let g:UltiSnipsJumpForwardTrigger = "<C-j>"
let g:UltiSnipsJumpBackwardTrigger = "<C-k>"

let g:UltiSnipsSnippetDirectories = [$HOME . '/.vim/UltiSnip']

highlight link snipLeadingSpaces NONE

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Easy Align
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

nmap ga <Plug>(EasyAlign)
xmap ga <Plug>(EasyAlign)

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

" call `:exec SynGroup()` to show the highlight group under the cursor
function! SynGroup()
  let l:s = synID(line('.'), col('.'), 1)
  echo synIDattr(l:s, 'name') . ' -> ' . synIDattr(synIDtrans(l:s), 'name')
endfun

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Automatically save sessions
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" create session directory if not exists
let g:SessionDirectory = $HOME . '/.config/nvim/sessions' . getcwd()
let g:SessionFile = SessionDirectory . '/.session.vim'
if !isdirectory(g:SessionDirectory)
    echom "creating sessions directory " . g:SessionDirectory
    call mkdir(g:SessionDirectory, "p")
endif

function IsGitCommit()
  return @% == '.git/COMMIT_EDITMSG'
endfunction

function SaveSess()
  if IsGitCommit() | return | endif
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
