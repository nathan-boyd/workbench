" let g:python_host_prog="/usr/local/bin/python2"
" let g:python3_host_prog="/usr/local/bin/python3"

set shortmess+=c                                             " don't give |ins-completion-menu| messages.
set signcolumn=yes                                           " always show signcolumns
set autoread                                                 " Automatically read changed files
set ttyfast                                                  " Indicate fast terminal conn for faster redraw
set shell=/usr/local/bin/zsh                                 " explicitly use zsh shell
set laststatus=2                                             " always display status line
set background=dark                                          " assume a dark background
set autowrite                                                " automatically write file when leaving a modified buffer
set shortmess+=filmnrxoOtT                                   " abbrev. of messages (avoids 'hit enter')
set viewoptions=folds,options,cursor,unix,slash              " better Unix / Windows compatibility
set virtualedit=onemore                                      " allow for cursor beyond last character
set history=1000                                             " store 1000 history items
set hidden                                                   " allow buffer switching without saving
set iskeyword-=.                                             " '.' is an end of word designator
set iskeyword-=#                                             " '#' is an end of word designator
set iskeyword-=-                                             " '-' is an end of word designator
set showcmd                                                  " show command in bottom bar
set lazyredraw                                               " fix slow scrolling
set fillchars+=vert:┃                                        " use this char for line between buffers
set cursorline                                               " highlight cursorline
set backspace=indent,eol,start                               " normal backspace functionality
set linespace=0                                              " no extra spaces between rows
set number                                                   " line numbers on
set showmatch                                                " show matching brackets/parenthesis
set incsearch                                                " find as you type search
set hlsearch                                                 " highlight search terms
set winminheight=0                                           " windows can be 0 line high
set ignorecase                                               " case insensitive search
set smartcase                                                " case sensitive when uc present
set wildmenu                                                 " show list instead of just completing
set wildignorecase                                           " ignore case when matching
set wildmode=list:full                                       " command <Tab> completion, list matches, then longest common part, then all.
set wildignore+=*/tmp/*,*.so,*.swp,*.zip,*.pyc,*.db,*.sqlite " ignored when expanding wildcards
set whichwrap=b,s,h,l,<,>,[,]                                " backspace and cursor keys wrap too
set scrolljump=5                                             " lines to scroll when cursor leaves screen
set scrolloff=3                                              " minimum lines to keep above and below cursor
set foldenable                                               " auto fold code
set list                                                     " show whitespace
set listchars=tab:›\ ,trail:•,extends:#,nbsp:.               " highlight problematic whitespace
set noerrorbells                                             " turn off error bell
set novisualbell                                             " turn off visual bell
set t_vb=                                                    " turn off visual bell
set completeopt-=preview                                     " remove preview from complete options
set completeopt+=noinsert,noselect,longest,menuone           " set complete options preference
set diffopt+=vertical                                        " display diffs in vertical window
set omnifunc=syntaxcomplete#Complete                         " set completion options
set conceallevel=0                                           " dont obfuscate quotes etc in syntax highlighting
set cmdheight=1                                              " Better display for messages
set updatetime=300                                           " Smaller updatetime for CursorHold & CursorHoldI
set termguicolors                                            " use 24bit color

syntax on                                                    " syntax highlighting
scriptencoding utf-8                                         " set file encoding

filetype plugin indent on                                    " automatically detect file types.

highlight clear SignColumn                                   " signColumn should match background
highlight clear LineNr                                       " current line number row will have same background color in relative mode

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Configure Spelling
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

set nospell
" set spell spelllang=en_us                                    " turn on spell check
" syn match myExCapitalWords +\<\w*[_0-9A-Z-]\w*\>+ contains=@NoSpell " Ignore CamelCase words when spell checking

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Configure Netrw
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

let g:netrw_banner       = 0  " remove the netrw banner
let g:netrw_liststyle    = 3  " tree style listing
let g:netrw_browse_split = 4  " see help on this one. lots of useful options
let g:netrw_altv         = 1  " change from left splitting to right splitting
let g:netrw_winsize      = 20 " initial size of new explore windows
let g:netrw_keepdir      = 0  " update current directory along with browsing directory
let g:netrw_fastbrowse   = 1  " reuse directory listings

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Configure Clipboard
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" pbcopy for OSX copy/paste
if has('macunix')
    vmap <C-x> :!pbcopy<CR>
    vmap <C-c> :w !pbcopy<CR><CR>
endif

if has('clipboard')
    if has('unnamedplus')   " When possible use + register for copy-paste
        set clipboard=unnamed,unnamedplus
    else                    " On mac and Windows, use * register for copy-paste
        set clipboard=unnamed
    endif
endif

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Configure Backups
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" maintain undo history between sessions
set undodir=~/.vim/undodir
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
set foldnestmax=5       " max 5 depth
set foldlevelstart=10   " start with fold level of 1
set foldcolumn=0        " dont show fold column numbers

" remember folds when leaving buffer
augroup remember_folds
  autocmd!
  autocmd BufWinLeave * silent! mkview
  autocmd BufWinEnter * silent! loadview
augroup END

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Configure Leader Key and Non Plugin Mappings
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" set leader key to spacebar
let mapleader=" "
let maplocalleader = ","

" wait indefinitely after leader key is pressed
" set notimeout
" set nottimeout

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

if !exists(":PushStandupUpdate")
    :command PushStandupUpdate :!gist -u 5b9de1197606716cf48b586065ea8a43 ~/Users/nboyd/standupUpdates/updates.md
endif

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

autocmd BufNewFile,BufRead *.tpl set filetype=go
autocmd BufNewFile,BufRead *.manifest set filetype=json

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Searching
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" useful for searching the pager
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
Plug 'morhetz/gruvbox'                                             " color theme
Plug 'godlygeek/tabular'                                           " vertical alignment
Plug 'easymotion/vim-easymotion'                                   " ace movements
Plug 'tpope/vim-fugitive'                                          " git tooling
Plug 'airblade/vim-gitgutter'                                      " dirty indicators
Plug 'w0rp/ale'                                                    " syntax highlighting
Plug '/usr/local/opt/fzf'                                          " after installing fzf with homebrew
Plug 'junegunn/fzf.vim'                                            " vim fuzzier
"Plug 'editorconfig/editorconfig-vim'                               " editor config
Plug 'Yggdroot/indentLine'                                         " vertical alignment markers
Plug 'maxbrunsfeld/vim-yankstack'                                  " kill ring behavior
Plug 'SirVer/ultisnips'                                            " snippets engine
Plug 'honza/vim-snippets'                                          " snippets
Plug 'scrooloose/nerdtree'                                         " file explorer
Plug 'Xuyuanp/nerdtree-git-plugin'                                 " show git status in nerdtree
Plug 'sainnhe/gruvbox-material'                                    " theme
Plug 'junegunn/vim-easy-align'                                     " column alignment on characters
Plug 'scrooloose/nerdcommenter'                                    " global comment patterns
Plug 'majutsushi/tagbar'                                           " tag visualization
Plug 'ekalinin/Dockerfile.vim'                                     " dockerfile syntax highlighting
Plug 'romainl/vim-qf'                                              " quick fix / location window config
"Plug 'OmniSharp/omnisharp-vim'                                     " csharp support

Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'hashivim/vim-terraform'
Plug 'christoomey/vim-tmux-navigator'
Plug 'Raimondi/delimitMate'
Plug 'tpope/vim-cucumber'
Plug 'tpope/vim-surround'


call plug#end()

" autocmd VimEnter *
"   \  if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
"   \|   PlugInstall --sync | q
"   \| endif

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Configure Omnisharp
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" let g:OmniSharp_typeLookupInPreview = 1

" let g:OmniSharp_server_type = 'roslyn'
"
" " Use the stdio OmniSharp-roslyn server
" let g:OmniSharp_server_stdio = 1
"
" " Timeout in seconds to wait for a response from the server
" let g:OmniSharp_timeout = 5
"
" " Fetch semantic type/interface/identifier names on BufEnter and highlight them
" let g:OmniSharp_highlight_types = 1
"
" " Enable snippet completion
" let g:OmniSharp_want_snippet=1
"
" let g:OmniSharp_selector_ui = 'fzf'
"
" augroup omnisharp_commands
"     autocmd!
"
"     autocmd BufWritePre *.cs call OmniSharp#CodeFormat()
"
"     " Show type information automatically when the cursor stops moving
"     autocmd CursorHold *.cs call OmniSharp#TypeLookupWithoutDocumentation()
"
"     " Update the highlighting whenever leaving insert mode
"     autocmd InsertLeave *.cs call OmniSharp#HighlightBuffer()
"
"     autocmd FileType cs nnoremap <buffer> <Leader>rn :OmniSharpRename<CR>
"
"     " Alternatively, use a mapping to refresh highlighting for the current buffer
"     autocmd FileType cs nnoremap <buffer> <Leader>th :OmniSharpHighlightTypes<CR>
"
"     " The following commands are contextual, based on the cursor position.
"     autocmd FileType cs nnoremap <buffer> <Leader>gd :OmniSharpGotoDefinition<CR>
"     autocmd FileType cs nnoremap <buffer> <Leader>fi :OmniSharpFindImplementations<CR>
"     autocmd FileType cs nnoremap <buffer> <Leader>fs :OmniSharpFindSymbol<CR>
"     autocmd FileType cs nnoremap <buffer> <Leader>fu :OmniSharpFindUsages<CR>
"     autocmd FileType cs nnoremap <buffer> <Leader>rt :OmniSharpRunTest<CR>
"
"     " Finds members in the current buffer
"     autocmd FileType cs nnoremap <buffer> <Leader>fm :OmniSharpFindMembers<CR>
"
"     autocmd FileType cs nnoremap <buffer> <Leader>fx :OmniSharpFixUsings<CR>
"     autocmd FileType cs nnoremap <buffer> <Leader>tt :OmniSharpTypeLookup<CR>
"     autocmd FileType cs nnoremap <buffer> <Leader>dc :OmniSharpDocumentation<CR>
"
"     autocmd FileType cs nnoremap <buffer> <C-\> :OmniSharpSignatureHelp<CR>
"     autocmd FileType cs inoremap <buffer> <C-\> <C-o>:OmniSharpSignatureHelp<CR>
"
"     " Navigate up and down by method/property/field
"     autocmd FileType cs nnoremap <buffer> <C-k> :OmniSharpNavigateUp<CR>
"     autocmd FileType cs nnoremap <buffer> <C-j> :OmniSharpNavigateDown<CR>
"
"     " Find all code errors/warnings for the current solution and populate the quickfix window
"     autocmd FileType cs nnoremap <buffer> <Leader>gcc :OmniSharpGlobalCodeCheck<CR>
"
" augroup END
"
" " Contextual code actions (uses fzf, CtrlP or unite.vim when available)
" nnoremap <Leader><Space> :OmniSharpGetCodeActions<CR>
"
" " Run code actions with text selected in visual mode to extract method
" xnoremap <Leader><Space> :call OmniSharp#GetCodeActions('visual')<CR>
"
" " Rename with dialog
" nnoremap <Leader>nm :OmniSharpRename<CR>
" nnoremap <F2> :OmniSharpRename<CR>
"
" " Rename without dialog - with cursor on the symbol to rename: `:Rename newname`
" command! -nargs=1 Rename :call OmniSharp#RenameTo("<args>")
"
" nnoremap <Leader>cf :OmniSharpCodeFormat<CR>
"
" " Start the omnisharp server for the current solution
" nnoremap <Leader>ss :OmniSharpStartServer<CR>
" nnoremap <Leader>sp :OmniSharpStopServer<CR>

" Enable snippet completion
" let g:OmniSharp_want_snippet=1

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
" Configure terraform
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

let g:terraform_align=1
let g:terraform_fmt_on_save=1

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Configure Vim-Qf
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

let g:qf_loclist_window_bottom=0

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Configure EasyAlign
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)

" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)

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

" dont change gutter highlights
let g:gitgutter_override_sign_column_highlight = 0

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Configure NERDTree
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

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

nnoremap <C-e> :call CheckNERD()<CR>
function CheckNERD()
  if @% =~ "NERD"
    NERDTreeToggle
  else
    NERDTreeFind
  endif
endfunction

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Configure COC
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

let g:coc_global_extensions = [
    \'coc-word',
    \'coc-dictionary',
    \'coc-tag',
    \'coc-json',
    \'coc-lists',
    \'coc-snippets',
    \'coc-spell-checker',
    \'coc-yaml',
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
" Configure NerdCommenter
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

let g:NERDSpaceDelims = 1            " Add spaces after comment delimiters by default
let g:NERDDefaultAlign = 'left'      " Align line-wise comment delimiters flush left instead of following code indentation
let g:NERDCommentEmptyLines = 1      " Allow commenting and inverting empty lines (useful when commenting a region)
let g:NERDTrimTrailingWhitespace = 1 " Enable trimming of trailing whitespace when uncommenting
let g:NERDToggleCheckAllLines = 1    " Enable NERDCommenterToggle to check all selected lines is commented or not

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Configure Vim-go
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

autocmd InsertLeave go :write

" the following are handled by the language client / server
let g:go_def_mapping_enabled = 0
let g:go_code_completion_enabled = 0

let g:go_bin_path = "/usr/local/bin/go"
let $GOPATH = $HOME."/go"
let g:go_autodetect_gopath = 1

"let g:go_auto_type_info = 1

let g:go_fmt_autosave = 0
let g:go_fmt_experimental = 1 " fixes opening folds on save
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
\}
"    \ 'cs': ['OmniSharp'],
"    \ 'go': ['gopls'],

let g:ale_fix_on_save=1
let g:ale_fixers={
\ '*':['remove_trailing_lines','trim_whitespace'],
\  'javascript': ['eslint'],
\ }

" nmap <silent> <C-k> <Plug>(ale_previous_wrap)
" nmap <silent> <C-j> <Plug>(ale_next_wrap)

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Configure IndentLine
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

let g:indentLine_char = '¦'
let g:indentLine_setConceal = 0

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Configure Gruvbox & Airline Plugins
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Enable integration with airline.
let g:airline#extensions#ale#enabled = 1
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

" override default command to search hidden files
command! -bang -nargs=* Rg
  \ call fzf#vim#grep(
  \   'rg -g \!.git --column --line-number --no-heading --color=always --smart-case --hidden '.shellescape(<q-args>), 1,
  \   <bang>0 ? fzf#vim#with_preview('up:60%')
  \           : fzf#vim#with_preview('right:50%:hidden', '?'),
  \   <bang>0)

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
let g:fzf_colors =
\ { 'fg':      ['fg', 'Normal'],
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
" Colors
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" change color of quick fix line
hi QuickFixLine term=reverse ctermfg=224

" colorscheme gruvbox
let g:airline_theme = 'gruvbox_material'

silent! colorscheme gruvbox-material
